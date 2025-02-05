Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6657E792;
	Wed,  5 Feb 2025 14:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765824; cv=none; b=cO5uWYy6bA/ugmg7OYlqeyVKjolxAy6eGRvww752frrX0Gr65Dxh7Gy39EJRpvvmCs9Yi61R8gB1CJAL8vaMhqeOakFUgRi2R5dtcVIURTM3cMvv6d684JyAl/imE5B4Aj1s8D7XCXpc6mP+ElVXSy/66bmU57R7EXuezS8hkho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765824; c=relaxed/simple;
	bh=xgBvLQKocCw72A6oV20tJhYPKoilAN6LE8OTtLmIeZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HM7amIVanpBNl//DJ85ivE2VbvkIj5Pjh4FH0lZyZug4uXo3iU79cDIKekZHvOs2wfIQATZk9q3TNYK7vM5DkGqmS2yWYnBhhDZ0v+qi20m3w5Zl82H/wYgw2v+RHKTCd486dHHqk8yfJjQfH+L5WKg2nCD/H01jb9RRv3RTJYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQNjDJv8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQNjDJv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9434FC4CED1;
	Wed,  5 Feb 2025 14:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765824;
	bh=xgBvLQKocCw72A6oV20tJhYPKoilAN6LE8OTtLmIeZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQNjDJv82csiMqn7bKLB4eOZLcckpm8UU57E1VUmiFykmWOetZ+NPDmmZ0F3KZV2W
	 fxfpUMcGvoQ5umhp7z4+manLF5cCphC5x/A1LrQurJcKZwI7moqHTi89AzBZ/NFw0N
	 vx7ZxabK26VXVAzoXq8GaolP47e2yf6MTn6kZo+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Kumar Singh <quic_adisi@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	Nicolas Escande <nico.escande@gmail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 217/623] wifi: ath12k: fix key cache handling
Date: Wed,  5 Feb 2025 14:39:19 +0100
Message-ID: <20250205134504.527607184@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Kumar Singh <quic_adisi@quicinc.com>

[ Upstream commit 336097d74c284a7c928b723ce8690f28912da03d ]

Currently, an interface is created in the driver during channel assignment.
If mac80211 attempts to set a key for an interface before this assignment,
the driver caches the key. Once the interface is created, the driver
installs the cached key to the hardware. This sequence is exemplified in
mesh mode operation where the group key is set before channel assignment.

However, in ath12k_mac_update_key_cache(), after caching the key, due to
incorrect logic, it is deleted from the cache during the subsequent loop
iteration. As a result, after the interface is created, the driver does not
find any cached key, and the key is not installed to the hardware which is
wrong. This leads to issue in mesh, where broadcast traffic is not
encrypted over the air.

Fix this issue by adjusting the logic of ath12k_mac_update_key_cache()
properly.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3-03253.1-QCAHKSWPL_SILICONZ-29 # Nicolas Escande <nico.escande@gmail.com>
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1  # Nicolas Escande <nico.escande@gmail.com>

Fixes: 25e18b9d6b4b ("wifi: ath12k: modify ath12k_mac_op_set_key() for MLO")
Signed-off-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
Acked-by: Kalle Valo <kvalo@kernel.org>
Tested-by: Nicolas Escande <nico.escande@gmail.com>
Link: https://patch.msgid.link/20250112-fix_key_cache_handling-v2-1-70e142c6153e@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 30 ++++++++++++++++-----------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index fd2919f84d6f7..ef2736fb5f53f 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -4316,7 +4316,23 @@ static int ath12k_mac_update_key_cache(struct ath12k_vif_cache *cache,
 				       struct ieee80211_sta *sta,
 				       struct ieee80211_key_conf *key)
 {
-	struct ath12k_key_conf *key_conf = NULL, *tmp;
+	struct ath12k_key_conf *key_conf, *tmp;
+
+	list_for_each_entry_safe(key_conf, tmp, &cache->key_conf.list, list) {
+		if (key_conf->key != key)
+			continue;
+
+		/* If SET key entry is already present in cache, nothing to do,
+		 * just return
+		 */
+		if (cmd == SET_KEY)
+			return 0;
+
+		/* DEL key for an old SET key which driver hasn't flushed yet.
+		 */
+		list_del(&key_conf->list);
+		kfree(key_conf);
+	}
 
 	if (cmd == SET_KEY) {
 		key_conf = kzalloc(sizeof(*key_conf), GFP_KERNEL);
@@ -4330,17 +4346,7 @@ static int ath12k_mac_update_key_cache(struct ath12k_vif_cache *cache,
 		list_add_tail(&key_conf->list,
 			      &cache->key_conf.list);
 	}
-	if (list_empty(&cache->key_conf.list))
-		return 0;
-	list_for_each_entry_safe(key_conf, tmp, &cache->key_conf.list, list) {
-		if (key_conf->key == key) {
-			/* DEL key for an old SET key which driver hasn't flushed yet.
-			 */
-			list_del(&key_conf->list);
-			kfree(key_conf);
-			break;
-		}
-	}
+
 	return 0;
 }
 
-- 
2.39.5



