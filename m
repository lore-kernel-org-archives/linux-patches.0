Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C0016F84F;
	Wed,  2 Oct 2024 13:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875631; cv=none; b=H7wv851H8qTEcnXz7oUvb3+VXeK/W4oJ1Y6QpVkBHwrcPMGROLWxArIoZ/DToW5F1HwHceQvu7Ejdebrv7wZDjx8qOZntAHSVznH3Oa/QlU2olkcoGRSXbT8A0jhs3kvvtL3XNmdQfhTjznvZNJmSXlojLYur4U2uC3lST3DEU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875631; c=relaxed/simple;
	bh=U+HPV/CYbN2+tp5JPUe2n1RgAz857NBjsShAsdSRYD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7b2LO69Opi1gqZ6WrdBFjLbSw/HQLIEpJSbXTEtQvXvnOVlx4J/LCigj8LNNwb4kQOYIWlwUU50YO2O4Dgp2oSN/zP+5+r4C7QO52SZzWbPnoKaPqY7KSYJswy6mjTtQ0ktdflSaUFdkQvidUmP2rTYyReb+vE9WV6Uw2m42uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CkjKeAOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CkjKeAOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33897C4CEC5;
	Wed,  2 Oct 2024 13:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875631;
	bh=U+HPV/CYbN2+tp5JPUe2n1RgAz857NBjsShAsdSRYD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CkjKeAOQ9PG+XIpSVFTjKvggx5CIUsPwPpPGrP8uGGG4pDla8iA9l+sMWNCqViQOE
	 NSuV/G0TG+nX7otRCCn7ZY13WMTpEOrCJzP8/eHkLXHWH8L2QzMq8+rE+/mfWTdLul
	 r/gKB6kAIWxXVkzsgVUFC95AXzkc+JUGxcIXEbdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 168/695] x86/boot/64: Strip percpu address space when setting up GDT descriptors
Date: Wed,  2 Oct 2024 14:52:46 +0200
Message-ID: <20241002125829.180979378@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit b51207dc02ec3aeaa849e419f79055d7334845b6 ]

init_per_cpu_var() returns a pointer in the percpu address space while
rip_rel_ptr() expects a pointer in the generic address space.

When strict address space checks are enabled, GCC's named address space
checks fail:

  asm.h:124:63: error: passing argument 1 of 'rip_rel_ptr' from
                       pointer to non-enclosed address space

Add a explicit cast to remove address space of the returned pointer.

Fixes: 11e36b0f7c21 ("x86/boot/64: Load the final kernel GDT during early boot directly, remove startup_gdt[]")
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20240819083334.148536-1-ubizjak@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/head64.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index a817ed0724d1e..4b9d4557fc94a 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -559,10 +559,11 @@ void early_setup_idt(void)
  */
 void __head startup_64_setup_gdt_idt(void)
 {
+	struct desc_struct *gdt = (void *)(__force unsigned long)init_per_cpu_var(gdt_page.gdt);
 	void *handler = NULL;
 
 	struct desc_ptr startup_gdt_descr = {
-		.address = (unsigned long)&RIP_REL_REF(init_per_cpu_var(gdt_page.gdt)),
+		.address = (unsigned long)&RIP_REL_REF(*gdt),
 		.size    = GDT_SIZE - 1,
 	};
 
-- 
2.43.0



