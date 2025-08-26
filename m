Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCB01FBCB1;
	Tue, 26 Aug 2025 13:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214911; cv=none; b=AKCf4fc67V5IwGrG4hKONj//qspJgi74JZrpcHdLzT1XQE7GCUxJDA1ZCYSjor0z53jgt4l6RtPlS+syaGalcTNjpA+flmaxDHwpKUJZ+jpcrkIzytoq+FFwFWjLNZjsINQP5NORW9uT/rRNTujRsEAsptVeXIV9UlWPQkbUIWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214911; c=relaxed/simple;
	bh=AZvh2OKdoCLimHv1Fg8BHtE4iE5AFWkDYQrJ71IsZcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Giqz01hpPd/q7Yq1o0zEY82ykAUFc9ie5aqsYWphwb/rHQyQE75r0hqa5TrHk7+n//Ki0f4kPk123KqsfbQUy2JmjPgDCzNpX8VXn6Iz3XpHRc+ftZNr8WHA4gh4x37tTcTneAyKHwUS5ZPJBUn6TppV+R/+XwoAcRzEsryY2yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yr+XVKjR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yr+XVKjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C4DC4CEF1;
	Tue, 26 Aug 2025 13:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214911;
	bh=AZvh2OKdoCLimHv1Fg8BHtE4iE5AFWkDYQrJ71IsZcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yr+XVKjR6BTO94/S1IsI0SSeBbeeFvzkEF30mrEyD5p7o5W5JlYNwf09Jr0HHtLr9
	 30X8sO7IxOtSnCszJsikaQlzZcWD8H3shpZcggblEJAubtP8bLU0nFIUKYMFFoULXT
	 w4aiqbuqW/xRaaw3Nu5XnWQiMLbvUhNP9d5EhwE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 315/482] parisc: Revise __get_user() to probe user read access
Date: Tue, 26 Aug 2025 13:09:28 +0200
Message-ID: <20250826110938.585993365@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

From: John David Anglin <dave.anglin@bell.net>

commit 89f686a0fb6e473a876a9a60a13aec67a62b9a7e upstream.

Because of the way read access support is implemented, read access
interruptions are only triggered at privilege levels 2 and 3. The
kernel executes at privilege level 0, so __get_user() never triggers
a read access interruption (code 26). Thus, it is currently possible
for user code to access a read protected address via a system call.

Fix this by probing read access rights at privilege level 3 (PRIV_USER)
and setting __gu_err to -EFAULT (-14) if access isn't allowed.

Note the cmpiclr instruction does a 32-bit compare because COND macro
doesn't work inside asm.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/uaccess.h |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/arch/parisc/include/asm/uaccess.h
+++ b/arch/parisc/include/asm/uaccess.h
@@ -42,9 +42,24 @@
 	__gu_err;					\
 })
 
-#define __get_user(val, ptr)				\
-({							\
-	__get_user_internal(SR_USER, val, ptr);	\
+#define __probe_user_internal(sr, error, ptr)			\
+({								\
+	__asm__("\tproberi (%%sr%1,%2),%3,%0\n"			\
+		"\tcmpiclr,= 1,%0,%0\n"				\
+		"\tldi %4,%0\n"					\
+		: "=r"(error)					\
+		: "i"(sr), "r"(ptr), "i"(PRIV_USER),		\
+		  "i"(-EFAULT));				\
+})
+
+#define __get_user(val, ptr)					\
+({								\
+	register long __gu_err;					\
+								\
+	__gu_err = __get_user_internal(SR_USER, val, ptr);	\
+	if (likely(!__gu_err))					\
+		__probe_user_internal(SR_USER, __gu_err, ptr);	\
+	__gu_err;						\
 })
 
 #define __get_user_asm(sr, val, ldx, ptr)		\


