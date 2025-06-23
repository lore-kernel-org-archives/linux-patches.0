Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAC1222576;
	Mon, 23 Jun 2025 22:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716446; cv=none; b=WHbh3dKr9lPM4nHXLyQ5Rx92TPlT4P3nm0oOUgF8ZRYMrnvGGqPmj0mHaN3FcmekUVrVpWoA97H5qaI3aL6vXJguEeOXxpRbN++/YhtPw5ZdvjE2qOHylH9Y2ttcTb5Qksoz11XUTU3pKe8U/NV2AyUDTqrC2z21VZzmYmGSZFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716446; c=relaxed/simple;
	bh=uTF4iwJkVLnP5uv2TGQBGH7UI5gIk5+WoqEQxqD0Reg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLkgK25gcCuJKHwpomSh/qIuyfteOoQ6M1xhHCUgx2n9sAsSFg3lXdVneslaQgkh9XCPRt0vuLCCAO0zZwGfKrWDRRkZHDLhe9UkIugQ02BkU0pbl+dQooX81DHQJMTJx7RUPrLS+a7PIlJPnhGY0OBya1Y8u743r2l/txh7ETY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H79UsE8r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H79UsE8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325CBC4CEEA;
	Mon, 23 Jun 2025 22:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716446;
	bh=uTF4iwJkVLnP5uv2TGQBGH7UI5gIk5+WoqEQxqD0Reg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H79UsE8rC7Vets/VjFvftI2agsQ06Y92bsWavfXxZsiFkwtug4itN3q8MkxQmAntV
	 u54qo+SXq3800McCDKH7KNTZIfeEmrNd9eWR+rY3glD1l/7DHMMLK1+STdeaLCfKdb
	 DY3lzuf+76SXNVso5DyPplGNkY2YgiCfvOLK25qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.10 349/355] s390/pci: Fix __pcilg_mio_inuser() inline assembly
Date: Mon, 23 Jun 2025 15:09:10 +0200
Message-ID: <20250623130637.216863166@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

commit c4abe6234246c75cdc43326415d9cff88b7cf06c upstream.

Use "a" constraint for the shift operand of the __pcilg_mio_inuser() inline
assembly. The used "d" constraint allows the compiler to use any general
purpose register for the shift operand, including register zero.

If register zero is used this my result in incorrect code generation:

 8f6:   a7 0a ff f8             ahi     %r0,-8
 8fa:   eb 32 00 00 00 0c       srlg    %r3,%r2,0  <----

If register zero is selected to contain the shift value, the srlg
instruction ignores the contents of the register and always shifts zero
bits. Therefore use the "a" constraint which does not permit to select
register zero.

Fixes: f058599e22d5 ("s390/pci: Fix s390_mmio_read/write with MIO")
Cc: stable@vger.kernel.org
Reported-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_mmio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -229,7 +229,7 @@ static inline int __pcilg_mio_inuser(
 		:
 		[cc] "+d" (cc), [val] "=d" (val), [len] "+d" (len),
 		[dst] "+a" (dst), [cnt] "+d" (cnt), [tmp] "=d" (tmp),
-		[shift] "+d" (shift)
+		[shift] "+a" (shift)
 		:
 		[ioaddr] "a" (addr)
 		: "cc", "memory");


