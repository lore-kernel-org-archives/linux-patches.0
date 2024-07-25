Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBFB199E9F;
	Thu, 25 Jul 2024 14:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918647; cv=none; b=lcZfLb3aBjwGNCQlRZJYEnnqupq249eWva7RFOCiu4IaIcmItOqYmg9qdvBrTNQDUvoGRQMLTSYP3w1GS8PWLJdnXPm4tupf49oX0sF8Yux2IVuk1wg/I4VDvYyucOMRjZwzIo6DNmVjF25NVuxiahBM4YmX1tHU835JwwWugko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918647; c=relaxed/simple;
	bh=OwMny5WJMRCQsVIhx/wPY8sI4WtIBUs1zM8ZjI88s3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiygTIw40Mrnv5z6TjLlsrAq3wN7+ULYjmFpeM0pbk1XhtiORcqxQHOv6M+Imkn3xfcRhQn9CY+8hhMJxdTG6zYTWgyDHSFA3SDaJca0X4L0YQszpSNiHGD/t39VNiN3XWgFnea9QNDYODWMlIOBlzTRAmxCwe71TxN76taogNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vc7kIzVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vc7kIzVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D209DC116B1;
	Thu, 25 Jul 2024 14:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918647;
	bh=OwMny5WJMRCQsVIhx/wPY8sI4WtIBUs1zM8ZjI88s3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vc7kIzVUv4nfEx9ElvhiC0E6+gRHBPShU7yXe01LXtZPW8Q+82+3/GLRnBRYCLbBO
	 tQtuKHu/BDIXo3Rwc/DL/uyYpr7/hYlj+RRmZ8qQIJkLr0HedN/mafYnaMvnqaI4+7
	 LRXaYUjxaAb5XJFyo/luXcKFdfeYuW8JcLOEjE6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/43] mips: fix compat_sys_lseek syscall
Date: Thu, 25 Jul 2024 16:36:40 +0200
Message-ID: <20240725142731.124981402@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 0d5679a0aae2d8cda72169452c32e5cb88a7ab33 ]

This is almost compatible, but passing a negative offset should result
in a EINVAL error, but on mips o32 compat mode would seek to a large
32-bit byte offset.

Use compat_sys_lseek() to correctly sign-extend the argument.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/syscalls/syscall_o32.tbl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 353539ea4140a..5f2c2636e7a4f 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -27,7 +27,7 @@
 17	o32	break				sys_ni_syscall
 # 18 was sys_stat
 18	o32	unused18			sys_ni_syscall
-19	o32	lseek				sys_lseek
+19	o32	lseek				sys_lseek			compat_sys_lseek
 20	o32	getpid				sys_getpid
 21	o32	mount				sys_mount			compat_sys_mount
 22	o32	umount				sys_oldumount
-- 
2.43.0



