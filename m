Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2291C2451C8;
	Tue, 29 Apr 2025 17:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947612; cv=none; b=sI2CFy85JbgdHNbQIRt4k/isvZFiIp3NFynjZhWe8GARXQFWaIhf2FMpMZbxU6viCoSlxrMFjX9pD7h3MQT5QnlOOGa/Xw/Uw073/ujlB9cz5NkBjzwBNb4k5Va8cMQG3oV/Z6+176jMmijRoZQVoxhCekD7TJPQFJzwn/GlH/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947612; c=relaxed/simple;
	bh=MYDGLaTZlg0dPUCpRY4jLhlbAue5tkdKtpCJiUZooas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DNlCFASSCRDA47i1LQB1DlzWFOgKLKEQ1aja1fY0T0mGdDk0F8UXEsE6yERMGAiUK/uCr69sMoIOOIHE6UFVASHAPIxPaR9epwrM8mq0yIspaXKm0Ory2UFf6+xrZR/n37I7GVHBwmEzxTBX/jeP+L4/cDCilCAGtFNLnvhjfeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWNWOdsI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWNWOdsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335E3C4CEE3;
	Tue, 29 Apr 2025 17:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947611;
	bh=MYDGLaTZlg0dPUCpRY4jLhlbAue5tkdKtpCJiUZooas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wWNWOdsIA77HArWYCadt1pVkDr6J49mH2Eutlq8tH+vvYjYsbYujdUzmL6L8dqU29
	 gTwyOQn7WaR3UdZDqWA2SfoMQTIp/Jw2iU5JBqqNLBit5/v+5u7ZdmWkau2qDOuKdu
	 0RmwLmNyCVphonhAFryYyFplI9LpCNj4uCbHPioM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/280] cpufreq: sun50i: prevent out-of-bounds access
Date: Tue, 29 Apr 2025 18:39:52 +0200
Message-ID: <20250429161117.213646146@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit 14c8a418159e541d70dbf8fc71225d1623beaf0f ]

A KASAN enabled kernel reports an out-of-bounds access when handling the
nvmem cell in the sun50i cpufreq driver:
==================================================================
BUG: KASAN: slab-out-of-bounds in sun50i_cpufreq_nvmem_probe+0x180/0x3d4
Read of size 4 at addr ffff000006bf31e0 by task kworker/u16:1/38

This is because the DT specifies the nvmem cell as covering only two
bytes, but we use a u32 pointer to read the value. DTs for other SoCs
indeed specify 4 bytes, so we cannot just shorten the variable to a u16.

Fortunately nvmem_cell_read() allows to return the length of the nvmem
cell, in bytes, so we can use that information to only access the valid
portion of the data.
To cover multiple cell sizes, use memcpy() to copy the information into a
zeroed u32 buffer, then also make sure we always read the data in little
endian fashion, as this is how the data is stored in the SID efuses.

Fixes: 6cc4bcceff9a ("cpufreq: sun50i: Refactor speed bin decoding")
Reported-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Jernej Škrabec <jernej.skrabec@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/sun50i-cpufreq-nvmem.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/sun50i-cpufreq-nvmem.c b/drivers/cpufreq/sun50i-cpufreq-nvmem.c
index 293921acec937..0599dbf851ebe 100644
--- a/drivers/cpufreq/sun50i-cpufreq-nvmem.c
+++ b/drivers/cpufreq/sun50i-cpufreq-nvmem.c
@@ -167,7 +167,9 @@ static int sun50i_cpufreq_get_efuse(void)
 	struct nvmem_cell *speedbin_nvmem;
 	const struct of_device_id *match;
 	struct device *cpu_dev;
-	u32 *speedbin;
+	void *speedbin_ptr;
+	u32 speedbin = 0;
+	size_t len;
 	int ret;
 
 	cpu_dev = get_cpu_device(0);
@@ -190,14 +192,18 @@ static int sun50i_cpufreq_get_efuse(void)
 		return dev_err_probe(cpu_dev, PTR_ERR(speedbin_nvmem),
 				     "Could not get nvmem cell\n");
 
-	speedbin = nvmem_cell_read(speedbin_nvmem, NULL);
+	speedbin_ptr = nvmem_cell_read(speedbin_nvmem, &len);
 	nvmem_cell_put(speedbin_nvmem);
-	if (IS_ERR(speedbin))
-		return PTR_ERR(speedbin);
+	if (IS_ERR(speedbin_ptr))
+		return PTR_ERR(speedbin_ptr);
 
-	ret = opp_data->efuse_xlate(*speedbin);
+	if (len <= 4)
+		memcpy(&speedbin, speedbin_ptr, len);
+	speedbin = le32_to_cpu(speedbin);
 
-	kfree(speedbin);
+	ret = opp_data->efuse_xlate(speedbin);
+
+	kfree(speedbin_ptr);
 
 	return ret;
 };
-- 
2.39.5



