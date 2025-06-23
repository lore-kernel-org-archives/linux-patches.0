Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C63D219E0;
	Mon, 23 Jun 2025 21:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713749; cv=none; b=BPuBhcApzycU20W+BMC3vLS4b23Vg0zJz9NfvXQ3Rrjl1T2Idjg3fjBtBrY/k3HAfqIlSAUvIgvLdiIZU98Vh3XQQgF3gS0mdaUSDOkYsCsGx+syHjA/v0BgqaMCItKebRSm+OJuLQzxqb+PRhKyGRc0UFw4p9ChG17iCLlRZ+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713749; c=relaxed/simple;
	bh=ANNng+4wRf/S8tBkdWTmY9yCrqRJMdHzAG4YO+1DWuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6viyXJUJBtDbn05kHeDXWDM04F79xJkgCH5gzQYf5y0UVtVARKnbXbwITOlU6AsBHY5k3UehzZo3j7QFtUoUZsT72SLbDv6bPo0kVqJxiOUoilcnbclI8ukmftc8OOIgo/33Cx22dE9r50o69kqN8M0Bid8A7D3eBf1O1k0t80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6iLdOKL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6iLdOKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94EAC4CEEA;
	Mon, 23 Jun 2025 21:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713749;
	bh=ANNng+4wRf/S8tBkdWTmY9yCrqRJMdHzAG4YO+1DWuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6iLdOKLpfDwAFCZHf0NTLmWBdjwDEz1WEgGByOaK7ip13IkDeOmjwzRhKFhtXpZA
	 UIPX2fOJul7Zb5/VSiUNHCfskmw1mGGpPqSNFgouhrmXUwjahYZBqp1zSGKItu7p84
	 5gwR4ovsZt3RAPEFHM0tHddxMLkEVMZCSJv6Xua8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Greental <yonatan02greental@gmail.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/411] powerpc/powernv/memtrace: Fix out of bounds issue in memtrace mmap
Date: Mon, 23 Jun 2025 15:04:48 +0200
Message-ID: <20250623130637.235289286@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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



