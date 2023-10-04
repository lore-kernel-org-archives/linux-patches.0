Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63C020B05
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxtYh9FK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8E5C433C9;
	Wed,  4 Oct 2023 18:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444326;
	bh=AE2jKM4YfL0eyMJKQd1xX7Z1zL5eIgLpYUr9RtNMFi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxtYh9FKKOHjgEqUhJ1ggUHK/+CILjEkFcnorbrDWCIIhkPmyW66dyAZ71WOIdfeG
	 nkjzJ28ei1ZyilXBQhK1HcGATmsfAr/gnpm4+7Dnfk3NL0EOA4XpCsEgVrCgOWbVew
	 5zB8A3ZrIEslG8I9q7PiEz108FTKRsKazVsV/yD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 182/321] efi/x86: Ensure that EFI_RUNTIME_MAP is enabled for kexec
Date: Wed,  4 Oct 2023 19:55:27 +0200
Message-ID: <20231004175237.664378430@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit aba7e066c738d4b349413a271b2a236aa55bacbc ]

CONFIG_EFI_RUNTIME_MAP needs to be enabled in order for kexec to be able
to provide the required information about the EFI runtime mappings to
the incoming kernel, regardless of whether kexec_load() or
kexec_file_load() is being used. Without this information, kexec boot in
EFI mode is not possible.

The CONFIG_EFI_RUNTIME_MAP option is currently directly configurable if
CONFIG_EXPERT is enabled, so that it can be turned on for debugging
purposes even if KEXEC is not enabled. However, the upshot of this is
that it can also be disabled even when it shouldn't.

So tweak the Kconfig declarations to avoid this situation.

Reported-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e36261b4ea14f..68ce4f786dcd1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1955,6 +1955,7 @@ config EFI
 	select UCS2_STRING
 	select EFI_RUNTIME_WRAPPERS
 	select ARCH_USE_MEMREMAP_PROT
+	select EFI_RUNTIME_MAP if KEXEC_CORE
 	help
 	  This enables the kernel to use EFI runtime services that are
 	  available (such as the EFI variable services).
@@ -2030,7 +2031,6 @@ config EFI_MAX_FAKE_MEM
 config EFI_RUNTIME_MAP
 	bool "Export EFI runtime maps to sysfs" if EXPERT
 	depends on EFI
-	default KEXEC_CORE
 	help
 	  Export EFI runtime memory regions to /sys/firmware/efi/runtime-map.
 	  That memory map is required by the 2nd kernel to set up EFI virtual
-- 
2.40.1



