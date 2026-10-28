Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211744;
	b=UnKrj52D6HArE7r9dTdwQrEqxvXRAcgwkxUVBDwI4iL4RQ+OpfbkgbrjcdgG1xU/hs4S
	 saQNH+kxaHML45pHQnAScK+skfkXEBkcHNqkmJIs6HwY7tdVdtQO7jzb25xi9hyYL4UU+
	 VUxKeC9JyP43NmhmIUoX304dWzAfXU000X+1ZVpuCFQz1Mx9gSilMOzYBQUGE4Bbyr8r6
	 Sz8wQY3E+/oiuQh2dT6UfyG2i+vz+A9acIn9wZShmlTZrTFboebZcjrowK2ebZGuVLGFo
	 HAHUh3fBlvBeH6sVR0IdvKp9IBBx4IKShKtzqYSleTVlJ9k76Y5bErIatXbbty1LzTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qUUo/4HP+vB2UZ1FRofGum9/nOA/eIPbcgIz3ZHzXWg=;
	b=pK9NTeaoBNsPwATVDl2HNsUOr9jZcmII+QyA2Yr4UvIj3X2WyXShZFXE3tNu3D8eX3c3
	 Wa+EHjmzJ+pqQufmsEyCI48cBW3KDlZlf02lK0lw58xOvwDhKJWFz0pT7/2a3i034Vv0f
	 1Be8QRS+Ehx2u+d+wUdrBdSVMU4+WZaaguaUYsVxekCaCSWk+aUzOZz54Sy5RvYvOV7b0
	 j7MisAQU4vRC67oSbtY9EoGelECE8MmeU6VUp9WjwBTcKVq434k14iFu6DMLhZ/JRD0ty
	 7ATBPwbJyXoqPQRfQ0hnDNYpVJsEylFOH4PXRTupOSfWnF/QeLni3E3MT6g5ePqe/iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FrRCC6wQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09B6606A321;
	Wed, 28 Oct 2026 18:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FrRCC6wQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2B11F01825;
	Wed, 28 Oct 2026 18:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211743;
	bh=qUUo/4HP+vB2UZ1FRofGum9/nOA/eIPbcgIz3ZHzXWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FrRCC6wQjp5XNMiRh38LmvrWwcrwE5+3SuIqMPebxGOZ9y7fFv6dn6Fw1FEiTTAgn
	 0kp4CJKTYS48DMzlzVxwbXXcGaS3r+vMq99VSAsSro6yIzOe9QCVV/tsUZ8cFJfdXu
	 89y5t/YFDRhiz/78F2EJ2EkVzn5JBtMyWsSoW6qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 485/571] scsi: target: iscsi: Fix race in discovery auth updates
Date: Wed, 28 Oct 2026 18:00:32 +0100
Message-ID: <20261028170019.534931056@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit e15b81f602edbdee39c335546f25486a1747f3f0 ]

Separate configfs opens can concurrently update the discovery AuthMethod
parameter. Both callers may free the same value in
iscsi_update_param_value(), causing a double-free.

Protect the lookup and replacement with the discovery TPG access lock,
as used by the other TPG configfs parameter updates.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Link: https://patch.msgid.link/20260811124843.6817-1-linfeng.sun.dev@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 26 ++++++++++++++------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 4ae5314e8c453..a0a024ae652f8 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1284,17 +1284,24 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
 		return -EINVAL;
 	}
 
+	if (iscsit_get_tpg(discovery_tpg) < 0)
+		return -EINVAL;
+
 	param = iscsi_find_param_from_key(AUTHMETHOD,
 				discovery_tpg->param_list);
-	if (!param)
-		return -EINVAL;
+	if (!param) {
+		err = -EINVAL;
+		goto out;
+	}
 
 	if (op) {
 		/*
 		 * Reset the AuthMethod key to CHAP.
 		 */
-		if (iscsi_update_param_value(param, CHAP) < 0)
-			return -EINVAL;
+		if (iscsi_update_param_value(param, CHAP) < 0) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		discovery_tpg->tpg_attrib.authentication = 1;
 		iscsit_global->discovery_acl.node_auth.enforce_discovery_auth = 1;
@@ -1305,8 +1312,10 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
 		/*
 		 * Reset the AuthMethod key to CHAP,None
 		 */
-		if (iscsi_update_param_value(param, "CHAP,None") < 0)
-			return -EINVAL;
+		if (iscsi_update_param_value(param, "CHAP,None") < 0) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		discovery_tpg->tpg_attrib.authentication = 0;
 		iscsit_global->discovery_acl.node_auth.enforce_discovery_auth = 0;
@@ -1315,7 +1324,10 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
 			" Discovery TPG\n");
 	}
 
-	return count;
+	err = count;
+out:
+	iscsit_put_tpg(discovery_tpg);
+	return err;
 }
 
 CONFIGFS_ATTR(iscsi_disc_, enforce_discovery_auth);
-- 
2.53.0



