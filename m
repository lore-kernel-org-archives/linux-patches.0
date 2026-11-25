Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622362;
	b=aHijy71lfMZUclDCVR1sOInAZ5RoJDd+mQs2VXNWuyclpPNJ0j5b2bJHrVII4Y4VMJCl
	 HcGJM2d+wdB4v+vXX7KFvPL7LNqNkmJ6xczIeqi5OGNj59QApV6ozsUloI8+7dzMW4FSP
	 IKP+Vug7WIyNBYtcnILKCiyA3++VWLHaOK33K2jdTnfqCf0BqvAuhejkPpkEp2yMWwV2d
	 D/f7WXxZ4dG9u6r9ORKMJxFROiDrfUFEo8Kf+b5Dl/dxXm/5po+RsPyUfBFfZRSugB3BR
	 6l3e7BSF1zGykLj2+4uFDScDNmV+gE/bra+R0OsQCSl94wPoMziBwCx5HI9HZSl/u/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xtVaXWKzsk/DOSmj9pQTs4aU+SOF1ERAVUhVHjnQGlY=;
	b=2REQ21CJEaAgBO1Arwr6r6eKOI+NTmD3Gh8EjEuvwGlj8gcq9OjBIa+b1DduUa+/6xwn
	 EEz9sSKlBH17J24oOatcVVAcRgWxWcd20HxTDkP5ZVpRMZ6KJyIgZBKM9z7HftnkU9GJ+
	 WV3U1hiQI5XEg15ZUDuNoKNV38gV3my8d9bOPqRxpEutWNs/dKyf/jtCvNKb8sF+geuVp
	 J3mOYXrdKpRxpfF08OlhCmuiNSQ+hDOy7MADeN7qagdEDGjs9I3ferdBWz/aaK7JSyDqz
	 l5iKl0uZe8PwyXlfQJWwYC6E0+p3Yx2skQJL/d2i2bd176eqI5XWvqW0yGs2sDZCcAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qgsWl87r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F80606A327;
	Wed, 25 Nov 2026 15:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qgsWl87r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AB61F000D1;
	Wed, 25 Nov 2026 15:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622361;
	bh=xtVaXWKzsk/DOSmj9pQTs4aU+SOF1ERAVUhVHjnQGlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qgsWl87rfPr9bJUiTysFlddsxUNeLQeESQICDQeA1tTHORafsquKsRYIZpDJiOUKc
	 jHiUgU0v2djvIAuy5ouSsiXObOrEir2dnhC2Co+BAUvQpRP0VHTXSRn1GJgpNRsQTu
	 jAxQgaJlt19JuDibYRHoX3Cvd+hMDmf6CWFL2R1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 514/990] ACPI: glue: Rearrange acpi_bind_one() to avoid breakage
Date: Wed, 25 Nov 2026 15:31:21 +0100
Message-ID: <20261125143834.137625178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit fcfb2b562115632e0a60a0928dca495f98eb335c ]

Rearange the code in acpi_bind_one() to avoid situations in which the
existing ACPI companion of the given device would be replaced with NULL
due to a memory allocation error or because somebody tries to bind a
physical device with an ACPI companion to a different ACPI device
erroneously.

