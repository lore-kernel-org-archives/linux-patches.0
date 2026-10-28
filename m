Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209352;
	b=mRKkNxQfTrs+4F/1wx8cuDxTbdAb1M6AbedkFo/XWntFSk4NDdxgglC/fRYhUwPIfs8L
	 no8H+t/ZD3q/KQsNuQNyf3SP7h5TWwBuA7aFciECY3xgj9W6QJSOH3BKO/1DRJEPJgeHB
	 nb11q5HJ7/sZIr0aIM3rkDd7TOIQAfDmLQE9R4I8Hkh61Id+IA9EQ25MEQHL7Kz9B+ckL
	 c2eTqcFErvlH3bI4e/u3ss6qKsS0VzMgIb2KSBVKenHi7RRiiJFLCrEolmXvqxIcmj8O2
	 evbxzJfHylD8NTzJZ9kqOAJHqw/y8abCgDfaj8pnFi/+dTfiiiY7xmlzhYGH9t9DywA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IFiZOBE9hJN4bJDkr3AxBdUZQNCnUc8uSQXYUX943AY=;
	b=pQl6JP3sKWasv80rLpIrUNSBUooH1qjuUlccVzY2u2xUt+LFpzLBiyhDrtwzDopoDiAn
	 4kfS41i55WdxAACaAvbWN148zQoHg8arv7kjOB2cQzAh6tfQg8OPAcM+mgMfCi0lAyqub
	 tOCP9GvCLyo+Pn3ZtHFf6X/iDi1jwQQbzTkNCSv6tlx5GH4II5wDjiWbZt2U+GafhoWxP
	 0JJ29IM2KxK/r+ddf+Ylb/YLpZ/O9gonOnRE8zy84yHmGHn56LBJf96Hb6TwtHmUhwTZN
	 xZohFRZ/huEkB2RE7nHa0sIkZWwSHLllzKikmstnyLWffDURrns+ivKKu5D1k+GZbvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrWx2Gvc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925A5606A31A;
	Wed, 28 Oct 2026 17:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrWx2Gvc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFFB1F01825;
	Wed, 28 Oct 2026 17:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209352;
	bh=IFiZOBE9hJN4bJDkr3AxBdUZQNCnUc8uSQXYUX943AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UrWx2GvcaUowPtunbACIzORhni/77nl1DFkYIeHMyKVnA5gNMLDeDoNW1tQ/rsbH/
	 61pCXTNmos79q5ITvzkBbNEpHjc6gu4f0c0c7hRHiLZeAzgDcKE+fnrIZyiwnZhwSi
	 N1jWdmSit4zTil2mFV8XSGdQgfie21S4aDJxYyhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 441/516] scsi: target: iscsi: Fix race in discovery auth updates
Date: Wed, 28 Oct 2026 17:59:53 +0100
Message-ID: <20261028170013.929823419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 755e980071b24..0af491672307d 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1285,17 +1285,24 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
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
@@ -1306,8 +1313,10 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
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
@@ -1316,7 +1325,10 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
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



