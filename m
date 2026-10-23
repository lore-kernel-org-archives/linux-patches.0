Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773898;
	b=whT0gqXZGTb4pCtgwmdjbV9MjQPxkHE+CfZtj4knmYbv4ftWGtlJe3fVfsxF6WjIczu/
	 uWyEffShWpklS3j0KwT/bCKGH5+gXJzK3AAWUT45YoKswk2MFodCCwDJNfpo4CcNf67qw
	 +8Q6KrEzYO+GqGib+FGofuExAnSbHh8S3cyw3pCMQTZUjQpCO0XBt50GsrwcDD6+4quQR
	 Hz4T137E4Ts8qd5x+XGg9+tHI3B2N7n4rxQGOPDALUvPF/xd4pgNj6R4hhSHShykNQEEH
	 nKgQHWZrfhsjFX0CV8ggupYoYcJLOx8UfNXGu2WmKYhx4bL7G15vNfv0+AQr+u7mu5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V+mYi12QBLkyth5hwNW3DawAvYbSmu1DQY1IJHfj0ik=;
	b=w+z4Tvvtvz/28k1XPqTERUI4S6q9B2WKa91xVZ+gKHLudRs4CzJIg6Z4Um8yyIYr0fMW
	 i46IPOl/80jWAyv7S2RknRLv8fHLluqr6SjULoVAYPQBJZ6uEaBf1vV1N64GpIktdHBR0
	 n8YDpux/wHd+38nLKZP9prexCbUvrwJiDLIBs8fgmTSa8sfjUobYUltnvDx9bBkxKkUpx
	 UpUM9vvNv15xJoRpO1bSxTMbJUzOEdq1v5Kz9f3s+oOtZHIqHlQoRmj7NtcUfq7yW/fzG
	 h9k0hfsm1oi81ygMXQ9csZPd0ulX0ngvwtUDvWh+pHir7Vfav7Lsdicq3otiH4ecizA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H4fsVPSa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9016E606A31B;
	Fri, 23 Oct 2026 16:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H4fsVPSa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3131F01828;
	Fri, 23 Oct 2026 16:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773898;
	bh=V+mYi12QBLkyth5hwNW3DawAvYbSmu1DQY1IJHfj0ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H4fsVPSayfbR5WXOpt5su3QyeZvtDe1QzHCIqQcZnLA6bnedFuIb5XRqOMp/D/eWB
	 uBxnOjAPpbO7rHgEz/D2N7kouYOQAz3frI+NvlYrs1cvpe1phDIF7OIlaGVpl9+xoY
	 PE7g4UjIzJq5897UKlFQx17ojzC9KZXmWXCmVH2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 051/193] scsi: target: iscsi: Fix race in discovery auth updates
Date: Fri, 23 Oct 2026 18:35:28 +0200
Message-ID: <20261023163715.414156937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index efe8cdb200609..3b4e7a8d3d317 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1306,17 +1306,24 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
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
@@ -1327,8 +1334,10 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
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
@@ -1337,7 +1346,10 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
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



