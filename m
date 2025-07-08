Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9AE32E266B;
	Tue,  8 Jul 2025 16:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993710; cv=none; b=EDKbmJ3Btr/y1hmLgK1IXX0+4ArVH6p/8k95kh3Uvmc6qAPwmMbQUHo/ismFC5Tg5w6FG9lKCpNi1KgwcKC0XqI1ktALpnJP7aNfAf8KDoiIeMYkP3cnbQaTqla91hozsPq9+R+i1rwGabnHTWQ2RxRvImuOdw8AN0sGGNyBKJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993710; c=relaxed/simple;
	bh=7CG2DOnBnST9mIVrUT5mFEsNr4RpdWj3pzmpsG3wcOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HC+wtiazCqtldopaQi2s49AAXbOM8wWfqVHQQwv3969Z8r4ap1z4uxcoQbo8x+to/tAe0wRGtfL/l2iRBhJbrvN3v0R9qRI46j6ZlVguTL1P6hHLtHQn+Wp8UnVJmjyCI1QrRqSk/M7tPI/JudIfJKntGqoEmBHAxASNCTFeOa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nedKLoud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nedKLoud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC97C4CEED;
	Tue,  8 Jul 2025 16:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993710;
	bh=7CG2DOnBnST9mIVrUT5mFEsNr4RpdWj3pzmpsG3wcOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nedKLoudRNR/2UGUGDbxPV+BHlcMCgyE71nhaJzCmCwQAvCf7VEPkQSGwJrH/Vztc
	 7CZNUzPKQ6/y80ekLgpxfRin3T+19xgwVT6rwjmP9lEqEU92YQxY50wlos5qlydyhE
	 f59WFFmbq6wJpsJ09bim3tSKMPIikNZKeED+cPng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.15 166/178] powercap: intel_rapl: Do not change CLAMPING bit if ENABLE bit cannot be changed
Date: Tue,  8 Jul 2025 18:23:23 +0200
Message-ID: <20250708162240.808278005@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

From: Zhang Rui <rui.zhang@intel.com>

commit 964209202ebe1569c858337441e87ef0f9d71416 upstream.

PL1 cannot be disabled on some platforms. The ENABLE bit is still set
after software clears it. This behavior leads to a scenario where, upon
user request to disable the Power Limit through the powercap sysfs, the
ENABLE bit remains set while the CLAMPING bit is inadvertently cleared.

According to the Intel Software Developer's Manual, the CLAMPING bit,
"When set, allows the processor to go below the OS requested P states in
order to maintain the power below specified Platform Power Limit value."

Thus this means the system may operate at higher power levels than
intended on such platforms.

Enhance the code to check ENABLE bit after writing to it, and stop
further processing if ENABLE bit cannot be changed.

Reported-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Fixes: 2d281d8196e3 ("PowerCap: Introduce Intel RAPL power capping driver")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Link: https://patch.msgid.link/20250619071340.384782-1-rui.zhang@intel.com
[ rjw: Use str_enabled_disabled() instead of open-coded equivalent ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/powercap/intel_rapl_common.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -340,12 +340,28 @@ static int set_domain_enable(struct powe
 {
 	struct rapl_domain *rd = power_zone_to_rapl_domain(power_zone);
 	struct rapl_defaults *defaults = get_defaults(rd->rp);
+	u64 val;
 	int ret;
 
 	cpus_read_lock();
 	ret = rapl_write_pl_data(rd, POWER_LIMIT1, PL_ENABLE, mode);
-	if (!ret && defaults->set_floor_freq)
+	if (ret)
+		goto end;
+
+	ret = rapl_read_pl_data(rd, POWER_LIMIT1, PL_ENABLE, false, &val);
+	if (ret)
+		goto end;
+
+	if (mode != val) {
+		pr_debug("%s cannot be %s\n", power_zone->name,
+			 str_enabled_disabled(mode));
+		goto end;
+	}
+
+	if (defaults->set_floor_freq)
 		defaults->set_floor_freq(rd, mode);
+
+end:
 	cpus_read_unlock();
 
 	return ret;


