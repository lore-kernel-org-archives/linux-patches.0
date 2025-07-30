Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC742698BF;
	Wed, 30 Jul 2025 09:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868546; cv=none; b=ZzKd+L7xfoWvwlxrlccQnnBeZVAt8dOKbsMMXqIFu4SY5ucrWaMwsdKxK4JxRiE844n9mwlrfVsv47VxczB6Hk9juJFy6V/dkkkjR41g7TVPLLH+DP5HdD3RfldGuDAyB9NFQfT8hxuwczUrycV4VqGBJ7r54dG/LT2exp8kJWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868546; c=relaxed/simple;
	bh=7ouzbVPE7BAn1KyA59414EMwrHeII6dEqUFXG7oOYGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y8IGLaXolQFurcW1Jm1i80S1vE2m8HWdhipVjFWrBwXiCPvsMGgqOpD5hd0X8BDMwl++rW6eBPoPvolgacb0ZXmCEt63iUedSkcILzNZ6/skuJw6kobe2eFkey7a7CMjm9/K8qppOG+SpqjgHJ3RlcFn2g0qs6zfRV7bd6FS1K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=togJ5qZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="togJ5qZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0DAC4CEF5;
	Wed, 30 Jul 2025 09:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868546;
	bh=7ouzbVPE7BAn1KyA59414EMwrHeII6dEqUFXG7oOYGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=togJ5qZFgX3E0mySH+03kL0Rlqpx40mPbucw3St+1TQuEAoEJngVZr7G4KWS6cHEU
	 0iq1kFmjC2IPkXvPFrtzYSTsvY3u+QtbN59pl5z013MtnFeK0sVHjHhyfHElN43al+
	 hJAX+WSTYZwG9WdOROF+8St/fTBM+iIJRCoyipAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Torsten Hilbrich <torsten.hilbrich@secunet.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/117] platform/x86: Fix initialization order for firmware_attributes_class
Date: Wed, 30 Jul 2025 11:34:45 +0200
Message-ID: <20250730093234.212863712@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Torsten Hilbrich <torsten.hilbrich@secunet.com>

[ Upstream commit 2bfe3ae1aa45f8b61cb0dc462114fd0c9636ad32 ]

The think-lmi driver uses the firwmare_attributes_class. But this class
is registered after think-lmi, causing the "think-lmi" directory in
"/sys/class/firmware-attributes" to be missing when the driver is
compiled as builtin.

Fixes: 55922403807a ("platform/x86: think-lmi: Directly use firmware_attributes_class")
Signed-off-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Link: https://lore.kernel.org/r/7dce5f7f-c348-4350-ac53-d14a8e1e8034@secunet.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index e1b1429470674..4631c7bb22cd0 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -58,6 +58,8 @@ obj-$(CONFIG_X86_PLATFORM_DRIVERS_HP)	+= hp/
 # Hewlett Packard Enterprise
 obj-$(CONFIG_UV_SYSFS)       += uv_sysfs.o
 
+obj-$(CONFIG_FW_ATTR_CLASS)	+= firmware_attributes_class.o
+
 # IBM Thinkpad and Lenovo
 obj-$(CONFIG_IBM_RTL)		+= ibm_rtl.o
 obj-$(CONFIG_IDEAPAD_LAPTOP)	+= ideapad-laptop.o
@@ -120,7 +122,6 @@ obj-$(CONFIG_SYSTEM76_ACPI)	+= system76_acpi.o
 obj-$(CONFIG_TOPSTAR_LAPTOP)	+= topstar-laptop.o
 
 # Platform drivers
-obj-$(CONFIG_FW_ATTR_CLASS)		+= firmware_attributes_class.o
 obj-$(CONFIG_SERIAL_MULTI_INSTANTIATE)	+= serial-multi-instantiate.o
 obj-$(CONFIG_MLX_PLATFORM)		+= mlx-platform.o
 obj-$(CONFIG_TOUCHSCREEN_DMI)		+= touchscreen_dmi.o
-- 
2.39.5



