Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596241A76C7;
	Tue, 12 Nov 2024 10:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407657; cv=none; b=Ah5f7E2WGjD6Vr5iAXkU7Z29h4O+JN+WYvhyMnkPC8eOR9OWpbbwrB3lynHKBHn/+5X0GeDCB6H/CjaXXs9oiOcpZM9yZo02kNlZQc4icw/gmeIST/Z8jV9M1GkDsDnVqayCycoeLcjDjkWpE75deaYXn7809hAsLDelLT35vPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407657; c=relaxed/simple;
	bh=pun9ucIohujwxWF4H+2sJ25k1iFywKcOpU+IPIW0yP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=byO39G5CS/3PTPHmNoIs0WNzaB9QQgh3EY/7Bmq5tTDhjV7JMpz+cQOE/KDMyD3nnhuRdZibRJa0bQSkTSlT9mUOXkmsN6mtmtjzPYF/nxu1We0j7RbrqvKfnM1e9DNKBiBioJ8tz0wiDxitvVKz+zQT26WAZsEQYfLeJvhyfp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9kDI8Gy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9kDI8Gy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AED0C4CECD;
	Tue, 12 Nov 2024 10:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407657;
	bh=pun9ucIohujwxWF4H+2sJ25k1iFywKcOpU+IPIW0yP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9kDI8GyGeSnUM1Ia/AUuLfervMyiGT/e4hnOxvHG7/kTxQJaLvzzuv72XykrAqXa
	 ou34ne+6SZ2cVwwDouJ51PzaheTvu9FD2l+4XUleH9uCKK6iQw5xCsOxiySY8Dqogi
	 TroyLFSK3TR+4qHbxnf/3UZPR8uJPDyJM06ifsrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Corey Hickey <bugfood-c@fatooh.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/119] platform/x86/amd/pmc: Detect when STB is not available
Date: Tue, 12 Nov 2024 11:20:33 +0100
Message-ID: <20241112101849.674808473@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/platform/x86/amd/pmc/pmc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc.c b/drivers/platform/x86/amd/pmc/pmc.c
index 96caf2221d877..f49b1bb258c73 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -931,6 +931,11 @@ static int amd_pmc_s2d_init(struct amd_pmc_dev *dev)
 	amd_pmc_send_cmd(dev, S2D_PHYS_ADDR_LOW, &phys_addr_low, dev->s2d_msg_id, true);
 	amd_pmc_send_cmd(dev, S2D_PHYS_ADDR_HIGH, &phys_addr_hi, dev->s2d_msg_id, true);
 
+	if (!phys_addr_hi && !phys_addr_low) {
+		dev_err(dev->dev, "STB is not enabled on the system; disable enable_stb or contact system vendor\n");
+		return -EINVAL;
+	}
+
 	stb_phys_addr = ((u64)phys_addr_hi << 32 | phys_addr_low);
 
 	/* Clear msg_port for other SMU operation */
-- 
2.43.0



