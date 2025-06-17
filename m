Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E204C2EA143;
	Tue, 17 Jun 2025 16:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176094; cv=none; b=huWThAhyvveNWVMgH8I106EVXkVBOnhfhVEovU5WsJipRHZAbv9IWpayhlTALkPRjZaTl1WrsjSZ3ixIlsXuZlxHxYtXCqybO4sBY6RlILo59xzVU/18LNv8cA1ECFoLCKib7a/AI70ALwwxOTtxDv3qlooZhwB+74ssLWYZcww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176094; c=relaxed/simple;
	bh=Wx61f8/kLPr2il8I8T6f+koVqwnYtuGBbUg/a+UCXjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmsMwlV96RO46+jjJ/+DS28UBET4Bbsk17nndElwbGp5UeCa7rX8Y1nzCEDLuGzHCVwNIF/QkPRJbh2AzmKIybU4hGKrVlIeAJlmkGDOiS6Dxkoe4WwwYmSSjbOSKHtjSKVpQOoykus2m10EdQE6IuSis77++mODNpQLol38SAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLM5eP0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLM5eP0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526FCC4CEE3;
	Tue, 17 Jun 2025 16:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176093;
	bh=Wx61f8/kLPr2il8I8T6f+koVqwnYtuGBbUg/a+UCXjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLM5eP0DG0k43cPBjtk+gBpEv7/ZRw23OReABq3WDtCXEXI1/LJtXux23E2zvhWeJ
	 xj0HVUjceyX29wF44UcJMKVdG84wQdaoUPaews13xf6NpK0hdcb4h2UKxiL7quh2Kv
	 hC2fSPOHaPDPLjySnalt20nWrXCsLmdDsk75NOzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zepta <z3ptaa@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 195/512] Bluetooth: btintel: Check dsbr size from EFI variable
Date: Tue, 17 Jun 2025 17:22:41 +0200
Message-ID: <20250617152427.539914737@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 3aa1dc3c9060e335e82e9c182bf3d1db29220b1b ]

Since the size of struct btintel_dsbr is already known, we can just
start there instead of querying the EFI variable size. If the final
result doesn't match what we expect also fail. This fixes a stack buffer
overflow when the EFI variable is larger than struct btintel_dsbr.

Reported-by: zepta <z3ptaa@gmail.com>
Closes: https://lore.kernel.org/all/CAPBS6KoaWV9=dtjTESZiU6KK__OZX0KpDk-=JEH8jCHFLUYv3Q@mail.gmail.com
Fixes: eb9e749c0182 ("Bluetooth: btintel: Allow configuring drive strength of BRI")
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 645047fb92fd2..51d6d91ed4041 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2705,7 +2705,7 @@ static int btintel_uefi_get_dsbr(u32 *dsbr_var)
 	} __packed data;
 
 	efi_status_t status;
-	unsigned long data_size = 0;
+	unsigned long data_size = sizeof(data);
 	efi_guid_t guid = EFI_GUID(0xe65d8884, 0xd4af, 0x4b20, 0x8d, 0x03,
 				   0x77, 0x2e, 0xcc, 0x3d, 0xa5, 0x31);
 
@@ -2715,16 +2715,10 @@ static int btintel_uefi_get_dsbr(u32 *dsbr_var)
 	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
 		return -EOPNOTSUPP;
 
-	status = efi.get_variable(BTINTEL_EFI_DSBR, &guid, NULL, &data_size,
-				  NULL);
-
-	if (status != EFI_BUFFER_TOO_SMALL || !data_size)
-		return -EIO;
-
 	status = efi.get_variable(BTINTEL_EFI_DSBR, &guid, NULL, &data_size,
 				  &data);
 
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS || data_size != sizeof(data))
 		return -ENXIO;
 
 	*dsbr_var = data.dsbr;
-- 
2.39.5



