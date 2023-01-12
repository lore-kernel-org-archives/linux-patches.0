Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383A4746A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 13:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9013DC433EF;
	Thu, 12 Jan 2023 13:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673531844;
	bh=vW1oJVo+2y6fr34fPRzOm9gsCuR9xrq4mH9jEIv8ylc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mI7VHjyWNZcjp3EtuWnEvh0YzUCZfpDaFWgNbRQOxPrZeR3cJ4hSCzTnNuEWrA7n9
	 z6R+8lEKhWuvGAuBdJpk+uS6EK56p2Tsd1LK7+n2ZMNm3vsUj3iA4Y+a899shRRlZP
	 ZpIVOMxVjPO7ooU+0boEGaxtykBNzqQAkF5GL2fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Huey <me@kylehuey.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 5.15 04/10] x86/fpu: Add a pkru argument to copy_uabi_to_xstate()
Date: Thu, 12 Jan 2023 14:56:41 +0100
Message-Id: <20230112135326.849086713@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
References: <20230112135326.689857506@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kyle Huey <me@kylehuey.com>

commit 2c87767c35ee9744f666ccec869d5fe742c3de0a upstream

In preparation for adding PKRU handling code into copy_uabi_to_xstate(),
add an argument that copy_uabi_from_kernel_to_xstate() can use to pass the
canonical location of the PKRU value. For
copy_sigframe_from_user_to_xstate() the kernel will actually restore the
PKRU value from the fpstate, but pass in the thread_struct's pkru location
anyways for consistency.

Signed-off-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20221115230932.7126-4-khuey%40kylehuey.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/xstate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1092,7 +1092,7 @@ static int copy_from_buffer(void *dst, u
 
 
 static int copy_uabi_to_xstate(struct xregs_state *xsave, const void *kbuf,
-			       const void __user *ubuf)
+			       const void __user *ubuf, u32 *pkru)
 {
 	unsigned int offset, size;
 	struct xstate_header hdr;
@@ -1161,7 +1161,7 @@ static int copy_uabi_to_xstate(struct xr
  */
 int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf, u32 *pkru)
 {
-	return copy_uabi_to_xstate(xsave, kbuf, NULL);
+	return copy_uabi_to_xstate(xsave, kbuf, NULL, pkru);
 }
 
 /*
@@ -1172,7 +1172,7 @@ int copy_uabi_from_kernel_to_xstate(stru
 int copy_sigframe_from_user_to_xstate(struct task_struct *tsk,
 				      const void __user *ubuf)
 {
-	return copy_uabi_to_xstate(&tsk->thread.fpu.state.xsave, NULL, ubuf);
+	return copy_uabi_to_xstate(&tsk->thread.fpu.state.xsave, NULL, ubuf, &tsk->thread.pkru);
 }
 
 static bool validate_xsaves_xrstors(u64 mask)


