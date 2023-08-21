Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F085011703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720BAC433C8;
	Mon, 21 Aug 2023 19:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647776;
	bh=U9mFyu5XHRGA3Wok2dRZIV719QkZ9TcR8KXPX2uSn2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjo7Fu5MmRMPmr14FR03UfBPY6I/xGvhNaZObXrn4q3qoSLUEt5nK0yBRluyLscom
	 kYH2VSWdGFsNnw608pMHCHCKdsns7uUuQ215U0lJ5Fo8PfYQzcQm96rl+KHN51Qhgj
	 e+KGI5d2VjGbE269QeE50ejz5xiLEd532j71RceE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"kernelci.org bot" <bot@kernelci.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/194] bus: ti-sysc: Flush posted write on enable before reset
Date: Mon, 21 Aug 2023 21:41:54 +0200
Message-ID: <20230821194128.620095903@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
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
index cae078bffc715..9b7268bae66ab 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -2159,6 +2159,8 @@ static int sysc_reset(struct sysc *ddata)
 		sysc_val = sysc_read_sysconfig(ddata);
 		sysc_val |= sysc_mask;
 		sysc_write(ddata, sysc_offset, sysc_val);
+		/* Flush posted write */
+		sysc_val = sysc_read_sysconfig(ddata);
 	}
 
 	if (ddata->cfg.srst_udelay)
-- 
2.40.1



