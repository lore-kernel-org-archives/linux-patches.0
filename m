Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514AF2DF6E6;
	Thu, 28 May 2026 20:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999345; cv=none; b=k0g72ANUwbosR6cmwZRX3Gfz9Ii4ozhnu+BuMTP4qHnZ5jREhdn0qZsWHub9e5dIs5qJsAbY47BtJXW3E14htm/2BKQaa5UIoDvQhDzIgLX0xvkcriJlEMa1ZUItnStka3zL3AnYiPrqksQOm2WBR2Q8lWPM8yicXg/TZ4MRX3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999345; c=relaxed/simple;
	bh=OqjwqHKoQvFfUAdlhZFUJXAlDIZZQChFiy8fl5VdhGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lb+gJOswJFvHGINJh/xcqbsLTGCXi/yKKgSVQGnGSNTutFoYjz9jhNIm6t3ZXa5bFaoy7PjrwyaGlqGDEV186Q6O+G4nmoto6LOrwV/f6HpY66wOWJcLC+vSyk8J2x+XjI5quirZr4/CxuYFtkTnZEdcIxqGwii8/mkHKPwjbSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrCX805V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrCX805V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC6C1F000E9;
	Thu, 28 May 2026 20:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999344;
	bh=itj55XZjMwcfJP35tuyNmunYUynDnuxeQ0OqNBtLjDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrCX805Vc1s++UosTBi5PyCSgVijUOXBqKyK1kVaZhlrATNwDAHUGe1ZsAHo53rCf
	 JKPCQKx2R9wt4T1e/ue+8sKSyh4PgR9b1GQ7xCEh7tv1tNTUKyde+m8R7MMMc/2wH5
	 6T9/Lgp2oFuA58TjSPgsd79b96tKhm+Q+Tm4YEHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 032/377] smb: client: require net admin for CIFS SWN netlink
Date: Thu, 28 May 2026 21:44:30 +0200
Message-ID: <20260528194639.311322375@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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


