Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F62020F090;
	Tue, 17 Jun 2025 15:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174714; cv=none; b=P+i9i0xNpGjDOkcPuNIMY4+MiL7az+52Oq8HVLi9gTZr8Ubc0doWYaJdRARKRZRDVBTNc18kkrxYwlNX37Crr4W0FHLBMzuqt4q80gJKHWRPhRvmGtqh6zu30CS25mVagx/gYCb1mR9fAm1s5EVHgwMDdmuPHrP1kjPEBDL9fmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174714; c=relaxed/simple;
	bh=arInd4HGjrX78s6D3NQPSCrkx72xfkY0MPpa0mrqve0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYULxJzbzenKKnPOFxUOEL8leO0JG0qTXwv+rTYiw5eYqiPGlUdOJS/0GIsoT0ao12VtNJg3pEI1UCHhw6Q9HcMpOxT+PpKFVM2SECglGAST/sU//qcAzLKSm7pGiE6+3c/lWB8cEji1W1VkNHimuMAb2gLLYb6d9Nm9bWd6c6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEdAML0k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEdAML0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A671FC4CEE3;
	Tue, 17 Jun 2025 15:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174714;
	bh=arInd4HGjrX78s6D3NQPSCrkx72xfkY0MPpa0mrqve0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEdAML0koQY+g3kxHAMu3feb9C+AWYgGNbAH/QHlO6gwOopILwtqJmIe85iks1Anv
	 H9U+hAPWox+E296r+aVWdNG0E6itivOb82Ea6OQDxcIm9v1oGaFIr2EbEYZrfSMe4W
	 pznRYZU1zzaF1b/sBMZxW7yI+9J89vqdgETBDQ8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/512] PM: sleep: Print PM debug messages during hibernation
Date: Tue, 17 Jun 2025 17:20:19 +0200
Message-ID: <20250617152421.682825956@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d8bad1eeedd3e..85008ead2ac91 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -89,6 +89,11 @@ void hibernate_release(void)
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
index 6254814d48171..0622e7dacf172 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -613,7 +613,8 @@ bool pm_debug_messages_on __read_mostly;
 
 bool pm_debug_messages_should_print(void)
 {
-	return pm_debug_messages_on && pm_suspend_target_state != PM_SUSPEND_ON;
+	return pm_debug_messages_on && (hibernation_in_progress() ||
+		pm_suspend_target_state != PM_SUSPEND_ON);
 }
 EXPORT_SYMBOL_GPL(pm_debug_messages_should_print);
 
diff --git a/kernel/power/power.h b/kernel/power/power.h
index de0e6b1077f23..6d1ec7b23e844 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -71,10 +71,14 @@ extern void enable_restore_image_protection(void);
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



