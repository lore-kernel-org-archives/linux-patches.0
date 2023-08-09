Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B5717AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAC7C433C7;
	Wed,  9 Aug 2023 11:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581106;
	bh=WMfYavpZhy6SfzZyjVwRQwdxTEbekJnHTEWcStSw/dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YoqYPBQUdIClHya5hTnYvkeKN67QA/8TqO60EV/MCIgw8OyZHR9C3Zyv797ctbSJZ
	 bTqDogfVx96b1d1ADiJBOwI57Qdbd4mrVZSPqjbme+5cWhGcCJe+KIQgIebCZJwUj9
	 o7mbW+Zq/xyLbtUEassLg453dRDteN52XcQoEeBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <ptyadav@amazon.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hagar Hemdan <hagarhem@amazon.de>
Subject: [PATCH 5.10 107/201] ACPI: processor: perflib: Use the "no limit" frequency QoS
Date: Wed,  9 Aug 2023 12:41:49 +0200
Message-ID: <20230809103647.380281265@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit c02d5feb6e2f60affc6ba8606d8d614c071e2ba6 upstream.

When _PPC returns 0, it means that the CPU frequency is not limited by
the platform firmware, so make acpi_processor_get_platform_limit()
update the frequency QoS request used by it to "no limit" in that case.

This addresses a problem with limiting CPU frequency artificially on
some systems after CPU offline/online to the frequency that corresponds
to the first entry in the _PSS return package.

Reported-by: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Pratyush Yadav <ptyadav@amazon.de>
Tested-by: Pratyush Yadav <ptyadav@amazon.de>
Tested-by: Hagar Hemdan <hagarhem@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_perflib.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -56,6 +56,8 @@ static int acpi_processor_get_platform_l
 {
 	acpi_status status = 0;
 	unsigned long long ppc = 0;
+	s32 qos_value;
+	int index;
 	int ret;
 
 	if (!pr)
@@ -75,17 +77,27 @@ static int acpi_processor_get_platform_l
 		return -ENODEV;
 	}
 
+	index = ppc;
+
 	pr_debug("CPU %d: _PPC is %d - frequency %s limited\n", pr->id,
-		       (int)ppc, ppc ? "" : "not");
+		 index, index ? "is" : "is not");
 
-	pr->performance_platform_limit = (int)ppc;
+	pr->performance_platform_limit = index;
 
 	if (ppc >= pr->performance->state_count ||
 	    unlikely(!freq_qos_request_active(&pr->perflib_req)))
 		return 0;
 
-	ret = freq_qos_update_request(&pr->perflib_req,
-			pr->performance->states[ppc].core_frequency * 1000);
+	/*
+	 * If _PPC returns 0, it means that all of the available states can be
+	 * used ("no limit").
+	 */
+	if (index == 0)
+		qos_value = FREQ_QOS_MAX_DEFAULT_VALUE;
+	else
+		qos_value = pr->performance->states[index].core_frequency * 1000;
+
+	ret = freq_qos_update_request(&pr->perflib_req, qos_value);
 	if (ret < 0) {
 		pr_warn("Failed to update perflib freq constraint: CPU%d (%d)\n",
 			pr->id, ret);


