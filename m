Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A967F26A0B3;
	Tue, 26 Aug 2025 12:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212862; cv=none; b=ZCs4ksdbmI/0cToM/Ep0JyesH/sQ9prFuWZLl/Z2vkFN4Sg6gI0jubbdYvhg9m30PFdE6G8EwGMQ+j/MDlZxz5rNzF52xEr5TKTgxjNit3/FpML+5JWofObMwUVmpd94olyafXIEUDfHyK6SqgFMqoEewFqijOaMYPzRQiL6A1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212862; c=relaxed/simple;
	bh=Y/ClSAQUEPx8RID2UixLDVdXbw0moBr5GVmmZIqSsZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BDm5XjyMWPao7JAq+L0c9ffoNLqrHcRkbwtyYx/A7L9S9MVKvxkF1Z2NSsI+xBNWUjBJlp/uOG272K1ITEcUmg6s9klWdm/W0j/aCDdJclcR0dtAv+qrUWVKEDL9N2LQkEQ1JHQ+dZQ8Yu3DMPO1BaAm9FcYw1Vc4jddfTpSZ1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrfV0/EF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrfV0/EF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C136C4CEF1;
	Tue, 26 Aug 2025 12:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212862;
	bh=Y/ClSAQUEPx8RID2UixLDVdXbw0moBr5GVmmZIqSsZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DrfV0/EFUQeEYOlxEzxIYaj6umJHlQKBY87x/qQVi7wi71oLWNsyNHd77yUOQeFmS
	 CPgduSqmL7PLVE1kd2MJfbtOlS8qS3R3sbC8irzZCW6WUhYEhhWIvGV3vgQr7QEmVT
	 JLcTKf2t45c1YrHu4E16tnxdPinDBn+0TPr1RuIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/587] platform/x86: thinkpad_acpi: Handle KCOV __init vs inline mismatches
Date: Tue, 26 Aug 2025 13:04:40 +0200
Message-ID: <20250826110956.287761092@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8de0d3232e48..88364a5502e6 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -537,12 +537,12 @@ static unsigned long __init tpacpi_check_quirks(
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



