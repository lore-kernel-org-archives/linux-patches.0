Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1312D3ED6;
	Tue, 12 Aug 2025 18:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023752; cv=none; b=KsSLXnAXuoqwcX4Rm1hSKJiKLuRAJ89/KSmZkv+8hObmb5vUxJ9ceYmZxqwlAPNHVQ9Jt4LuCnMc8qTH6fv88R72Yc3a6dVolEl7KlCCxM8NfB/lQEHuit7iZOfBTbbbnz25veo9w56HHoAu/06dAeD0AUJW+Qn9JNfjcu6vOUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023752; c=relaxed/simple;
	bh=ZiFW85wgM6Bi/6kenlHkKZsq8SJRIbLyoaLV87qg6Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8yigHyfGU3yj0pdxXHTceY9WBKskNMe8YLweRlihEMB3Q7jS3VOs23PO5WlWbd+dkaccPwU0x1u4l5sJ1NoQMuczGeOJi83EWDdcQXakTf4pD5cURe2rczYiS13FZmCNzQQWS4eyQ8SeOhRW4s4GLljX14vi+OABcPo0LvwNJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHCgVATz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHCgVATz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705D2C4CEF0;
	Tue, 12 Aug 2025 18:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023751;
	bh=ZiFW85wgM6Bi/6kenlHkKZsq8SJRIbLyoaLV87qg6Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHCgVATzI/w0nW1NZcGPn0SwoQeoSvB2JXxE86FL88sC79GWRShsqpxLzSxUFP8DJ
	 ST+vJAeROfLPJnDIYUXNOL321LDEZdGas7KzLyS/SrB3hmnkLuwQisRC4yUdEPGhMC
	 9VZDdnXIGrZXQiPT8F26RIad9Gxq8IHDxpR4RZRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 138/627] wifi: rtw89: sar: drop lockdep assertion in rtw89_set_sar_from_acpi
Date: Tue, 12 Aug 2025 19:27:13 +0200
Message-ID: <20250812173424.551918384@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 6fe21445f7e801de5527d420f8e25e97b0cdd7e2 ]

The following assertion is triggered on the rtw89 driver startup. It
looks meaningless to hold wiphy lock on the early init stage so drop the
assertion.

 WARNING: CPU: 7 PID: 629 at drivers/net/wireless/realtek/rtw89/sar.c:502 rtw89_set_sar_from_acpi+0x365/0x4d0 [rtw89_core]
 CPU: 7 UID: 0 PID: 629 Comm: (udev-worker) Not tainted 6.15.0+ #29 PREEMPT(lazy)
 Hardware name: LENOVO 21D0/LNVNB161216, BIOS J6CN50WW 09/27/2024
 RIP: 0010:rtw89_set_sar_from_acpi+0x365/0x4d0 [rtw89_core]
 Call Trace:
  <TASK>
  rtw89_sar_init+0x68/0x2c0 [rtw89_core]
  rtw89_core_init+0x188e/0x1e50 [rtw89_core]
  rtw89_pci_probe+0x530/0xb50 [rtw89_pci]
  local_pci_probe+0xd9/0x190
  pci_call_probe+0x183/0x540
  pci_device_probe+0x171/0x2c0
  really_probe+0x1e1/0x890
  __driver_probe_device+0x18c/0x390
  driver_probe_device+0x4a/0x120
  __driver_attach+0x1a0/0x530
  bus_for_each_dev+0x10b/0x190
  bus_add_driver+0x2eb/0x540
  driver_register+0x1a3/0x3a0
  do_one_initcall+0xd5/0x450
  do_init_module+0x2cc/0x8f0
  init_module_from_file+0xe1/0x150
  idempotent_init_module+0x226/0x760
  __x64_sys_finit_module+0xcd/0x150
  do_syscall_64+0x94/0x380
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Found by Linux Verification Center (linuxtesting.org).

Fixes: 88ca3107d2ce ("wifi: rtw89: sar: add skeleton for SAR configuration via ACPI")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250604161339.119954-1-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/sar.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/sar.c b/drivers/net/wireless/realtek/rtw89/sar.c
index 517b66022f18..33a4b5c23fe7 100644
--- a/drivers/net/wireless/realtek/rtw89/sar.c
+++ b/drivers/net/wireless/realtek/rtw89/sar.c
@@ -499,8 +499,6 @@ static void rtw89_set_sar_from_acpi(struct rtw89_dev *rtwdev)
 	struct rtw89_sar_cfg_acpi *cfg;
 	int ret;
 
-	lockdep_assert_wiphy(rtwdev->hw->wiphy);
-
 	cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
 	if (!cfg)
 		return;
-- 
2.39.5



