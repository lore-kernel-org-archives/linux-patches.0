Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038968;
	b=ZFVZFluvqp/oJ7p/MN+lFH5DBPfc962yDRI68BhSXYzTuk0PIYDU75dClQpS3pJ83Nkw
	 xuk4BgFboqzLdcpMgJtBylJ7RcYe8GSzGX/vlJyq0C/4G5qIEc711hvAGtELGVd3ZlTf0
	 p8k9pXjRdVxLe0wf9kiP6ISVJi3WIGr1TRRxstNM2H/sBfbghRPn2gx6RGNSlv6EQMjzx
	 tM/XCf929UjpMOkosmm2Lk09ha7/vfWMUYBOyuqDlxswMz5H51G1w3qM9zlHIw0rVOt8K
	 KcdPU2x+ioxOsvOsQAGquAW3js1KfQTKhyG+xmpnCOhTJTvs8DAS9n0ejwahloevvIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yQCdZqgXfHCZs2m5ipVklb3Cx/tTeaJXChyhG859emI=;
	b=ngZviT0mQ0mG88JyAcfr/bf8EBYxkISlX+2XklO8mPpsfsyxAFeF0q/lgLzjH2/UnbOG
	 jK/Kqv7rCJLx2AwG3MXpFzynlt7TDIOb3+kWIFoj3mZH4TBKfuZoT1IYhINI6yeC/myfu
	 C75rZuVtQ9eiKS5HOk5DGpjvtZLTKaiyr+CGBVhUs+JMTB7YTHr/OjiNLfXdTMBebafvT
	 5Slb86Xf3fafrj795emE0932gQXyVvh19QLjv9euFPEBPy93eZlChiJS0hOsigUW3inIG
	 ceUj+YtJXIVFfYEDuIwSQyW5IZWu/tynFD4qi8FwaeiwGmn8/hzq8sC47FMjv2cqTkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPlIKVl0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CF9606A32A;
	Wed, 18 Nov 2026 21:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uPlIKVl0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1B41F000C7;
	Wed, 18 Nov 2026 21:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038967;
	bh=yQCdZqgXfHCZs2m5ipVklb3Cx/tTeaJXChyhG859emI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uPlIKVl0/PMX1EzSuVKur88zff5ANnomUu2I52lJmPOUqs0ERlwcSaiYeQS2gM7L5
	 WXkKXWDIXr+QHmpRGqLqBuplFYfQouuTgv0ZvxEzMxbZyB9rJcYZLn5XnuYis16TXM
	 rvRkbyRZNj1WgDeajbzrgCjXeEDWkyj4boeTmfi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1933/3318] mm/vma: dont leak the charge for stack growth
Date: Wed, 18 Nov 2026 15:42:35 +0100
Message-ID: <20261118150420.025972863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit b1ee87802111156e27557e82acc31fa7dfc76e2a ]

acct_stack_growth() charges stack expansion even without VM_ACCOUNT.
This can happen for read-only or MAP_NORESERVE mappings created with
MAP_GROWSDOWN. Unmapping these VMAs does not release the charge, leaking
Committed_AS.

Only check and charge growth for VM_ACCOUNT VMAs, matching mremap().
Unaccounted growth skips the overcommit check while remaining subject
to the other stack-growth limits.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-44-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Replaced vma_test(vma, VMA_ACCOUNT_BIT) with a direct vma->vm_flags & VM_ACCOUNT check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 10d5e416e80d1..d1cabe718b63f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1957,7 +1957,8 @@ static int acct_stack_growth(struct vm_area_struct *vma,
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
-	if (security_vm_enough_memory_mm(mm, grow))
+	if ((vma->vm_flags & VM_ACCOUNT) &&
+	    security_vm_enough_memory_mm(mm, grow))
 		return -ENOMEM;
 
 	return 0;
-- 
2.53.0



