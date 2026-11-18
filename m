Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049428;
	b=LHzMU301umpLuusxs/GB7A/y/xF0ePFDGnUxFdLwMKTG5vF8Ms05WfqwEHBp2miSbKQ+
	 72h5rftB467yN0jB4YVbcx/gRF0YXiffPGAW+wnMxhLj71SHVgyQLvAjvwdnhT6XlYz/v
	 fXHFXWX76K1YvRedHHrZUngTBIxXG/jZOsjLlZWWvb2CHRaqe3rnYqBcgNkxIKgZcmBNU
	 Ga0N4nwHrG8EC5Wklk9USRnmn2ej7RNRXyFxTmtMaiJJuFRHWo9fkj65wcVmVNqHvIFSw
	 YX2NLtIudQbglh6cVu8an4w7QZdLVFq83FHza7824j7a7bwRmtX4ZE/SRc3bxxdHqCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IKJn0CoBMesUVOVvrFwevpYsXfITT1dRcB0GKRYZQJQ=;
	b=Tii+mgU9xYXfwCqXnmPZIAA8I2LHpAE4eNaKQBB9Dkcg3cFrVy6vJOnHBm14H2fH0xb0
	 I5PPQYBQDdUxH9ggluDVAV1e1aWEZoU+8bcITT+8dz5oiLFSsls53LGLTPGU3L0/6RPdv
	 PTVRnPo7ccThxfHUBNqomQjfbti4byS5ENA22Br0zvXEnojzZ6GmhwWkpD/bhXrhGU3K8
	 oqBEj/v6rg81jcm8OT7vv1ZdSr0l8pQl631VSXkGtjinAbWExHPAfEj7NJEmVp0pDh48a
	 qGTisxy8UJPKhS4g5esDXXXCZ5p+Gk5rt4LpPwvUSlVFMs6NULTWspX4MhQRejSQBVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YjItwpkK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38310606A31C;
	Thu, 19 Nov 2026 00:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YjItwpkK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CA71F000C4;
	Thu, 19 Nov 2026 00:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049428;
	bh=IKJn0CoBMesUVOVvrFwevpYsXfITT1dRcB0GKRYZQJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YjItwpkKGpuk2Bk6WVsktkS57gCmuB/iylKboc6zvdrj8PAzzhotLo3zyrJCX5o5X
	 LUpIGbggkUwAZWOh8jDknU281+eGD/91IUYkT9ubp2iSgT9s6gFyj9J4w83ToBejJT
	 gRVp+p1lKEDfuZmQZ/7apTFzd9qGBRrCz7LcikCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2347/2857] wifi: cfg80211: reg: protect regdb pointer with RCU
Date: Wed, 18 Nov 2026 15:56:21 +0100
Message-ID: <20261118150326.033728825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 298618f28bd3d1da677828354b504c12e2f375e4 ]

