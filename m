Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516A643E075;
	Thu, 30 Jul 2026 14:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421052; cv=none; b=pnyY2WppzcvKcfFhWk2XulKZjOWtB7pJBHCcTKz4VEqtmeLyDtNV5XAosrvcIJn4pCtYEFQja6eXgpliIetQWhh2s/wWMy9MQtS8ef+DzXWT4MfP1tE35qrP1kfhf6emC6nvt4E8nV4lyUrDxfEl9SGBInkzZBGSltlIU2ciE/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421052; c=relaxed/simple;
	bh=vsPgj/Vr+1jWDh/EK+kfD3LsgywpUc2OW91ARqwj4/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EiildgS7ysBEpzTzoBo7WDZ5Xiw/4LKYBogAiASeyMA9kGsUhcsG/6GQjFGEp6Cy+F4Nq/sF8Zty4GjTUkUvWj+Tn3OuYnFFHg9YLluAIK9lxjD3eG8AQe5dRAEHsJXdohrBjMsZ2yzlSLmdukR4K1MIoNOhGFKXUwul/bSJ/Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fn7kAoi5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fn7kAoi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892461F00A3D;
	Thu, 30 Jul 2026 14:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421050;
	bh=uIpZfwMjI6LttrSwP9J+8uAuLdMwJ7UHoA8UHLSxqxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fn7kAoi5aAz7a5T0CxdGhl7RRFpKKpQ6VDXqjWswAePzPeXMkYJh6gvlrOaX7FjUh
	 RwQ5JkYWuWooA3qdPm+X/N2nsLDdha6TM5hrHaNOezMNhmzAEaxZcnKpVSIgAziSBL
	 Rtp645vTglayEdnP5wYg86j5T+ctBzpR1KwZsG8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Guixiong Wei <weiguixiong@bytedance.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/484] platform/x86/intel-uncore-freq: Fix current_freq_khz after CPU hotplug
Date: Thu, 30 Jul 2026 16:08:18 +0200
Message-ID: <20260730141423.428052279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixiong Wei <weiguixiong@bytedance.com>

commit 6b63520ed14b17bbe9c2103debbd2152dde1fba3 upstream.

When the last CPU of a legacy uncore die goes offline,
uncore_freq_remove_die_entry() clears control_cpu. During CPU hotplug
re-add, uncore_freq_add_entry() still populates sysfs attributes before
assigning the new control CPU. As a result, the current frequency read
returns -ENXIO and current_freq_khz is omitted from the recreated sysfs
group.

Assign control_cpu before the initial read paths and before
create_attr_group() so sysfs recreation uses the new online CPU. If
sysfs creation fails, restore control_cpu to -1 to keep the error path
state consistent.

Fixes: 4d73c6772ab7 ("platform/x86: intel-uncore-freq: Conditionally create attribute for read frequency")
Cc: stable@vger.kernel.org
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260602020752.3126-1-weiguixiong@bytedance.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[weiguixiong: Adapt to legacy uncore_read() and instance_id naming.]
Signed-off-by: Guixiong Wei <weiguixiong@bytedance.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../x86/intel/uncore-frequency/uncore-frequency-common.c   | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c
index 33bb58dc3f78c3..b362e0170a6256 100644
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c
@@ -238,14 +238,19 @@ int uncore_freq_add_entry(struct uncore_data *data, int cpu)
 		sprintf(data->name, "package_%02d_die_%02d", data->package_id, data->die_id);
 	}
 
+	/*
+	 * Set the control CPU before any read path so entry recreation after CPU
+	 * hotplug can populate read-only attributes from the new online CPU.
+	 */
+	data->control_cpu = cpu;
 	uncore_read(data, &data->initial_min_freq_khz, &data->initial_max_freq_khz);
 
 	ret = create_attr_group(data, data->name);
 	if (ret) {
+		data->control_cpu = -1;
 		if (data->domain_id != UNCORE_DOMAIN_ID_INVALID)
 			ida_free(&intel_uncore_ida, data->instance_id);
 	} else {
-		data->control_cpu = cpu;
 		data->valid = true;
 	}
 
-- 
2.53.0



