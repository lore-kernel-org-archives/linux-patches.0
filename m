Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F241EE7C6;
	Mon, 23 Jun 2025 21:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714551; cv=none; b=VDOCoG1X1aG1R3eCf0t1JuR5kUBi28IfUo6YT2XeZgyIYZiNZ1jkkK9qU+Ow18sFOqIOqRlERZMO1j4X49gX0DLqWTei4wfAwZekBDD5utlsKRjtUZTMHoklIqD8YpAMMoGZaI72uFvkPb4rtXPvOcHeJ4dQIZ5bGipnb/0CiDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714551; c=relaxed/simple;
	bh=AkU3CEg7MInLEfmmMdXPnI4odK4YlYE2gJowJJZiyeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5E3ciab1EnVyszT256KFjNepYmEX2ck/V1EtE/3RidmpJgEyii2IV01rNPoj0YT4Z5otHr9UvgTaHpCMoYVdvpWNFQhU0vOZfGlYbY2KePKhqRyDrlEZ77zmmSZsDGhBvcJmoH+9gD1xJJOxOzXfOfQuKKA6K0xchGntyBui6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pVsJ3TEI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pVsJ3TEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1552C4CEEA;
	Mon, 23 Jun 2025 21:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714551;
	bh=AkU3CEg7MInLEfmmMdXPnI4odK4YlYE2gJowJJZiyeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pVsJ3TEI/+/l9lUPVhGbqy7pgjJaGEPrbampUm96NHbmEJ31/4ehZydaiBCroH+5l
	 GfFfyEbQoKuEvv0ku+CKx8Irq1QQhAHJEyCz/vPWv5zDcaVnA+CKihcM1qIF7tn3hz
	 JMUQ1rHQp/lXWSnxNOvne9Kv9JZFr6n3gK6Frigg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Peng Fan <peng.fan@nxp.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 144/290] cpufreq: scmi: Skip SCMI devices that arent used by the CPUs
Date: Mon, 23 Jun 2025 15:06:45 +0200
Message-ID: <20250623130631.228471422@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

From: Mike Tipton <quic_mdtipton@quicinc.com>

[ Upstream commit 6c9bb86922728c7a4cceb99f131e00dd87514f20 ]

Currently, all SCMI devices with performance domains attempt to register
a cpufreq driver, even if their performance domains aren't used to
control the CPUs. The cpufreq framework only supports registering a
single driver, so only the first device will succeed. And if that device
isn't used for the CPUs, then cpufreq will scale the wrong domains.

To avoid this, return early from scmi_cpufreq_probe() if the probing
SCMI device isn't referenced by the CPU device phandles.

This keeps the existing assumption that all CPUs are controlled by a
single SCMI device.

Signed-off-by: Mike Tipton <quic_mdtipton@quicinc.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/scmi-cpufreq.c | 36 +++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/scmi-cpufreq.c b/drivers/cpufreq/scmi-cpufreq.c
index e4989764efe2a..6ff77003a96ea 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -299,6 +299,40 @@ static struct cpufreq_driver scmi_cpufreq_driver = {
 	.register_em	= scmi_cpufreq_register_em,
 };
 
+static bool scmi_dev_used_by_cpus(struct device *scmi_dev)
+{
+	struct device_node *scmi_np = dev_of_node(scmi_dev);
+	struct device_node *cpu_np, *np;
+	struct device *cpu_dev;
+	int cpu, idx;
+
+	if (!scmi_np)
+		return false;
+
+	for_each_possible_cpu(cpu) {
+		cpu_dev = get_cpu_device(cpu);
+		if (!cpu_dev)
+			continue;
+
+		cpu_np = dev_of_node(cpu_dev);
+
+		np = of_parse_phandle(cpu_np, "clocks", 0);
+		of_node_put(np);
+
+		if (np == scmi_np)
+			return true;
+
+		idx = of_property_match_string(cpu_np, "power-domain-names", "perf");
+		np = of_parse_phandle(cpu_np, "power-domains", idx);
+		of_node_put(np);
+
+		if (np == scmi_np)
+			return true;
+	}
+
+	return false;
+}
+
 static int scmi_cpufreq_probe(struct scmi_device *sdev)
 {
 	int ret;
@@ -307,7 +341,7 @@ static int scmi_cpufreq_probe(struct scmi_device *sdev)
 
 	handle = sdev->handle;
 
-	if (!handle)
+	if (!handle || !scmi_dev_used_by_cpus(dev))
 		return -ENODEV;
 
 	perf_ops = handle->devm_protocol_get(sdev, SCMI_PROTOCOL_PERF, &ph);
-- 
2.39.5



