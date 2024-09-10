Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D6B18A6B9;
	Tue, 10 Sep 2024 10:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963852; cv=none; b=QPcKguwG3Y3NO8Hb4+kClPD/61KRFU3811bpxCFgKqydqa5KWAZz66QW5R02zbonjkwQpNneENGNgRNn9xkfjRaZU9+a1DKudcv7NAvHBUq70tYOZfPm6XunktPm3guH0M4yDU5SuWgY+8QQXElO8Uuft1o+QOm6bdLBS3Y2znk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963852; c=relaxed/simple;
	bh=oyl4fkz1dkVpSTWOFwEXCsJJBMu1H5MND5LXQWZI7F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3A+dwY8s6uX9lp6X3VBSF8vWMA2r6GJiq8Ur5C5eUHnDV9fKdcyT16y3SHTLhdh1OY+U6vASQM4kmTs3WHbZqtQSBBizxPS7duif9j0kABNEfYvLlrQNGXPBYBLlUycOiA4v5YoAXTO36YNM7pPAZPlUYz0ba8fUAr99WVSrbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZPCSo+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZPCSo+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7904EC4CEC3;
	Tue, 10 Sep 2024 10:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963851;
	bh=oyl4fkz1dkVpSTWOFwEXCsJJBMu1H5MND5LXQWZI7F0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZPCSo+DKVMU24+Q73QBaX0O4sJg4+JAj9jUEz/iACBxVejNoxsdQDjsCBsQDyS11
	 QkEbmlIJf5gpZJ1NdQBSLn5S6dMdsIJjJl54EqgG2j0tWnE+JuX3HL+lOzSk5WtEme
	 H4ucHfhCjKjTgX92WaJzH3td22e8N2aFRzxxdJgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Gavin Shan <gshan@redhat.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 198/214] ACPI: processor: Fix memory leaks in error paths of processor_add()
Date: Tue, 10 Sep 2024 11:33:40 +0200
Message-ID: <20240910092606.671468822@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5662c157fda7..8bd5c4fa91f2 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -373,7 +373,7 @@ static int acpi_processor_add(struct acpi_device *device,
 
 	result = acpi_processor_get_info(device);
 	if (result) /* Processor is not physically present or unavailable */
-		return result;
+		goto err_clear_driver_data;
 
 	BUG_ON(pr->id >= nr_cpu_ids);
 
@@ -388,7 +388,7 @@ static int acpi_processor_add(struct acpi_device *device,
 			"BIOS reported wrong ACPI id %d for the processor\n",
 			pr->id);
 		/* Give up, but do not abort the namespace scan. */
-		goto err;
+		goto err_clear_driver_data;
 	}
 	/*
 	 * processor_device_array is not cleared on errors to allow buggy BIOS
@@ -400,12 +400,12 @@ static int acpi_processor_add(struct acpi_device *device,
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
 
@@ -416,10 +416,11 @@ static int acpi_processor_add(struct acpi_device *device,
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



