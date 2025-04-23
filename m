Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AE517B421;
	Wed, 23 Apr 2025 15:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420540; cv=none; b=PjkRICW0uE2z1glFi2w5LtVhpP24LAsQG3fLZXT+T6RMeMBFrzSmsbL1R2AdoLhx82D73jnnGqz3OHNKQEFyOB6vUL5Rmqv3QF9jsFzwhsaFKx8PkFHwpaAj9e0x0uDlw1eA2uYVTMk6CYe/JkZ0IB9DgEv3cVtFtqrheiV/SKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420540; c=relaxed/simple;
	bh=CTJItSX9QrAvzJL2ZkOIokO0yNYCIL0CgktLTY4x/PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTY15E2vKP6FPhSro/8yLs1pQtpqD0Ni6bMjNI+OoXBOYCfCIf1fp4j7sW9AlakqN2d2e98/IWu2b12vy8UgnYgeCU3EbtjjfQo1abHXMN6ODz4WOv8CZ+d6YFrNxagurMAsCzJDCNC67BurtX6jUi3tnbw51vJPKXJNGtVjRs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EoVwufp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EoVwufp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6760C4CEE2;
	Wed, 23 Apr 2025 15:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420540;
	bh=CTJItSX9QrAvzJL2ZkOIokO0yNYCIL0CgktLTY4x/PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EoVwufp2rdti5b3HIwZMl7dyXxKjIuegyCGQmTNWJkZXtanizTHDdT5fTlo3OJfAE
	 ydrjflHOhCWBaKO9au2d6G9oGLTUErUhnxuObrSYmq6Aaw1Lk22hQ+QHmkyR9WUTg2
	 a/j4/1K9WMl48HBjCDqTzZ7/TzvuAV37B0gEWcBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	moyi geek <1441339168@qq.com>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.14 101/241] rust: kbuild: use `pound` to support GNU Make < 4.3
Date: Wed, 23 Apr 2025 16:42:45 +0200
Message-ID: <20250423142624.699930479@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 


