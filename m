Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6BF32C946;
	Fri, 17 Oct 2025 15:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715521; cv=none; b=m5etz/5RF6UuRXgnCjqrkci1cYUmLLyBBumQXUVJgjVN6tyya7JPoiZwElkWlmciqej66pz0ThN2ki3rvM3zzmN0cvkdliqvub7p6fUllGFsniEwZZrvnQbwkFKrzQT2u7FsdO33yocchdI+84nkRN81oKXlIKg8xfg+0Mqu3ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715521; c=relaxed/simple;
	bh=7CWQcc11qa+fWcom4jAC+eQ/e131CH5Ts2ehnOc5zpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owNy4SkqQxwvDTBpXrtqVCgbIU1zMhnRPvFOdmK4rPJoiD6BvGZCmNs8KZG8hhPnh4meKR01jV4gDHsM6KVZdJHih0nYcfFdeeedBtWc3QnH2v9aCuUp1nRd8e14uCKs/VNV84OKY6hWtO/5T3uEaF59NjZekqe/b1LKu6vjPks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FViVXBzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FViVXBzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44698C4CEE7;
	Fri, 17 Oct 2025 15:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715521;
	bh=7CWQcc11qa+fWcom4jAC+eQ/e131CH5Ts2ehnOc5zpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FViVXBzOE2Li9tXbX4w2gNrp0RW5IEL53BRyW+uPX3X2O/NZvUeAY+aRxwaciQ1rr
	 /IfkFUZ3oDYrnIaHyku0oDu+9vLHxR+B4xMZ3fYWoAFVauqYYRqFY2JN5cg+mKi2wJ
	 oy2wjy7y5SZH2sY3yQuETqq1OOfKv2bx69S5hzQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ionut Nechita <ionut_n2001@yahoo.com>,
	Kenneth Crudup <kenny@panix.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.17 246/371] PM: hibernate: Fix hybrid-sleep
Date: Fri, 17 Oct 2025 16:53:41 +0200
Message-ID: <20251017145210.979235509@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit 469d80a3712c66a00b5bb888e62e809db8887ba7 upstream.

Hybrid sleep will hibernate the system followed by running through
the suspend routine.  Since both the hibernate and the suspend routine
will call pm_restrict_gfp_mask(), pm_restore_gfp_mask() must be called
before starting the suspend sequence.

Add an explicit call to pm_restore_gfp_mask() to power_down() before
the suspend sequence starts. Add an extra call for pm_restrict_gfp_mask()
when exiting suspend so that the pm_restore_gfp_mask() call in hibernate()
is balanced.

Reported-by: Ionut Nechita <ionut_n2001@yahoo.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4573
Tested-by: Ionut Nechita <ionut_n2001@yahoo.com>
Fixes: 12ffc3b1513eb ("PM: Restrict swap use to later in the suspend sequence")
Tested-by: Kenneth Crudup <kenny@panix.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20250925185108.2968494-2-superm1@kernel.org
[ rjw: Add comment explainig the new pm_restrict_gfp_mask() call purpose ]
Cc: 6.16+ <stable@vger.kernel.org> # 6.16+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/hibernate.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -695,12 +695,16 @@ static void power_down(void)
 
 #ifdef CONFIG_SUSPEND
 	if (hibernation_mode == HIBERNATION_SUSPEND) {
+		pm_restore_gfp_mask();
 		error = suspend_devices_and_enter(mem_sleep_current);
 		if (error) {
 			hibernation_mode = hibernation_ops ?
 						HIBERNATION_PLATFORM :
 						HIBERNATION_SHUTDOWN;
 		} else {
+			/* Match pm_restore_gfp_mask() call in hibernate() */
+			pm_restrict_gfp_mask();
+
 			/* Restore swap signature. */
 			error = swsusp_unmark();
 			if (error)


