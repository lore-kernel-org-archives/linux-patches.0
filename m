Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFAA22171A;
	Tue,  8 Apr 2025 10:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109907; cv=none; b=pjHNGyFcwe0Va1OyY8EHEM2rhlEaPVSWW6hHcxXSrK/A+7j5NkiX67/2xBVetuD/eTl1DFskbQZE7+9A+8WVKgXgQjlIwJkyT0ZxLOMSIzltxx2sjStTh9cISOTDpaPt6ZIHVb+Y086DLcxZDuWE3NEadghxjrquyAudZYAHcAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109907; c=relaxed/simple;
	bh=VWYbfDHKlbUFiIOsM2u1VVEnh9YxJr0PLrekLUTMq6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpOe26SQPGrBxbVm7KBPfQzrUTrwsS2qsxenlqcu9hGSBY5vbOPnPofHJIBTW+/DudHUJKPKvii9jK6tI6+tCH5jcFtXbYFQJzUnCdWnmI6hzLpjPGIEQ/K+zeHe0c/I9O8KhqlZpLgV7mMJXmogo7n8r5kU7+RQq+KIk1h2kWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwxLCLPL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwxLCLPL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F923C4CEE5;
	Tue,  8 Apr 2025 10:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109907;
	bh=VWYbfDHKlbUFiIOsM2u1VVEnh9YxJr0PLrekLUTMq6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fwxLCLPLJ+/z2TwbCEhW4iUXsbJmYiDvP1lPK5kkboWUds9zFk9X2kO43dAr49if2
	 KCOOGW6IdzYS3ymDYzoxISHaSBce/2Njc9eBJQCfGRspXXn1HMqg43r6mDOdmxUlAH
	 2XIZN7W36HVoXlSxYsdgPtCmao67YSDOLb/sI2Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanjun Yang <yangyj.ee@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 5.10 098/227] ARM: Remove address checking for MMUless devices
Date: Tue,  8 Apr 2025 12:47:56 +0200
Message-ID: <20250408104823.304445009@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


