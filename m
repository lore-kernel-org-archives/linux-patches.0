Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BA41C28E;
	Tue, 11 Nov 2025 01:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822841; cv=none; b=kAAAm2m1r9FBH61ysV2k4xJqU4tYqxhq4jHpWIbXbSVRjCYS65zazhmvJOeYCJ3v5Z516eLIJFMlUkitTueEWiuJaQFP+c/mZ1TMNlTTj1UcuXnVasj0m4u8BWs8kuuDsXntBgxQIjqhGiMZPun6le2lviM71fg7R3ddtRv2AVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822841; c=relaxed/simple;
	bh=sIBOoXVEl1GqHpIr2N7cGdkTZ1ztsmNlS15MiqLc5Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i593Wr1e9GiZrEocVWPs0/Bf5F7L7x7HGjqgmQQUrSM6FUzbu+epXDSWiDcOTlBvBmx065UNCEJ2FGA0syZj5PCISnuVSiwgLK/Hc5Sb2HT6XpLfAQBExkdXJJWGnRIO5vhvKE8O3TWeINE08flmWRGZ11YZDa/F68cNKNdTuT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKTWpnwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKTWpnwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C786CC4CEFB;
	Tue, 11 Nov 2025 01:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822841;
	bh=sIBOoXVEl1GqHpIr2N7cGdkTZ1ztsmNlS15MiqLc5Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKTWpnwvjfJ2KmtB81CCQ4Wj4v7Zp+i61MfbcpWzST553fJFkcpmuub8AACqjYhiD
	 LRaQwpS/UBUmBFY+XSenLY+ErtFy51Lak/x7b1OfDBZXj4xgwWYIr7swJu7GR9t0DY
	 3o4yGgoyiaHlRbXD9Yw0wcxe73XQ75T2WzYnWhXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 181/849] kunit: Enable PCI on UML without triggering WARN()
Date: Tue, 11 Nov 2025 09:35:51 +0900
Message-ID: <20251111004540.806788014@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 031cdd3bc3f369553933c1b0f4cb18000162c8ff ]

Various KUnit tests require PCI infrastructure to work. All normal
platforms enable PCI by default, but UML does not. Enabling PCI from
.kunitconfig files is problematic as it would not be portable. So in
commit 6fc3a8636a7b ("kunit: tool: Enable virtio/PCI by default on UML")
PCI was enabled by way of CONFIG_UML_PCI_OVER_VIRTIO=y. However
CONFIG_UML_PCI_OVER_VIRTIO requires additional configuration of
CONFIG_UML_PCI_OVER_VIRTIO_DEVICE_ID or will otherwise trigger a WARN() in
virtio_pcidev_init(). However there is no one correct value for
UML_PCI_OVER_VIRTIO_DEVICE_ID which could be used by default.

This warning is confusing when debugging test failures.

On the other hand, the functionality of CONFIG_UML_PCI_OVER_VIRTIO is not
used at all, given that it is completely non-functional as indicated by
the WARN() in question. Instead it is only used as a way to enable
CONFIG_UML_PCI which itself is not directly configurable.

Instead of going through CONFIG_UML_PCI_OVER_VIRTIO, introduce a custom
configuration option which enables CONFIG_UML_PCI without triggering
warnings or building dead code.

Link: https://lore.kernel.org/r/20250908-kunit-uml-pci-v2-1-d8eba5f73c9d@linutronix.de
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/Kconfig                           | 7 +++++++
 tools/testing/kunit/configs/arch_uml.config | 5 ++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/lib/kunit/Kconfig b/lib/kunit/Kconfig
index c10ede4b1d220..1823539e96da3 100644
--- a/lib/kunit/Kconfig
+++ b/lib/kunit/Kconfig
@@ -106,4 +106,11 @@ config KUNIT_DEFAULT_TIMEOUT
 	  If unsure, the default timeout of 300 seconds is suitable for most
 	  cases.
 
+config KUNIT_UML_PCI
+	bool "KUnit UML PCI Support"
+	depends on UML
+	select UML_PCI
+	help
+	  Enables the PCI subsystem on UML for use by KUnit tests.
+
 endif # KUNIT
diff --git a/tools/testing/kunit/configs/arch_uml.config b/tools/testing/kunit/configs/arch_uml.config
index 54ad8972681a2..28edf816aa70e 100644
--- a/tools/testing/kunit/configs/arch_uml.config
+++ b/tools/testing/kunit/configs/arch_uml.config
@@ -1,8 +1,7 @@
 # Config options which are added to UML builds by default
 
-# Enable virtio/pci, as a lot of tests require it.
-CONFIG_VIRTIO_UML=y
-CONFIG_UML_PCI_OVER_VIRTIO=y
+# Enable pci, as a lot of tests require it.
+CONFIG_KUNIT_UML_PCI=y
 
 # Enable FORTIFY_SOURCE for wider checking.
 CONFIG_FORTIFY_SOURCE=y
-- 
2.51.0



