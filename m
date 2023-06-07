Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0471519BBC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1657C433D2;
	Wed,  7 Jun 2023 20:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169092;
	bh=PsdLhYUW2/2yOHPd/tsa7m1zstJtfVAA7v3QvF6juMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RufZpLL/+mktY8GyFXEZAtrq+uPz4tnizSWOpe/I/y4UptWIf35HpmmXcwPbEB5Yh
	 W4bczyfAtenL4p3nAj8SeLlc/dv6CyHZi4s36PSNnrusgxC8qrJNlgPVqhIwF/BiSj
	 vK+rJnt3KXM4dCnNUKu/ZxOvAEDHCfh7wB1kGrtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Li <haibo.li@mediatek.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/61] ARM: 9295/1: unwind:fix unwind abort for uleb128 case
Date: Wed,  7 Jun 2023 22:15:26 +0200
Message-ID: <20230607200839.367241955@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200835.310274198@linuxfoundation.org>
References: <20230607200835.310274198@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Haibo Li <haibo.li@mediatek.com>

[ Upstream commit fa3eeb638de0c1a9d2d860e5b48259facdd65176 ]

When unwind instruction is 0xb2,the subsequent instructions
are uleb128 bytes.
For now,it uses only the first uleb128 byte in code.

For vsp increments of 0x204~0x400,use one uleb128 byte like below:
0xc06a00e4 <unwind_test_work>: 0x80b27fac
  Compact model index: 0
  0xb2 0x7f vsp = vsp + 1024
  0xac      pop {r4, r5, r6, r7, r8, r14}

For vsp increments larger than 0x400,use two uleb128 bytes like below:
0xc06a00e4 <unwind_test_work>: @0xc0cc9e0c
  Compact model index: 1
  0xb2 0x81 0x01 vsp = vsp + 1032
  0xac      pop {r4, r5, r6, r7, r8, r14}
The unwind works well since the decoded uleb128 byte is also 0x81.

For vsp increments larger than 0x600,use two uleb128 bytes like below:
0xc06a00e4 <unwind_test_work>: @0xc0cc9e0c
  Compact model index: 1
  0xb2 0x81 0x02 vsp = vsp + 1544
  0xac      pop {r4, r5, r6, r7, r8, r14}
In this case,the decoded uleb128 result is 0x101(vsp=0x204+(0x101<<2)).
While the uleb128 used in code is 0x81(vsp=0x204+(0x81<<2)).
The unwind aborts at this frame since it gets incorrect vsp.

To fix this,add uleb128 decode to cover all the above case.

Signed-off-by: Haibo Li <haibo.li@mediatek.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/unwind.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 314cfb232a635..f2bb090373c67 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -313,6 +313,29 @@ static int unwind_exec_pop_subset_r0_to_r3(struct unwind_ctrl_block *ctrl,
 	return URC_OK;
 }
 
+static unsigned long unwind_decode_uleb128(struct unwind_ctrl_block *ctrl)
+{
+	unsigned long bytes = 0;
+	unsigned long insn;
+	unsigned long result = 0;
+
+	/*
+	 * unwind_get_byte() will advance `ctrl` one instruction at a time, so
+	 * loop until we get an instruction byte where bit 7 is not set.
+	 *
+	 * Note: This decodes a maximum of 4 bytes to output 28 bits data where
+	 * max is 0xfffffff: that will cover a vsp increment of 1073742336, hence
+	 * it is sufficient for unwinding the stack.
+	 */
+	do {
+		insn = unwind_get_byte(ctrl);
+		result |= (insn & 0x7f) << (bytes * 7);
+		bytes++;
+	} while (!!(insn & 0x80) && (bytes != sizeof(result)));
+
+	return result;
+}
+
 /*
  * Execute the current unwind instruction.
  */
@@ -366,7 +389,7 @@ static int unwind_exec_insn(struct unwind_ctrl_block *ctrl)
 		if (ret)
 			goto error;
 	} else if (insn == 0xb2) {
-		unsigned long uleb128 = unwind_get_byte(ctrl);
+		unsigned long uleb128 = unwind_decode_uleb128(ctrl);
 
 		ctrl->vrs[SP] += 0x204 + (uleb128 << 2);
 	} else {
-- 
2.39.2



