Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389353F39C9;
	Wed, 20 May 2026 17:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299554; cv=none; b=V2aLLjSHE5F7oxcI8Xs5BveKHofNyZMUbMkBrgvdBG8oXkL/+KsD2w3DG5LWcD9oi/zYYqRPygsli6zfll2ZJuR7PCtO+J1tUmgW5C2QcydVUbgBmbs5fYLr1Km/21trC7StHucdstNLbOKEz+/6ua+c/SeIwxL2ttIGhrl8U40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299554; c=relaxed/simple;
	bh=ufuPxD45EdDE6mgFWVNUPkgEdVt3Iz+mZ/tRnjrcCcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mcD7Y7lAm96+ObEqH3sgWGGEDYhIpSDy0s61VBcVExoAHpLSTqVuyDaL388oT9nn6Twru91nL3hr+URt3vbC+dvPXdFl4AkyOFubub1i35FPYwnVjpXhdIGJUPxXXufXeXK7dwx9VDAqeAMcfLAFEpdN8czS8hc7Yo2Dj0s/1SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2RD5Ud5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2RD5Ud5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E65E1F000E9;
	Wed, 20 May 2026 17:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299553;
	bh=KTzYUXeFrXBDVOHej8qkvImqf5etbBib4oJlxVCss7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f2RD5Ud5KN3ei7eoBjw5zsG3TUPjLfTnFrnTeBP5zR6KGrvfBIkUNWUdBSDp8XQ/t
	 Wv21kXj8Dac1VQG0aSA/4ImZ6+1eVKqAIlaE9O6hjFLqSoSnAxuspbS/GfrJ8t5CCo
	 J41O/oZLsww9NC2iXuNeCV6jUrxfLr4ymWTeazno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 816/957] net: psp: require admin permission for dev-set and key-rotate
Date: Wed, 20 May 2026 18:21:39 +0200
Message-ID: <20260520162152.262979518@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit b718342a7fbaa2dff5fefc31988c07af8c6cbc21 ]

The dev-set and key-rotate netlink operations modify shared device
state (PSP version configuration and cryptographic key material,
respectively) but do not require CAP_NET_ADMIN. The only access
control is psp_dev_check_access() which merely verifies netns
membership.

Fixes: 00c94ca2b99e ("psp: base PSP device support")
Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260427195856.401223-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/psp.yaml | 2 ++
 net/psp/psp-nl-gen.c                 | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/netlink/specs/psp.yaml b/Documentation/netlink/specs/psp.yaml
index 944429e5c9a84..d41ea6155e52e 100644
--- a/Documentation/netlink/specs/psp.yaml
+++ b/Documentation/netlink/specs/psp.yaml
@@ -111,6 +111,7 @@ operations:
       name: dev-set
       doc: Set the configuration of a PSP device.
       attribute-set: dev
+      flags: [admin-perm]
       do:
         request:
           attributes:
@@ -130,6 +131,7 @@ operations:
       name: key-rotate
       doc: Rotate the device key.
       attribute-set: dev
+      flags: [admin-perm]
       do:
         request:
           attributes:
diff --git a/net/psp/psp-nl-gen.c b/net/psp/psp-nl-gen.c
index 9fdd6f831803e..85cf90999c9f1 100644
--- a/net/psp/psp-nl-gen.c
+++ b/net/psp/psp-nl-gen.c
@@ -70,7 +70,7 @@ static const struct genl_split_ops psp_nl_ops[] = {
 		.post_doit	= psp_device_unlock,
 		.policy		= psp_dev_set_nl_policy,
 		.maxattr	= PSP_A_DEV_PSP_VERSIONS_ENA,
-		.flags		= GENL_CMD_CAP_DO,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
 	},
 	{
 		.cmd		= PSP_CMD_KEY_ROTATE,
@@ -79,7 +79,7 @@ static const struct genl_split_ops psp_nl_ops[] = {
 		.post_doit	= psp_device_unlock,
 		.policy		= psp_key_rotate_nl_policy,
 		.maxattr	= PSP_A_DEV_ID,
-		.flags		= GENL_CMD_CAP_DO,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
 	},
 	{
 		.cmd		= PSP_CMD_RX_ASSOC,
-- 
2.53.0



