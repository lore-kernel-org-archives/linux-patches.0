Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F55168DC
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C79C433D2;
	Mon, 22 May 2023 19:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784159;
	bh=sGEfzEU4J9EVVpL60o5S2n9YBq1DDYpJhnVnfCVv1ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLmaHUZDiPRaTShvR83Bng3Bvx3s4u9suxKzXfVrhY43KJYiYli2iy6eINXSp66yi
	 jvqkSiWPScveXUAmT7JBuuncFxIthmlMqGZXvvBlKbYvGm0ctnbCBQMn86p15drt7v
	 NIDFDwR5aWphl2ChdqGsWDTB+OtdwtDC4ccDFt+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.1 283/292] s390/crypto: use vector instructions only if available for ChaCha20
Date: Mon, 22 May 2023 20:10:40 +0100
Message-Id: <20230522190413.018489207@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
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

commit 8703dd6b238da0ec6c276e53836f8200983d3d9b upstream.

Commit 349d03ffd5f6 ("crypto: s390 - add crypto library interface for
ChaCha20") added a library interface to the s390 specific ChaCha20
implementation. However no check was added to verify if the required
facilities are installed before branching into the assembler code.

If compiled into the kernel, this will lead to the following crash,
if vector instructions are not available:

data exception: 0007 ilc:3 [#1] SMP
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.3.0-rc7+ #11
Hardware name: IBM 3931 A01 704 (KVM/Linux)
Krnl PSW : 0704e00180000000 000000001857277a (chacha20_vx+0x32/0x818)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
Krnl GPRS: 0000037f0000000a ffffffffffffff60 000000008184b000 0000000019f5c8e6
           0000000000000109 0000037fffb13c58 0000037fffb13c78 0000000019bb1780
           0000037fffb13c58 0000000019f5c8e6 000000008184b000 0000000000000109
           00000000802d8000 0000000000000109 0000000018571ebc 0000037fffb13718
Krnl Code: 000000001857276a: c07000b1f80b        larl    %r7,0000000019bb1780
           0000000018572770: a708000a            lhi     %r0,10
          #0000000018572774: e78950000c36        vlm     %v24,%v25,0(%r5),0
          >000000001857277a: e7a060000806        vl      %v26,0(%r6),0
           0000000018572780: e7bf70004c36        vlm     %v27,%v31,0(%r7),4
           0000000018572786: e70b00000456        vlr     %v0,%v27
           000000001857278c: e71800000456        vlr     %v1,%v24
           0000000018572792: e74b00000456        vlr     %v4,%v27
Call Trace:
 [<000000001857277a>] chacha20_vx+0x32/0x818
Last Breaking-Event-Address:
 [<0000000018571eb6>] chacha20_crypt_s390.constprop.0+0x6e/0xd8
---[ end trace 0000000000000000 ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Fix this by adding a missing MACHINE_HAS_VX check.

Fixes: 349d03ffd5f6 ("crypto: s390 - add crypto library interface for ChaCha20")
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Cc: <stable@vger.kernel.org> # 5.19+
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
[agordeev@linux.ibm.com: remove duplicates in commit message]
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/crypto/chacha-glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/crypto/chacha-glue.c
+++ b/arch/s390/crypto/chacha-glue.c
@@ -82,7 +82,7 @@ void chacha_crypt_arch(u32 *state, u8 *d
 	 * it cannot handle a block of data or less, but otherwise
 	 * it can handle data of arbitrary size
 	 */
-	if (bytes <= CHACHA_BLOCK_SIZE || nrounds != 20)
+	if (bytes <= CHACHA_BLOCK_SIZE || nrounds != 20 || !MACHINE_HAS_VX)
 		chacha_crypt_generic(state, dst, src, bytes, nrounds);
 	else
 		chacha20_crypt_s390(state, dst, src, bytes,


