Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971802E3AE8;
	Tue,  8 Jul 2025 16:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992526; cv=none; b=Tlj+HR26U7a9WltrLyDhPtsve/HtbpNJ23jBK3zxR4j3B6Z74w4TgEssk+EplvMpTnsGiiP5jPnXIgymsd7p1zpKUobaUV/JAgSMZPP0ozFwou2Jpp6GMUpTJ7zOA4RaffLw2F28mFTuBO5ZXq4xbrkpLxib70+61A/Cw4UrsUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992526; c=relaxed/simple;
	bh=qRMCEl63T3vEnrESKHSrZ3EAf3k7+rvClRC2TxobFxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5Mcd0CGJQ2BA1wnM0izkEXKYmNV1lg9x+zfc8hHbWdo3DNbp571A+hsnLZcgio3VgMIbG4YVWYqr3DLcAEdVgJBSibUmp3kW9D8cEqUmanhD+T3abPFJhc2zqC8At8QfZL3EoPiEgBUvXPwto1kfoVSeC6rha6N8s5INPQv+YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eh6n2NCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eh6n2NCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B4FC4CEF5;
	Tue,  8 Jul 2025 16:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992526;
	bh=qRMCEl63T3vEnrESKHSrZ3EAf3k7+rvClRC2TxobFxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eh6n2NCE4Sq4eHuSMPRbTjdyu0glrnKzMJnKO5rJW3xCsBMDX6kvO5z+Yo4BYS+Tk
	 nikJtrGQ97s7uDyvjrTnz1N5JnjDi8qqgdSU3buLTaKoTuoVLqVwhYSODJNIc06kEr
	 Yi85CJTcI2OvdSW+gR7P0hJ8Q5HwkE4O/yjDXs88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 122/132] powercap: intel_rapl: Do not change CLAMPING bit if ENABLE bit cannot be changed
Date: Tue,  8 Jul 2025 18:23:53 +0200
Message-ID: <20250708162234.108446512@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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
@@ -338,12 +338,28 @@ static int set_domain_enable(struct powe
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


