Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6581B87E8;
	Tue, 26 Aug 2025 13:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215530; cv=none; b=KUvls06DNryCzPtlzuTbVeMhIPC2T46NvlhLkcfzim4JZmMjgmfgitaZy2rJqU+H3JrMjcKFuK7b37K1gr62hJ2RwZMBZxrdkHdgXlkuhw/bS+co+45bPhxb62LRpVKNze1nadBRf9sj6isI18nFooV8LOI+4eQFs3BP6TFAbDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215530; c=relaxed/simple;
	bh=TElNZdWboIa2XCrmG4AufI7EsZyH8xD/fM0keTMUQFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ezm9kL5Vff/ohcAc0xO3hJeTMdZE67QnRtAkPcG+h7ySl7c2GeDakuodupWgmBnG6exsz8aE0iHFjuW3db7E4NdA41VOoOy+PKDiJJX1xA6ZNa1VZOsE/xOxcGSobACEu6+A1BgKV8eGw30wTPeFlhn/30Ld/3z+sHBouI2wxoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsQnj0QT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsQnj0QT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7691C4CEF1;
	Tue, 26 Aug 2025 13:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215530;
	bh=TElNZdWboIa2XCrmG4AufI7EsZyH8xD/fM0keTMUQFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsQnj0QT9iMX979TCnNpsdLSIqE6f+GKNSZqb9w1zkb7Yx0Nq0a5DCxBCEVOhAY3Q
	 bu8ej/A2BGBiKYO/1gj5cS5i8CyNvADrWRSs/Yjh/2LXc+2vy5z3DE8VcWmcQhnfkR
	 H0hpEujWxEvmKeieTuTWSIY3DH43KXI6AZABBcoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/644] powercap: intel_rapl: Do not change CLAMPING bit if ENABLE bit cannot be changed
Date: Tue, 26 Aug 2025 13:02:40 +0200
Message-ID: <20250826110948.208019659@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ replaced rapl_write_pl_data() and rapl_read_pl_data() with rapl_write_data_raw() and rapl_read_data_raw() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/powercap/intel_rapl_common.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -212,12 +212,33 @@ static int find_nr_power_limit(struct ra
 static int set_domain_enable(struct powercap_zone *power_zone, bool mode)
 {
 	struct rapl_domain *rd = power_zone_to_rapl_domain(power_zone);
+	u64 val;
+	int ret;
 
 	if (rd->state & DOMAIN_STATE_BIOS_LOCKED)
 		return -EACCES;
 
 	cpus_read_lock();
-	rapl_write_data_raw(rd, PL1_ENABLE, mode);
+	ret = rapl_write_data_raw(rd, PL1_ENABLE, mode);
+	if (ret) {
+		cpus_read_unlock();
+		return ret;
+	}
+
+	/* Check if the ENABLE bit was actually changed */
+	ret = rapl_read_data_raw(rd, PL1_ENABLE, true, &val);
+	if (ret) {
+		cpus_read_unlock();
+		return ret;
+	}
+
+	if (mode != val) {
+		pr_debug("%s cannot be %s\n", power_zone->name,
+			 mode ? "enabled" : "disabled");
+		cpus_read_unlock();
+		return 0;
+	}
+
 	if (rapl_defaults->set_floor_freq)
 		rapl_defaults->set_floor_freq(rd, mode);
 	cpus_read_unlock();


