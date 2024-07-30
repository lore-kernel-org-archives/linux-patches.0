Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEE11BA885;
	Tue, 30 Jul 2024 15:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355121; cv=none; b=azzMExgOTHajXGan9Tyy6P5Hv36PRfnd305yWXWaqk2WbKvCCMMt4UkihRS1E8l/+ROXjCw9mfqCQEEU1dJkv8oCv0sYSBPYDxnsRDG3Rq83VmPHkvWnZVQd/Xl7CnGlOwvVdPNH4nOvWF6VZKb+kGXdTmbzn98SI/DxQR25f+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355121; c=relaxed/simple;
	bh=GzS+jdv1M180B2Qj+UeyHyNQ0S1EeacX1gsBHTKAWoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uGi1JSSP6rPBaR5FBd3tqFzJM8yvtrKuHzIscHaavaUCanZfWACQEQDZAxVqpcYv56jCEeW4/FZshW+Ns+sPuRIjmsKlpiCDQncjJsVMP+DqSo4A4seKPC7w2YRwMjn3A0FOjoZ3bnFEzktI2U6CKchz9Kv1S75aFCp2cagwsUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNN61/GQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNN61/GQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E400C4AF0A;
	Tue, 30 Jul 2024 15:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355120;
	bh=GzS+jdv1M180B2Qj+UeyHyNQ0S1EeacX1gsBHTKAWoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNN61/GQZB2qHc/50kumZ+fr+R1Ovro59eERyJlaWzeco2Ldc3xG4TRWc0w4FNTqt
	 ylDYqtlOlzDppJtIBDnwUE1htCWx4acWZkCFbSIoTwOunEwxLSzR+Cb7TTCMVTgjb6
	 PGW/pLaa3/aSTdLf+OxPwG0gfBji9jK/ey326H8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 021/809] x86/platform/iosf_mbi: Convert PCIBIOS_* return codes to errnos
Date: Tue, 30 Jul 2024 17:38:17 +0200
Message-ID: <20240730151725.496206914@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



