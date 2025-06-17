Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383982DFF04;
	Tue, 17 Jun 2025 15:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175450; cv=none; b=nG2R6AAmHYx5EYdz4JLPTxbbHCK2lwQyH5cdj7hW6Jo7S5TWUiOkUwyLAKbWbrLzyKEFAMP+WjInHD3rHJx1H6+uC74/lbcbr0mZarJqER5eK+r0lWVzGmFn/FYb+WfxojrB1PGW6u+5owZvarSFdO0uMUHmIwKVV/tx61f0W74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175450; c=relaxed/simple;
	bh=4+M2YerSgqb6H+IC4/8TKONFkIHyBKpizfQj/Czkr/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9uZPx+imAvqLEAXG8C27RzGjsfOdhNPmvyEOSql8S6o8hwV+FqiWX38mmo9eoJrx0XyIyz6rroLoZhorVJbvdwh6dgSlhora/WlmwFq4dkMUwQ8uuYBVZxDwTHPs2Sx72E5vRNWQ1JeXCKcgMUdxxrZU/iAFqB+ggh1ja0Up2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVpcZzCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVpcZzCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CED5C4CEE3;
	Tue, 17 Jun 2025 15:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175450;
	bh=4+M2YerSgqb6H+IC4/8TKONFkIHyBKpizfQj/Czkr/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVpcZzCI5bsQ6Orj82/X4dxXhdzQBTeuCUcGDd3dFW8pqqcHCSo1hqPaeHzW87Au/
	 oem5UzEuBiTB432WUNMsakBfx5WmL1mkkhH5DLeqnBRds/yKl+gz7qssMfmvn0f6MV
	 N7dH0WkzW55CWSFDzppJzQKhvnS8Ef3SaeiUcX8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 077/780] PM: sleep: Print PM debug messages during hibernation
Date: Tue, 17 Jun 2025 17:16:25 +0200
Message-ID: <20250617152454.647873186@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 23c0f4e6cb2ff..5af9c7ee98cd4 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -90,6 +90,11 @@ void hibernate_release(void)
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
index c352dea2f67b5..f8496f40b54fa 100644
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



