Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981C115AE7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD08C4339A;
	Wed, 20 Sep 2023 12:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212204;
	bh=mBzrAV+7c8Hh+RMH0nSu7xxZisbtsphZJduU34QnXXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSuexkrQleSc6nT+O+KzkQyp4uZspMhVTjD79xt7ExueTdL0kROU86cZ+xs7OWyBn
	 aqNkwfPE6aBg1J2SkA0F4sAMxgoESnhmeewWCanIrxz38REIXJ65NICH8Ti/PuGcQA
	 KlY4OJfYyAp2NX3c5Sg4Is/IXFgNjtkUEL7DzNOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 4.19 188/273] cpufreq: brcmstb-avs-cpufreq: Fix -Warray-bounds bug
Date: Wed, 20 Sep 2023 13:30:28 +0200
Message-ID: <20230920112852.320423228@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit e520d0b6be950ce3738cf4b9bd3b392be818f1dc upstream.

Allocate extra space for terminating element at:

drivers/cpufreq/brcmstb-avs-cpufreq.c:
449         table[i].frequency = CPUFREQ_TABLE_END;

and add code comment to make this clear.

This fixes the following -Warray-bounds warning seen after building
ARM with multi_v7_defconfig (GCC 13):
In function 'brcm_avs_get_freq_table',
    inlined from 'brcm_avs_cpufreq_init' at drivers/cpufreq/brcmstb-avs-cpufreq.c:623:15:
drivers/cpufreq/brcmstb-avs-cpufreq.c:449:28: warning: array subscript 5 is outside array bounds of 'void[60]' [-Warray-bounds=]
  449 |         table[i].frequency = CPUFREQ_TABLE_END;
In file included from include/linux/node.h:18,
                 from include/linux/cpu.h:17,
                 from include/linux/cpufreq.h:12,
                 from drivers/cpufreq/brcmstb-avs-cpufreq.c:44:
In function 'devm_kmalloc_array',
    inlined from 'devm_kcalloc' at include/linux/device.h:328:9,
    inlined from 'brcm_avs_get_freq_table' at drivers/cpufreq/brcmstb-avs-cpufreq.c:437:10,
    inlined from 'brcm_avs_cpufreq_init' at drivers/cpufreq/brcmstb-avs-cpufreq.c:623:15:
include/linux/device.h:323:16: note: at offset 60 into object of size 60 allocated by 'devm_kmalloc'
  323 |         return devm_kmalloc(dev, bytes, flags);
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy() and help us make progress towards globally
enabling -Warray-bounds.

Link: https://github.com/KSPP/linux/issues/324
Fixes: de322e085995 ("cpufreq: brcmstb-avs-cpufreq: AVS CPUfreq driver for Broadcom STB SoCs")
Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/brcmstb-avs-cpufreq.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/brcmstb-avs-cpufreq.c
+++ b/drivers/cpufreq/brcmstb-avs-cpufreq.c
@@ -410,7 +410,11 @@ brcm_avs_get_freq_table(struct device *d
 	if (ret)
 		return ERR_PTR(ret);
 
-	table = devm_kcalloc(dev, AVS_PSTATE_MAX + 1, sizeof(*table),
+	/*
+	 * We allocate space for the 5 different P-STATES AVS,
+	 * plus extra space for a terminating element.
+	 */
+	table = devm_kcalloc(dev, AVS_PSTATE_MAX + 1 + 1, sizeof(*table),
 			     GFP_KERNEL);
 	if (!table)
 		return ERR_PTR(-ENOMEM);


