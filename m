Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362B1322549;
	Mon, 18 Aug 2025 13:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523476; cv=none; b=iDq6xVkZiA9dHMUyZ1XSRiWNqKjhuuIKANV7tNH7tyz9HDmTP/EeANp+KquOtbAB818t2UbcK7SyrTHEqpeLre7iTC2AlGfe0tYRoxdEHRe87fN2h+jx+oSAPfY99RLStseUpXyg6n2cDpvT6WNlgaF/DJlbNXm4DzYEI+impqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523476; c=relaxed/simple;
	bh=jh0VhUa6NKU2eLUxp3cawwPBUIkSL6x9XYGC39LkDaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s02lvSdSQhRaQsVCQxDJYgxoYo7Ap8JikMKpadO7aqPBGDCVWj6iv03X9dUNPSGaJgqjfXz1tMViWfsRdnC/Q5qHNpxn/tfVIE86AMKgLK7KkLqpcmlf5Jd8qZqsbltMUCYo2A7nSC3h5ugDNmdVYzrrgULu++kgemE7SOoY2dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjrLqU9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjrLqU9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A3EC116B1;
	Mon, 18 Aug 2025 13:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523475;
	bh=jh0VhUa6NKU2eLUxp3cawwPBUIkSL6x9XYGC39LkDaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SjrLqU9g0O0bXd+/xMl147XqSVB5Y8imxzmMa6Tbr8UGsRJCS82oZt7z88I5ThgVd
	 NK8YgUGk28trvywSOWuu4otvt7YPZ271KenGN0zAvPniZiOIVZvwH30LhF1ISLpb+V
	 tdPN89qmLZXTSDkXEChIrGXzHneN2YNaBsEcdHH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 181/515] platform/x86: thinkpad_acpi: Handle KCOV __init vs inline mismatches
Date: Mon, 18 Aug 2025 14:42:47 +0200
Message-ID: <20250818124505.341530461@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 657625dd60a0..dc1fc069fed9 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -558,12 +558,12 @@ static unsigned long __init tpacpi_check_quirks(
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



