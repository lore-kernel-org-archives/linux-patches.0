Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C19B168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63DCC433EF;
	Mon,  8 May 2023 10:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540884;
	bh=OA4b/0jb12WeWdYP3LvDJaMTvf/wovwjSeQtyUhE68Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUUzG2tnf8JG5lOnAh0EqcgPrgB0kZ9rIROY2766oxJmcmRkKppBhnWWICkHSf98+
	 0j9w5XDPB0t7uS9+0Stz3aJL7b68Sm9yE7OFyqW7e2dBxLGns79cbBr4T40V1L7AwM
	 v0TqDNT7DR8WyctW7d0HB2R76hJ9+cXxLsTUptXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 535/611] pwm: mtk-disp: Configure double buffering before reading in .get_state()
Date: Mon,  8 May 2023 11:46:17 +0200
Message-Id: <20230508094439.386165667@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit b16c310115f2084b8826a35b77ef42bab6786d9f ]

The DISP_PWM controller's default behavior is to always use register
double buffering: all reads/writes are then performed on shadow
registers instead of working registers and this becomes an issue
in case our chosen configuration in Linux is different from the
default (or from the one that was pre-applied by the bootloader).

An example of broken behavior is when the controller is configured
to use shadow registers, but this driver wants to configure it
otherwise: what happens is that the .get_state() callback is called
right after registering the pwmchip and checks whether the PWM is
enabled by reading the DISP_PWM_EN register;
At this point, if shadow registers are enabled but their content
was not committed before booting Linux, we are *not* reading the
current PWM enablement status, leading to the kernel knowing that
the hardware is actually enabled when, in reality, it's not.

The aforementioned issue emerged since this driver was fixed with
commit 0b5ef3429d8f ("pwm: mtk-disp: Fix the parameters calculated
by the enabled flag of disp_pwm") making it to read the enablement
status from the right register.

Configure the controller in the .get_state() callback to avoid
this desync issue and get the backlight properly working again.

Fixes: 3f2b16734914 ("pwm: mtk-disp: Implement atomic API .get_state()")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Tested-by: Alexandre Mergnat <amergnat@baylibre.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-mtk-disp.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pwm/pwm-mtk-disp.c b/drivers/pwm/pwm-mtk-disp.c
index 7fea385a387a5..3811578fcff05 100644
--- a/drivers/pwm/pwm-mtk-disp.c
+++ b/drivers/pwm/pwm-mtk-disp.c
@@ -196,6 +196,16 @@ static int mtk_disp_pwm_get_state(struct pwm_chip *chip,
 		return 0;
 	}
 
+	/*
+	 * Apply DISP_PWM_DEBUG settings to choose whether to enable or disable
+	 * registers double buffer and manual commit to working register before
+	 * performing any read/write operation
+	 */
+	if (mdp->data->bls_debug)
+		mtk_disp_pwm_update_bits(mdp, mdp->data->bls_debug,
+					 mdp->data->bls_debug_mask,
+					 mdp->data->bls_debug_mask);
+
 	rate = clk_get_rate(mdp->clk_main);
 	con0 = readl(mdp->base + mdp->data->con0);
 	con1 = readl(mdp->base + mdp->data->con1);
-- 
2.39.2



