Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD1824337D;
	Thu,  3 Apr 2025 15:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743694026; cv=none; b=OvrzOPbn00C1MDXwhYP4jyZgThA3RBBrE4Oo/SWi13620VBXc3x+8eYJvuUT+rc2DR+F6vFgtZ+RmvzerWw2TBi88UV0SM2Xxjed5TcLzxC5LxuINA+ZcnSGBu7crM5kI6yMeCcXTF25pT6cSlJTOSQwKyT3ADrdp4nn9UjLjWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743694026; c=relaxed/simple;
	bh=Tt9dbrtbQ0k1A9WxoF5QUWkDMsh1KeIie2obRVrFNTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBkIo1XVt0mon6SFob89l2mPkw5FV4a+Irp6xa3n5GAztFeRKNGfVxoGZaQKN8hjIpMTDg3RoYKeNLNynvqRyiVRrDOiDbZ5vhTio7KDQYo5FlrU4EXHZI8vKXP2ouSWD+t1fR+O77gE+VMXTjrp5zAc693zPaJpDWsOcir2T+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pn9ZXnQ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pn9ZXnQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A72C4CEE3;
	Thu,  3 Apr 2025 15:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743694026;
	bh=Tt9dbrtbQ0k1A9WxoF5QUWkDMsh1KeIie2obRVrFNTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pn9ZXnQ7dEI3JqiiRm6l8H5FRuZ0mkzwha3XbwqvPLdpQTTv166g30KF5xdm/NMIB
	 H3l7yX2u/TRz+yOvNSO7NJmo8OqpTENkeY3plu0y8x/Ogj3T8obMGve+2P2yQ9Y1zM
	 IWu9zk34vuHg05mD8Q6sCvJDpiNdqVJJv58PNG0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanjun Yang <yangyj.ee@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.6 06/26] ARM: Remove address checking for MMUless devices
Date: Thu,  3 Apr 2025 16:20:27 +0100
Message-ID: <20250403151622.599929673@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.415201055@linuxfoundation.org>
References: <20250403151622.415201055@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


