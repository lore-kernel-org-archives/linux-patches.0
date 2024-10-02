Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2351D0F47;
	Wed,  2 Oct 2024 14:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877663; cv=none; b=ZxIGf9Fl7O1tIHszwtzdgIlUdNmLUtRQ3HcKuq2JVghpijf9qMyBXHg/ZMtP31msvd33rH/x0Llu7HxzIfG/e+mzvYhGqlGLPM8di4efu+dookef8iQY/RPFkc8RXpfOPS6daK19VdOE9DUAJD8P4b/eqiwCRCuK3h3nJAgnMak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877663; c=relaxed/simple;
	bh=FA+PJbYrEKVvbneZ8Xkds+A/MQU0sdNT2ryL8bNxmEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKPKIpPu26A04VN+shKwzC/TM0FExqK8jmvAqMtvI5yfnV1AtzB9l5b+7Kyg5ArTBtwlOS6PktepVR9Mmz+L6rtikl3AZ1n/MsDK6k5xqoQjS8E6Sf/u2yHCUox+BwVvHEu+jTHyG4dzRD9INel6z8iUc7F/5mT1mr8YLX7ockw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAjSNLQE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAjSNLQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C933FC4CEC2;
	Wed,  2 Oct 2024 14:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877663;
	bh=FA+PJbYrEKVvbneZ8Xkds+A/MQU0sdNT2ryL8bNxmEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAjSNLQE2tbfTwgzjUhnMaA/T24LnGSj3XpvmRhgG5yxMJuvwV82TfpxdPNIdQX26
	 djVtIeNLH368LDYcn1Pgprx08IomKKi5DCCbVb9clQDPuWA3OS+SgKnO4ti+k/sWlu
	 bn6v2boAw7OJBOdGXqsY6t2rBtbizl7KpbnRWEKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 151/634] x86/boot/64: Strip percpu address space when setting up GDT descriptors
Date: Wed,  2 Oct 2024 14:54:11 +0200
Message-ID: <20241002125817.070554225@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



