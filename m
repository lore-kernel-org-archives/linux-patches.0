Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB11250C11;
	Thu,  3 Apr 2025 15:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693789; cv=none; b=MQwSqIawFs0IH0RDh8ZNPWMzMUX75j8z0WBhyXNbYsQQKWFDuyF31E0KOXQDT97mDTXgt+zqFe+AAIN78SR+UyqBs9qvdeg4YIEIHPm0M3iKNL+w63NpgJvclaOwQCkZWia8IDrsXiubgpIX9TWJ7m6cKO/Iet7u8nf8SsIHgPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693789; c=relaxed/simple;
	bh=WF0WrHl30x3N75JVIBnjDbf37V9y4wT6jeYTqEJ9pMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBqiyMqiCAQqGrkrX4yihuuJjg6WaOmMomflTWTBaRze6kFb3YYx8qkYaeVmu3l1neKtx6IAsXgYiQHSL/XrYbKYQ8LPoC1ZdhmrmwuZ4utnI7KFvQJ8nqlNy9lns5U/kz9PZZmDl17HpIUuz5pOqMnaL4hY46yxJD5GjPxKrQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GcFpLm4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GcFpLm4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D394C4CEE3;
	Thu,  3 Apr 2025 15:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693789;
	bh=WF0WrHl30x3N75JVIBnjDbf37V9y4wT6jeYTqEJ9pMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GcFpLm4sbN3Dn+Te+2C785UjEe3CTqtD+bYXHq7ACcStQDXTD3sGFJCNv057PZ1MY
	 DGdoc5HtwfCouN8Nj+mBjiPloaSZrAMiBbZ0K0tk10l/Q9f0U7BVr6HmVRJcaBKtyR
	 IeBAFxbvOYL5xV09TN2UhNSpXBYccr8+zYeAltyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanjun Yang <yangyj.ee@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.1 06/22] ARM: Remove address checking for MMUless devices
Date: Thu,  3 Apr 2025 16:20:01 +0100
Message-ID: <20250403151621.125457424@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
References: <20250403151620.960551909@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yanjun Yang <yangyj.ee@gmail.com>

commit 3ccea4784fddd96fbd6c4497eb28b45dab638c2a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/fault.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -25,6 +25,8 @@
 
 #include "fault.h"
 
+#ifdef CONFIG_MMU
+
 bool copy_from_kernel_nofault_allowed(const void *unsafe_src, size_t size)
 {
 	unsigned long addr = (unsigned long)unsafe_src;
@@ -32,8 +34,6 @@ bool copy_from_kernel_nofault_allowed(co
 	return addr >= TASK_SIZE && ULONG_MAX - addr >= size;
 }
 
-#ifdef CONFIG_MMU
-
 /*
  * This is useful to dump out the page tables associated with
  * 'addr' in mm 'mm'.


