Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EFF3BBA0E;
	Wed, 20 May 2026 16:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296096; cv=none; b=FYyVAUDz2lQSdt2POH+itdCLKx1YxcdBc52EfSMMQqpKcNyvecnn+/nvC+4k6wrFa4L5jfHH5qW7hbzXAYG4PyqwwGWgREAf7vdfJe6KXQoLT282y6d939l2+1GWhMt9ek3MCNBOZTd1NqSg5tNsCwPPIybNBdXh9CdlGBkd4zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296096; c=relaxed/simple;
	bh=uX+cJLs8aiBGqBdxLQqMjCJ3n1+ovjOIP5BT8jJ3ftU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dv6+0OpVm06dsNQjF/qSc0w8Ej6O+H3RRwSBCIGhjnQfQlzee0QAgDB832+fzRnPV3MbtgXpPLMBaL5UfQXGrgTSASp0yrsp3uSldSdZdSrJJFNOW1cwP3sfit7cXyaXDVsN+EnPU7fzHY1sK5yHu9yOUSt6Bd5n/0CXyOn7GF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZYmIjZ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZYmIjZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406101F000E9;
	Wed, 20 May 2026 16:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296094;
	bh=HjCRey48jiFzZEzuuueKOTaafSc/cbjtBuWKmyiSgpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KZYmIjZ+vQf1hB7l5C8B15AW8s+42qlCSnL9oijWIF48r9uZQT0lueR7yZSSenEDF
	 6WLcVm9ecOQhzOb89IIIf8FBHWEEDwWr5YvDSCzYMo6cNPPFRj590aayo30CnqqBgR
	 ncL6gNAoMvxR9XOHsC2jcEvgUMHxrCVTRk7mbzFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0669/1146] usb: typec: ps883x: Fix Oops at unbind
Date: Wed, 20 May 2026 18:15:19 +0200
Message-ID: <20260520162203.327935053@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 5f2879749769e..1256252eceedc 100644
--- a/drivers/usb/typec/mux/ps883x.c
+++ b/drivers/usb/typec/mux/ps883x.c
@@ -444,6 +444,7 @@ static int ps883x_retimer_probe(struct i2c_client *client)
 		goto err_switch_unregister;
 	}
 
+	i2c_set_clientdata(client, retimer);
 	return 0;
 
 err_switch_unregister:
-- 
2.53.0



