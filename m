Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7061079D;
	Sat,  3 Feb 2024 04:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933528; cv=none; b=SaVZvk86ZUW7kGme6FT1XjDnc3kZSmvRsz2RnGB2YENaa4pRyPsuv37qG5Ji2erMMdHs3CfJGtmBuvhbHt7lnq0V1vcsIzN5okMziRTQf6ErjQ1L6xkq4yDKsg6XUv3mGyyh8zynCaGPaCRM8JHHM44+FMxR0WHwj3++tHviq0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933528; c=relaxed/simple;
	bh=0p6ONPXduCzhlLB6qogsMOUOswuuuw+yB23w6tXyoqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qsy1cUPimZs6nDlEZO6nxdheqJ2D83YixlQUAAW62IFpQV8uYgi5qYRTK5OFkQQCMgiF0O8OPlSPO7K3a9Z6IZg0J7zavVla2RTgxR8FoRfgEUOCKgPaNZ0yK7n2XaeFJBbXO+YLIVVU7/UuL8zI4uNNUQtG1sxguRMB4TZnxpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOI7jL7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOI7jL7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B2CC43390;
	Sat,  3 Feb 2024 04:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933528;
	bh=0p6ONPXduCzhlLB6qogsMOUOswuuuw+yB23w6tXyoqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOI7jL7ImIGfJOy2+Xj6oQW18uedLFxZOLYGnjCqTXvIX0zW6A3Q+7UklzuqxHEr7
	 qn8jurqZj+16rM8QjNPNCjbcpdktgZhLnyaRyBZeGnx0yxcuAGDd0rF/Qo2F8kFIpc
	 ZNSheW39RzvP7AbdeLQd1z+fLxd4uhNebgIYWaJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/322] s390/ptrace: handle setting of fpc register correctly
Date: Fri,  2 Feb 2024 20:02:23 -0800
Message-ID: <20240203035400.584803724@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 8b13601d19c541158a6e18b278c00ba69ae37829 ]

If the content of the floating point control (fpc) register of a traced
process is modified with the ptrace interface the new value is tested for
validity by temporarily loading it into the fpc register.

This may lead to corruption of the fpc register of the tracing process:
if an interrupt happens while the value is temporarily loaded into the
fpc register, and within interrupt context floating point or vector
registers are used, the current fp/vx registers are saved with
save_fpu_regs() assuming they belong to user space and will be loaded into
fp/vx registers when returning to user space.

test_fp_ctl() restores the original user space fpc register value, however
it will be discarded, when returning to user space.

In result the tracer will incorrectly continue to run with the value that
was supposed to be used for the traced process.

Fix this by saving fpu register contents with save_fpu_regs() before using
test_fp_ctl().

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ptrace.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index ea244a73efad..512b81473759 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -385,6 +385,7 @@ static int __poke_user(struct task_struct *child, addr_t addr, addr_t data)
 		/*
 		 * floating point control reg. is in the thread structure
 		 */
+		save_fpu_regs();
 		if ((unsigned int) data != 0 ||
 		    test_fp_ctl(data >> (BITS_PER_LONG - 32)))
 			return -EINVAL;
@@ -741,6 +742,7 @@ static int __poke_user_compat(struct task_struct *child,
 		/*
 		 * floating point control reg. is in the thread structure
 		 */
+		save_fpu_regs();
 		if (test_fp_ctl(tmp))
 			return -EINVAL;
 		child->thread.fpu.fpc = data;
@@ -904,9 +906,7 @@ static int s390_fpregs_set(struct task_struct *target,
 	int rc = 0;
 	freg_t fprs[__NUM_FPRS];
 
-	if (target == current)
-		save_fpu_regs();
-
+	save_fpu_regs();
 	if (MACHINE_HAS_VX)
 		convert_vx_to_fp(fprs, target->thread.fpu.vxrs);
 	else
-- 
2.43.0



