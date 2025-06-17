Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979BC2FA64D;
	Tue, 17 Jun 2025 16:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178229; cv=none; b=PjsEXGRenM8iZYj7mjV30Qk0qXVjGV/Y4QpmwpkLWgeZnQ0y6c6D0AKXuD6utdJy6c26GCaeprupVSGyhdWqkF31o+0pTaih5/DXXwAma2LJ+zis+njzqGy61sRp5k6Y7Y9s98d5UkwYnDynPFXow/LZz0nKFjsNjsFHLLFOjhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178229; c=relaxed/simple;
	bh=qnkdNJlzd5zntKXFFMkdjjoRACA0O/91M5sMI++XvP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7KRRcqIOqm2DCFU0uow9unShbJBUHFrsYxMUZu1rtJJ+Bjr9NdPwKhE3RJz46lku+EE2aItU2KVmdTz990wq31AFQHhONW6F0AsuhGAbMvHaAR9QUsrw6q4aMevp6w/CJPqvnYCPyN2hvoHo+2PrOkdXL6hYnAmWl+6+oJvq0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUHfpP3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUHfpP3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057FAC4CEE3;
	Tue, 17 Jun 2025 16:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178229;
	bh=qnkdNJlzd5zntKXFFMkdjjoRACA0O/91M5sMI++XvP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dUHfpP3i+xBJ+mlEJPTARHhrikPCws8DYjLwfpxLvQyux6ZN2GV+a+TlF1xcPitlJ
	 +wWM/shHq5VXvsM0Wb7UYChwkB/Mg+skexSUDvC1DjuhUQBqKqbV3sZJyxP/WIf4AB
	 b5S/gErkQUHkJKdOlA+RqkTrWoo5qWi3avnXuw5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Greental <yonatan02greental@gmail.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 443/512] powerpc/powernv/memtrace: Fix out of bounds issue in memtrace mmap
Date: Tue, 17 Jun 2025 17:26:49 +0200
Message-ID: <20250617152437.514354093@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 877720c645151..35471b679638a 100644
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



