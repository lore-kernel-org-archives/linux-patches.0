Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE4C3396F4;
	Thu, 28 May 2026 19:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779997999; cv=none; b=cTN1tt8vD/4Ghw7oP5HPDcuS3K/LuGpoMHM9cLKspNUuWHqV/BxpJwEJlTOjVOtdOMIW5eLGVgu97xkDPOUH++J6Frv11Z3pw7h79vVzlu8ddgg+e9oM89dh+AqABrz6eGVK5x1bhTpWBKp8FxYctsCW9muVHRtZClyUj6KHroE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779997999; c=relaxed/simple;
	bh=i9M/lzgZLNFUgkeyFkeyF4cUKjEL67mPnTVZoM683K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLALrHg7YYNsfEtM98Cf2ZsB4T6/QYPqo+qvdTPqqLSxMJq/16+EtotMPc59dfnRQ2BqN7CP9zZ6W63mGJVePx/QMxCOS7OAwKKqo0/iINs7oRpI+vjVzeBPnIZTnc7lczOOqhotnHA4+3Ebefd9W2Coszyh7x+d3xls1WpxW5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZSCZ3Nq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZSCZ3Nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593B11F000E9;
	Thu, 28 May 2026 19:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779997998;
	bh=7Frxg5/H7nZnnbTB/Cu/N+aPeyXvB6a25vqBoUHR2F0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZSCZ3NqNT3Er6FTE2+tsDvFAjH/md8AcWfAAQ0uRy+nCBfl7z91nKAHt7BBt9ek1
	 2NLt7ncSMSgVm6LzzOhT2I9OH+3gk0fQN0ne5P/JFM/hIHjJMDwqZXdA1UKgnUIthz
	 6IdnQZqrT8SIyuVVSm1mYGXGcJaR3f3e8rNufXIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.0 018/461] smb: client: require net admin for CIFS SWN netlink
Date: Thu, 28 May 2026 21:42:27 +0200
Message-ID: <20260528194647.399369848@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit d1ebfce2c1d161186a82e77590bf7da2ea1bce91 upstream.

CIFS_GENL_CMD_SWN_NOTIFY is the userspace witness-notify command.  The
intended sender is the cifs.witness helper, but the generic-netlink
operation currently has no capability flag, so any local process can send
RESOURCE_CHANGE or CLIENT_MOVE notifications to the in-kernel witness
handler.

The same family exposes CIFS_GENL_MCGRP_SWN without multicast-group
capability flags.  Register messages sent to that group include the witness
registration id and, for NTLM-authenticated mounts, the username, domain,
and password attributes copied from the CIFS session.  An unprivileged
local process should not be able to join that group and receive those
messages.

Require CAP_NET_ADMIN for incoming SWN_NOTIFY commands with
GENL_ADMIN_PERM, and require CAP_NET_ADMIN over the network namespace for
joining the SWN multicast group with GENL_MCAST_CAP_NET_ADMIN.  The
cifs.witness service runs with the privileges needed for both operations.

Fixes: fed979a7e082 ("cifs: Set witness notification handler for messages from userspace daemon")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/netlink.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/smb/client/netlink.c
+++ b/fs/smb/client/netlink.c
@@ -33,13 +33,17 @@ static const struct nla_policy cifs_genl
 static const struct genl_ops cifs_genl_ops[] = {
 	{
 		.cmd = CIFS_GENL_CMD_SWN_NOTIFY,
+		.flags = GENL_ADMIN_PERM,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = cifs_swn_notify,
 	},
 };
 
 static const struct genl_multicast_group cifs_genl_mcgrps[] = {
-	[CIFS_GENL_MCGRP_SWN] = { .name = CIFS_GENL_MCGRP_SWN_NAME },
+	[CIFS_GENL_MCGRP_SWN] = {
+		.name = CIFS_GENL_MCGRP_SWN_NAME,
+		.flags = GENL_MCAST_CAP_NET_ADMIN,
+	},
 };
 
 struct genl_family cifs_genl_family = {


