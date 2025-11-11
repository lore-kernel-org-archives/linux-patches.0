Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A844C97;
	Tue, 11 Nov 2025 00:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822472; cv=none; b=j010GQquaZxR4rXzpGehBVuJnM/eyW07J7IwBnxKN4jjLN5LXcC+JgnVL2s2vSaFns7CZ519mKTjf9h9boMILAFVV+90ICd34Xtn7nBRdlsCSwqqpyTkNO/L1gy8dz7M7naky1takPfCxYdCvmFA5W2LWIPJMxj3pb/0ZJBU6ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822472; c=relaxed/simple;
	bh=rWFELUsl/cJJIgiH7M4phPUuPl7k/G1WfnDb7phk/j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHCHRHWex/jbwH0eCIUtFxVEMI+3aclSHrjkdHjsrI15GD5f9dE/9pcjrjlExGKuhXQkE/WaPmruRqEg0bRCb3VcbWv3EvJlip0WDHdh1kFSR5SXuCdATV6eMF+WB/nqNMK2wl8Vv38haM19iwS9q4iAJom6EcWM0cwJj/K4LQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1i2TftKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1i2TftKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C99C116B1;
	Tue, 11 Nov 2025 00:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822472;
	bh=rWFELUsl/cJJIgiH7M4phPUuPl7k/G1WfnDb7phk/j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1i2TftKPcRZcTGM3w9NUicf9pVU8eOrcQ9DO+r4BMVpugMQ4JNmvNA3LFath3s+Uf
	 p+R4bwD5H9s96qpAHz9S5rVZ48OxZqUcUr5FiZ8NX8y1QEAw/3Om64D0Ol50y9dqYK
	 vUEW3BG399bjhZEDWi+mvBhMvBP172wXxKMeQZxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 114/849] PM: hibernate: Combine return paths in power_down()
Date: Tue, 11 Nov 2025 09:34:44 +0900
Message-ID: <20251111004539.155488923@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 1f5bcfe91ffce71bdd1022648b9d501d46d20c09 ]

To avoid code duplication and improve clarity, combine the code
paths in power_down() leading to a return from that function.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/3571055.QJadu78ljV@rafael.j.wysocki
[ rjw: Changed the new label name to "exit" ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 35e4a69b2003 ("PM: sleep: Allow pm_restrict_gfp_mask() stacking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/hibernate.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -708,21 +708,11 @@ static void power_down(void)
 	if (hibernation_mode == HIBERNATION_SUSPEND) {
 		pm_restore_gfp_mask();
 		error = suspend_devices_and_enter(mem_sleep_current);
-		if (error) {
-			hibernation_mode = hibernation_ops ?
-						HIBERNATION_PLATFORM :
-						HIBERNATION_SHUTDOWN;
-		} else {
-			/* Match pm_restore_gfp_mask() call in hibernate() */
-			pm_restrict_gfp_mask();
+		if (!error)
+			goto exit;
 
-			/* Restore swap signature. */
-			error = swsusp_unmark();
-			if (error)
-				pr_err("Swap will be unusable! Try swapon -a.\n");
-
-			return;
-		}
+		hibernation_mode = hibernation_ops ? HIBERNATION_PLATFORM :
+						     HIBERNATION_SHUTDOWN;
 	}
 #endif
 
@@ -733,12 +723,9 @@ static void power_down(void)
 	case HIBERNATION_PLATFORM:
 		error = hibernation_platform_enter();
 		if (error == -EAGAIN || error == -EBUSY) {
-			/* Match pm_restore_gfp_mask() in hibernate(). */
-			pm_restrict_gfp_mask();
-			swsusp_unmark();
 			events_check_enabled = false;
 			pr_info("Wakeup event detected during hibernation, rolling back.\n");
-			return;
+			goto exit;
 		}
 		fallthrough;
 	case HIBERNATION_SHUTDOWN:
@@ -757,6 +744,15 @@ static void power_down(void)
 	pr_crit("Power down manually\n");
 	while (1)
 		cpu_relax();
+
+exit:
+	/* Match the pm_restore_gfp_mask() call in hibernate(). */
+	pm_restrict_gfp_mask();
+
+	/* Restore swap signature. */
+	error = swsusp_unmark();
+	if (error)
+		pr_err("Swap will be unusable! Try swapon -a.\n");
 }
 
 static int load_image_and_restore(void)


