Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7D71B583F;
	Tue, 30 Jul 2024 15:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355021; cv=none; b=JAXyTXpUhkfDvVD9aoawHRZOqwHmyNmxZI86EPt98jISx2hqTFhxAxY2TCVbe2B1ZbTpMKgPpgIrvZHkmnIupM4jIMkUnoDe3d8WbV3+rZDbhUM8ldZZo3+gxCZPv00zI3ItfoAKspdS2Z98ytupFeZVDXeZdSXyrQNat6nGCKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355021; c=relaxed/simple;
	bh=BDavEZB4cStQ4enV+qfFB9AsLcbYKVzzXaY0SzjPT0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n1v/WTFrkuMFTsZiHNi8uWW+w+V7+V0qdLr1QpTTP+UaPfauC549UMt1Ne6+EW30eq0RlnJHFp7bskffhAHba5lD0fEu1YkDlUCgoaTdoF3ovVbrNoc6ZMdOCV3LdwZF44UeBSQG2NmdDOXy8oO4m6gELsQLoOyGJqcO5pxfKR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxrhgTEP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxrhgTEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D092C32782;
	Tue, 30 Jul 2024 15:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355020;
	bh=BDavEZB4cStQ4enV+qfFB9AsLcbYKVzzXaY0SzjPT0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxrhgTEP3PJ07wUXc7RhFmgZ3tAbNHhIM1V2KuQl5KwIYrwc1lxnP/8SiU/a7Ydow
	 HFFehqX6j2k7GJhGRxFsezo0IGDhho9huixa8rJ85Bjh1ns2tonmdn5UOMSAF0mF3i
	 KA+farE3ji8nF7YGFbktCA9VG/26pjcbxMSjYoZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/440] x86/platform/iosf_mbi: Convert PCIBIOS_* return codes to errnos
Date: Tue, 30 Jul 2024 17:44:09 +0200
Message-ID: <20240730151616.396698084@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 7821fa101eab529521aa4b724bf708149d70820c ]

iosf_mbi_pci_{read,write}_mdr() use pci_{read,write}_config_dword()
that return PCIBIOS_* codes but functions also return -ENODEV which are
not compatible error codes. As neither of the functions are related to
PCI read/write functions, they should return normal errnos.

Convert PCIBIOS_* returns code using pcibios_err_to_errno() into normal
errno before returning it.

Fixes: 46184415368a ("arch: x86: New MailBox support driver for Intel SOC's")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240527125538.13620-4-ilpo.jarvinen@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/platform/intel/iosf_mbi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/intel/iosf_mbi.c b/arch/x86/platform/intel/iosf_mbi.c
index fdd49d70b4373..c81cea208c2c4 100644
--- a/arch/x86/platform/intel/iosf_mbi.c
+++ b/arch/x86/platform/intel/iosf_mbi.c
@@ -62,7 +62,7 @@ static int iosf_mbi_pci_read_mdr(u32 mcrx, u32 mcr, u32 *mdr)
 
 fail_read:
 	dev_err(&mbi_pdev->dev, "PCI config access failed with %d\n", result);
-	return result;
+	return pcibios_err_to_errno(result);
 }
 
 static int iosf_mbi_pci_write_mdr(u32 mcrx, u32 mcr, u32 mdr)
@@ -91,7 +91,7 @@ static int iosf_mbi_pci_write_mdr(u32 mcrx, u32 mcr, u32 mdr)
 
 fail_write:
 	dev_err(&mbi_pdev->dev, "PCI config access failed with %d\n", result);
-	return result;
+	return pcibios_err_to_errno(result);
 }
 
 int iosf_mbi_read(u8 port, u8 opcode, u32 offset, u32 *mdr)
-- 
2.43.0



