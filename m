Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7114A134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC9DC433C0;
	Mon, 26 Jun 2023 18:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803430;
	bh=cmOIWXKRlm6R0XRISnhNMwNrUVkK9hw0Xev84FwBN/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i80/5gQUySV3ltY0m4KSbvIx09fEEaswVd1lHZarmtOc4ZbhrMc+xN1dsqlKix2qk
	 byiUV2T7/h0e8vRdp56Q4ILQ3Py4LcYrqWRwiWYvcokLnlJK6LeBpbwctvmpSzUXlQ
	 3lddoCBUD7B7bnoZQGOdeLcOZiBlP5LebeVXgvqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernhard Krug <b.krug@elektronenpumpe.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.3 057/199] thermal/intel/intel_soc_dts_iosf: Fix reporting wrong temperatures
Date: Mon, 26 Jun 2023 20:09:23 +0200
Message-ID: <20230626180808.069859988@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

commit 0bb619f9227aa370330d2b309733d74750705053 upstream.

Since commit 955fb8719efb ("thermal/intel/intel_soc_dts_iosf: Use Intel
TCC library") intel_soc_dts_iosf is reporting the wrong temperature.

The driver expects tj_max to be in milli-degrees-celcius but after
the switch to the TCC library this is now in degrees celcius so
instead of e.g. 90000 it is set to 90 causing a temperature 45
degrees below tj_max to be reported as -44910 milli-degrees
instead of as 45000 milli-degrees.

Fix this by adding back the lost factor of 1000.

Fixes: 955fb8719efb ("thermal/intel/intel_soc_dts_iosf: Use Intel TCC library")
Reported-by: Bernhard Krug <b.krug@elektronenpumpe.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Cc: 6.3+ <stable@vger.kernel.org> # 6.3+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/intel_soc_dts_iosf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thermal/intel/intel_soc_dts_iosf.c
+++ b/drivers/thermal/intel/intel_soc_dts_iosf.c
@@ -401,7 +401,7 @@ struct intel_soc_dts_sensors *intel_soc_
 	spin_lock_init(&sensors->intr_notify_lock);
 	mutex_init(&sensors->dts_update_lock);
 	sensors->intr_type = intr_type;
-	sensors->tj_max = tj_max;
+	sensors->tj_max = tj_max * 1000;
 	if (intr_type == INTEL_SOC_DTS_INTERRUPT_NONE)
 		notification = false;
 	else


