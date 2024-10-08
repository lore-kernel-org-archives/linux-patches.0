Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A36189910;
	Tue,  8 Oct 2024 12:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392390; cv=none; b=IMczwpM/ls7aTGP3cDGvst6r1i4uvuUIE1tuUMMvWKDIi2b31b67MMcGiJbhR3ByrqpXnCPbgV6ueaYKwBwDYH1yxty0K3+/pQ0hBZWebM6MFsfu8vJZXtddp6cShP38CwXpJUog5nWQBQElNOiav8MWQU+3Zys2lsTK0jgn4ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392390; c=relaxed/simple;
	bh=B/rnJqWLTlb5WsL7V/G6xLQhXQ0YnNzEQ9SwS0U2Qeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7ZxN8Cn+xhuLNhE/nBixn7XTwgwwqRP6X9Sv71QWXXfTLK1OVmR4GbSBqucSPhJAjn6vg4Tntmogd8k3XyRn5vMVJAgh8HlCKjQFSeFXiPZYR/uB3x70f/YvmCu88q+Iweu54WaarvYWprdVQEDl/2OCRMbingR2iPHuW4A1I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bu5bCgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bu5bCgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158A7C4CEC7;
	Tue,  8 Oct 2024 12:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392390;
	bh=B/rnJqWLTlb5WsL7V/G6xLQhXQ0YnNzEQ9SwS0U2Qeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1bu5bCgXE1Mrln6lrA91pG7AhsnckEKcv7+IqIl3ggj7/qbTNzNfs4c4nr4MHKIs3
	 WTiKgXw3OIT6MSGkZMna8DiNYOrx+oUb6qapn272YFELc1I9iYIIvWOfkDwVdPUy+4
	 bd32Uvperb4OnIEgLO/8jgNkiBMKl0p3lhx+d9Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Camm Maguire <camm@maguirefamily.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.11 401/558] parisc: Allow mmap(MAP_STACK) memory to automatically expand upwards
Date: Tue,  8 Oct 2024 14:07:11 +0200
Message-ID: <20241008115718.059616100@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


