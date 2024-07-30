Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A737F1A6199;
	Tue, 30 Jul 2024 16:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356351; cv=none; b=MywwFPxeNNPl4hAqHspNS1s0VKF8R2WR/yRDY5t+lrtJ/tg10mach24IuTWPE+f5BrKfQpuGp01vHOQb+/jVq9FyQgm5cpIXgO46w3a+P/mPCi8h5KcIrTIKwfTEX2iqRZnJZqsE4zbRjMtZgZUXdXE7KmZn4v5+yNSdNEeyzQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356351; c=relaxed/simple;
	bh=FuLL64HinT/22NkuLu5MxphWWieAo3RohN3E4Fh4cW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WamEU12eugCZP16dSZ6xAuuFbJsFPvWLFWoXN678DrVfRiRyklXp5bAGiYBG6iQe7nt9wz8V6fv+bcon1I6rez6MqqxAxPSe4PmPNCapgcLfDU01al1vCl2r2up+IGK/vHsOPVGws/2Oqu1tYLg5mEMCUsiyXR9K2FY4GjYTWl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=na1L/ABP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="na1L/ABP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159D6C32782;
	Tue, 30 Jul 2024 16:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356351;
	bh=FuLL64HinT/22NkuLu5MxphWWieAo3RohN3E4Fh4cW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=na1L/ABPRpodDfPzjnc8zdO4yc4eVLAI8NFaiFMVbsfV6uLsVLygWFGoQGmhoI8Sj
	 0J44/gHESjEYIJHI7DqEkMiuQFCJ1DC1AQ0X2vogyFkOrh26wWFveWZVVK6Dti81Ux
	 KxI7eco3FkU3WCruT2fZLLy20tvG3FZfJDifYV00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanjun Yang <yangyj.ee@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 142/809] ARM: Remove address checking for MMUless devices
Date: Tue, 30 Jul 2024 17:40:18 +0200
Message-ID: <20240730151730.217013703@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Yanjun Yang <yangyj.ee@gmail.com>

[ Upstream commit 3ccea4784fddd96fbd6c4497eb28b45dab638c2a ]

Commit 169f9102f9198b ("ARM: 9350/1: fault: Implement
copy_from_kernel_nofault_allowed()") added the function to check address
before use. However, for devices without MMU, addr > TASK_SIZE will
always fail.  This patch move this function after the #ifdef CONFIG_MMU
statement.

Signed-off-by: Yanjun Yang <yangyj.ee@gmail.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218953
Fixes: 169f9102f9198b ("ARM: 9350/1: fault: Implement copy_from_kernel_nofault_allowed()")
Link: https://lore.kernel.org/r/20240611100947.32241-1-yangyj.ee@gmail.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/fault.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 67c425341a951..ab01b51de5590 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -25,6 +25,8 @@
 
 #include "fault.h"
 
+#ifdef CONFIG_MMU
+
 bool copy_from_kernel_nofault_allowed(const void *unsafe_src, size_t size)
 {
 	unsigned long addr = (unsigned long)unsafe_src;
@@ -32,8 +34,6 @@ bool copy_from_kernel_nofault_allowed(const void *unsafe_src, size_t size)
 	return addr >= TASK_SIZE && ULONG_MAX - addr >= size;
 }
 
-#ifdef CONFIG_MMU
-
 /*
  * This is useful to dump out the page tables associated with
  * 'addr' in mm 'mm'.
-- 
2.43.0



