Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1522C3EEAC6;
	Wed, 20 May 2026 17:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296929; cv=none; b=GRCSATokzveRZkYM+mw8zM3NUhCSCcz9CADVTBopJgY0QkaT4zdBEeau1xgwhUkJsgbqwBTcHt7VwwbPFxvvTepGb8Hi3Dlc6likRsNotoUdFOQyCjufBL0OWn1g9FtvMBJYSvqavEYq+l5VeTaz+FdB2ks6O9umAyuStS2hlNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296929; c=relaxed/simple;
	bh=JK35KytxAdQlQym8N5IoSUgIMqb/u37RcP52GhjvOFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3QSvpeh2Jnjf9JZ/yqe0vqjLTlPRRLQU0WdY1uz0acZe09XnH4pMLa5yXSPgHvQlo1e6WS1BpZ1LOiH3eancEv7OokhfYtQjGFqdSeRoVJQ07YMsjUqEpIX8V8JmXE9Pp6ld+kZAXKMklXulGWMhZU8zqK1nm8WzDQLYFKQ4go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyHf3fBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyHf3fBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B8E1F000E9;
	Wed, 20 May 2026 17:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296927;
	bh=SXdZtVQYDLS7x4tic5GenVGSJ+k2wKa01hI6cl9UEWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uyHf3fBC32OtgGlzg4r4MJSDMzHfaOk5ubtMyn2qY2IWh9G+bUm8t+GorfqHtjXyX
	 IMrBZ04mKqegVz1EPzBBmo4DhOKlGnH0DnvnroqRtmnJZT756XtwJrMYEZlzzYNMi3
	 xREvIqqNyVm/FV/yy59VXWEm4sbR/hPHKJ7PHbkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0984/1146] net: psp: require admin permission for dev-set and key-rotate
Date: Wed, 20 May 2026 18:20:34 +0200
Message-ID: <20260520162210.500939701@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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
index f3a57782d2cf4..49b7563f705f1 100644
--- a/Documentation/netlink/specs/psp.yaml
+++ b/Documentation/netlink/specs/psp.yaml
@@ -188,6 +188,7 @@ operations:
       name: dev-set
       doc: Set the configuration of a PSP device.
       attribute-set: dev
+      flags: [admin-perm]
       do:
         request:
           attributes:
@@ -207,6 +208,7 @@ operations:
       name: key-rotate
       doc: Rotate the device key.
       attribute-set: dev
+      flags: [admin-perm]
       do:
         request:
           attributes:
diff --git a/net/psp/psp-nl-gen.c b/net/psp/psp-nl-gen.c
index 22a48d0fa378c..953309952cef7 100644
--- a/net/psp/psp-nl-gen.c
+++ b/net/psp/psp-nl-gen.c
@@ -76,7 +76,7 @@ static const struct genl_split_ops psp_nl_ops[] = {
 		.post_doit	= psp_device_unlock,
 		.policy		= psp_dev_set_nl_policy,
 		.maxattr	= PSP_A_DEV_PSP_VERSIONS_ENA,
-		.flags		= GENL_CMD_CAP_DO,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
 	},
 	{
 		.cmd		= PSP_CMD_KEY_ROTATE,
@@ -85,7 +85,7 @@ static const struct genl_split_ops psp_nl_ops[] = {
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



