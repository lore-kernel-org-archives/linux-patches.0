Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A15314D0D;
	Tue, 31 Mar 2026 17:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976926; cv=none; b=cK8Fyir2jAHAhumSbc/zD2LPeIMJekD0O28tG5KFc1tAx9INRJvA2yZztEdRLBnS2pvCX+l4KZHLvMntdDYtoTBU+uMdMxe9COQAciYPoV+9tICb4c5dJ7/YT9WhxVwbV+KQCmdr8SmJIJIXSDRdEejh3JJrUGfyeRyfSlOHr1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976926; c=relaxed/simple;
	bh=yUqp8A1jyCS4bATYYEJqbsfXKOhL5jtpwRGyV4+hYn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKbweK9IPkVp38w0dtTSiz328qsKBbiks4HEjPlWfgHre2u5pfVXzu9zaJ/K0Fy2JoknmotTTmfzPEmxdcQjghvDceRnygCydj5Co3KNPHaxYTn4wLoNb4/6x9nPv4sFWxSjiawBTB9tB9Tx+rFLP8/PcAn/LqEmu+g++tIq4SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWm5XRlP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWm5XRlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AF2C19423;
	Tue, 31 Mar 2026 17:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976926;
	bh=yUqp8A1jyCS4bATYYEJqbsfXKOhL5jtpwRGyV4+hYn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWm5XRlPbPGWBWSQAl2c78XOSOr7yPtV1BQbsP/OFrs53CN3xCXSvzsy0lWFlz+PJ
	 ncNICwbZ+8MU+0IQJcwVeheixwrXgUwrmWIZJ7rybTymYOs5ilnbL/fsSAoSiJGYyz
	 WnO+h4b4PwXRNJWvDmXgW7EZhlazqcO6YDc2NAmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Antonius <antonius@bluedragonsec.com>,
	"David Hildenbrand (ARM)" <david@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 282/309] mm/mseal: update VMA end correctly on merge
Date: Tue, 31 Mar 2026 18:23:05 +0200
Message-ID: <20260331161803.950072738@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

commit 2697dd8ae721db4f6a53d4f4cbd438212a80f8dc upstream.

Previously we stored the end of the current VMA in curr_end, and then upon
iterating to the next VMA updated curr_start to curr_end to advance to the
next VMA.

However, this doesn't take into account the fact that a VMA might be
updated due to a merge by vma_modify_flags(), which can result in curr_end
being stale and thus, upon setting curr_start to curr_end, ending up with
an incorrect curr_start on the next iteration.

Resolve the issue by setting curr_end to vma->vm_end unconditionally to
ensure this value remains updated should this occur.

While we're here, eliminate this entire class of bug by simply setting
const curr_[start/end] to be clamped to the input range and VMAs, which
also happens to simplify the logic.

Link: https://lkml.kernel.org/r/20260327173104.322405-1-ljs@kernel.org
Fixes: 6c2da14ae1e0 ("mm/mseal: rework mseal apply logic")
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reported-by: Antonius <antonius@bluedragonsec.com>
Closes: https://lore.kernel.org/linux-mm/CAK8a0jwWGj9-SgFk0yKFh7i8jMkwKm5b0ao9=kmXWjO54veX2g@mail.gmail.com/
Suggested-by: David Hildenbrand (ARM) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mseal.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -56,7 +56,6 @@ static int mseal_apply(struct mm_struct
 		unsigned long start, unsigned long end)
 {
 	struct vm_area_struct *vma, *prev;
-	unsigned long curr_start = start;
 	VMA_ITERATOR(vmi, mm, start);
 
 	/* We know there are no gaps so this will be non-NULL. */
@@ -66,7 +65,8 @@ static int mseal_apply(struct mm_struct
 		prev = vma;
 
 	for_each_vma_range(vmi, vma, end) {
-		unsigned long curr_end = MIN(vma->vm_end, end);
+		const unsigned long curr_start = MAX(vma->vm_start, start);
+		const unsigned long curr_end = MIN(vma->vm_end, end);
 
 		if (!(vma->vm_flags & VM_SEALED)) {
 			vma = vma_modify_flags(&vmi, prev, vma,
@@ -78,7 +78,6 @@ static int mseal_apply(struct mm_struct
 		}
 
 		prev = vma;
-		curr_start = curr_end;
 	}
 
 	return 0;


