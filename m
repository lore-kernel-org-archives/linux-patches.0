Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B602E7BBD;
	Thu,  3 Jul 2025 15:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556283; cv=none; b=CcK7NmlMveCLzSkTiuJ6wzg8fTd8xYRmj4yRNAOwUDQEBJ6I3PEyhxV8AhpaSaYcetS8LW8xOqDgMbuXcZaw/3usM/o2ZzroZ8HKjJvHiUPfERNSSJkGCs4cADoy9t49ILFzGWnpGllXTevVQJPcdNSWcfMC1sU/kJs7WTeOcL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556283; c=relaxed/simple;
	bh=Uhn7efm4mJy47JNW0pCAJr2neJ7cORNs3/YADvJ8GqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1zb1q37VqsSOT111qvFoykq2IlYPsH41lQ29LWKZEyy9G6B2o4rVHG7Dqpy12N2UkC6yad2BrL2cunSxzSJ63zIMQ7dlDSEJywIAjIGPmn7bOih+15iPLXDYOwHozMeUTo2VC8iHEUMdOsLGWiW/jYqZ+Hp59EoGcVKmd7wPoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0+cr7vF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0+cr7vF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7609C4CEEE;
	Thu,  3 Jul 2025 15:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556283;
	bh=Uhn7efm4mJy47JNW0pCAJr2neJ7cORNs3/YADvJ8GqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0+cr7vFtTiYwA9WmryIRoMDnh9gDmwzzibcC0FLOKY+cwb2BY2SVoBILg0YOd9h1
	 uPYnA6H3z4ssQDnsUzHNn0nQ01V+nh00BVgDfNdZ8SQWK7xs/x2gPnlGZ2Ui3rjZnO
	 jBoSmwGO7zFA81YbNTqHhwVxy4jddzBtZpSFo3xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.1 124/132] s390/entry: Fix last breaking event handling in case of stack corruption
Date: Thu,  3 Jul 2025 16:43:33 +0200
Message-ID: <20250703143944.265074000@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -690,7 +690,7 @@ ENTRY(stack_overflow)
 	stmg	%r0,%r7,__PT_R0(%r11)
 	stmg	%r8,%r9,__PT_PSW(%r11)
 	mvc	__PT_R8(64,%r11),0(%r14)
-	stg	%r10,__PT_ORIG_GPR2(%r11) # store last break to orig_gpr2
+	mvc	__PT_ORIG_GPR2(8,%r11),__LC_PGM_LAST_BREAK
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	lgr	%r2,%r11		# pass pointer to pt_regs
 	jg	kernel_stack_overflow


