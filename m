Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDB218C03E;
	Tue, 10 Sep 2024 09:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962249; cv=none; b=Z5+wwVR8KFxkLCDHHixnr3yeBXL2WXagA0B0/QO3rY+L1F2+pAeAic+quZi0t0SeuVy09aeDiM1e2Kwd9dpK/CyKFFOQrWn4QD0weSYUmohrvJG9LG9v8Gefp4ZsS+OXL6lmzkVfye6KRY8XmcZERriw7Wv+hXW4rReiyUxciZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962249; c=relaxed/simple;
	bh=ka0lGrS/ffUNOahWcVxEpmad6l3Bklyi1gkqFcdaahg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imoyl37OvmSXIybWiMyc+3ldo+nNhIs34TjYRtIVv7EfRjm57hU1/bfbvFSsjqfNXVxZ15vcK7t8aysisllloGIyE/yK0/ii/Nuzf6ivFmjPGo/UY+IwAqFZKl/219DPjjKxh7Cv9qmyH9uNIUwTZBiw8rG5VYbsmQqyk95vbz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0U+xL3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0U+xL3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBA3C4CEC3;
	Tue, 10 Sep 2024 09:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962249;
	bh=ka0lGrS/ffUNOahWcVxEpmad6l3Bklyi1gkqFcdaahg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0U+xL3iiI/MA/6iakKhFXU7VgVFSDT+nkD6xda5w7cHguXyFkTNaEEoHWXt6MIyu
	 fr0gI14RYo5v9fTLBl9K3/F74NvGaXrINs7vIFRUDXRebrrZGP5KwNAIQdehHM3LQr
	 Y6hxeKY1sJxqkcp2S5KeWqpnIl+7F2EpMX0IDSwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Gavin Shan <gshan@redhat.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 318/375] ACPI: processor: Fix memory leaks in error paths of processor_add()
Date: Tue, 10 Sep 2024 11:31:55 +0200
Message-ID: <20240910092633.248163473@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index c052cdeca9fd..5f5a01ccfc3a 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -400,7 +400,7 @@ static int acpi_processor_add(struct acpi_device *device,
 
 	result = acpi_processor_get_info(device);
 	if (result) /* Processor is not physically present or unavailable */
-		return result;
+		goto err_clear_driver_data;
 
 	BUG_ON(pr->id >= nr_cpu_ids);
 
@@ -415,7 +415,7 @@ static int acpi_processor_add(struct acpi_device *device,
 			"BIOS reported wrong ACPI id %d for the processor\n",
 			pr->id);
 		/* Give up, but do not abort the namespace scan. */
-		goto err;
+		goto err_clear_driver_data;
 	}
 	/*
 	 * processor_device_array is not cleared on errors to allow buggy BIOS
@@ -427,12 +427,12 @@ static int acpi_processor_add(struct acpi_device *device,
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
 
@@ -443,10 +443,11 @@ static int acpi_processor_add(struct acpi_device *device,
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



