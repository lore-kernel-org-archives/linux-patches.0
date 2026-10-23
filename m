Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774582;
	b=mwswNw5nRnNsGYT/ynzg2FVa6bQpB2I6EBxutN6AKFEGD6Ay5M673BhLVanPYTnSN4as
	 JG880TRcRSxAQjfuCnqUBvks2W6xxutjaUqWO0tVkHGrK7mX56OaYIHxsJWlJ1X9OppzM
	 JPuSg28jVeGOhf5pv4QW6mQdOYnrUygeBTpEJ3Yum4B3eEQid1VEdyJcmI1WCgj834ZAl
	 WLbUSCxbKUWRpsCQzWkSJ1DvTHABRcTms6Jf3DWyQ9JNm9OL2vo89Mr1jbAvQeSWNw5w5
	 8AKrjQ6MrJZUxnplfoPC/LWOxV3hAnxMEdHVwfhltXyfohiH3Dih/SvsL7fr4zU5hgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5WmOYUsJaPCYuWBZSXsrue4Ryf+R+C1HdmRDBSwOSmA=;
	b=lnRDpLsli/CJNHb0/ktnDH8X38NERRwzLMGTAr1F0b+I1AMZC5JW9MKaixSprsyLm2mI
	 U8ZEdGN16XRihNsv2aKw9E+RO977q85Od6hU4LeQHepaHZmFIFPmdxPskWEXSvKz3O8te
	 6u3JYWWo8UkQPHQbTPmQLvCXFKeHR5ID5ERyqmVSkJryJB0V0KDMVEiVUmV+FqmjYsU0w
	 YLytrgK8hEgPVAAhHgxZahwFBDeuPYwC98MCVztQG0Kn0SlSwYXHw3s8dbYIEtHSVfv/b
	 vU1d8C9rvySxOs8x5Wf9f3IPodrQ8OYwuSQu6//vb9V4B9uEUpW3bnt6hMtIO+M0vcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mRAPToRw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA0B606A31D;
	Fri, 23 Oct 2026 16:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mRAPToRw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D521F01825;
	Fri, 23 Oct 2026 16:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774581;
	bh=5WmOYUsJaPCYuWBZSXsrue4Ryf+R+C1HdmRDBSwOSmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mRAPToRwBHQgpxozbBV/hgzzqocvdAa7xQsegM3gmuJmEoqMWGs+kFfQYFtrJZaCC
	 BTIln6Emetdh3bVXn+iD/9gGVaM6vNGmV8bvxJFjogRp/cW6gkIf4IafbrYUR8KAI0
	 blxWVvFOwKTFdosPO6/vIrTItPF2BWJ2U7fguL3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 051/242] scsi: target: iscsi: Fix race in discovery auth updates
Date: Fri, 23 Oct 2026 18:38:13 +0200
Message-ID: <20261023163714.983825494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 704ec94383c3c..e1aa0af52c658 100644
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



