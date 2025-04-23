Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70FA481CD;
	Wed, 23 Apr 2025 14:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420174; cv=none; b=DhpaTBCMZnGhB9H6oZyLmkJyurqDQXQg9vJA/wRWqFUuv9a9KDcUEjZskJwm1V4pPZ37f4FOphznIDYChUWhW6wkjKb489yBH1zZHIjp9cgAUqNN3NHP6TcSQP2h1dCnt5EvKGTOgHYuW/DRcgh2qD1aj0uV1+fOT/N0zlkrt7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420174; c=relaxed/simple;
	bh=s8tpM+J00SHHB6T8AuGjfdjH8wQqLWrG3nniwL8Fkgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7MShXsymgsAzP+iQWYD4wlqxLCP9/DbwtzjjUU2ZpHTxuHIqukGmVYoWina8P1IOicsHQAKHaqeqdj/IePTbrRzD1Nm8Y+VS8eriKjGpsHzYrt3hDZXEWat5wpIBguYhlkYUAulupI5yLYlC3mBlfZr/aOglpOjIRDyq8xMYjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INONRfCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INONRfCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0D2C4CEE2;
	Wed, 23 Apr 2025 14:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420173;
	bh=s8tpM+J00SHHB6T8AuGjfdjH8wQqLWrG3nniwL8Fkgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INONRfCGktH9B00FCDJN5XcMjAZTuqbWE4H0t1hzbE37CtAZ3yeV0SldTVqYl1FDi
	 oiq5Q9COlVWGD9yHbqMtvIoBZ6ns3sIBCEiRQM3LoMJzS45U6xmrsFkagPjDkITsiJ
	 kTX4ipxg+jFFVXzcAO3TbsbrxhfAJ0HiaLj9AdEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	moyi geek <1441339168@qq.com>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 086/223] rust: kbuild: use `pound` to support GNU Make < 4.3
Date: Wed, 23 Apr 2025 16:42:38 +0200
Message-ID: <20250423142620.626359313@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 1c4494c14b4124f3a13a7f4912b84b633ff4f9ba upstream.

GNU Make 4.3 changed the behavior of `#` inside commands in commit
c6966b323811 ("[SV 20513] Un-escaped # are not comments in function
invocations"):

    * WARNING: Backward-incompatibility!
      Number signs (#) appearing inside a macro reference or function invocation
      no longer introduce comments and should not be escaped with backslashes:
      thus a call such as:
        foo := $(shell echo '#')
      is legal.  Previously the number sign needed to be escaped, for example:
        foo := $(shell echo '\#')
      Now this latter will resolve to "\#".  If you want to write makefiles
      portable to both versions, assign the number sign to a variable:
        H := \#
        foo := $(shell echo '$H')
      This was claimed to be fixed in 3.81, but wasn't, for some reason.
      To detect this change search for 'nocomment' in the .FEATURES variable.

Unlike other commits in the kernel about this issue, such as commit
633174a7046e ("lib/raid6/test/Makefile: Use $(pound) instead of \#
for Make 4.3"), that fixed the issue for newer GNU Makes, in our case
it was the opposite, i.e. we need to fix it for the older ones: someone
building with e.g. 4.2.1 gets the following error:

    scripts/Makefile.compiler:81: *** unterminated call to function 'call': missing ')'.  Stop.

Thus use the existing variable to fix it.

Reported-by: moyi geek <1441339168@qq.com>
Closes: https://rust-for-linux.zulipchat.com/#narrow/channel/291565/topic/x/near/512001985
Cc: stable@vger.kernel.org
Fixes: e72a076c620f ("kbuild: fix issues with rustc-option")
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20250414171241.2126137-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/Makefile.compiler |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/Makefile.compiler
+++ b/scripts/Makefile.compiler
@@ -75,7 +75,7 @@ ld-option = $(call try-run, $(LD) $(KBUI
 # Usage: MY_RUSTFLAGS += $(call __rustc-option,$(RUSTC),$(MY_RUSTFLAGS),-Cinstrument-coverage,-Zinstrument-coverage)
 # TODO: remove RUSTC_BOOTSTRAP=1 when we raise the minimum GNU Make version to 4.4
 __rustc-option = $(call try-run,\
-	echo '#![allow(missing_docs)]#![feature(no_core)]#![no_core]' | RUSTC_BOOTSTRAP=1\
+	echo '$(pound)![allow(missing_docs)]$(pound)![feature(no_core)]$(pound)![no_core]' | RUSTC_BOOTSTRAP=1\
 	$(1) --sysroot=/dev/null $(filter-out --sysroot=/dev/null --target=%,$(2)) $(3)\
 	--crate-type=rlib --out-dir=$(TMPOUT) --emit=obj=- - >/dev/null,$(3),$(4))
 


