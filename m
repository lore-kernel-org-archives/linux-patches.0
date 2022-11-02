Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7F9629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C1EC433D7;
	Wed,  2 Nov 2022 03:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358279;
	bh=M/heCmifT334VO/7CrF9vV2ePSdnHuw0E85l9uaPBSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zdVSJJpbZrVejeXMg3+0eh7dyU4GJy0cC3n9mje2CwSVnqRtq/+6GbBGc2WHVnute
	 O5ymbyKimqnBUFKAmGSyYKvgLvswJZs2eam9Ho7bxM4GHmhAbVIWXVbxZQp/lJTUI5
	 k/40K89U86z9n3bmSI4UUSO8MhUiX3nXlJbxxZ0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.15 046/132] s390/pci: add missing EX_TABLE entries to __pcistg_mio_inuser()/__pcilg_mio_inuser()
Date: Wed,  2 Nov 2022 03:32:32 +0100
Message-Id: <20221102022100.834902102@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Heiko Carstens <hca@linux.ibm.com>

commit 6ec803025cf3173a57222e4411097166bd06fa98 upstream.

For some exception types the instruction address points behind the
instruction that caused the exception. Take that into account and add
the missing exception table entry.

Cc: <stable@vger.kernel.org>
Fixes: f058599e22d5 ("s390/pci: Fix s390_mmio_read/write with MIO")
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_mmio.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -63,7 +63,7 @@ static inline int __pcistg_mio_inuser(
 	asm volatile (
 		"       sacf    256\n"
 		"0:     llgc    %[tmp],0(%[src])\n"
-		"       sllg    %[val],%[val],8\n"
+		"4:	sllg	%[val],%[val],8\n"
 		"       aghi    %[src],1\n"
 		"       ogr     %[val],%[tmp]\n"
 		"       brctg   %[cnt],0b\n"
@@ -71,7 +71,7 @@ static inline int __pcistg_mio_inuser(
 		"2:     ipm     %[cc]\n"
 		"       srl     %[cc],28\n"
 		"3:     sacf    768\n"
-		EX_TABLE(0b, 3b) EX_TABLE(1b, 3b) EX_TABLE(2b, 3b)
+		EX_TABLE(0b, 3b) EX_TABLE(4b, 3b) EX_TABLE(1b, 3b) EX_TABLE(2b, 3b)
 		:
 		[src] "+a" (src), [cnt] "+d" (cnt),
 		[val] "+d" (val), [tmp] "=d" (tmp),
@@ -214,10 +214,10 @@ static inline int __pcilg_mio_inuser(
 		"2:     ahi     %[shift],-8\n"
 		"       srlg    %[tmp],%[val],0(%[shift])\n"
 		"3:     stc     %[tmp],0(%[dst])\n"
-		"       aghi    %[dst],1\n"
+		"5:	aghi	%[dst],1\n"
 		"       brctg   %[cnt],2b\n"
 		"4:     sacf    768\n"
-		EX_TABLE(0b, 4b) EX_TABLE(1b, 4b) EX_TABLE(3b, 4b)
+		EX_TABLE(0b, 4b) EX_TABLE(1b, 4b) EX_TABLE(3b, 4b) EX_TABLE(5b, 4b)
 		:
 		[ioaddr_len] "+&d" (ioaddr_len.pair),
 		[cc] "+d" (cc), [val] "=d" (val),


