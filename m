Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C75D1CEE8E;
	Tue,  8 Oct 2024 12:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390620; cv=none; b=X2a6RGStXhqu8iY/sUIqedRv4ti5NU9OUpjHzY50LNnOy3WS6FFAc/Hp+bjztITxNlFbHBDr+5KI4wi+ePsYiVhEoq5800SUUsy2keqkBjNNppf2VkH+HBR/Dl1kt0NUpfmXccyxlq39W0e5cZPFAQNoqRMQ+Q7KcmpTywzb08k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390620; c=relaxed/simple;
	bh=hIX9l8Ue3+ceK7nMEgbzPxJcm2eqg/PmwliN4YRccG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkYsiXI245O5QWnNELvfirRNiqV7PWQNQDl35bmt+7AVwQdRstfTnUfiesCfh6237KRfB9MoOUXAf6aVl/GZ4Xq0DycocTAVpaBgIkqWU/X2t0QEx8xZYDbj7uuWBfhYTzV8vSA6/px0o307otnpT476oYb33q2GXf+RsO3Rbhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEo/8Rni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEo/8Rni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C327C4CEC7;
	Tue,  8 Oct 2024 12:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390620;
	bh=hIX9l8Ue3+ceK7nMEgbzPxJcm2eqg/PmwliN4YRccG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEo/8Rni+kqdnwE3LFhH+taueJAVPUXx4dQSkPeEKRHmCsd0mnb7i02KqoCnjeiCa
	 I3XUqM8YfV14Ap2JdG9dTy+LYquBvBkUW/uuvtRTKlhal3rGr57/zeUTJfj61vmcHD
	 H9dAnM9Q3xpvnoEZov5owqNsmOIDeTMj00Z3eeOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Camm Maguire <camm@maguirefamily.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.10 342/482] parisc: Allow mmap(MAP_STACK) memory to automatically expand upwards
Date: Tue,  8 Oct 2024 14:06:45 +0200
Message-ID: <20241008115701.883028305@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


