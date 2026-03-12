Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAD238D686;
	Thu, 12 Mar 2026 20:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347282; cv=none; b=pSp4Yvps6eQ4XcRaKsUZDVaSM4x6xOXzGyVMI8JKMFCqWm+A5pmA/Mq3ugQEhI/Vkr2LoKQ13tW0PhdPnk/bUIgB5/OVunV/GuI2RzSUVLpqNhal2mFMLe7JbKOqalresAKxA3hdM5+gmnhV7JVWBw3tew4i+nkTYKjRcKHvj00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347282; c=relaxed/simple;
	bh=yVDJqsKeIjfpfWygphqEIJmQJIerJyz0212QdKRhm34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GTnpydHy9sgK+nxs1eSsC03EC57MsEBDCrwHJ0+e9nUeuPTMfVbdg0XvtrLlMl6TkQmsDguy/0LuOobcT/buVXRuAvE7tCGig9/nK/ZdgYxAaWtfIn4Qmb8bhe1J7PVNncwrlaku41QLMigkSBm/ZTFFCrv44IDTRbvcIKwFxTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=feFZUEob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="feFZUEob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552EFC2BC9E;
	Thu, 12 Mar 2026 20:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347282;
	bh=yVDJqsKeIjfpfWygphqEIJmQJIerJyz0212QdKRhm34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=feFZUEobqwTIf9/H7dz5tv/3LIPvLdmKi6sf0tYu5Pod26kW+ZAsTl0r9mzrFC2e1
	 SCsmHlbzJMruP+jRVcg/LEvHpTZ6Vx+xCPWcSYNlpa8CTZ1Siig92tO48RfOpFe3YX
	 yAjz3RuxqKwLApoKzAN0NO59ZNg/IiSo+lYV8A+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qualys Security Advisory <qsa@qualys.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Georgia Garcia <georgia.garcia@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.12 251/265] apparmor: fix memory leak in verify_header
Date: Thu, 12 Mar 2026 21:10:38 +0100
Message-ID: <20260312201027.407882167@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>

commit e38c55d9f834e5b848bfed0f5c586aaf45acb825 upstream.

The function sets `*ns = NULL` on every call, leaking the namespace
string allocated in previous iterations when multiple profiles are
unpacked. This also breaks namespace consistency checking since *ns
is always NULL when the comparison is made.

Remove the incorrect assignment.
The caller (aa_unpack) initializes *ns to NULL once before the loop,
which is sufficient.

Fixes: dd51c8485763 ("apparmor: provide base for multiple profiles to be replaced at once")
Reported-by: Qualys Security Advisory <qsa@qualys.com>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
Signed-off-by: Massimiliano Pellizzer <massimiliano.pellizzer@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/policy_unpack.c |    1 -
 1 file changed, 1 deletion(-)

--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1142,7 +1142,6 @@ static int verify_header(struct aa_ext *
 {
 	int error = -EPROTONOSUPPORT;
 	const char *name = NULL;
-	*ns = NULL;
 
 	/* get the interface version */
 	if (!aa_unpack_u32(e, &e->version, "version")) {


