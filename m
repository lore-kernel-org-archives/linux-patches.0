Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3311A01DA;
	Thu, 15 Aug 2024 14:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731054; cv=none; b=dqMNz7ooGrZkq0wKU8NY7GJi6uZG0GssufhYE4Y/Fu9iAByhoF5GR/7dadT5IVQC1NU5Ze7mPf/MKJSlk0uP9iqSCalHAC9RbWAtWsxhS4A7nV6ThcKxTR32raHNxXesOf05qErkY5eBOR7R4SF/Er7vqoZBwjxFBDrVQmuSmDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731054; c=relaxed/simple;
	bh=U0vK2N6Jzbns1PAhGE9dClkAPlieknEsvQQdMLdGdUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsTeILIBt0KogGLWNsLJoop0tvRd8MfvMGbUPdXEQFysS2PmGpv2dxo2UXVrAROHD15bgzGaiRQD0qjA/50YJ3YddjZEgKrq4dUvk+l8KD9At5s4J2rUXKjAsr+/OjTYK2wH1MjDuhSmzIcgNZRen8TAD1SUZuXwLZbCNEd20UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfOiY3UO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfOiY3UO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A2DC32786;
	Thu, 15 Aug 2024 14:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731054;
	bh=U0vK2N6Jzbns1PAhGE9dClkAPlieknEsvQQdMLdGdUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lfOiY3UOgQ67YoonJdXbjAzpSRYlAO5tLCh9kb6+h/quK8ia06mlzIThAXgV0Wtst
	 QEBs533TQgZmXCnWAiXfkjdT7HpSBgDUPhh/YL/2QgEpfYe4hUsJ5esGbt2Nxaia7x
	 nwd6A+mevdwLWYZlKEuwF5wjefxOZDZSChh5mMnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aristeu Rozanski <aris@redhat.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 001/259] EDAC, skx_common: Refactor so that we initialize "dev" in result of adxl decode.
Date: Thu, 15 Aug 2024 15:22:14 +0200
Message-ID: <20240815131902.841507497@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit 29b8e84fbc23cb2b70317b745641ea0569426872 ]

Simplifies the code a little.

Acked-by: Aristeu Rozanski <aris@redhat.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Stable-dep-of: 123b15863550 ("EDAC, i10nm: make skx_common.o a separate module")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/skx_common.c | 48 +++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index 99dea4f66b5e9..e6647c26bd1bb 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -100,6 +100,7 @@ void __exit skx_adxl_put(void)
 
 static bool skx_adxl_decode(struct decoded_addr *res)
 {
+	struct skx_dev *d;
 	int i, len = 0;
 
 	if (res->addr >= skx_tohm || (res->addr >= skx_tolm &&
@@ -118,6 +119,24 @@ static bool skx_adxl_decode(struct decoded_addr *res)
 	res->channel = (int)adxl_values[component_indices[INDEX_CHANNEL]];
 	res->dimm    = (int)adxl_values[component_indices[INDEX_DIMM]];
 
+	if (res->imc > NUM_IMC - 1) {
+		skx_printk(KERN_ERR, "Bad imc %d\n", res->imc);
+		return false;
+	}
+
+	list_for_each_entry(d, &dev_edac_list, list) {
+		if (d->imc[0].src_id == res->socket) {
+			res->dev = d;
+			break;
+		}
+	}
+
+	if (!res->dev) {
+		skx_printk(KERN_ERR, "No device for src_id %d imc %d\n",
+			   res->socket, res->imc);
+		return false;
+	}
+
 	for (i = 0; i < adxl_component_count; i++) {
 		if (adxl_values[i] == ~0x0ull)
 			continue;
@@ -452,24 +471,6 @@ static void skx_unregister_mci(struct skx_imc *imc)
 	edac_mc_free(mci);
 }
 
-static struct mem_ctl_info *get_mci(int src_id, int lmc)
-{
-	struct skx_dev *d;
-
-	if (lmc > NUM_IMC - 1) {
-		skx_printk(KERN_ERR, "Bad lmc %d\n", lmc);
-		return NULL;
-	}
-
-	list_for_each_entry(d, &dev_edac_list, list) {
-		if (d->imc[0].src_id == src_id)
-			return d->imc[lmc].mci;
-	}
-
-	skx_printk(KERN_ERR, "No mci for src_id %d lmc %d\n", src_id, lmc);
-	return NULL;
-}
-
 static void skx_mce_output_error(struct mem_ctl_info *mci,
 				 const struct mce *m,
 				 struct decoded_addr *res)
@@ -580,15 +581,12 @@ int skx_mce_check_error(struct notifier_block *nb, unsigned long val,
 	if (adxl_component_count) {
 		if (!skx_adxl_decode(&res))
 			return NOTIFY_DONE;
-
-		mci = get_mci(res.socket, res.imc);
-	} else {
-		if (!skx_decode || !skx_decode(&res))
-			return NOTIFY_DONE;
-
-		mci = res.dev->imc[res.imc].mci;
+	} else if (!skx_decode || !skx_decode(&res)) {
+		return NOTIFY_DONE;
 	}
 
+	mci = res.dev->imc[res.imc].mci;
+
 	if (!mci)
 		return NOTIFY_DONE;
 
-- 
2.43.0