reg_query_regdb_wmm() is only used by iwlwifi, but even when
it was introduced was already broken, as it reads the global
db without any locking (drivers can't really guarantee any).
Certainly iwlwifi doesn't since it calls it for FW messages.
Therefore, it can race against regdb updates. The function
uses a local pointer, but doesn't help.

Use RCU to protect the regdb pointer to fix that, and update
the documentation to mention this (and do some cleanups).

Fixes: 19d3577e35e0 ("cfg80211: Add API to allow querying regdb for wmm_rule")
Link: https://patch.msgid.link/20261006120655.7c261d237cae.If21cf0af3b0d7e8c62c45ece5dc654b30c9d7757@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 12 ++++++------
 net/wireless/reg.c     | 41 +++++++++++++++++++++++++----------------
 2 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 636fb2a77f996..00ba1d10916e6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6854,20 +6854,20 @@ bool regulatory_pre_cac_allowed(struct wiphy *wiphy);
  */
 
 /**
- * reg_query_regdb_wmm -  Query internal regulatory db for wmm rule
- * Regulatory self-managed driver can use it to proactively
- *
+ * reg_query_regdb_wmm -  Query internal regulatory db for WMM rules
  * @alpha2: the ISO/IEC 3166 alpha2 wmm rule to be queried.
  * @freq: the frequency (in MHz) to be queried.
- * @rule: pointer to store the wmm rule from the regulatory db.
+ * @rule: pointer to store the WMM rule from the regulatory db.
  *
- * Self-managed wireless drivers can use this function to  query
+ * Self-managed wireless drivers can use this function to query
  * the internal regulatory database to check whether the given
- * ISO/IEC 3166 alpha2 country and freq have wmm rule limitations.
+ * ISO/IEC 3166 alpha2 country and freq have WMM rule limitations.
  *
  * Drivers should check the return value, its possible you can get
  * an -ENODATA.
  *
+ * This uses RCU internally so can be called in just about any context.
+ *
  * Return: 0 on success. -ENODATA.
  */
 int reg_query_regdb_wmm(char *alpha2, int freq,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 695f7159b2bba..02f041ce53322 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -600,7 +600,7 @@ static inline int call_crda(const char *alpha2)
 #endif /* CONFIG_CFG80211_CRDA_SUPPORT */
 
 /* code to directly load a firmware database through request_firmware */
-static const struct fwdb_header *regdb;
+static const struct fwdb_header __rcu *global_regdb;
 
 struct fwdb_country {
 	u8 alpha2[2];
@@ -943,16 +943,19 @@ static int __regdb_query_wmm(const struct fwdb_header *db,
 
 int reg_query_regdb_wmm(char *alpha2, int freq, struct ieee80211_reg_rule *rule)
 {
-	const struct fwdb_header *hdr = regdb;
 	const struct fwdb_country *country;
+	const struct fwdb_header *regdb;
 
+	guard(rcu)();
+
+	regdb = rcu_dereference(global_regdb);
 	if (!regdb)
 		return -ENODATA;
 
 	if (IS_ERR(regdb))
 		return PTR_ERR(regdb);
 
-	country = &hdr->country[0];
+	country = &regdb->country[0];
 	while (country->coll_ptr) {
 		if (alpha2_equal(alpha2, country->alpha2))
 			return __regdb_query_wmm(regdb, country, freq, rule);
@@ -1022,15 +1025,13 @@ static int regdb_query_country(const struct fwdb_header *db,
 
 static int query_regdb(const char *alpha2)
 {
-	const struct fwdb_header *hdr = regdb;
+	const struct fwdb_header *regdb = rtnl_dereference(global_regdb);
 	const struct fwdb_country *country;
 
-	ASSERT_RTNL();
-
 	if (IS_ERR(regdb))
 		return PTR_ERR(regdb);
 
-	country = &hdr->country[0];
+	country = &regdb->country[0];
 	while (country->coll_ptr) {
 		if (alpha2_equal(alpha2, country->alpha2))
 			return regdb_query_country(regdb, country);
@@ -1042,6 +1043,7 @@ static int query_regdb(const char *alpha2)
 
 static void regdb_fw_cb(const struct firmware *fw, void *context)
 {
+	const struct fwdb_header *regdb;
 	int set_error = 0;
 	bool restore = true;
 	void *db;
@@ -1055,6 +1057,7 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 	}
 
 	rtnl_lock();
+	regdb = rtnl_dereference(global_regdb);
 	if (regdb && !IS_ERR(regdb)) {
 		/* negative case - a bug
 		 * positive case - can happen due to race in case of multiple cb's in
@@ -1063,11 +1066,11 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 		 * Either case, just restore and free new db.
 		 */
 	} else if (set_error) {
-		regdb = ERR_PTR(set_error);
+		rcu_assign_pointer(global_regdb, ERR_PTR(set_error));
 	} else if (fw) {
 		db = kmemdup(fw->data, fw->size, GFP_KERNEL);
 		if (db) {
-			regdb = db;
+			rcu_assign_pointer(global_regdb, db);
 			restore = context && query_regdb(context);
 		} else {
 			restore = true;
@@ -1092,7 +1095,7 @@ static int query_regdb_file(const char *alpha2)
 
 	ASSERT_RTNL();
 
-	if (regdb)
+	if (rcu_access_pointer(global_regdb))
 		return query_regdb(alpha2);
 
 	alpha2 = kmemdup(alpha2, 2, GFP_KERNEL);
@@ -1110,8 +1113,8 @@ static int query_regdb_file(const char *alpha2)
 
 int reg_reload_regdb(void)
 {
+	const struct fwdb_header *db, *old;
 	const struct firmware *fw;
-	void *db;
 	int err;
 	const struct ieee80211_regdomain *current_regdomain;
 	struct regulatory_request *request;
@@ -1132,9 +1135,7 @@ int reg_reload_regdb(void)
 	}
 
 	rtnl_lock();
-	if (!IS_ERR_OR_NULL(regdb))
-		kfree(regdb);
-	regdb = db;
+	old = rcu_replace_pointer_rtnl(global_regdb, db);
 
 	/* reset regulatory domain */
 	current_regdomain = get_cfg80211_regdom();
@@ -1155,6 +1156,11 @@ int reg_reload_regdb(void)
 
 out_unlock:
 	rtnl_unlock();
+
+	if (!IS_ERR_OR_NULL(old)) {
+		synchronize_rcu();
+		kfree(old);
+	}
  out:
 	release_firmware(fw);
 	return err;
@@ -4381,6 +4387,7 @@ void regulatory_exit(void)
 {
 	struct regulatory_request *reg_request, *tmp;
 	struct reg_beacon *reg_beacon, *btmp;
+	const struct fwdb_header *db;
 
 	cancel_work_sync(&reg_work);
 	cancel_crda_timeout_sync();
@@ -4410,8 +4417,10 @@ void regulatory_exit(void)
 		kfree(reg_request);
 	}
 
-	if (!IS_ERR_OR_NULL(regdb))
-		kfree(regdb);
+	/* RCU is irrelevant on the way out */
+	db = rcu_dereference_protected(global_regdb, true);
+	if (!IS_ERR_OR_NULL(db))
+		kfree(db);
 	if (!IS_ERR_OR_NULL(cfg80211_user_regdom))
 		kfree(cfg80211_user_regdom);
 
-- 
2.53.0



