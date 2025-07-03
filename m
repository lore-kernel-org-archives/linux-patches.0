Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1202EF676;
	Thu,  3 Jul 2025 15:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555862; cv=none; b=R5RORHHpIghNJEMqyS5MLZT1GFZy082+bew8HzhpbsAG0dl2LoUlK58PXY3we1eJo3KqJgvOWjOP45keKVFigYHO61/1TCBdyD0xfTtrJFCbUtAqWyz2RGVeNNxrGxVOfCoXPfI5gcvsqSRC6qGqQ/1guNRb9NQYWHhYaZd0BYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555862; c=relaxed/simple;
	bh=mA7+JLcmiZg4uAveMRexUN/dBRS/qfxogvK/+X7nrZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avWaFSOdORCs7zDQvHwDN3Cd/zULIy2TyzjCHd4aV+iJnYMqIOsoBqo63rLVq9TbEDP9O5Dyk84P/8kw/1RZ1//ExB0/B7B37VGk3N+EgA/XxDNe/OQc6uq0MshEMKjK6GL6zSTY0X45tieebphKRfZwKd9pvxbZ19brJRsPLew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=geEEkfqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="geEEkfqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D16C4CEE3;
	Thu,  3 Jul 2025 15:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555862;
	bh=mA7+JLcmiZg4uAveMRexUN/dBRS/qfxogvK/+X7nrZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=geEEkfqTeHft/Pa9+lprx3okur+N4tKJcv4GpCKIJLlqj0L8L+AmclWBfZoMTojzs
	 0W5tlFrx3joMnew7Wu3qSvyA2kYyh/t7UwUhov+1s14Faz0gjTLhMnzHTBsGsb4ylU
	 x3ikVJJgCKzlA8qg+ocH40b57U9pu/8JdyHhlWwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.6 132/139] s390/entry: Fix last breaking event handling in case of stack corruption
Date: Thu,  3 Jul 2025 16:43:15 +0200
Message-ID: <20250703143946.341617442@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

commit ae952eea6f4a7e2193f8721a5366049946e012e7 upstream.

In case of stack corruption stack_invalid() is called and the expectation
is that register r10 contains the last breaking event address. This
dependency is quite subtle and broke a couple of years ago without that
anybody noticed.

Fix this by getting rid of the dependency and read the last breaking event
address from lowcore.

Fixes: 56e62a737028 ("s390: convert to generic entry")
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -639,7 +639,7 @@ SYM_CODE_START(stack_overflow)
 	stmg	%r0,%r7,__PT_R0(%r11)
 	stmg	%r8,%r9,__PT_PSW(%r11)
 	mvc	__PT_R8(64,%r11),0(%r14)
-	stg	%r10,__PT_ORIG_GPR2(%r11) # store last break to orig_gpr2
+	mvc	__PT_ORIG_GPR2(8,%r11),__LC_PGM_LAST_BREAK
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	lgr	%r2,%r11		# pass pointer to pt_regs
 	jg	kernel_stack_overflow


