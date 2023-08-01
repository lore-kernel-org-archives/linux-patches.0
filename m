Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C951F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFBAC433C9;
	Tue,  1 Aug 2023 09:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882760;
	bh=HK1NamKLdHZJvarHnxQLlQdWOtRMgJFgP/47W6N+xi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwXQKvsHkYqC+QVn7i5cbFEQObMskIa4uRboPVHqOYZYasNn2gbAQPdhJIpXF2P3W
	 mBmUvCqu1rJvYKP6pM6qTQ3b2Py9XZaKyxeTqLEY44EbYRp3DfO3mJIXIJ29m1tRgK
	 NE37gSfh3YILo1x6f0tC8I8dYNL6SGrwTMOshN0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hagar Hemdan <hagarhem@amazon.de>
Subject: [PATCH 6.1 222/228] ACPI: processor: perflib: Avoid updating frequency QoS unnecessarily
Date: Tue,  1 Aug 2023 11:21:20 +0200
Message-ID: <20230801091930.869152323@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
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

commit 99387b016022c29234c4ebf9abd34358c6e56532 upstream.

Modify acpi_processor_get_platform_limit() to avoid updating its
frequency QoS request when the _PPC return value has not changed
by comparing that value to the previous _PPC return value stored in
the performance_platform_limit field of the struct acpi_processor
corresponding to the given CPU.

While at it, do the _PPC return value check against the state count
earlier, to avoid setting performance_platform_limit to an invalid
value, and make acpi_processor_ppc_init() use FREQ_QOS_MAX_DEFAULT_VALUE
as the "no limit" frequency QoS for consistency.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Hagar Hemdan <hagarhem@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_perflib.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -76,13 +76,16 @@ static int acpi_processor_get_platform_l
 
 	index = ppc;
 
+	if (pr->performance_platform_limit == index ||
+	    ppc >= pr->performance->state_count)
+		return 0;
+
 	pr_debug("CPU %d: _PPC is %d - frequency %s limited\n", pr->id,
 		 index, index ? "is" : "is not");
 
 	pr->performance_platform_limit = index;
 
-	if (ppc >= pr->performance->state_count ||
-	    unlikely(!freq_qos_request_active(&pr->perflib_req)))
+	if (unlikely(!freq_qos_request_active(&pr->perflib_req)))
 		return 0;
 
 	/*
@@ -177,9 +180,16 @@ void acpi_processor_ppc_init(struct cpuf
 		if (!pr)
 			continue;
 
+		/*
+		 * Reset performance_platform_limit in case there is a stale
+		 * value in it, so as to make it match the "no limit" QoS value
+		 * below.
+		 */
+		pr->performance_platform_limit = 0;
+
 		ret = freq_qos_add_request(&policy->constraints,
-					   &pr->perflib_req,
-					   FREQ_QOS_MAX, INT_MAX);
+					   &pr->perflib_req, FREQ_QOS_MAX,
+					   FREQ_QOS_MAX_DEFAULT_VALUE);
 		if (ret < 0)
 			pr_err("Failed to add freq constraint for CPU%d (%d)\n",
 			       cpu, ret);


