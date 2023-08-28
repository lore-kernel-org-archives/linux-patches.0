Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593B111C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0735C433C8;
	Mon, 28 Aug 2023 10:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219107;
	bh=jrvIWMhwJU2NdyKrobiQYUm3FTlI/g0N2V6jX+Q2QwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jQb91whSzbEusbnf9W7fv/nhA3vKtBMljPXEZuM/wk9/5wYDr3v7ihOXnK3GrfuhN
	 R/Cz75rfbn8QeiNi2v9Z50/n4as7rdG+ptvilrfLDLP5U1cXx/rD3MPkyL2q2sMZoT
	 weIeifYe35XfcxyznIkmPadW1AcFs87vW+q+3Lj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"kernelci.org bot" <bot@kernelci.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/158] bus: ti-sysc: Flush posted write on enable before reset
Date: Mon, 28 Aug 2023 12:12:53 +0200
Message-ID: <20230828101159.842263803@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index c2808d118568e..e1a9838c96655 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -1823,6 +1823,8 @@ static int sysc_reset(struct sysc *ddata)
 		sysc_val = sysc_read_sysconfig(ddata);
 		sysc_val |= sysc_mask;
 		sysc_write(ddata, sysc_offset, sysc_val);
+		/* Flush posted write */
+		sysc_val = sysc_read_sysconfig(ddata);
 	}
 
 	if (ddata->cfg.srst_udelay)
-- 
2.40.1



