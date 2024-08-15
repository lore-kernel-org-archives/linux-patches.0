Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFBC1AC8BB;
	Thu, 15 Aug 2024 14:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731913; cv=none; b=LH40+gLBXJDXHvm1fa9BAA1jFOS8MftfnoM+3Y7CgCBzz16Y4fjnHJsVCI4I9T+nY5GVjR+pkV+ZNI2hGZE0m+arnNCtMH5kMhdlZP6QzlEisC832lJy7UMP3rt5TFOx5/3NHPaooCim+SEnlCtGRBQXu82Pt/O0b6cdpELMvL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731913; c=relaxed/simple;
	bh=7QJfsdG+kT9bR3oRWriUGpZsE5QBoDa+JT5y7Pp049s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OrpsD2eILtLtSjDB2qgcw71KpmGgvfo9UlgnQowN2KZY2hvZWrxIRQDkzMSPhMZUFBMzZ/NNTHfLnabiMBM0KCneSI0L5iMY2vIhQBTqk4QrWjj/Hi8riSrCLpoJttYSEFvzW7UHzhgFYDKK175y2z1NhXWA/vNhn6xHGNRBvxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OzSKVjQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OzSKVjQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA552C32786;
	Thu, 15 Aug 2024 14:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731913;
	bh=7QJfsdG+kT9bR3oRWriUGpZsE5QBoDa+JT5y7Pp049s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OzSKVjQF+U2zVCH3qf1iaG10oAfVQHztnvu9hpJUgCg3xQ1T0Q3+WPx4Lr7sAKKsC
	 R4a0ieaKG8Xh5d7Sxj+6v0rNzyW+wW3YROnxCHxraS+hKAFFPMD0tDdwfWGde/6mj6
	 ylniWdge51PKAd0R04plAEUheamO0RXQP1kJMVU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/352] x86/platform/iosf_mbi: Convert PCIBIOS_* return codes to errnos
Date: Thu, 15 Aug 2024 15:21:14 +0200
Message-ID: <20240815131919.531717943@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 526f70f27c1c3..70a1c3877f8e3 100644
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



