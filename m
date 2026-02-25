Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47D22D4805;
	Wed, 25 Feb 2026 06:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002748; cv=none; b=Kfkb1mejQyuN0F6dAfO2ZGAa247x8otYtfG8nKVeXY49ymeVwA/t/8EvKfUJ/kNKDeYV8szvC7flR5q9sDWOHDSEKxxWZMn3E2woRD4EByDXszyMmdxZbQICB71CpzJBPKOaLbQgrJ8tdGQLwOyEsEHUuRPSgxeREi2Mi0DRnKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002748; c=relaxed/simple;
	bh=X2E8xW0K+oRM/T80fr6dSco6GKdkvbcMMkxLaHmu+jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+xoyrp0WuaGjZ1RW3W1yIkl9gq94yokmix/51jY18sBlGcJNl+aov4RkzKiwjKvSIs15keFLdLY66zLFJt6YsRCaowW0cQOhsPDAtbPnoV6iPjQ7MG8/E/lKjSkmB6aIU6X3/xGFOmDEhTJjDBRStJnRPahLTDuM95xbG0SGgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtmVmHYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtmVmHYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A435C116D0;
	Wed, 25 Feb 2026 06:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002748;
	bh=X2E8xW0K+oRM/T80fr6dSco6GKdkvbcMMkxLaHmu+jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EtmVmHYbcDtOL5/EDjeC3yscXGioplftNnitXOGUwCefHgOqi3J5gBxFofqaLEasn
	 BLV5Wbv7OvWJP4kmYspZaZ8L7Ko2/9g4O061Upv8hVzfr3vg/KMp3dm4OyMJ0zTKlD
	 01eaZ4DFlx/Thgo15U7lnKrs9tyybPf4bjcxer4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 564/641] apparmor: fix NULL sock in aa_sock_file_perm
Date: Tue, 24 Feb 2026 17:24:50 -0800
Message-ID: <20260225012402.186963979@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 00b67657535dfea56e84d11492f5c0f61d0af297 ]

Deal with the potential that sock and sock-sk can be NULL during
socket setup or teardown. This could lead to an oops. The fix for NULL
pointer dereference in __unix_needs_revalidation shows this is at
least possible for af_unix sockets. While the fix for af_unix sockets
applies for newer mediation this is still the fall back path for older
af_unix mediation and other sockets, so ensure it is covered.

Fixes: 56974a6fcfef6 ("apparmor: add base infastructure for socket mediation")
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/net.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/net.c b/security/apparmor/net.c
index 45cf25605c345..44c04102062f3 100644
--- a/security/apparmor/net.c
+++ b/security/apparmor/net.c
@@ -326,8 +326,10 @@ int aa_sock_file_perm(const struct cred *subj_cred, struct aa_label *label,
 	struct socket *sock = (struct socket *) file->private_data;
 
 	AA_BUG(!label);
-	AA_BUG(!sock);
-	AA_BUG(!sock->sk);
+
+	/* sock && sock->sk can be NULL for sockets being set up or torn down */
+	if (!sock || !sock->sk)
+		return 0;
 
 	if (sock->sk->sk_family == PF_UNIX)
 		return aa_unix_file_perm(subj_cred, label, op, request, file);
-- 
2.51.0



