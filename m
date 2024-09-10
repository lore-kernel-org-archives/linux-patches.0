Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2551B17BEAE;
	Tue, 10 Sep 2024 09:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962246; cv=none; b=YqnfdowTwpq2EKyGFe1QzWbWcYZAUPtcrQSYEDCX1o5sBG9w8k1WpmyVKxtx3ihw9JHIA/Ry1y5Q+CcYg/AO85zPEj57HGssCLMmjy6nsLwU4jlHqln1leDFlCVmDIS1XPyj5WEzIr8IGwH9wK/YRCO6spuAvuscdomN1rUoL9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962246; c=relaxed/simple;
	bh=UYaz166SZMs6SvoG3vYYPq53ddR2seZSmKay/3OhxbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNJ0GQOSpyCqPdbeL98Kgw8j647EWY80ViB7MsxwQAN9ado8mI5mOHSFjmoOGuU5wJSnaP8VMr+H2DU7y8+B23cX2i3fkAUmNidu/1cLsrpNwF1blfAV1/SgrPQ20EgQsDFiETgxY+J2DZFxoYJPmyDxGpHHB0TQ0iKX6RBZedM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EaicubSz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EaicubSz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0637C4CEC6;
	Tue, 10 Sep 2024 09:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962246;
	bh=UYaz166SZMs6SvoG3vYYPq53ddR2seZSmKay/3OhxbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EaicubSzTkJi/P5xZmhKR1tkCnHSukOa3WiYbQgvzYrywpnziC31xgpanQ0T7HpZt
	 dl8BKn1OwLdWd6e9MOCEvVzEkKeDlTErdSa3tF5dKPXHgF5WBbdj9ZikCpS1PC5FsC
	 3f7fXxrRiE2nTVDLtwDDjI70YXbjRquxZcs4ObTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Gavin Shan <gshan@redhat.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 317/375] ACPI: processor: Return an error if acpi_processor_get_info() fails in processor_add()
Date: Tue, 10 Sep 2024 11:31:54 +0200
Message-ID: <20240910092633.215749622@linuxfoundation.org>
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

[ Upstream commit fadf231f0a06a6748a7fc4a2c29ac9ef7bca6bfd ]

Rafael observed [1] that returning 0 from processor_add() will result in
acpi_default_enumeration() being called which will attempt to create a
platform device, but that makes little sense when the processor is known
to be not available.  So just return the error code from acpi_processor_get_info()
instead.

Link: https://lore.kernel.org/all/CAJZ5v0iKU8ra9jR+EmgxbuNm=Uwx2m1-8vn_RAZ+aCiUVLe3Pw@mail.gmail.com/ [1]
Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20240529133446.28446-5-Jonathan.Cameron@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: 47ec9b417ed9 ("ACPI: processor: Fix memory leaks in error paths of processor_add()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 7a0dd35d62c9..c052cdeca9fd 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -400,7 +400,7 @@ static int acpi_processor_add(struct acpi_device *device,
 
 	result = acpi_processor_get_info(device);
 	if (result) /* Processor is not physically present or unavailable */
-		return 0;
+		return result;
 
 	BUG_ON(pr->id >= nr_cpu_ids);
 
-- 
2.43.0



