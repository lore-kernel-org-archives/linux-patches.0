Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B7929A2;
	Tue, 30 Jul 2024 15:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354960; cv=none; b=UmHvr9XMGNeG7FZhkY5YeXQYxp+scJH5R5gymg/Ni8ey0k0rAJ5OFbiLav140LMMhp29jQqwBUtjPhxow+P7aviDgck60Y6L/fRc3HgXNu9tTqkeLHZbTiWchAn5gWrdNyeDTeZb7kaWwlIseMb0DI0iKqSfhUAMu3mrRaC9r10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354960; c=relaxed/simple;
	bh=zpIHUimZJviQMd/kgQl0jDE3gxhmpdNMPSkaC41o9J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IytRnW3Kmq/oy+znxcaTXtd5mh774cUHI+qrcN08ELuimcr8hXH+D5o7y8B5ecLHa+CKd86M28oikixHuFKdL8WmEdNr8zqCKcNnK576T1ARSi6NBMxolFqGYJZMtQ+r6vWXvC8Cut5UtrJiiRSQl3G65N8+u3tdSeFaur0vmwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpMPbIZ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpMPbIZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875DAC32782;
	Tue, 30 Jul 2024 15:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354960;
	bh=zpIHUimZJviQMd/kgQl0jDE3gxhmpdNMPSkaC41o9J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpMPbIZ7sq0xq1nOKRYsxtELYpRmQNmhkojs0eSxdmLDwAv6uigRc1OxovR3riCBz
	 A/P1K1kffuWWgnmnFxAbwgSm2G9QF1gVJa8mbHjZRu42JoQGKREugP8HV27vcPe3Wb
	 bvC/DOW9hg67y+irFIwqNEZlGFyR5OmMZJQiUFm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/568] x86/platform/iosf_mbi: Convert PCIBIOS_* return codes to errnos
Date: Tue, 30 Jul 2024 17:42:02 +0200
Message-ID: <20240730151640.425283119@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



