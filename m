Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6351223DEE;
	Mon, 23 Jun 2025 22:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716662; cv=none; b=trXOrhE4/n1iNB6jW5fmH+OGBvEtpDqN8IR3xwHNpwT3nhR+rtRviW4gUyMW5bqXfGiV/hQT4zf//qyJIvkaGkyqz/aQTT8cAIDeWtdOmqrB1qV0AZA8JioWyLYogoIMZzSTqaijvV4uuQHbph2CWnggks+VKkxEXky/hXkvR2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716662; c=relaxed/simple;
	bh=hTIknVAFAAtm37SNiZFAG1ZY4XZai3+iBszAAQi+7UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FjP7qe4sZJevaIySqANeP95Jkdm9O99jz8G2TjgWjlP8Ra3DJeg1huwtBjl2UWPZKh3eCFCA/lKjBg8ylQbYjRbXV/kLLKK1rCFkdE4tOQGvF+AQ/ZoASK3v7WHk+GJT+nnyzrYdOq7FdwLAF6695Jtvfi2eFH3uTDWSg/MKD1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXvewEFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXvewEFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8165CC4CEEA;
	Mon, 23 Jun 2025 22:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716661;
	bh=hTIknVAFAAtm37SNiZFAG1ZY4XZai3+iBszAAQi+7UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXvewEFU4/IGia8d0EkqVuHbRj4HWDB6aXownx0YbFQ3vNS6T1Acy3AYeNyyqJcjT
	 AU8ieXUOqMe693OcQC3Nl02Zvv6aDgoW8kQSuwT9HYYI8oIBA1BlDf1f5Toxh4PwrT
	 o3u3Ows1rhVFRyA1P3JrLL5MCQpCrIY9cnaC4dy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.6 280/290] s390/pci: Fix __pcilg_mio_inuser() inline assembly
Date: Mon, 23 Jun 2025 15:09:01 +0200
Message-ID: <20250623130635.343087936@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -223,7 +223,7 @@ static inline int __pcilg_mio_inuser(
 		[ioaddr_len] "+&d" (ioaddr_len.pair),
 		[cc] "+d" (cc), [val] "=d" (val),
 		[dst] "+a" (dst), [cnt] "+d" (cnt), [tmp] "=d" (tmp),
-		[shift] "+d" (shift)
+		[shift] "+a" (shift)
 		:: "cc", "memory");
 
 	/* did we write everything to the user space buffer? */


