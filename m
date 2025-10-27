Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C7133030F;
	Mon, 27 Oct 2025 18:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591281; cv=none; b=fzO/slv/1v30ohYOQkvUIvVtW+Vp9UdJoiy/I1jUvfbFQzAWZLzGOJJydTKeLLc0G/vnClvfpW9L0PIAgAxu3rRPe7dxAd579wD2HBufmnt40FamZilofruBKXjY15guOUSvDk/osV0h/BgnNZw5vY56BcR0NeN8xfOoOmM39/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591281; c=relaxed/simple;
	bh=sRPLYqwbnBIytY52Sg4uNqQ62mrBCQpQmJhb1lEwA0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VowPF3xNMU6YuSvqJv2z1pGONIJj02zE4pHz1bWA2ES+lqJCUh135UTh+sj4jFgH2hGZAIZEao221G74FCs4m+mF2fjkRjyL8Ecaz2wrt1YpqU02k0gi0NhTCWpyFol6gJIiIOqcvEh6KIfOoVzUjvBnBxPtnRAvHOngICQlevg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXoag1jj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXoag1jj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE727C4CEFD;
	Mon, 27 Oct 2025 18:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591281;
	bh=sRPLYqwbnBIytY52Sg4uNqQ62mrBCQpQmJhb1lEwA0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXoag1jjrwYbQ9TwOd45jsumX+Jz8FS8Ns+QLU+rxQuy+nkuUiDZ+mpD1EFQvJRih
	 CSxwu51/eTk8w7TNXFaYeutX1Mev8uhoeqj41yiOvnODWbOBTDHyzRGrtXllbY88pc
	 O3wWwfKNAQaA86WN3ll6CSjKzA5rQh9XEhJ+ePvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 136/332] copy_sighand: Handle architectures where sizeof(unsigned long) < sizeof(u64)
Date: Mon, 27 Oct 2025 19:33:09 +0100
Message-ID: <20251027183528.224596132@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Schuster <schuster.simon@siemens-energy.com>

commit 04ff48239f46e8b493571e260bd0e6c3a6400371 upstream.

With the introduction of clone3 in commit 7f192e3cd316 ("fork: add
clone3") the effective bit width of clone_flags on all architectures was
increased from 32-bit to 64-bit. However, the signature of the copy_*
helper functions (e.g., copy_sighand) used by copy_process was not
adapted.

As such, they truncate the flags on any 32-bit architectures that
supports clone3 (arc, arm, csky, m68k, microblaze, mips32, openrisc,
parisc32, powerpc32, riscv32, x86-32 and xtensa).

For copy_sighand with CLONE_CLEAR_SIGHAND being an actual u64
constant, this triggers an observable bug in kernel selftest
clone3_clear_sighand:

        if (clone_flags & CLONE_CLEAR_SIGHAND)

in function copy_sighand within fork.c will always fail given:

        unsigned long /* == uint32_t */ clone_flags
        #define CLONE_CLEAR_SIGHAND 0x100000000ULL

This commit fixes the bug by always passing clone_flags to copy_sighand
via their declared u64 type, invariant of architecture-dependent integer
sizes.

Fixes: b612e5df4587 ("clone3: add CLONE_CLEAR_SIGHAND")
Cc: stable@vger.kernel.org # linux-5.5+
Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>
Link: https://lore.kernel.org/20250901-nios2-implement-clone3-v2-1-53fcf5577d57@siemens-energy.com
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1519,7 +1519,7 @@ static int copy_io(unsigned long clone_f
 	return 0;
 }
 
-static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
+static int copy_sighand(u64 clone_flags, struct task_struct *tsk)
 {
 	struct sighand_struct *sig;
 


