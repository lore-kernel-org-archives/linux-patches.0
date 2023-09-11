Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DAC11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7124C433C8;
	Mon, 11 Sep 2023 14:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443881;
	bh=gKo/ltqocFOaLEWC0v62KhytptoGW2xNrGOP924SM90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1xEqnrSzGDx8DWd82PW3G504ZxCZTYHHJrtgFV/2ryBYudMu4WYrq+KEmMbrJjQD
	 FoFIrac2MAvXGCJbpF0HxooMWlCbSHPmviB+qQmqNn96MWzPaoju+FSrhwoAKpfm3A
	 cWV9/VByDi7Mvbf37wdMqwgdOF/WePFjFN5Ok3Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 534/737] extcon: cht_wc: add POWER_SUPPLY dependency
Date: Mon, 11 Sep 2023 15:46:33 +0200
Message-ID: <20230911134705.486479393@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d20a3a8a32e3fa564ff25da860c5fc1a97642dfe ]

The driver fails to link when CONFIG_POWER_SUPPLY is disabled:

x86_64-linux-ld: vmlinux.o: in function `cht_wc_extcon_psy_get_prop':
extcon-intel-cht-wc.c:(.text+0x15ccda7): undefined reference to `power_supply_get_drvdata'
x86_64-linux-ld: vmlinux.o: in function `cht_wc_extcon_pwrsrc_event':
extcon-intel-cht-wc.c:(.text+0x15cd3e9): undefined reference to `power_supply_changed'
x86_64-linux-ld: vmlinux.o: in function `cht_wc_extcon_probe':
extcon-intel-cht-wc.c:(.text+0x15cd596): undefined reference to `devm_power_supply_register'

It should be possible to change the driver to not require this at
compile time and still provide other functions, but adding a hard
Kconfig dependency does not seem to have any practical downsides
and is simpler since the option is normally enabled anyway.

Fixes: 66e31186cd2aa ("extcon: intel-cht-wc: Add support for registering a power_supply class-device")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/extcon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 290186e44e6bd..4dd52a6a5b48d 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -62,6 +62,7 @@ config EXTCON_INTEL_CHT_WC
 	tristate "Intel Cherrytrail Whiskey Cove PMIC extcon driver"
 	depends on INTEL_SOC_PMIC_CHTWC
 	depends on USB_SUPPORT
+	depends on POWER_SUPPLY
 	select USB_ROLE_SWITCH
 	help
 	  Say Y here to enable extcon support for charger detection / control
-- 
2.40.1



