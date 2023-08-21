Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CBF1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF70C433C9;
	Mon, 21 Aug 2023 20:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648452;
	bh=hp73kmSVLXc9H1W2nqXbvVF35riPw7CH2ANVj0/YE+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXdvOTWHGCEgf3257L5qlmQJ5cghZffvNJR+GRZvDpsY1oc+3ziqKxBS9Lvv3QAZw
	 DqHn+816AGy4PWWqGtmjoRpebf5AcEQAXEKDvDwSjoACfdjr0+Qcvoe2DPyXPEowzO
	 rWQQcx6WrJvkMmtflOqHCflCdrF3R/K/YD8GxiKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"kernelci.org bot" <bot@kernelci.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 180/234] bus: ti-sysc: Flush posted write on enable before reset
Date: Mon, 21 Aug 2023 21:42:23 +0200
Message-ID: <20230821194136.801684857@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 34539b442b3bc7d5bf10164750302b60b91f18a7 ]

The am335x devices started producing boot errors for resetting musb module
in because of subtle timing changes:

Unhandled fault: external abort on non-linefetch (0x1008)
...
sysc_poll_reset_sysconfig from sysc_reset+0x109/0x12
sysc_reset from sysc_probe+0xa99/0xeb0
...

The fix is to flush posted write after enable before reset during
probe. Note that some devices also need to specify the delay after enable
with ti,sysc-delay-us, but this is not needed for musb on am335x based on
my tests.

Reported-by: kernelci.org bot <bot@kernelci.org>
Closes: https://storage.kernelci.org/next/master/next-20230614/arm/multi_v7_defconfig+CONFIG_THUMB2_KERNEL=y/gcc-10/lab-cip/baseline-beaglebone-black.html
Fixes: 596e7955692b ("bus: ti-sysc: Add support for software reset")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 21fe9854703f9..4cb23b9e06ea4 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -2142,6 +2142,8 @@ static int sysc_reset(struct sysc *ddata)
 		sysc_val = sysc_read_sysconfig(ddata);
 		sysc_val |= sysc_mask;
 		sysc_write(ddata, sysc_offset, sysc_val);
+		/* Flush posted write */
+		sysc_val = sysc_read_sysconfig(ddata);
 	}
 
 	if (ddata->cfg.srst_udelay)
-- 
2.40.1



