Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9193619AD5C;
	Tue,  8 Apr 2025 11:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112567; cv=none; b=D2L07bn4tC1RZDuU4JMIqFGnHU1A12Fc/U/HzNGu4BGNHsI9a8Wf4WstDsw/8UCv1xwHRQwYFi5pbRDatHlF3YivLBUUYNedPYs66yTqO9Q04PV8ESgh55GSg0Zk6mWwyOcHkP25uuVQfDrwb/YpeEZvZMY/H5SIR+4GF5T727w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112567; c=relaxed/simple;
	bh=VFVhapmxzQvrCoLO0hdE/VQeMCKeSX7BPC54yUVRJIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cygNRC/mLssxhdutCM5jCT0l+rk/Ysff4okYLyu7YWMn1e8YeqIqgw6xnF59ZkRPRo7q3OSOFpjbihgeydvCbsjd/mUb4A9/tzjiGDnmaorE8Gygmh/nUz4qyeIK5azPhyryS8teQMWtO4s6k++kFBW4brzx0U97xh90BzWPptg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWy8+xAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWy8+xAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B97CC4CEE7;
	Tue,  8 Apr 2025 11:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112567;
	bh=VFVhapmxzQvrCoLO0hdE/VQeMCKeSX7BPC54yUVRJIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWy8+xAPMJt4zmsyMnNJ5prqscZ8Va0ZExByQ7CNsNsze3z2OBVqWV8l/WZnqHPBk
	 +f9wNjmg0IfoRC0hPxuCvxW6eVwfjENjEF7JJ8LnnhPP8gKhZjdcIgtUIQ2fnmBK+n
	 DPQvI3xO4GlUkcNPlQpcWrhs4UeVkVtBbUcaxN6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanjun Yang <yangyj.ee@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 5.15 115/279] ARM: Remove address checking for MMUless devices
Date: Tue,  8 Apr 2025 12:48:18 +0200
Message-ID: <20250408104829.451064332@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -24,6 +24,8 @@
 
 #include "fault.h"
 
+#ifdef CONFIG_MMU
+
 bool copy_from_kernel_nofault_allowed(const void *unsafe_src, size_t size)
 {
 	unsigned long addr = (unsigned long)unsafe_src;
@@ -31,8 +33,6 @@ bool copy_from_kernel_nofault_allowed(co
 	return addr >= TASK_SIZE && ULONG_MAX - addr >= size;
 }
 
-#ifdef CONFIG_MMU
-
 /*
  * This is useful to dump out the page tables associated with
  * 'addr' in mm 'mm'.


