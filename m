Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707842FA631;
	Tue, 17 Jun 2025 16:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179225; cv=none; b=dGU8Walw1zfwjNJFyOA/5wFpuGYP5R+Z0PhUSNIF+Pni2Mhb2EAv+p/0X3pJalgOOkHhL8OmYg2XGBVN43Zm/h39k6mV7SMrCNQF9WItyReSzeHJhGgikEJ1hdrD39j8iUewKTIQ24ZMP7Ld4Lwu69zLGreh1fPUlwhDqkfl4Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179225; c=relaxed/simple;
	bh=a4oxds3GucSYMb9BrZ5lvf9APJfMhlca6HlRJYYo25M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxAoaSQOz6zsbekxqAFjbwVYWJRncMEh3XNiunZTcINV+Y1MubAI7tbpWTD6kkA+OEW4KO0hvKIt43+n4/2l6mPN+fSayg0Usj6CtlvOhNv0aDEtRrE2xzQPh3PDxk7Ys8ytQBq9CWrfWiEvnycMwlScounK0Xh4VpeU/vZJ6/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKTnvXtj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKTnvXtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A91C4CEE3;
	Tue, 17 Jun 2025 16:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179225;
	bh=a4oxds3GucSYMb9BrZ5lvf9APJfMhlca6HlRJYYo25M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKTnvXtjV7dprMotlhss5WV3jv1wF0s1ZEJgPo9jPgu1kTw52r4o78aKyEnUXk66H
	 qpf6vy8R7HbGMd+vGBIgHqQKzJUxWAHFiKFN/0r2MjQTDmTzuTTOGZtFIp1kjWPqU2
	 ejbPH5oRaek4+OpxMAtq15OIo1P1KEePK5xeLJ1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Greental <yonatan02greental@gmail.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 687/780] powerpc/powernv/memtrace: Fix out of bounds issue in memtrace mmap
Date: Tue, 17 Jun 2025 17:26:35 +0200
Message-ID: <20250617152519.468065293@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

[ Upstream commit cd097df4596f3a1e9d75eb8520162de1eb8485b2 ]

memtrace mmap issue has an out of bounds issue. This patch fixes the by
checking that the requested mapping region size should stay within the
allocated region size.

Reported-by: Jonathan Greental <yonatan02greental@gmail.com>
Fixes: 08a022ad3dfa ("powerpc/powernv/memtrace: Allow mmaping trace buffers")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250610021227.361980-1-maddy@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/memtrace.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/memtrace.c b/arch/powerpc/platforms/powernv/memtrace.c
index 4ac9808e55a44..2ea30b3433541 100644
--- a/arch/powerpc/platforms/powernv/memtrace.c
+++ b/arch/powerpc/platforms/powernv/memtrace.c
@@ -48,11 +48,15 @@ static ssize_t memtrace_read(struct file *filp, char __user *ubuf,
 static int memtrace_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct memtrace_entry *ent = filp->private_data;
+	unsigned long ent_nrpages = ent->size >> PAGE_SHIFT;
+	unsigned long vma_nrpages = vma_pages(vma);
 
-	if (ent->size < vma->vm_end - vma->vm_start)
+	/* The requested page offset should be within object's page count */
+	if (vma->vm_pgoff >= ent_nrpages)
 		return -EINVAL;
 
-	if (vma->vm_pgoff << PAGE_SHIFT >= ent->size)
+	/* The requested mapping range should remain within the bounds */
+	if (vma_nrpages > ent_nrpages - vma->vm_pgoff)
 		return -EINVAL;
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-- 
2.39.5



