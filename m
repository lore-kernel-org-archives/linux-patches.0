Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054441;
	b=YIaZVw7rzvqsVunCxHr9cfkOW7F+gW1DRL/+viqdfvlTQnFvcCM2NBNDZgP4qYqKzXgP
	 eEmWCOA/tljwntKO8KxJgv2/AZg79HLNkJm30z+VIegHxk21NlweTrPtAFAP/lPn9Oxmm
	 8EwyBd46T5SENRjJ4XpP/TRQZw7BV0LzPm6BSff1X6VUTiEMJ+fb3YNmAgV9GjwmlhqWN
	 6X3VKvwBKGcEAatnwyVjVtMBjduvk/5hL2F/1iybxU4t4DWPAWwFHW7wXyd6MCXAqamkn
	 2+aLOscOilFK5CbcKk2VHoOXajn207toCMi66G+pKTnGXGqtUDBFQy5tJjN15S169QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QK6ttUD/vLSBO7GcqV9SCMuNFEEfFTEp7W7RK+dSXAY=;
	b=V/i9Fa0ac43Okdy7DHOXCczCNiuBZ+s7Zp0CJWw08ieWSsW6YfWYhM3Q2HxJXNXOSdBT
	 W2TwNp/+VPi8Eui8jGfTeN7pdt+Vkj8GssAPhzPl6hLuP2c+CFKIQQMFQehIOm0kpul5C
	 nUillGN3iEAya8u1cuqXX+8F0RkhBdfrzGuUqxcyR67SLfMFELX3Off7ZLKC6XfHoWk+A
	 apzxL1bkOUq0LEE7Dc4c+tvTiokFO5KXILwJK+GwqFyX9Bo3X1TzXRrFsa4U2yER8i/YW
	 nPUyIr+WEZhF8KjBkbv6U4SYnFdQc4ezGXaKKDq2wknvSn2LfXD+4rINmIhDz63cv7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JmIlh47q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5204D606A32A;
	Thu, 19 Nov 2026 02:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JmIlh47q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44C61F000C4;
	Thu, 19 Nov 2026 02:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054441;
	bh=QK6ttUD/vLSBO7GcqV9SCMuNFEEfFTEp7W7RK+dSXAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JmIlh47qxehNDakm4jz5rQaKkIEYyOqptJUbwrxzdAKXqmqxfphNBPPhHgSTtauU/
	 7nH5SJUZ0tVAsoQH4XzuxRsZNN9Q5tnU34A4dOkwA8hHByBJA8L3ClPPX8kSgFsEVv
	 u7ZIpxWv6QJx8aPk0EttWW3DpuL0yasVxFCtT6Wc=
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
Subject: [PATCH 5.15 1274/2214] mm/vma: dont leak the charge for stack growth
Date: Wed, 18 Nov 2026 15:49:10 +0100
Message-ID: <20261118150102.551980672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced vma_test() with a direct vm_flags check for VM_ACCOUNT ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 3737febcb8768..a315134dcdfec 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2373,7 +2373,8 @@ static int acct_stack_growth(struct vm_area_struct *vma,
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



