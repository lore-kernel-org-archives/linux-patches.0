Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F499263F3B;
	Tue,  8 Apr 2025 12:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113996; cv=none; b=UvGh3rk7tMUFNzq5ZyIgP/LIDNEsPaenuDSRafAXB0kN+03DDZVQLjF8WkRLhUOstmuxdRn0jHV36xSCne5BGn5gv4v0EutvbHMBpj0KQ5dwxg7MgxPY2FRaRkWxbRqofxfI8TnDqooyerLzzqnXcKIGJC/YHzEhojTgbCleb8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113996; c=relaxed/simple;
	bh=20bvDM3nFV7LvUPUSrn2dU9guSmIkyLw/t6TRakCoy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=So4TO7XeQSVYjdHLfH9H4AYX/vXIOei59CCBLFto9rlSMd1b0AdYR7MbMFMAnJCkiuOpHanI4LZGjtJtR/PC8Pi1nss8xN1XC4CPoP5ExaT3+Qm+Y4Q0df6RRLhFrfJ3yS5JQoXlmludbw5jKu2MSsDiqAFaQpw27SbJyqLo0wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EMMK3mX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EMMK3mX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21811C4CEE5;
	Tue,  8 Apr 2025 12:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113996;
	bh=20bvDM3nFV7LvUPUSrn2dU9guSmIkyLw/t6TRakCoy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMMK3mX8wgRBOUf96azAEhYxQbrw5GgpTWqZjWzhcX0YaKqCvJVZkKFT/W4vZKfMX
	 HCeCUoVpCTIYLL+iq/hV8EmIP3p3hAQrmy64Mr5t7f/tL6VZXOkFGWZjkDdmZW7P5Z
	 YhLBZpDn0nrlJCiDE2Ay7UgyLpwax75GW6Lhkg9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanjun Yang <yangyj.ee@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 5.4 071/154] ARM: Remove address checking for MMUless devices
Date: Tue,  8 Apr 2025 12:50:12 +0200
Message-ID: <20250408104817.577533798@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


