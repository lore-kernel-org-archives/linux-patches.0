Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D63A2F9DBB;
	Wed, 28 Jan 2026 15:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615063; cv=none; b=tOqbQ4jlFFgI5FgMZGojMmAgJLWG88d3chXwlrKwKy+LSiBaqgvtk+3pZQtznNtHZmVxwqp1CP/HpZzz4UJvrmdyCYIpX8WL5KLVYPP2oJ80Ve+sImc7JDRblq+EZM6AuGeJy4Ham8Y2r3c4UZkYw4ZT946ESul+uEMnyfjEj90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615063; c=relaxed/simple;
	bh=llQp3lcH21ses7/jvRpBi8yBPTjOJ47WFOByeWJN8j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fh4xS5eCXYL0dSRBWcZEU9eTOL7go8mvherN7Anri2fQB08PXt2679spTnaZfev0n2I2xCDQr/XGsnRYs72fREmvGybqgtG7jQVYlKAipNoliyRDbXuI+CSb37187TqTO47qW2rxKRDVpGmB9aP+z+Tc4Izle520GYQB3iuQJRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3s1h/55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3s1h/55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03A7C4CEF1;
	Wed, 28 Jan 2026 15:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615063;
	bh=llQp3lcH21ses7/jvRpBi8yBPTjOJ47WFOByeWJN8j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3s1h/55Ac5/1igc0CYrZvKXCvdks2M+hsCAOb8whETuyNOaKf/3LcngRk8G842SV
	 ZGDI8wcGGEIZBwTR4Rwl71wrRwB4pzrB2oloZhpjOYOjU/35HbyCIu3/HAiO8MNBay
	 jLkqg3OI84mF53rorELBduedCsPiLU+C61QtORlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	Zilin Guan <zilin@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/169] platform/x86/amd: Fix memory leak in wbrf_record()
Date: Wed, 28 Jan 2026 16:22:30 +0100
Message-ID: <20260128145336.420645347@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 2bf1877b7094c684e1d652cac6912cfbc507ad3e ]

The tmp buffer is allocated using kcalloc() but is not freed if
acpi_evaluate_dsm() fails. This causes a memory leak in the error path.

Fix this by explicitly freeing the tmp buffer in the error handling
path of acpi_evaluate_dsm().

Fixes: 58e82a62669d ("platform/x86/amd: Add support for AMD ACPI based Wifi band RFI mitigation feature")
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://patch.msgid.link/20260106091318.747019-1-zilin@seu.edu.cn
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/wbrf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/amd/wbrf.c b/drivers/platform/x86/amd/wbrf.c
index dd197b3aebe06..0f58d252b620a 100644
--- a/drivers/platform/x86/amd/wbrf.c
+++ b/drivers/platform/x86/amd/wbrf.c
@@ -104,8 +104,10 @@ static int wbrf_record(struct acpi_device *adev, uint8_t action, struct wbrf_ran
 	obj = acpi_evaluate_dsm(adev->handle, &wifi_acpi_dsm_guid,
 				WBRF_REVISION, WBRF_RECORD, &argv4);
 
-	if (!obj)
+	if (!obj) {
+		kfree(tmp);
 		return -EINVAL;
+	}
 
 	if (obj->type != ACPI_TYPE_INTEGER) {
 		ret = -EINVAL;
-- 
2.51.0



