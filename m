Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D4D337118;
	Fri, 17 Oct 2025 15:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713781; cv=none; b=mbD7yh+6ZVxkbO8CsmiX3oK8XIqoLssve62U1wdLcjCHrrDDuGW8gylHyGaE7Vz/iTKXV1dO+BWhQw8zzIyV3wJIyHW0VAamAxj6GP8LkUMwQxpjD8twU8GECkMwaayNp0oP1iyhxHq4RcCfwkaJB1CkG5q0WQO+J27bOsNAlNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713781; c=relaxed/simple;
	bh=w2MAzWxEoJ2J9wsv6SKe16WlCQOftuoG8C1MGZ3ZKKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tucuI8JZ5/ReUqyy9iiUmBzs/j8+1pp8vRqXP8ixxwkSIJMgKad7LmwtVLxmogushqYr4IZyuyOBmBnQJyhsQYOHqW4n+zZ9USgsqeiXXdJjpmt5q2sb8cqwgoAvR5SIEVoGAcxC7URpOUISTF6lcTUJcP8uoEw1qMb5OmjS02Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18JyaKbZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18JyaKbZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758E9C4CEFE;
	Fri, 17 Oct 2025 15:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713780;
	bh=w2MAzWxEoJ2J9wsv6SKe16WlCQOftuoG8C1MGZ3ZKKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18JyaKbZYS558qR17/lKIquqq+oe4dwGFdrOpuEuZW6zkAUOYVpIADaJKNqkA8J1v
	 Cso385ppgf9WA7ga+vcl8QdOtY4CJjwXchO2eogoHf0CoKZNDGj+KmzAK7nHXgXI6/
	 rRN7+9OtX2+m47qkK/ASATg0IAOpFta8cxqI6q9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 084/201] copy_sighand: Handle architectures where sizeof(unsigned long) < sizeof(u64)
Date: Fri, 17 Oct 2025 16:52:25 +0200
Message-ID: <20251017145137.840428041@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1799,7 +1799,7 @@ static int copy_files(unsigned long clon
 	return 0;
 }
 
-static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
+static int copy_sighand(u64 clone_flags, struct task_struct *tsk)
 {
 	struct sighand_struct *sig;
 


