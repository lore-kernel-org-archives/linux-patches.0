Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207514;
	b=xxeMzhJ5Sjur2miUSbRzqgoXY7JLRju6Ski/xT8bIRhbKaB60ZFmG7+brARMMMQk1WTv
	 enUZlveoX4v4/wqqyQNGUP20iFuN/zHdEK4V/ULCr/tS0iYhqHExDjQSUBczXp01mNupV
	 crqpUQy2dca3UPmC72nBAdBpvi2CQbhi2nT7rci5Rpfwl5+WgZCySxLLziL21JrbEBYgN
	 IM4hb2r3bgJ1AH3+JwlAFjFqaWDQmZO9kOrpxvgcn21xorH680XwEI6uFHgc3E7+H8vKF
	 M1UswCzoZhpQo71MTBvz3y3VvubYZzBrIgn/xPlt8GlRAgBEvgveJ0MT62rEttWyVLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gpTrtFRT61VZDgcbZdQFJGDcQa3q1ZrNPyQYTRI18/w=;
	b=3f6W6gz+xzfF5siQ7SC7fJcMU+CSq0sD0hYCMMCmGlkp2t0AoUyJNVeTEMJsw9YWaOVP
	 ei1KOY+DLEbTgRezJGJmeiLjW9AoWmcoZ7dtHLJNwnV/trTTXrESomVSRXb+GkaW9SqSQ
	 eIhgTUgLkDseC9XEn1gJtECQnudJ+Rj3hypgN+6yUpGKdfyhc1UNkVR45DztNT+OEK9LN
	 AJvMMJmg3dFeORZxVw8EHbUKfK1qXz1QgrIdY1iC6iuzSpTI/WsJ0Zq2cFFZTzr2SKdPH
	 RW/7zB6V56sV9Ob3RLVeUEQ8LUtq4j9VHeYaP3lbd9OvlJ8t8cqHMUCOaDOUHmNUouQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SlCdxEw4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D92606A334;
	Wed, 28 Oct 2026 17:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SlCdxEw4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643D61F031E3;
	Wed, 28 Oct 2026 17:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207513;
	bh=gpTrtFRT61VZDgcbZdQFJGDcQa3q1ZrNPyQYTRI18/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SlCdxEw460KKGcT0HLrRZn/if7Hj+wshzTFM33NUfmHRxHnFHmba5iFj+aoj7czQC
	 PPQF83qfu9ECHy/+kxViNQTNS1o5xtz/Q+SmObA0MiImsti+tqrNL5A/wJXokPzMw2
	 9Sqt9wjh/bU54Rbl2th5GiDl78WWNl0N40D6BvDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/247] scsi: target: iscsi: Fix race in discovery auth updates
Date: Wed, 28 Oct 2026 17:57:27 +0100
Message-ID: <20261028165948.414644005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 88db94f382bb9..5e01ab65cec5f 100644
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



