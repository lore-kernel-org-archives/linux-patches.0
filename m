Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3332123E8;
	Tue, 12 Nov 2024 10:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407242; cv=none; b=bo0Zr6l81gxPVAT659CzUZa2P3rUMQYzULuFVzl9008LkT0FMyX+EiCE6cppfroS1IaoZ1EJw7hV7ZTRPA5396JbRpGa1ZfNhjUl6I9QSvsc/Q8B3LWG15EjBhmlRPzCLzsiwVDKVem8xinLQqJGEd3NIMSZfXTbP1TtkPy6sLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407242; c=relaxed/simple;
	bh=kWijvAlzB3ufQFc0jujhtIzMV6fEHB0RzecDIg2HyWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U9/u2UEj1VcGUynCdpCPm4taRo0MaxFhQ23khETkod19dT+QiogJ5A5zZhFUvGpImpF9FycagUiGKXxWuxQIaFLZJkZvou2AFGLKOs79dxh+BMcbz4QGIH2Kwv8vfZP51kUeoNbZvqN4wLP0JVHSOeTvaPs6LJOazJfNVJK3Rwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+wcdWoJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+wcdWoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B11C4CECD;
	Tue, 12 Nov 2024 10:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407242;
	bh=kWijvAlzB3ufQFc0jujhtIzMV6fEHB0RzecDIg2HyWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+wcdWoJZyWl0Tp426vUMKyer10EDBZMei2IezCf7zRvvmxvJPoKsCdFaxIRW6buh
	 WxMeESc0ZivSjTyVSW+E7xcl9RPJHbT8zswrUu3HpHV1bHKRsHecx/vrvH/LYv7121
	 UyNV7Dca80Zvj/Aq64oXBZ5FXB3RwcGQzQCfY6zE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Corey Hickey <bugfood-c@fatooh.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 17/98] platform/x86/amd/pmc: Detect when STB is not available
Date: Tue, 12 Nov 2024 11:20:32 +0100
Message-ID: <20241112101844.927378591@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Hickey <bugfood-c@fatooh.org>

[ Upstream commit bceec87a73804bb4c33b9a6c96e2d27cd893a801 ]

Loading the amd_pmc module as:

    amd_pmc enable_stb=1

...can result in the following messages in the kernel ring buffer:

    amd_pmc AMDI0009:00: SMU cmd failed. err: 0xff
    ioremap on RAM at 0x0000000000000000 - 0x0000000000ffffff
    WARNING: CPU: 10 PID: 2151 at arch/x86/mm/ioremap.c:217 __ioremap_caller+0x2cd/0x340

Further debugging reveals that this occurs when the requests for
S2D_PHYS_ADDR_LOW and S2D_PHYS_ADDR_HIGH return a value of 0,
indicating that the STB is inaccessible. To prevent the ioremap
warning and provide clarity to the user, handle the invalid address
and display an error message.

Link: https://lore.kernel.org/platform-driver-x86/c588ff5d-3e04-4549-9a86-284b9b4419ba@amd.com
Fixes: 3d7d407dfb05 ("platform/x86: amd-pmc: Add support for AMD Spill to DRAM STB feature")
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Corey Hickey <bugfood-c@fatooh.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20241028180241.1341624-1-bugfood-ml@fatooh.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc.c b/drivers/platform/x86/amd/pmc.c
index eb9fc6cb13e33..f237c1ea8d350 100644
--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -878,6 +878,11 @@ static int amd_pmc_s2d_init(struct amd_pmc_dev *dev)
 	amd_pmc_send_cmd(dev, S2D_PHYS_ADDR_LOW, &phys_addr_low, STB_SPILL_TO_DRAM, 1);
 	amd_pmc_send_cmd(dev, S2D_PHYS_ADDR_HIGH, &phys_addr_hi, STB_SPILL_TO_DRAM, 1);
 
+	if (!phys_addr_hi && !phys_addr_low) {
+		dev_err(dev->dev, "STB is not enabled on the system; disable enable_stb or contact system vendor\n");
+		return -EINVAL;
+	}
+
 	stb_phys_addr = ((u64)phys_addr_hi << 32 | phys_addr_low);
 
 	/* Clear msg_port for other SMU operation */
-- 
2.43.0



