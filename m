Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41751DF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CD0C433D2;
	Mon, 15 May 2023 16:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168978;
	bh=38bZB3L3hn/uWjRnQhYtKB0lKhQ3yxmwloio/fOzmew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19PemHGPgxP2R3NuqBlEWAv5Qfh5PAxzHqAF4lMoz4VvPZUuBwpxSsR3hC9fMuBCZ
	 lTOf/BsAaCy9EaAhin8OPHMC9HWCjcAT6MFru/NZBsh0AEPf/WE12uKchlchbG0Eeg
	 A5mQnwQnMahbxwRmO5sd8yKFTrjdHCkQS5cD9bcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jishnu Prakash <quic_jprakash@quicinc.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 103/191] spmi: Add a check for remove callback when removing a SPMI driver
Date: Mon, 15 May 2023 18:25:40 +0200
Message-Id: <20230515161710.987568233@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jishnu Prakash <quic_jprakash@quicinc.com>

[ Upstream commit b56eef3e16d888883fefab47425036de80dd38fc ]

When removing a SPMI driver, there can be a crash due to NULL pointer
dereference if it does not have a remove callback defined. This is
one such call trace observed when removing the QCOM SPMI PMIC driver:

 dump_backtrace.cfi_jt+0x0/0x8
 dump_stack_lvl+0xd8/0x16c
 panic+0x188/0x498
 __cfi_slowpath+0x0/0x214
 __cfi_slowpath+0x1dc/0x214
 spmi_drv_remove+0x16c/0x1e0
 device_release_driver_internal+0x468/0x79c
 driver_detach+0x11c/0x1a0
 bus_remove_driver+0xc4/0x124
 driver_unregister+0x58/0x84
 cleanup_module+0x1c/0xc24 [qcom_spmi_pmic]
 __do_sys_delete_module+0x3ec/0x53c
 __arm64_sys_delete_module+0x18/0x28
 el0_svc_common+0xdc/0x294
 el0_svc+0x38/0x9c
 el0_sync_handler+0x8c/0xf0
 el0_sync+0x1b4/0x1c0

If a driver has all its resources allocated through devm_() APIs and
does not need any other explicit cleanup, it would not require a
remove callback to be defined. Hence, add a check for remove callback
presence before calling it when removing a SPMI driver.

Link: https://lore.kernel.org/r/1671601032-18397-2-git-send-email-quic_jprakash@quicinc.com
Fixes: 6f00f8c8635f ("mfd: qcom-spmi-pmic: Use devm_of_platform_populate()")
Fixes: 5a86bf343976 ("spmi: Linux driver framework for SPMI")
Signed-off-by: Jishnu Prakash <quic_jprakash@quicinc.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20230413223834.4084793-7-sboyd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spmi/spmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spmi/spmi.c b/drivers/spmi/spmi.c
index aa3edabc2b0fe..55f1cad836ba2 100644
--- a/drivers/spmi/spmi.c
+++ b/drivers/spmi/spmi.c
@@ -356,7 +356,8 @@ static int spmi_drv_remove(struct device *dev)
 	const struct spmi_driver *sdrv = to_spmi_driver(dev->driver);
 
 	pm_runtime_get_sync(dev);
-	sdrv->remove(to_spmi_device(dev));
+	if (sdrv->remove)
+		sdrv->remove(to_spmi_device(dev));
 	pm_runtime_put_noidle(dev);
 
 	pm_runtime_disable(dev);
-- 
2.39.2



