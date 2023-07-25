Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F65B1EA74
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DDDC433C9;
	Tue, 25 Jul 2023 10:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282188;
	bh=8/5W2GXxWmIbAvkf807Q61r5u9UpymPMwxCirb9fScE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiTz9y2waYEqstR6nDVf264JUbeMKLK7wiC9sHZ2wSUdWKnLhRieP0P8w9w0PoG55
	 35Uz46eBqKlPyh0y44tvB4ztZbMHjlzWM93Zb7Nd7ZT6C/jT0S5kA2XLEwJ2c18Z2B
	 YI4ue0GQ8Isho8xbE8zC4OGiBHBHpcLDtH8Jm/dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	matoro <matoro_mailinglist_kernel@matoro.tk>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ia64@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.4 032/227] ia64: mmap: Consider pgoff when searching for free mapping
Date: Tue, 25 Jul 2023 12:43:19 +0200
Message-ID: <20230725104516.170600624@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit 07e981137f17e5275b6fa5fd0c28b0ddb4519702 upstream.

IA64 is the only architecture which does not consider the pgoff value when
searching for a possible free memory region with vm_unmapped_area().
Adding this seems to have no negative side effect on IA64, so add it now
to make IA64 consistent with all other architectures.

Cc: stable@vger.kernel.org # 6.4
Signed-off-by: Helge Deller <deller@gmx.de>
Tested-by: matoro <matoro_mailinglist_kernel@matoro.tk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-ia64@vger.kernel.org
Link: https://lore.kernel.org/r/20230721152432.196382-3-deller@gmx.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/kernel/sys_ia64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/sys_ia64.c b/arch/ia64/kernel/sys_ia64.c
index 6e948d015332..eb561cc93632 100644
--- a/arch/ia64/kernel/sys_ia64.c
+++ b/arch/ia64/kernel/sys_ia64.c
@@ -63,7 +63,7 @@ arch_get_unmapped_area (struct file *filp, unsigned long addr, unsigned long len
 	info.low_limit = addr;
 	info.high_limit = TASK_SIZE;
 	info.align_mask = align_mask;
-	info.align_offset = 0;
+	info.align_offset = pgoff << PAGE_SHIFT;
 	return vm_unmapped_area(&info);
 }
 
-- 
2.41.0



