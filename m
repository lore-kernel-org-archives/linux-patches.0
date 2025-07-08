Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232D02E54D5;
	Tue,  8 Jul 2025 17:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994002; cv=none; b=NQTfPqmOsfjBbbj/sBAqVB2tNwjaRNdtA/JMBTlp4V+uF8HXdvPVQncYPxZv5I/uE6Ft23nhqrL3xStIT3P4ER8ttGHYrNEHQsZBYnebo8PwOaWQVkL5eJcVdEB768AplzvVD9dMVtV4U+6/mbX7APyWtKAksGyyFszOC5Jy/S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994002; c=relaxed/simple;
	bh=TtElT1b9aXNCIZBWowfHE9oRZ2n48m9qyeMqf9bJq20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5HIADKrKPFDm++JwcrsCV29GneuI/PCEJAQkn2VMtRQ+B5Os5HzGZNYPdqo813k6/Ki0bUx1Dza21RYTXvQJSZJLeWlp+AkfEMB0xh5IR2d34+Tj9hIiLYx0MlKdL3gfiIC6q4M4p5jGRnVg8vtjhe8Dg009ByzDc9asU7+X3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2rLpeXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2rLpeXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB86C4CEF0;
	Tue,  8 Jul 2025 17:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994002;
	bh=TtElT1b9aXNCIZBWowfHE9oRZ2n48m9qyeMqf9bJq20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2rLpeXThLEZeYHOJq+72yXC+6HKWFj51+wX/uE7Go+FPVUX+/SdWptW4MQLP6Umn
	 X1pjxqDBYGVp3fPB+fUI+pLem+67qXZh1x17W4oXOXXxIRHn06WAaifedKvQcNR9KQ
	 BZPMPDx5pkM7aNEzk+9mcAil11eHvWdH/ajpmF2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.15 091/160] s390/entry: Fix last breaking event handling in case of stack corruption
Date: Tue,  8 Jul 2025 18:22:08 +0200
Message-ID: <20250708162234.029780937@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -676,7 +676,7 @@ ENTRY(stack_overflow)
 	stmg	%r0,%r7,__PT_R0(%r11)
 	stmg	%r8,%r9,__PT_PSW(%r11)
 	mvc	__PT_R8(64,%r11),0(%r14)
-	stg	%r10,__PT_ORIG_GPR2(%r11) # store last break to orig_gpr2
+	mvc	__PT_ORIG_GPR2(8,%r11),__LC_LAST_BREAK
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	lgr	%r2,%r11		# pass pointer to pt_regs
 	jg	kernel_stack_overflow


