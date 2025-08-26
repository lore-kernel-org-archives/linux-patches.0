Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C1535A2A2;
	Tue, 26 Aug 2025 14:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217722; cv=none; b=tm4US0b27FT3Kmh1PTuGd+Fw3Wz4RibiOQ/0tbvh5Zrd3E46EOGt2F8yFODmxcMQ6vpHjrKdO40ZTe6XGI/tBYZ6lBgnIujnFRfmxzRhITPc1nB4XLLT6O51dHn0CCVcnqXDO8YFUFU+AqXW58hCfoyprivDoHD3KLPQXPBSZI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217722; c=relaxed/simple;
	bh=GcVCjv0fTRTlEV7XFQbhekDMcavpaD65y75cHRA+m3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rceTItnoGP+har8KnDwjuRr7mJ+GlSWIGygNQG4ppbZ8aFfqtCB2HZneCsUmWPnqno26AyjepX/21YQoztyysjYxNxxkk9+r7iX2G3ptnGXdj6+Byns4y4zstR86xeuHOBoIYaoQGcLqKbOKD+5sdRpealZ8nUQjK0eCuG1ULWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLUDH3c3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLUDH3c3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E314C4CEF1;
	Tue, 26 Aug 2025 14:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217722;
	bh=GcVCjv0fTRTlEV7XFQbhekDMcavpaD65y75cHRA+m3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PLUDH3c3vHA90xH/ECVC0rmpanAuYmiTfmAir9LZ0ZShPlP25NNYCUOH6XI9Agi1T
	 NhXUbzX34hbhxTND+/L/6vbCp3FVZ1xOj1YTzBzA2w0UfavKL0NaZt9DvDPfcDQC6H
	 YIm9Vt9+OeK+McyIPhI+Rt2IupOAQ8NNYXTqlqqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 251/523] platform/x86: thinkpad_acpi: Handle KCOV __init vs inline mismatches
Date: Tue, 26 Aug 2025 13:07:41 +0200
Message-ID: <20250826110930.623783961@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 6418a8504187dc7f5b6f9d0649c03e362cb0664b ]

When KCOV is enabled all functions get instrumented, unless the
__no_sanitize_coverage attribute is used. To prepare for
__no_sanitize_coverage being applied to __init functions[1], we have
to handle differences in how GCC's inline optimizations get resolved.
For thinkpad_acpi routines, this means forcing two functions to be
inline with __always_inline.

Link: https://lore.kernel.org/lkml/20250523043935.2009972-11-kees@kernel.org/ [1]
Signed-off-by: Kees Cook <kees@kernel.org>
Link: https://lore.kernel.org/r/20250529181831.work.439-kees@kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 5a8434da60e7..d18b6ddba982 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -515,12 +515,12 @@ static unsigned long __init tpacpi_check_quirks(
 	return 0;
 }
 
-static inline bool __pure __init tpacpi_is_lenovo(void)
+static __always_inline bool __pure __init tpacpi_is_lenovo(void)
 {
 	return thinkpad_id.vendor == PCI_VENDOR_ID_LENOVO;
 }
 
-static inline bool __pure __init tpacpi_is_ibm(void)
+static __always_inline bool __pure __init tpacpi_is_ibm(void)
 {
 	return thinkpad_id.vendor == PCI_VENDOR_ID_IBM;
 }
-- 
2.39.5



