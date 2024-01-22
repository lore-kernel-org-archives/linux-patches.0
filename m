Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EBD33097;
	Tue, 23 Jan 2024 00:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969660; cv=none; b=EwVy6Zf8W+TNHjjPPYSXlEUvjoiwuO5BoLARRjfl3cCfQ4qeOyyt9e4YyhGg3Pzdbi3nzba2sPBmQPQDlzennUV4XW+/GisNRFCCp4aR+eP7f522FVqb1eegkUThPDQQledP+w04613AyIGSz5TkBYKhyslrC6fMfSyRAgRh7ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969660; c=relaxed/simple;
	bh=n4YEv7gEp2CjJUb0lhEYZ5Fb1+QefdJtWBMqfkj3KiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNtXwSY4507K6EjZa51JGUFjdzRiqPdx8Gk40MjU8WR/gs/9i/gr+ehbOynkixykZe90KSU1IYuvMIgIr9XFwIoZKnCo/LA+X6MrqwXWoKx3rZhMOyxjT2JVIBTRnQmF6BbmZmQ+vuc1zbup5YYdOWIBRPChuuFZJDz4FEJ1brk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDsVmBR6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDsVmBR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48F1C433F1;
	Tue, 23 Jan 2024 00:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969660;
	bh=n4YEv7gEp2CjJUb0lhEYZ5Fb1+QefdJtWBMqfkj3KiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDsVmBR6Dkm4LKY/iJt+hENgHTSJ/bMdMb4wVjKvFCkIv330eANLxREzbFfeMqw8K
	 gEa5jDR1Y/iVLc0Ie/pAPDyUEUB1PuWIhv5vU7gndmptcDQW7PpMqssGWXuylyUBWD
	 9l5PueL0/g3jpPv6L9Dh4TvLGb9qaXxtTsaXMqKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@outlook.com>,
	Guo Ren <guoren@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 6.7 389/641] dt-bindings: timer: thead,c900-aclint-mtimer: separate mtime and mtimecmp regs
Date: Mon, 22 Jan 2024 15:54:53 -0800
Message-ID: <20240122235830.124966554@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Inochi Amaoto <inochiama@outlook.com>

commit b91cf01cf3e63a627b3b65f4284dcf9a4deb80f9 upstream.

The timer registers of aclint don't follow the clint layout and can
be mapped on any different offset. As sg2042 uses separated timer
and mswi for its clint, it should follow the aclint spec and have
separated registers.

The previous patch introduced a new type of T-HEAD aclint timer which
has clint timer layout. Although it has the clint timer layout, it
should follow the aclint spec and uses the separated mtime and mtimecmp
regs. So a ABI change is needed to make the timer fit the aclint spec.

To make T-HEAD aclint timer more closer to the aclint spec, use
regs-names to represent the mtimecmp register, which can avoid hack
for unsupport mtime register of T-HEAD aclint timer.

Also, as T-HEAD aclint only supports mtimecmp, it is unnecessary to
implement the whole aclint spec. To make this binding T-HEAD specific,
only add reg-name for existed register. For details, see the discussion
in the last link.

Signed-off-by: Inochi Amaoto <inochiama@outlook.com>
Fixes: 4734449f7311 ("dt-bindings: timer: Add Sophgo sg2042 CLINT timer")
Link: https://lists.infradead.org/pipermail/opensbi/2023-October/005693.html
Link: https://github.com/riscv/riscv-aclint/blob/main/riscv-aclint.adoc
Link: https://lore.kernel.org/all/IA1PR20MB4953F9D77FFC76A9D236922DBBB6A@IA1PR20MB4953.namprd20.prod.outlook.com/
Acked-by: Guo Ren <guoren@kernel.org>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/IA1PR20MB49531ED1BCC00D6B265C2D10BB86A@IA1PR20MB4953.namprd20.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../bindings/timer/thead,c900-aclint-mtimer.yaml         | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/timer/thead,c900-aclint-mtimer.yaml b/Documentation/devicetree/bindings/timer/thead,c900-aclint-mtimer.yaml
index fbd235650e52..2e92bcdeb423 100644
--- a/Documentation/devicetree/bindings/timer/thead,c900-aclint-mtimer.yaml
+++ b/Documentation/devicetree/bindings/timer/thead,c900-aclint-mtimer.yaml
@@ -17,7 +17,12 @@ properties:
       - const: thead,c900-aclint-mtimer
 
   reg:
-    maxItems: 1
+    items:
+      - description: MTIMECMP Registers
+
+  reg-names:
+    items:
+      - const: mtimecmp
 
   interrupts-extended:
     minItems: 1
@@ -28,6 +33,7 @@ additionalProperties: false
 required:
   - compatible
   - reg
+  - reg-names
   - interrupts-extended
 
 examples:
@@ -39,5 +45,6 @@ examples:
                             <&cpu3intc 7>,
                             <&cpu4intc 7>;
       reg = <0xac000000 0x00010000>;
+      reg-names = "mtimecmp";
     };
 ...
-- 
2.43.0



