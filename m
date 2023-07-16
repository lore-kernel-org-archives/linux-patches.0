Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B24A8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815A1C433C7;
	Sun, 16 Jul 2023 20:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538903;
	bh=DvVNDZj08XdUBWyW7SU0R5lUaoa7TwIED40WbY0wjMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3fG2jSxjH+g9xYmlmsbLplseptKeY8CMQ0CfZEV8zluse5PrLKoOKy/AT1urKHbA
	 xTutpw4kPWEfe6BcfjlIeFXIytncrIwlQ9S65ErRoYpgEuXmcdEMFNPAIKA1ugsL/e
	 i0pgIcuonAzpGGK57r66F3eC6bWffhmGB5FHBdKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nico Boehr <nrb@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 617/800] KVM: s390: fix KVM_S390_GET_CMMA_BITS for GFNs in memslot holes
Date: Sun, 16 Jul 2023 21:47:50 +0200
Message-ID: <20230716195003.444261638@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nico Boehr <nrb@linux.ibm.com>

[ Upstream commit 285cff4c0454340a4dc53f46e67f2cb1c293bd74 ]

The KVM_S390_GET_CMMA_BITS ioctl may return incorrect values when userspace
specifies a start_gfn outside of memslots.

This can occur when a VM has multiple memslots with a hole in between:

+-----+----------+--------+--------+
| ... | Slot N-1 | <hole> | Slot N |
+-----+----------+--------+--------+
      ^          ^        ^        ^
      |          |        |        |
GFN   A          A+B      |        |
                          A+B+C    |
			           A+B+C+D

When userspace specifies a GFN in [A+B, A+B+C), it would expect to get the
CMMA values of the first dirty page in Slot N. However, userspace may get a
start_gfn of A+B+C+D with a count of 0, hence completely skipping over any
dirty pages in slot N.

The error is in kvm_s390_next_dirty_cmma(), which assumes
gfn_to_memslot_approx() will return the memslot _below_ the specified GFN
when the specified GFN lies outside a memslot. In reality it may return
either the memslot below or above the specified GFN.

When a memslot above the specified GFN is returned this happens:

- ofs is calculated, but since the memslot's base_gfn is larger than the
  specified cur_gfn, ofs will underflow to a huge number.
- ofs is passed to find_next_bit(). Since ofs will exceed the memslot's
  number of pages, the number of pages in the memslot is returned,
  completely skipping over all bits in the memslot userspace would be
  interested in.

Fix this by resetting ofs to zero when a memslot _above_ cur_gfn is
returned (cur_gfn < ms->base_gfn).

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: afdad61615cc ("KVM: s390: Fix storage attributes migration with memory slots")
Message-Id: <20230324145424.293889-2-nrb@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 17b81659cdb20..6700196964648 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2156,6 +2156,10 @@ static unsigned long kvm_s390_next_dirty_cmma(struct kvm_memslots *slots,
 		ms = container_of(mnode, struct kvm_memory_slot, gfn_node[slots->node_idx]);
 		ofs = 0;
 	}
+
+	if (cur_gfn < ms->base_gfn)
+		ofs = 0;
+
 	ofs = find_next_bit(kvm_second_dirty_bitmap(ms), ms->npages, ofs);
 	while (ofs >= ms->npages && (mnode = rb_next(mnode))) {
 		ms = container_of(mnode, struct kvm_memory_slot, gfn_node[slots->node_idx]);
-- 
2.39.2



