Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640473EFD09;
	Wed, 20 May 2026 17:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298873; cv=none; b=VcIzf1kkc4/NVi+n1DwJ2X07naDrNKDnR0IkunXvoB9E+ZuVZlPt5IF8XxWT33NmbAuopZf+zEflEqTISW5wLnmV4G4EREZARCpH0RRrQ+Ag6OLEZAOvhdaYlh3wKr9ydCQwpayReUH0nR/kBiuAey0Yus1EQHB6IX4ekWEtYEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298873; c=relaxed/simple;
	bh=STq1/a8T2IXCvdKKnCNZ6cUDdekMfJbkgi5D4I2kJ7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V96GRgXQQ8a9QaemJ0ie76bLZ1NkNTdIVT0WgNJpK1l6pfiRWF3CBOeDL1TnTYU9qrcBYJ0UTkr7/2hxOxuU6/flFDTOkZUseO2Ev4S6T94qYlPjVyPZFK6PzH2dCPloHloL2yjrVrLr1ok9tEHL+Ajkf7HltOPUfKF3rHDtLQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAd2ypUu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAd2ypUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EF01F000E9;
	Wed, 20 May 2026 17:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298872;
	bh=4Lg/L8tXEqZD2w6iZeTcRiOafRXoHMMtSMjYJ8Trxko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IAd2ypUuR3f8YDDbwa7zO0HjnuMvL81K1HaQ7C6T2n8Sr+T7PdVnkB/rPlpu/af1G
	 KYnuNKVuLecVwnlfjXAM1QNcIZFf7+yhUR+IDwEbbCQmMPYr22nEjYsSt9MPDd4mtT
	 lfSkjFAnkq3OIOHWQKQ4dGqtZ1O4ALZV8061x5RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 534/957] usb: typec: ps883x: Fix Oops at unbind
Date: Wed, 20 May 2026 18:16:57 +0200
Message-ID: <20260520162146.114666528@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mostafa Saleh <smostafa@google.com>

[ Upstream commit 381133848a033c2086cf9cafb226f425bd0414ff ]

When trying to unbind a device in order to bind to it vfio-platform as:

  echo bc0000.geniqup  > /sys/bus/platform/devices/bc0000.geniqup/driver/unbind

I get the following Oops:

[  436.478639] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
[  436.487762] Mem abort info:
[  436.490716]   ESR = 0x0000000096000004
[  436.494595]   EC = 0x25: DABT (current EL), IL = 32 bits
[  436.500071]   SET = 0, FnV = 0
[  436.503250]   EA = 0, S1PTW = 0
[  436.506505]   FSC = 0x04: level 0 translation fault
[  436.511533] Data abort info:
[  436.514558]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[  436.520215]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[  436.525436]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[  436.530918] user pgtable: 4k pages, 48-bit VAs, pgdp=00000008861a9000
[  436.537554] [0000000000000020] pgd=0000000000000000, p4d=0000000000000000
[  436.544548] Internal error: Oops: 0000000096000004 [#1]  SMP
[  436.550374] Modules linked in:
[  436.553542] CPU: 2 UID: 0 PID: 671 Comm: bash Tainted: G        W           7.0.0-rc3-g56fcdd0911a5-dirty #2 PREEMPT
[  436.564440] Tainted: [W]=WARN
[  436.567515] Hardware name: LENOVO 91B6CTO1WW/3796, BIOS O6NKT3BA 05/02/2025
[  436.574675] pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[  436.581841] pc : ps883x_retimer_remove+0x14/0x94
[  436.586605] lr : i2c_device_remove+0x28/0x84
[  436.591017] sp : ffff8000847137c0

That's because the ps883x_retimer_remove() retrieves the driver data
from i2c_get_clientdata() which was never set at probe. So, add
i2c_set_clientdata() at the end of the probe.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: 257a087c8b52 ("usb: typec: Add support for Parade PS8830 Type-C Retimer")
Link: https://patch.msgid.link/20260313155534.1916773-1-smostafa@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/mux/ps883x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/typec/mux/ps883x.c b/drivers/usb/typec/mux/ps883x.c
index ad59babf7ccec..f1f65d4e5729b 100644
--- a/drivers/usb/typec/mux/ps883x.c
+++ b/drivers/usb/typec/mux/ps883x.c
@@ -411,6 +411,7 @@ static int ps883x_retimer_probe(struct i2c_client *client)
 		goto err_switch_unregister;
 	}
 
+	i2c_set_clientdata(client, retimer);
 	return 0;
 
 err_switch_unregister:
-- 
2.53.0



