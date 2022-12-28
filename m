Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED8F1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88A6C43396;
	Wed, 28 Dec 2022 15:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240545;
	bh=Y1DO5o7BuAe5s+ybFJLesPQquWluBXAXBGwYrizFhzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2lQ2Zncp44AwUncZkZ0u6RSVuJzwjgD9KsmT7pOzWTGnc4QYfp01A9Aj9jFSJGTy
	 dSLwPAAffBiaxfwZn6iIwhxqEEu/ztiBci1MwWquCw0cSF89Y0K3zZ5om47P6EqexN
	 uLZu9kXrf18MIWHQfHpL6fgbVjuTGFZMeZAvK/wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Liao <liaoyu15@huawei.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0173/1073] platform/x86: mxm-wmi: fix memleak in mxm_wmi_call_mx[ds|mx]()
Date: Wed, 28 Dec 2022 15:29:21 +0100
Message-Id: <20221228144332.711839579@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Liao <liaoyu15@huawei.com>

[ Upstream commit 727cc0147f5066e359aca65cc6cc5e6d64cc15d8 ]

The ACPI buffer memory (out.pointer) returned by wmi_evaluate_method()
is not freed after the call, so it leads to memory leak.

The method results in ACPI buffer is not used, so just pass NULL to
wmi_evaluate_method() which fixes the memory leak.

Fixes: 99b38b4acc0d ("platform/x86: add MXM WMI driver.")
Signed-off-by: Yu Liao <liaoyu15@huawei.com>
Link: https://lore.kernel.org/r/20221129011101.2042315-1-liaoyu15@huawei.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/mxm-wmi.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/mxm-wmi.c b/drivers/platform/x86/mxm-wmi.c
index 9a19fbd2f734..9a457956025a 100644
--- a/drivers/platform/x86/mxm-wmi.c
+++ b/drivers/platform/x86/mxm-wmi.c
@@ -35,13 +35,11 @@ int mxm_wmi_call_mxds(int adapter)
 		.xarg = 1,
 	};
 	struct acpi_buffer input = { (acpi_size)sizeof(args), &args };
-	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
 	acpi_status status;
 
 	printk("calling mux switch %d\n", adapter);
 
-	status = wmi_evaluate_method(MXM_WMMX_GUID, 0x0, adapter, &input,
-				     &output);
+	status = wmi_evaluate_method(MXM_WMMX_GUID, 0x0, adapter, &input, NULL);
 
 	if (ACPI_FAILURE(status))
 		return status;
@@ -60,13 +58,11 @@ int mxm_wmi_call_mxmx(int adapter)
 		.xarg = 1,
 	};
 	struct acpi_buffer input = { (acpi_size)sizeof(args), &args };
-	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
 	acpi_status status;
 
 	printk("calling mux switch %d\n", adapter);
 
-	status = wmi_evaluate_method(MXM_WMMX_GUID, 0x0, adapter, &input,
-				     &output);
+	status = wmi_evaluate_method(MXM_WMMX_GUID, 0x0, adapter, &input, NULL);
 
 	if (ACPI_FAILURE(status))
 		return status;
-- 
2.35.1



