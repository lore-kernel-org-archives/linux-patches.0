Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591576;
	b=R7KWAGGuBq9+TJL2kI3R6pjAY1aLxyzwi5wXYolr41sgGxNVSiuKTbZc4FX05uP0AzYf
	 INsm9RkzPdCVTBZrHKaZ4u5kxgGA8PILJah3Rjy2wywOEs0MiYXzfIBHN+al2DwTPgHxn
	 X5SC6RfcVpASRr/kYFoCNfOVVK8iXJuNVOG+hoHbt6LmMt5Dvcdlwq/Y2z0QlxJNnf9lB
	 YZW5FilETFy8MdFQu0Qf7CkxHmPGfa159eZTlAcXAJzQMDK9Afj4Ool/KDq2+dak37fhe
	 kSlS2AlDxlQcWBjF2Xh+16ACMXMdkrHwirlRlltZ9XzGAwAJ9ofCz1jjhniOkL1eYZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OEl7Mi3avismWvHUKbfpMKxAv1frIOTBZh+KFxr1Qj0=;
	b=JB5Fo1lV4rSLsv2MNoRkyYc/ujhQ28UNrw6RQURTxDP7dIsDo3HCS3WaJM0jPd8W0YRO
	 OKMqaTKVXVn86BJ+9DvuSBOizs/xDhl4gQHlvICQBjtr9RdBpoJx5QrSwSAj+C9aHajTL
	 N3doGAYHsB6J6HWjKHsk6Gmnnz+xkTBaJtZakfJDw/yjfnERHBwePl1ASdq+RR5qUmuAc
	 7SC01sWiMPwglsCvNE4rE16zf7s8wJz5UgamHDSpeQJpvnKqU/OM4uSL9PL6kP0i8aqI4
	 fsrwaKpkbHppZPdHxeqSc+kIkNaqRB4E11iqvds4lQm2qxsuf25486VH4vmwlTV/Szw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XahBX/L8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452E2606E64C;
	Fri, 13 Nov 2026 17:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XahBX/L8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12271F000C7;
	Fri, 13 Nov 2026 17:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591576;
	bh=OEl7Mi3avismWvHUKbfpMKxAv1frIOTBZh+KFxr1Qj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XahBX/L8ub1WaEr0LtLSyipaGdQ37Gzh0ohYQ9hjmp69fV71KpXJDXDnHoB1DoL/I
	 8J9Hd9cLrhKPcLOkDL6zq/hEdXhf4samLqEiM2eo5udQFv0h2dHNjRgsoyS8UIWTlm
	 wWAqv25K2WN+gRPec/0RJ1WZbSMYNakN2gQ/DuuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Adam Litke <agl@us.ibm.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Rik van Riel <riel@surriel.com>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 607/670] mm/vma: dont leak the commit charge on mmap failure
Date: Fri, 13 Nov 2026 10:52:51 -0500
Message-ID: <20261113153832.391590598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit aa09311c40f6d3aa6037065e17d257ffa48b9402 ]

Patch series "mm: various (urgent?) fixes", v1.

Here are various MM fixes.  The majority was reported by Josef at
Anthrophic, the remainder was found while reviewing/overhauling them.

Two issues/fixes reported are not included, as we are discussing
(better) alternatives on the list already.

I left most of the original commit messages as schloppy as they are: I
don't particularly care as long as the code is in good shape and as long
as they are not actively wrong.  But I (and Mike) could not be stopped
from overhauling at least some of them.

While I don't think there is anything too critical in here, I think this
is a good opportunity to see how fast we can get pre-screened/pre-reviewed
fixes upstream that might be security-related.

The majority are hugetlb + uffd issues, that are not actually that
relevant for most installations.  But all things that should just get
fixed.  Some uffd fixes need proper follow ups to fix some more of the
root causes of leftover UFFD PTE bits (or proof that there are none
remaining).

This patch (of 10):

When an accountable mapping replaces existing mappings (MAP_FIXED),
__mmap_setup() only charges the difference between the size of the new
mapping and the VM_ACCOUNT pages it replaces. It then zeroes
vms->nr_accounted so that unmapping the old VMAs does not return their
charge, which now backs the new mapping.

If the operation fails after that point, the error path returns
map->charged, i.e. only the difference. By then vms_clean_up_area() has
zapped the page tables and closed the old VMAs, so
vms_abort_munmap_vmas() cannot reattach them. It leaves a gap and
finishes the unmap with vms_complete_munmap_vmas(), which uncharges
vms->nr_accounted == 0 pages. The old VMAs are gone, the new one was
never created, and the charge of the old ones is never returned, not
even when the process exits.

No privilege is needed to hit this, only a file whose mmap hook fails,
for example a socket (sock_no_mmap() returns -ENODEV):

	p = mmap(NULL, len, PROT_READ | PROT_WRITE,
		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	mmap(p, len, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_FIXED,
	     socket_fd, 0);

Every iteration adds len to Committed_AS for good. With
vm.overcommit_memory=2 this lets any user make all further accountable
allocations in the system fail with -ENOMEM.

Once the new mapping has taken over the charge of the mappings it
replaces, it owns the charge for all of its pages. Record that in
map->charged, so that the error path returns all of it.

A failure in __mmap_setup() itself is not affected: it happens before
the charge is taken over and the old VMAs are reattached with their
charge intact.

Original fix generated by an LLM and sent in private by Josef.

[david@kernel.org: call variable "uncharged" and make it const, adjust/simplify comments]
Link: https://lore.kernel.org/20261015-urgent_fixes-v1-0-42796911043b@kernel.org
Link: https://lore.kernel.org/20261015-urgent_fixes-v1-1-42796911043b@kernel.org
Fixes: 4f87153e82c4 ("mm: change failure of MAP_FIXED to restoring the gap on failure")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
[ sashal: adapted __mmap_setup() changes to use existing local variables in __mmap_region() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmap.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 2d69552e6be38..c930e03bd7997 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1415,14 +1415,17 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	 * Private writable mapping: check memory availability
 	 */
 	if (accountable_mapping(file, vm_flags)) {
-		charged = pglen;
-		charged -= vms.nr_accounted;
-		if (charged) {
-			error = security_vm_enough_memory_mm(mm, charged);
+		const unsigned long uncharged = pglen - vms.nr_accounted;
+
+		/* Charge only what's not already charged by mappings we replace. */
+		if (uncharged) {
+			error = security_vm_enough_memory_mm(mm, uncharged);
 			if (error)
 				goto abort_munmap;
 		}
 
+		/* Our new mapping owns the entire charge now. */
+		charged = pglen;
 		vms.nr_accounted = 0;
 		vm_flags |= VM_ACCOUNT;
 		vmg.flags = vm_flags;
-- 
2.53.0



