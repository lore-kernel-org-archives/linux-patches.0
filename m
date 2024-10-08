Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37D71DF975;
	Tue,  8 Oct 2024 13:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393765; cv=none; b=X75pQIVHav2vvSNLJarR9gSF43Buo4zRj5ZQPZf5+M2UcCIH6Y+wNxNRSfrWdc0aJZ7Pn6sdn5W3SUNPOPd+kKCmmgnJ20qtkFQVObG7YCslVESIXSl+o7M4I9aigX2E8PTFMsaI5x20z35ikRIacilvGCUwoPUOMNS3R1ZBaFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393765; c=relaxed/simple;
	bh=MUgeSD1QzEJJgqTpbCUJQbw0NvwCDYBhMq+oLZBZ8Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLvlbPx6tzQuiA6Ks/kukzXOQyaIlaKk+vNia2CgYvUHORDLAMzxyhKDwzDMY3lNwcK7vOaDYjGUXUIF262WmSw/CgKWTw01wysoA9BKnOS/2mU/CjH4E3jUvc+u/UBYt2CY2KR3DplTpIXLjEVZKm4JeTU1AjS3k4BGk4Tylb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2jOn8CV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2jOn8CV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3FBC4CEC7;
	Tue,  8 Oct 2024 13:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393765;
	bh=MUgeSD1QzEJJgqTpbCUJQbw0NvwCDYBhMq+oLZBZ8Xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2jOn8CV3dVRsf1X7hldTRkWOUqLxYihMGliP7sbf4d3SuzsCPKfC1wUPXQbNJ/C2
	 RjUJmA1fsOBYeamrB578yWmpO3Te8Z6ruz0jWr/2lF2z8y7VltopCMg2uBI76QNQGE
	 tctEja4yzchB6eUhJolRxFz+xapkjeWmYQjHLs3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Camm Maguire <camm@maguirefamily.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 249/386] parisc: Allow mmap(MAP_STACK) memory to automatically expand upwards
Date: Tue,  8 Oct 2024 14:08:14 +0200
Message-ID: <20241008115639.192695344@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Helge Deller <deller@kernel.org>

commit 5d698966fa7b452035c44c937d704910bf3440dd upstream.

When userspace allocates memory with mmap() in order to be used for stack,
allow this memory region to automatically expand upwards up until the
current maximum process stack size.
The fault handler checks if the VM_GROWSUP bit is set in the vm_flags field
of a memory area before it allows it to expand.
This patch modifies the parisc specific code only.
A RFC for a generic patch to modify mmap() for all architectures was sent
to the mailing list but did not get enough Acks.

Reported-by: Camm Maguire <camm@maguirefamily.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org	# v5.10+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/mman.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/arch/parisc/include/asm/mman.h
+++ b/arch/parisc/include/asm/mman.h
@@ -11,4 +11,18 @@ static inline bool arch_memory_deny_writ
 }
 #define arch_memory_deny_write_exec_supported arch_memory_deny_write_exec_supported
 
+static inline unsigned long arch_calc_vm_flag_bits(unsigned long flags)
+{
+	/*
+	 * The stack on parisc grows upwards, so if userspace requests memory
+	 * for a stack, mark it with VM_GROWSUP so that the stack expansion in
+	 * the fault handler will work.
+	 */
+	if (flags & MAP_STACK)
+		return VM_GROWSUP;
+
+	return 0;
+}
+#define arch_calc_vm_flag_bits(flags) arch_calc_vm_flag_bits(flags)
+
 #endif /* __ASM_MMAN_H__ */


