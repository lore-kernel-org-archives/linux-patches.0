Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BCF1FFC48;
	Mon, 23 Mar 2026 14:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275587; cv=none; b=qGkUo1aaZCTmkb5IVz8cSWOEX7cejfxxi90+Hm9iN+YMD6HpzBOALtvlPndTr3AIJ9zU0C8Xvxvfs/rPEFxGbF6yxdBBwD841w7n34bwkeL5+/UbFhqDPJAy9BsUEXk7MlIApV/e0cUJcBdNxwkoOubeAydw/bUVu/wP/8z0fBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275587; c=relaxed/simple;
	bh=oO6AxUBBeD7x60f9FxHM9uSpJuw5zj4YfIUEPCU3bPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5fcNdzStkzqaIv6w979/hMK1J5Fkj0yE6XLf7a2EUco8kTINK6IGRklHo3XPm9bf63fSkKJwy1L56ickNcodLN9fZ5XTveqqM0D1fQNGku34RKOvhgGhH3t6knaAEJtvkj4IL6GknyqUokoCyKHV3i8cWsg0y0j+lnRvhLChi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gg+mREb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gg+mREb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44288C4CEF7;
	Mon, 23 Mar 2026 14:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275587;
	bh=oO6AxUBBeD7x60f9FxHM9uSpJuw5zj4YfIUEPCU3bPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gg+mREb3DNXUDhIH4KUN2xZ0rFjkUNCDofv6QS+6KmJxJeAHbc4qFh9S1vQfc58vl
	 5Z7hVbcedHtkdggNefHkpDy/3PT/J3EvXsexFU22lT+wjNTUhVKuN0XVq8sCHQ8xKu
	 NdWr1YRTxVvBRObJCVKludbnsYutrqQTPo2RulQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.12 145/460] s390/pfault: Fix virtual vs physical address confusion
Date: Mon, 23 Mar 2026 14:42:21 +0100
Message-ID: <20260323134530.146034445@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@linux.ibm.com>

commit d879ac6756b662a085a743e76023c768c3241579 upstream.

When Linux is running as guest, runs a user space process and the
user space process accesses a page that the host has paged out,
the guest gets a pfault interrupt and schedules a different process.
Without this mechanism the host would have to suspend the whole
virtual CPU until the page has been paged in.

To setup the pfault interrupt the real address of parameter list
should be passed to DIAGNOSE 0x258, but a virtual address is passed
instead.

That has a performance impact, since the pfault setup never succeeds,
the interrupt is never delivered to a guest and the whole virtual CPU
is suspended as result.

Cc: stable@vger.kernel.org
Fixes: c98d2ecae08f ("s390/mm: Uncouple physical vs virtual address spaces")
Reported-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/pfault.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/mm/pfault.c
+++ b/arch/s390/mm/pfault.c
@@ -61,7 +61,7 @@ int __pfault_init(void)
 		"0:	nopr	%%r7\n"
 		EX_TABLE(0b, 0b)
 		: [rc] "+d" (rc)
-		: [refbk] "a" (&pfault_init_refbk), "m" (pfault_init_refbk)
+		: [refbk] "a" (virt_to_phys(&pfault_init_refbk)), "m" (pfault_init_refbk)
 		: "cc");
 	return rc;
 }
@@ -83,7 +83,7 @@ void __pfault_fini(void)
 		"0:	nopr	%%r7\n"
 		EX_TABLE(0b, 0b)
 		:
-		: [refbk] "a" (&pfault_fini_refbk), "m" (pfault_fini_refbk)
+		: [refbk] "a" (virt_to_phys(&pfault_fini_refbk)), "m" (pfault_fini_refbk)
 		: "cc");
 }
 