Fixes: 7b1998116bbb ("ACPI / driver core: Store an ACPI device pointer in struct acpi_dev_node")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ rjw: Merged two conditionals to avoid redundant check ]
Link: https://patch.msgid.link/3465482.44csPzL39Z@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ sashal: Rewrote the one kzalloc_obj(*physical_node) call in acpi_bind_one() as kzalloc(sizeof(*physical_node), GFP_KERNEL) to match the context in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/glue.c | 58 +++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 34 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index e2a40847d24b6..f915a7c0e7cca 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -243,31 +243,25 @@ static void acpi_physnode_link_name(char *buf, unsigned int node_id)
 int acpi_bind_one(struct device *dev, struct acpi_device *acpi_dev)
 {
 	struct acpi_device_physical_node *physical_node, *pn;
+	struct acpi_device *comp_dev = ACPI_COMPANION(dev);
 	char physical_node_name[PHYSICAL_NODE_NAME_SIZE];
 	struct list_head *physnode_list;
 	unsigned int node_id;
 	int retval = -EINVAL;
 
-	if (has_acpi_companion(dev)) {
-		if (acpi_dev) {
-			dev_warn(dev, "ACPI companion already set\n");
+	if (!acpi_dev) {
+		if (!comp_dev)
 			return -EINVAL;
-		} else {
-			acpi_dev = ACPI_COMPANION(dev);
-		}
-	}
-	if (!acpi_dev)
-		return -EINVAL;
 
-	acpi_dev_get(acpi_dev);
-	get_device(dev);
-	physical_node = kzalloc(sizeof(*physical_node), GFP_KERNEL);
-	if (!physical_node) {
-		retval = -ENOMEM;
-		goto err;
+		/* If the companion has been set upfront, pick it up. */
+		acpi_dev = comp_dev;
+	} else if (comp_dev && acpi_dev != comp_dev) {
+		dev_warn(dev, "ACPI companion already set to %s which is not %s\n",
+			 acpi_dev_name(comp_dev), acpi_dev_name(acpi_dev));
+		return -EEXIST;
 	}
 
-	mutex_lock(&acpi_dev->physical_node_lock);
+	guard(mutex)(&acpi_dev->physical_node_lock);
 
 	/*
 	 * Keep the list sorted by node_id so that the IDs of removed nodes can
@@ -278,15 +272,12 @@ int acpi_bind_one(struct device *dev, struct acpi_device *acpi_dev)
 	list_for_each_entry(pn, &acpi_dev->physical_node_list, node) {
 		/* Sanity check. */
 		if (pn->dev == dev) {
-			mutex_unlock(&acpi_dev->physical_node_lock);
-
-			dev_warn(dev, "Already associated with ACPI node\n");
-			kfree(physical_node);
-			if (ACPI_COMPANION(dev) != acpi_dev)
-				goto err;
-
-			put_device(dev);
-			acpi_dev_put(acpi_dev);
+			if (!comp_dev) {
+				/* Really unexpected. */
+				ACPI_COMPANION_SET(dev, acpi_dev);
+				dev_warn(&acpi_dev->dev,
+					 "Physical device list corruption fixed up\n");
+			}
 			return 0;
 		}
 		if (pn->node_id == node_id) {
@@ -295,12 +286,19 @@ int acpi_bind_one(struct device *dev, struct acpi_device *acpi_dev)
 		}
 	}
 
+	physical_node = kzalloc(sizeof(*physical_node), GFP_KERNEL);
+	if (!physical_node)
+		return -ENOMEM;
+
+	acpi_dev_get(acpi_dev);
+	get_device(dev);
+
 	physical_node->node_id = node_id;
 	physical_node->dev = dev;
 	list_add(&physical_node->node, physnode_list);
 	acpi_dev->physical_node_count++;
 
-	if (!has_acpi_companion(dev))
+	if (!comp_dev)
 		ACPI_COMPANION_SET(dev, acpi_dev);
 
 	acpi_physnode_link_name(physical_node_name, node_id);
@@ -316,18 +314,10 @@ int acpi_bind_one(struct device *dev, struct acpi_device *acpi_dev)
 		dev_err(dev, "Failed to create link firmware_node (%d)\n",
 			retval);
 
-	mutex_unlock(&acpi_dev->physical_node_lock);
-
 	if (acpi_dev->wakeup.flags.valid)
 		device_set_wakeup_capable(dev, true);
 
 	return 0;
-
- err:
-	ACPI_COMPANION_SET(dev, NULL);
-	put_device(dev);
-	acpi_dev_put(acpi_dev);
-	return retval;
 }
 EXPORT_SYMBOL_GPL(acpi_bind_one);
 
-- 
2.53.0



