Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063146;
	b=fxfwXKMC5RPlFUR8RuYMwcOX916FX1Kig97SjhNmj8S3kWco0glrA9zBlu3QbhPgFXqH
	 +e9uwHxSPuSxm2faM7H7RpKNeQeApXHogo7KM3RnQD1gFpJr3zDLj7KiQla68tgAyPDPN
	 fEuzjqofYROSX3pgm/y7OT/EP+cHtxueQCxrzuljOCOENU3aiEpRq0KCW6pe8dd/TZCVU
	 rt4m1mSNxN79LDsL2wcvzHidJIQDFBHpxuRd5cFlNjXGZSWdCvu0v/zwSwTtFz+8USyYm
	 vnEX2OcCwbl7TrdoyQF94X18papvrCmNClJlQVc+i6Lzu6Bfk9OO4cvqWONsjtOBjRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mKZcb6DPye34YSvg5TvipxijqM9wbxk1LTNC43HeVyw=;
	b=ftEiykJaHtY1x0Uukwdpw3ZioZIMKwLA0F/aYOv1t2KjLf5zJ8tgpzLaaXLFip0K6tO+
	 rjXpUGsXOiIr3GyXB8pjpnHBk1U3JMDysGSL/17IlLXMlRKOa47d2225GgjKX+owPNYhw
	 RY4X6/Iby+O/LultquSE2EyqTTfrzZc/rvNpLO9l0Sc6cD8Sc6m0S+BXgFKrxqAUVbDsZ
	 8IhAJuk4mHHDHSP9BBLJvnveY3L70+CUbPNrpuJx9BkeEfzrELIvPbTF3FefoqKu6Tu7G
	 e4drfyL8ZtYBLJP1YlIu36oWPmZpbtt2mi+VLdj5UbWEDFawC5/rZBRhx8aBT3hRyzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qd0Z8QjY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B76606A33E;
	Sat,  7 Nov 2026 14:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qd0Z8QjY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0921F0089F;
	Sat,  7 Nov 2026 14:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063146;
	bh=mKZcb6DPye34YSvg5TvipxijqM9wbxk1LTNC43HeVyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qd0Z8QjYlsIGv/rz+ueLcsvFmwnHzOWp7KlN9uKUjCYC7WPmzwR28i5buruBN8S9L
	 BSGiEMdsGOMK2DRtDvTF3S1odlZXMp/DM4ERqwx7FqDd3oC1/UgxTi42Edp3/JI0Pc
	 +wrhtNQsWJWdRZWPoxRHsv8NsCPwYtd/rRMMFkDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priyank Rathod <rathodpriyank@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 372/869] PCI/AER: Fix memory leak in aer_recover_queue() on kfifo buffer overflow
Date: Sat,  7 Nov 2026 08:50:54 -0500
Message-ID: <20261107134905.440529791@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Priyank Rathod <rathodpriyank@google.com>

[ Upstream commit 07938f8a3cbf3e9cc27553b8982e2d56c15b354a ]

When ACPI APEI/GHES processes PCIe AER error records, it allocates memory
for aer_capability_regs (aer_regs) from ghes_estatus_pool and passes it to
aer_recover_queue() to be enqueued into aer_recover_ring.

If kfifo_in_spinlocked() fails due to a buffer overflow,
aer_recover_queue() logged an error message but returned without freeing
aer_regs. Because the entry was rejected and never inserted into the queue,
aer_recover_work_func() could never dequeue or free it, leaking the
allocated ghes_estatus_pool memory.

aer_recover_queue() returns void, so the caller ghes_handle_aer() cannot
free the buffer itself: ownership is transferred to the AER code, which
until now only released it on the success path.

Free aer_regs via ghes_estatus_pool_region_free() when
kfifo_in_spinlocked() fails on buffer overflow.

Fixes: e2abc47a5a1a ("ACPI: APEI: Fix AER info corruption when error status data has multiple sections")
Signed-off-by: Priyank Rathod <rathodpriyank@google.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260928-b4-fix-aer-memleaks-v5-1-ba6b94c9c9a6@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 9f90abe3e88ed..ad3fea4b56f88 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -1379,11 +1379,14 @@ void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
 	};
 
 	if (kfifo_in_spinlocked(&aer_recover_ring, &entry, 1,
-				 &aer_recover_ring_lock))
+				 &aer_recover_ring_lock)) {
 		schedule_work(&aer_recover_work);
-	else
+	} else {
 		pr_err("buffer overflow in recovery for %04x:%02x:%02x.%x\n",
 		       domain, bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
+		ghes_estatus_pool_region_free((unsigned long)aer_regs,
+					      sizeof(struct aer_capability_regs));
+	}
 }
 EXPORT_SYMBOL_GPL(aer_recover_queue);
 #endif
-- 
2.53.0



