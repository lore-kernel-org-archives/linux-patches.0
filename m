Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4F520B7EE;
	Tue, 26 Aug 2025 11:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207292; cv=none; b=aOyBVo/sZp5hY0OKvFpBE1IenhliLcwf9C0hZLjSptoyJz1QfyqMMiBnnJ3/k7St+EPPDSpvDojsTV9OUDp/GH/RNIkJ6+gLopUTgfyWqB1cKUJCxFSS3FR8UjKkkGz54ymN2MYEX0/Tp7pg7ce6BWEThwCxQGxwDZDoO2xvggc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207292; c=relaxed/simple;
	bh=ccbMdD6EyY3BVjUgZTGXItmkmxja9tYHZky986EqSOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aj3HXrQ8+/TNIrg6m+Xb6toLH/q0VHWiwKNbBE90r5R9KK972Uns8aVQzIPsf1wDK0iVEqw/YwGAsb/VRS7hDw/xZ+sqZZoyFvXisNyuXTo5q9mCezurVE04QpURJ4UMTGsCivXAbCOOsfCXxbR4HKphcFEQLpS4OTJoQPca8qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TmvdAGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TmvdAGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C62C113CF;
	Tue, 26 Aug 2025 11:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207292;
	bh=ccbMdD6EyY3BVjUgZTGXItmkmxja9tYHZky986EqSOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TmvdAGtJntTfqTtyh7/EHJaxpMERuk4Ok/r/MKMgcmOk0nXk9b+/TzAF8MMIAg9g
	 Jh6CDD7IWYoGV7k7r0+Sl/aDey0q4fSmcPnWD3qJihmV/L/Us6pSNIQuVGyLb5EUQK
	 /q2zSvhmTioLXsI2/d4z46D7sYHMFcirDJBJQioY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.16 126/457] parisc: Revise __get_user() to probe user read access
Date: Tue, 26 Aug 2025 13:06:50 +0200
Message-ID: <20250826110940.488457553@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


