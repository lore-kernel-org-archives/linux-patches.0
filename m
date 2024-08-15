Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC9519E811;
	Thu, 15 Aug 2024 13:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728480; cv=none; b=ZdPdD87HPfD48qzvQ2/aup7LTy/eMjeIMTZwZUS/IyLwr5mVF8nmRf5ocXC1o/Nqv9dIt4KFuE7lQLK6xNdwVATYut29JgsPKPc0HjHng+/dQUboT4wHYSK0TnT+uTsEvLspfSWcY2sosMaHPntxGul6mDl+CCSRDirmonKl0Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728480; c=relaxed/simple;
	bh=xnrQBacFWT24vj8rhJEaa3YTgivdMGDlAJkFF66r4T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ejrD1faEnW7ZIfVS+zYSGOlZGcYl9UR8VOp+lzRcPVft/HoOubPtLmj4XKb9BCtIXFmRh6eAfNO/LG02USJSFr8FSro+QP3a0mNRBSVZ0EfzPsIvFd/cJQXFP5Z1qYEFhS8x7gX1t0fjsfMrSmwfPsSlF+AwnGQQj/JAGdDJV9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgp045s9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgp045s9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD146C32786;
	Thu, 15 Aug 2024 13:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728480;
	bh=xnrQBacFWT24vj8rhJEaa3YTgivdMGDlAJkFF66r4T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zgp045s9H9XwyuK0Eik8CjlVCKhpwKevsj9vXx68SyLlINFhIs5PCcfjiwNrbOu9Q
	 Ku7sshYs+2Iu+tPPp5xB21d4gIq5oTP5CFJ7S+CwPQx7QeZmuCsHmWiQYV3rYxvB+c
	 iXpD48npUZqp3UsohE70vEzoSl6GoCF1dj26BxW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 006/196] x86/platform/iosf_mbi: Convert PCIBIOS_* return codes to errnos
Date: Thu, 15 Aug 2024 15:22:03 +0200
Message-ID: <20240815131852.317159644@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 6f37a2137a795..dfeedbd6467fc 100644
--- a/arch/x86/platform/intel/iosf_mbi.c
+++ b/arch/x86/platform/intel/iosf_mbi.c
@@ -68,7 +68,7 @@ static int iosf_mbi_pci_read_mdr(u32 mcrx, u32 mcr, u32 *mdr)
 
 fail_read:
 	dev_err(&mbi_pdev->dev, "PCI config access failed with %d\n", result);
-	return result;
+	return pcibios_err_to_errno(result);
 }
 
 static int iosf_mbi_pci_write_mdr(u32 mcrx, u32 mcr, u32 mdr)
@@ -97,7 +97,7 @@ static int iosf_mbi_pci_write_mdr(u32 mcrx, u32 mcr, u32 mdr)
 
 fail_write:
 	dev_err(&mbi_pdev->dev, "PCI config access failed with %d\n", result);
-	return result;
+	return pcibios_err_to_errno(result);
 }
 
 int iosf_mbi_read(u8 port, u8 opcode, u32 offset, u32 *mdr)
-- 
2.43.0



