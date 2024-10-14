Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE411ABEB5;
	Mon, 14 Oct 2024 14:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917446; cv=none; b=paq1+mUPlNXz4wwVOORvUwmfZA8JEWo8/Am0y98TnYuTCMoUHMixSUEepJJoaI1ui6uKTKsU+Kt85udz3f0traSf2lY6ylzYzgd1DofGrS4ejarnHxIw4pMPjkySb+IzjmFl0+3K1o4wkudTU65ybVuxR9HcszoibwoHJWcdw+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917446; c=relaxed/simple;
	bh=0vf6X68U9tVrIm6ZIIQZyjuKU8ZEtVFlsyvgFWVOm3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7d7Nf7oYqoQiccE0mV5iODi8WC823WilC+tUTF/lGkiV5YgnZjk7CHxD/m01/cZFZB93CVMW6eZJIQwupTSgkceOb9EIvLI0QiKiPJ3FYnQM+gTQ8qt4/+ZRGP3YFyEygrl3Jo9vZg4H/GWtKtgn1mbXVHrgEk+2yQb5Zrq+Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9cNZejD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9cNZejD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E588CC4CEC3;
	Mon, 14 Oct 2024 14:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917446;
	bh=0vf6X68U9tVrIm6ZIIQZyjuKU8ZEtVFlsyvgFWVOm3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9cNZejDn+AyWRYarxhUpe5cd5BHAQXfvGfsh8IpevmezTNn4GMP8LVvaXr6P5ypt
	 Bwtu6DV6oESwTS/PFcrc3bIMKaWZQqmBfLdx/AcYE50MIci/bG978FuSIJ3BNWmeTz
	 PA1q2vUSay1225f2Ckywz1kpgBGqXQfgFV9Nytas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Khoruzhick <anarsoul@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/798] ACPICA: Implement ACPI_WARNING_ONCE and ACPI_ERROR_ONCE
Date: Mon, 14 Oct 2024 16:09:34 +0200
Message-ID: <20241014141218.744152828@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Khoruzhick <anarsoul@gmail.com>

[ Upstream commit 632b746b108e3c62e0795072d00ed597371c738a ]

ACPICA commit 2ad4e6e7c4118f4cdfcad321c930b836cec77406

In some cases it is not practical nor useful to nag user about some
firmware errors that they cannot fix. Add a macro that will print a
warning or error only once to be used in these cases.

Link: https://github.com/acpica/acpica/commit/2ad4e6e7
Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: c82c507126c9 ("ACPICA: executer/exsystem: Don't nag user about every Stall() violating the spec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/acpi/acoutput.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/acpi/acoutput.h b/include/acpi/acoutput.h
index 73781aae21192..eaef8471177af 100644
--- a/include/acpi/acoutput.h
+++ b/include/acpi/acoutput.h
@@ -193,6 +193,7 @@
  */
 #ifndef ACPI_NO_ERROR_MESSAGES
 #define AE_INFO                         _acpi_module_name, __LINE__
+#define ACPI_ONCE(_fn, _plist)                  { static char _done; if (!_done) { _done = 1; _fn _plist; } }
 
 /*
  * Error reporting. Callers module and line number are inserted by AE_INFO,
@@ -201,8 +202,10 @@
  */
 #define ACPI_INFO(plist)                acpi_info plist
 #define ACPI_WARNING(plist)             acpi_warning plist
+#define ACPI_WARNING_ONCE(plist)        ACPI_ONCE(acpi_warning, plist)
 #define ACPI_EXCEPTION(plist)           acpi_exception plist
 #define ACPI_ERROR(plist)               acpi_error plist
+#define ACPI_ERROR_ONCE(plist)          ACPI_ONCE(acpi_error, plist)
 #define ACPI_BIOS_WARNING(plist)        acpi_bios_warning plist
 #define ACPI_BIOS_EXCEPTION(plist)      acpi_bios_exception plist
 #define ACPI_BIOS_ERROR(plist)          acpi_bios_error plist
@@ -214,8 +217,10 @@
 
 #define ACPI_INFO(plist)
 #define ACPI_WARNING(plist)
+#define ACPI_WARNING_ONCE(plist)
 #define ACPI_EXCEPTION(plist)
 #define ACPI_ERROR(plist)
+#define ACPI_ERROR_ONCE(plist)
 #define ACPI_BIOS_WARNING(plist)
 #define ACPI_BIOS_EXCEPTION(plist)
 #define ACPI_BIOS_ERROR(plist)
-- 
2.43.0



