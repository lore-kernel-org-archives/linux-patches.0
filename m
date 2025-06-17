Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FEA2ECD38;
	Tue, 17 Jun 2025 15:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174326; cv=none; b=FtmwNOG94WFwapQp9uQ0iAB+tdoe1yp2TD79jR4vvxgm76vD6YnQ3GqjJRjWAiuGBfnIM7dgfKCdNlPxzL9sYQdn2swlRM2pJL34fri5EMOII25ApX2gP0H5HJQV75TM9qh4/58D6COdQBgnRU0eBnie6b89K6BgbcTUKx8DWEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174326; c=relaxed/simple;
	bh=YgGoYCPcqPrx7jH7MnV2VElnBfbhlGGIfY0pdVsHx7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSiBt+4Yds7L825rst+tzmdtPOQduYB2zM/IwlqK+MdejviFHHw2QrIIsj/ci/cYmnZTpWSTYYWldCI99IYjMqats4vtyO6WXiuNlmLz3w5uJxxirdvfNozueKO7ZrcI+OMWh3goutSp+Wj5I3uyq27EKsYDU1v5qrp2imoofvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jG6aspjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jG6aspjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14777C4CEE7;
	Tue, 17 Jun 2025 15:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174326;
	bh=YgGoYCPcqPrx7jH7MnV2VElnBfbhlGGIfY0pdVsHx7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jG6aspjI7AFHF0iHSoJxj38kOkt5Hn1W6LV0UyBJF5hdPgsn7O9U85q8PR3+sxK38
	 7q6puqlymJthyoGhDZJCOvq47B00zb7K+wcHpQEmT5fv789yuoFktKByjgCgBGeMLs
	 A47nSnOMoA/8PEGy3KJsGMkfdImgGbYD1k6012S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/356] PM: sleep: Print PM debug messages during hibernation
Date: Tue, 17 Jun 2025 17:22:46 +0200
Message-ID: <20250617152340.290853660@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 1b17d4525bca3916644c41e01522df8fa0f8b90b ]

Commit cdb8c100d8a4 ("include/linux/suspend.h: Only show pm_pr_dbg
messages at suspend/resume") caused PM debug messages to only be
printed during system-wide suspend and resume in progress, but it
forgot about hibernation.

Address this by adding a check for hibernation in progress to
pm_debug_messages_should_print().

Fixes: cdb8c100d8a4 ("include/linux/suspend.h: Only show pm_pr_dbg messages at suspend/resume")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/4998903.GXAFRqVoOG@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/hibernate.c | 5 +++++
 kernel/power/main.c      | 3 ++-
 kernel/power/power.h     | 4 ++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index c2fc58938dee5..76dcf2e28427f 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -80,6 +80,11 @@ void hibernate_release(void)
 	atomic_inc(&hibernate_atomic);
 }
 
+bool hibernation_in_progress(void)
+{
+	return !atomic_read(&hibernate_atomic);
+}
+
 bool hibernation_available(void)
 {
 	return nohibernate == 0 &&
diff --git a/kernel/power/main.c b/kernel/power/main.c
index f6425ae3e8b05..a3543bd2d25af 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -585,7 +585,8 @@ bool pm_debug_messages_on __read_mostly;
 
 bool pm_debug_messages_should_print(void)
 {
-	return pm_debug_messages_on && pm_suspend_target_state != PM_SUSPEND_ON;
+	return pm_debug_messages_on && (hibernation_in_progress() ||
+		pm_suspend_target_state != PM_SUSPEND_ON);
 }
 EXPORT_SYMBOL_GPL(pm_debug_messages_should_print);
 
diff --git a/kernel/power/power.h b/kernel/power/power.h
index a98f95e309a33..62a7cb452a4be 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -66,10 +66,14 @@ extern void enable_restore_image_protection(void);
 static inline void enable_restore_image_protection(void) {}
 #endif /* CONFIG_STRICT_KERNEL_RWX */
 
+extern bool hibernation_in_progress(void);
+
 #else /* !CONFIG_HIBERNATION */
 
 static inline void hibernate_reserved_size_init(void) {}
 static inline void hibernate_image_size_init(void) {}
+
+static inline bool hibernation_in_progress(void) { return false; }
 #endif /* !CONFIG_HIBERNATION */
 
 #define power_attr(_name) \
-- 
2.39.5



