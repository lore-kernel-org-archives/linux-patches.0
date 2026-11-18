Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031355;
	b=dgf2UjwTAQjTZ6fLBurERas7M6PnWLYXmO/sa22n11YvW5dvCwoOLTnlqE74BcCBEZ9k
	 Q/AKUUWqEJJYa8ebUiKKogh5WwfJYZk7/U1c1OVeNG7+bF8bZXUkXpJigKwbGxugopEAt
	 PstEQO+cQ9q/iZBAIik7V1KDt+XKRBX25MWdFOsdpl904Zd126QEk32r/ol0qUpvzKVBQ
	 0Y9dfYitt7dkLD6lQPRRgPuGeD1SiTVrYbSYKQia1ZHz7iLdjJcbi2CVyJaN6KdICc7vo
	 AI2PEE/PrujS8wwb1V3u7HeG2bL0TmWVMZgs70RFI+AbsV7yHvOwa/fRFIegojhZ1bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RS7SQBaHNPuKKg9QB7qlF5g9+eYlnRQ1MZIHU2aevJI=;
	b=wJpgJGfT0R6OSPXJrWLt6ajq7UG/G/1u+gmgq1kqAZ/OzEfVrCxMiqZLXNYry9rb3spy
	 cVLqrOHfZB8nyLi/YoP6TFL2+Pojt78W3TDsyBf/q5diLrGBMhWeK35PDlsYaQ4Ysbccb
	 Te6wFHGgneR8BDVd0c0NL+YvCiIKHakM+TuOJjfv43jPwuAczqA+dAJoIHfks5jqDG9Fc
	 Nt/HLQHOT3KUUJ1ejRgiy7tIkj1rqZH2l+mNWPMz3wZ5CcS5iyzgZdqr2GPWIHzDmpr4r
	 YMenRRCHEzkuejGQQ7b1bIX5ogUxcI+xxI8nzruiH0fJNK2rsmE/Azz2qh9RUbhayeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1GR9/wV3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197AD606A31C;
	Wed, 18 Nov 2026 19:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1GR9/wV3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700B21F000C4;
	Wed, 18 Nov 2026 19:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031355;
	bh=RS7SQBaHNPuKKg9QB7qlF5g9+eYlnRQ1MZIHU2aevJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1GR9/wV30oDOp/vwStvYD7a5MmDG+480QjfTw3MQ/WqAXiRPV4ZzvfpeolFbsd0Q4
	 IrLgU32e95BKmKMEMaAohtciYrc6XnVrcjVqfFLGKAocy3eA8KK9K5Wa8+/gzlsufb
	 r+r9j9JeNvDGlTYlzd7loAiE7JLmCwGRluhJMGe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1030/1756] wifi: cfg80211: reg: protect regdb pointer with RCU
Date: Wed, 18 Nov 2026 15:52:37 +0100
Message-ID: <20261118150051.081592076@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 83558dec5132d..ead0b2fcb7729 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -7412,20 +7412,20 @@ bool regulatory_pre_cac_allowed(struct wiphy *wiphy);
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
index 04bb6d7f955c0..f8dfe153157a5 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -602,7 +602,7 @@ static inline int call_crda(const char *alpha2)
 #endif /* CONFIG_CFG80211_CRDA_SUPPORT */
 
 /* code to directly load a firmware database through request_firmware */
-static const struct fwdb_header *regdb;
+static const struct fwdb_header __rcu *global_regdb;
 
 struct fwdb_country {
 	u8 alpha2[2];
@@ -907,16 +907,19 @@ static int __regdb_query_wmm(const struct fwdb_header *db,
 
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
@@ -986,15 +989,13 @@ static int regdb_query_country(const struct fwdb_header *db,
 
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
@@ -1006,6 +1007,7 @@ static int query_regdb(const char *alpha2)
 
 static void regdb_fw_cb(const struct firmware *fw, void *context)
 {
+	const struct fwdb_header *regdb;
 	int set_error = 0;
 	bool restore = true;
 	void *db;
@@ -1019,6 +1021,7 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 	}
 
 	rtnl_lock();
+	regdb = rtnl_dereference(global_regdb);
 	if (regdb && !IS_ERR(regdb)) {
 		/* negative case - a bug
 		 * positive case - can happen due to race in case of multiple cb's in
@@ -1027,11 +1030,11 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
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
@@ -1056,7 +1059,7 @@ static int query_regdb_file(const char *alpha2)
 
 	ASSERT_RTNL();
 
-	if (regdb)
+	if (rcu_access_pointer(global_regdb))
 		return query_regdb(alpha2);
 
 	alpha2 = kmemdup(alpha2, 2, GFP_KERNEL);
@@ -1074,8 +1077,8 @@ static int query_regdb_file(const char *alpha2)
 
 int reg_reload_regdb(void)
 {
+	const struct fwdb_header *db, *old;
 	const struct firmware *fw;
-	void *db;
 	int err;
 	const struct ieee80211_regdomain *current_regdomain;
 	struct regulatory_request *request;
@@ -1096,9 +1099,7 @@ int reg_reload_regdb(void)
 	}
 
 	rtnl_lock();
-	if (!IS_ERR_OR_NULL(regdb))
-		kfree(regdb);
-	regdb = db;
+	old = rcu_replace_pointer_rtnl(global_regdb, db);
 
 	/* reset regulatory domain */
 	current_regdomain = get_cfg80211_regdom();
@@ -1119,6 +1120,11 @@ int reg_reload_regdb(void)
 
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
@@ -4369,6 +4375,7 @@ void regulatory_exit(void)
 {
 	struct regulatory_request *reg_request, *tmp;
 	struct reg_beacon *reg_beacon, *btmp;
+	const struct fwdb_header *db;
 
 	cancel_work_sync(&reg_work);
 	cancel_crda_timeout_sync();
@@ -4398,8 +4405,10 @@ void regulatory_exit(void)
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



