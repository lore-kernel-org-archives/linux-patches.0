Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D162218C021;
	Tue, 10 Sep 2024 10:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964578; cv=none; b=psFiTNOaO01ynq3ZuHY2uXFdj1vIaJwYlVNE/h17kk5AMG0g0Pq+OPdUgJ9TGe6RhvizYia/4wo38/1bzZXWsqEGtYI7SX5J47dwnuZtYnwApdJR9Y4sGZGIK/l7uQjPbFsNYKiISut+cDjzZYQICpvI6WP3UcMTvtF/+/Tmuik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964578; c=relaxed/simple;
	bh=jUk0pPJYL6IVHDg4rpIFgdeSP8p3Yf70M+H3AmJ8INI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUKtpxr0H6z9WA+YpcnyOrOm33bnSNfs78xmQpuWVMxPdpByqpbK8+igAIRgmd3wC3pDEM/8W1k2x4VNZPdg+SMroO2PnKH1QVOxGgr4WmwK7P/Eq05r1/M+n5qJgxHpiueDftwsK6z4d9DeD8/fqmoI0STJtZSPoSFJDqCGfSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdwRxWcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdwRxWcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50714C4CEC3;
	Tue, 10 Sep 2024 10:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964578;
	bh=jUk0pPJYL6IVHDg4rpIFgdeSP8p3Yf70M+H3AmJ8INI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdwRxWcvkHzvN9pTfTq0Nep04Z6kAWO3YjAXo404XPJ06eoSxUoo+R+UiHGmA4+nD
	 BacpNbiL4dtyhPB6lbnEyNi66MwDp8ffF4fABqnGKkNv2pK7Qm0Dn8a2EdcBd1i0Ox
	 c9wYF9Kfg5TknrQtMVur/8M07+D6TKSTE9/pc2/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Gavin Shan <gshan@redhat.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 230/269] ACPI: processor: Fix memory leaks in error paths of processor_add()
Date: Tue, 10 Sep 2024 11:33:37 +0200
Message-ID: <20240910092616.119795511@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 47ec9b417ed9b6b8ec2a941cd84d9de62adc358a ]

If acpi_processor_get_info() returned an error, pr and the associated
pr->throttling.shared_cpu_map were leaked.

The unwind code was in the wrong order wrt to setup, relying on
some unwind actions having no affect (clearing variables that were
never set etc).  That makes it harder to reason about so reorder
and add appropriate labels to only undo what was actually set up
in the first place.

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20240529133446.28446-6-Jonathan.Cameron@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_processor.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 5f760bc62219..7053f1b9fc1d 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -415,7 +415,7 @@ static int acpi_processor_add(struct acpi_device *device,
 
 	result = acpi_processor_get_info(device);
 	if (result) /* Processor is not physically present or unavailable */
-		return result;
+		goto err_clear_driver_data;
 
 	BUG_ON(pr->id >= nr_cpu_ids);
 
@@ -430,7 +430,7 @@ static int acpi_processor_add(struct acpi_device *device,
 			"BIOS reported wrong ACPI id %d for the processor\n",
 			pr->id);
 		/* Give up, but do not abort the namespace scan. */
-		goto err;
+		goto err_clear_driver_data;
 	}
 	/*
 	 * processor_device_array is not cleared on errors to allow buggy BIOS
@@ -442,12 +442,12 @@ static int acpi_processor_add(struct acpi_device *device,
 	dev = get_cpu_device(pr->id);
 	if (!dev) {
 		result = -ENODEV;
-		goto err;
+		goto err_clear_per_cpu;
 	}
 
 	result = acpi_bind_one(dev, device);
 	if (result)
-		goto err;
+		goto err_clear_per_cpu;
 
 	pr->dev = dev;
 
@@ -458,10 +458,11 @@ static int acpi_processor_add(struct acpi_device *device,
 	dev_err(dev, "Processor driver could not be attached\n");
 	acpi_unbind_one(dev);
 
- err:
-	free_cpumask_var(pr->throttling.shared_cpu_map);
-	device->driver_data = NULL;
+ err_clear_per_cpu:
 	per_cpu(processors, pr->id) = NULL;
+ err_clear_driver_data:
+	device->driver_data = NULL;
+	free_cpumask_var(pr->throttling.shared_cpu_map);
  err_free_pr:
 	kfree(pr);
 	return result;
-- 
2.43.0



