Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E750F4D7950;
	Fri,  9 Oct 2026 14:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555402; cv=none; b=tzeaRSM6dnMwqjR+ltqTfbgod9uHuxr0X6gRdmpoij6a8mD3+o/um5Pk4PsmdBDOTzAvoZ0CV+tXepmRnW1gJi5va6tfkvzJTAsO947zS9yxmps58UxpmNoAlPB5GCX0guP1DU8M2Ewr31WhqGuXego9MfULR2r4rcKX8e8/dRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555402; c=relaxed/simple;
	bh=gme7OEIPdR8hOy6EyZGs7UGWMnCfKqrFIO9uticHDos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvtV+3w+UY2djpaqBlkpfFF+USpggImJ/azwRq5Lk0KQcL70atnVmzhuWg2QUGVFh/BkHwf4Vme33o0uuu+vptZurbQSBmOwVatqOvcIYfrMTEWEyxYzQMYcxWs+FqpVFHILYQQsvlLCHfGgI+gNZIudo7iC04OLh0e2c9wBJoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGALkFqb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGALkFqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4571F000FF;
	Fri,  9 Oct 2026 14:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555395;
	bh=5H/ISLgI5q11hZeWHBd0rH8JSHr1GxjFlcO/dVpYt6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GGALkFqbuuc6QYsmTdgSFRVa6hTp4tCYg5hXB6CWhYrj8YDixU21fEQNGfjpJhFF/
	 zamVENHxbKysW9VZowOK9x3taDLj4lFdIA31IjtLevpmNvY/7kgF3HFzfOMrrMPE0C
	 PUEHXH1zB/Qr/3hZ2z8O2HlwWVfx6J9z4zJma+JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 6.18 043/403] virt: vmgenid: remap memory as decrypted
Date: Fri,  9 Oct 2026 16:06:44 +0200
Message-ID: <20261009140953.112946920@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 1b48c13075829ee4961feeabd816dac1c9111959 upstream.

It was found that AWS SEV-SNP enabled instances are not able to boot with
commit 81256a50aa0f ("x86/mm: Make memremap(MEMREMAP_WB) map memory as
encrypted by default") applied and the reason seems to be the vmgenid
device which requires unencrypted writeable memory.

A similar problem was previously fixed in DRM with commit
7dfede7d7edd ("drm/vmwgfx: Fix guests running with TDX/SEV").

Note, trusting vmgenid device in a Confidential VM is questionable: the
malicious host may intentionally avoid notifying the guest when a copy is
created.

Fixes: 81256a50aa0f ("x86/mm: Make memremap(MEMREMAP_WB) map memory as encrypted by default")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: stable@vger.kernel.org # 6.15+
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/vmgenid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/virt/vmgenid.c
+++ b/drivers/virt/vmgenid.c
@@ -75,7 +75,8 @@ static int vmgenid_add_acpi(struct devic
 	phys_addr = (obj->package.elements[0].integer.value << 0) |
 		    (obj->package.elements[1].integer.value << 32);
 
-	virt_addr = devm_memremap(&device->dev, phys_addr, VMGENID_SIZE, MEMREMAP_WB);
+	virt_addr = devm_memremap(&device->dev, phys_addr, VMGENID_SIZE,
+				  MEMREMAP_WB | MEMREMAP_DEC);
 	if (IS_ERR(virt_addr)) {
 		ret = PTR_ERR(virt_addr);
 		goto out;


