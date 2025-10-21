Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE6F350A0D;
	Tue, 21 Oct 2025 20:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077392; cv=none; b=sxFWTuZQdBHg83AlCcsHc/dDnKORC3RqDK3POrsyslFFZ4HDS4siFyjwM5dWqK8lb3GmnzCUfTGZu0ja1R1DNX12nuLJrTJq4OFZn7bn8O7Vuva0fTqtrmTGZGOX4/LIcfL7BLyGTFeG61wNiMfRWUZd5/2QJle/5FEcObi8he0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077392; c=relaxed/simple;
	bh=5NRvZp+RltI9dyHxDAyKZQUJeTLBLEq9fi1SxmwayTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tf2eDUNYyOIiTCRPog+co5n+GjrtAQDASTd3vpW1iNIolf3prYIFTfeTIoxSLnzifs2iG9snHYc8qMX1opB9YGb/MSNwcfDpFkgUgRib0R2HhjriSx2aYxSV8KXmo8PmT+WMWciR1jLykqLrsJkt1ydpg8LevzhhBjd7U2l4rj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTgDfhUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTgDfhUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FB5C4CEF1;
	Tue, 21 Oct 2025 20:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077392;
	bh=5NRvZp+RltI9dyHxDAyKZQUJeTLBLEq9fi1SxmwayTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTgDfhUBHBjPJpT48T46hT6d3Uhfnmt/zhiLMOdA93gEgKoIzduwIW5jchLA2IbJg
	 T1H4sxrZ4O39QfYDHLQQ7e2+XbKUpIj2LTUWD9frgY1ytLOH9bseIaOtPBQeFrG5GB
	 SHFlTVTDyHJbSYRCySYTHOu1f2fBs4ylJaTB4CHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ionut Nechita <ionut_n2001@yahoo.com>,
	Kenneth Crudup <kenny@panix.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 048/159] PM: hibernate: Add pm_hibernation_mode_is_suspend()
Date: Tue, 21 Oct 2025 21:50:25 +0200
Message-ID: <20251021195044.364731285@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Mario Limonciello (AMD)" <superm1@kernel.org>

[ Upstream commit 495c8d35035edb66e3284113bef01f3b1b843832 ]

Some drivers have different flows for hibernation and suspend. If
the driver opportunistically will skip thaw() then it needs a hint
to know what is happening after the hibernate.

Introduce a new symbol pm_hibernation_mode_is_suspend() that drivers
can call to determine if suspending the system for this purpose.

Tested-by: Ionut Nechita <ionut_n2001@yahoo.com>
Tested-by: Kenneth Crudup <kenny@panix.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 0a6e9e098fcc ("drm/amd: Fix hybrid sleep")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/suspend.h  |    2 ++
 kernel/power/hibernate.c |   11 +++++++++++
 2 files changed, 13 insertions(+)

--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -276,6 +276,7 @@ extern void arch_suspend_enable_irqs(voi
 
 extern int pm_suspend(suspend_state_t state);
 extern bool sync_on_suspend_enabled;
+bool pm_hibernation_mode_is_suspend(void);
 #else /* !CONFIG_SUSPEND */
 #define suspend_valid_only_mem	NULL
 
@@ -288,6 +289,7 @@ static inline bool pm_suspend_via_firmwa
 static inline bool pm_resume_via_firmware(void) { return false; }
 static inline bool pm_suspend_no_platform(void) { return false; }
 static inline bool pm_suspend_default_s2idle(void) { return false; }
+static inline bool pm_hibernation_mode_is_suspend(void) { return false; }
 
 static inline void suspend_set_ops(const struct platform_suspend_ops *ops) {}
 static inline int pm_suspend(suspend_state_t state) { return -ENOSYS; }
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -80,6 +80,17 @@ static const struct platform_hibernation
 
 static atomic_t hibernate_atomic = ATOMIC_INIT(1);
 
+#ifdef CONFIG_SUSPEND
+/**
+ * pm_hibernation_mode_is_suspend - Check if hibernation has been set to suspend
+ */
+bool pm_hibernation_mode_is_suspend(void)
+{
+	return hibernation_mode == HIBERNATION_SUSPEND;
+}
+EXPORT_SYMBOL_GPL(pm_hibernation_mode_is_suspend);
+#endif
+
 bool hibernate_acquire(void)
 {
 	return atomic_add_unless(&hibernate_atomic, -1, 0);


