Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C1033A9E2;
	Sat, 12 Sep 2026 15:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225288; cv=none; b=LQPHRONeSeXMDHF+diQNODog9kNnrGYv0YNrUA1yxH437eKD+M4waLZYibffdFOMWHflx2457fBueLEGzE0yyBBu/ZmQdkZciqOz9lvFGgQbePD4blybO+4HK/N7Hf8fmWhrJBbtnH8xrSQvUCN4mQjaiOBr3Gvdc/eXmX+xgBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225288; c=relaxed/simple;
	bh=BI4mw0CocOU5TDojcLDk37ApiCAB29pkVldGVJpd8iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJlTwUI0Qpitbj1qEkDddr7jDQIVy+EJEe8DCQ+gA3v1YU1epsGREimktK8+xRIyt0ZbDm76ojG+uLRCxrImc72Hf7DUOGFotwPei1JaqBHL+qqgeJ7+YjnPbPWEK1jZfJ9CarzmhkJFWUDX+qeBuH7YWBw8CTJz0+8qiM8IYP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=at6uwWf2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="at6uwWf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3AC1F00893;
	Sat, 12 Sep 2026 15:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225287;
	bh=Bia1L/BIqEvOv+6sdAz7In97RmuPZp6PosI5JnzK2Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=at6uwWf2AomcmR7ZP8nT9b9TTjStrXEoo2DoQmIR4dcpI0ThPzl2GiuSsM+fNnqQ0
	 6ECUN+LGpX1H2s4WSz7uqQVHaZNJjjYD6FDkgD0qr2wwDZI6tTDQbezSl/Ly/bLLQR
	 5fFpyItF2tRnRbK2rMrYG7DzQNjQchen2rv81XXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1166/1424] nfc: llcp: avoid userspace overflow on invalid optlen
Date: Sat, 12 Sep 2026 08:59:58 +0200
Message-ID: <20260912065633.405301895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 99985bfa8336fadcc69190ba2dcbd5386af3d661 ]

nfc_llcp_getsockopt() casts optval to (u32 __user *) for put_user(), so
the kernel always stores 4 bytes regardless of the caller-supplied
optlen. The existing min_t(u32, len, sizeof(u32)) only clamps the length
reported back to userspace; it does not constrain the store. A call with
optlen < 4 therefore writes past the user buffer, violating the
getsockopt(2) contract for all five supported optnames.

Reject any call with optlen < sizeof(u32) up front. 'len' is int, so a
plain size comparison would promote a negative optlen to size_t and slip
past the check; an explicit 'len < 0' test is added first to catch
negative values before the size compare.

Fixes: 26fd76cab2e6 ("NFC: llcp: Implement socket options")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260521-fix_llc-v2-1-ab44cc09179c@debian.org
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_sock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index cd1fdf0beefb6..cc1642d82cda2 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -319,6 +319,12 @@ static int nfc_llcp_getsockopt(struct socket *sock, int level, int optname,
 	if (get_user(len, optlen))
 		return -EFAULT;
 
+	if (len < 0)
+		return -EINVAL;
+
+	if (len < sizeof(u32))
+		return -EINVAL;
+
 	local = llcp_sock->local;
 	if (!local)
 		return -ENODEV;
-- 
2.53.0



