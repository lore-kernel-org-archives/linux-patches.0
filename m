Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037917;
	b=F11pZqwB05cstDuCET8kaKSp7mL6WKfsYS+p+Uox86Q/uzB/OMiE0gyYncoCiEFFi4iR
	 u2KY6jMyFUxpGBXxOmVmQvcDVoG8lwMEOpoejiTlLqNpjBWBa/bHu6lTQlK5jMgzsAhIj
	 0VJQfSWQDnd9js89NdWnXz2NRwWyvf205xHma06Vzp6PRHQNqM4WF9PDGVRQ/4Fj8JMdl
	 VsYmXD8swVeofIpTFqgs8zwutcmDjZeCt+vzUB67BAyuFTapmTrzM2oX9vATVcUU89QsT
	 Ao4VLZnNpA56vvh1jBMZpvV66OxoD1g32A+Xi3VHi76xvdiogEqaRPmJcSyKNrvnz5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NT4FSEwqeWH1MW/anReDPMv6odthxHSW3Zq3WOQRZuY=;
	b=K7rpcqttu7K9rKvRj21QoaB9wEfIYWGvgTRVJz42vVMio2dEB1X+1kfc3+tvX9sQPCv/
	 Wnhl1f4t/m11dY0FZWwqj3XSg1kd7EvB1JfKy08+vcRPT+F0fF1bDU5dL9RCt6pwiaxIC
	 PFxlHD84Jx6a39NvrElTJd/FFyhiUUMy9HfNtfsWm/z2hFTMixgvrWvQbgefyOzizGe9P
	 b6OHAyH9FiVFGPTrsDQx/iIQ/W4W+HroWIyinovYX2X7yqU6tQFI5yCR5lLUYPS/9qEZO
	 hZsbdrohjtT7YkUfBFhENOCB0AFGMNw5ERL2B35VIQF0M1X1Qbjt1hj6TE8zuLaw16A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ED2q6k5h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933D7606A32A;
	Wed, 18 Nov 2026 21:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ED2q6k5h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A1F1F000C4;
	Wed, 18 Nov 2026 21:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037917;
	bh=NT4FSEwqeWH1MW/anReDPMv6odthxHSW3Zq3WOQRZuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ED2q6k5hlAky62deqzEroZNFRWShNGIe6OVMRyYLLMr4BP99dd6ZcWIfzVJVLsCEf
	 569Zxi5A8/QREuNMwnel+ps3uFk3Trnqs0tQ5Z0SXsRjbXHqYQI1MuKPHEYmlhzZcr
	 Inz5Dot7et3nuAGD9X1KRvS5n6kxKkEvQ108K2tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1520/3318] mm: fix unmap_mapping_range() beyond 4 GiB on 32-bit
Date: Wed, 18 Nov 2026 15:35:42 +0100
Message-ID: <20261118150406.555960289@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 7a81bc23dade8082187be6d9cc36e4be4b7207e2 ]

Commit 9eab0421fa94 ("mm: fix unmap_mapping_range high bits shift bug")
made holebegin and holelen unsigned before they are shifted, by casting
them to pgoff_t. That is an unsigned long: on a 32-bit kernel the cast
cuts off the upper half of the two loff_t values, so a hole which begins
at 4 GiB or beyond is taken for one in the first 4 GiB of the file.

truncate_pagecache() passes the new size of the file and asks for private
COWed pages to be unmapped as well. If a file of 6 GiB is truncated to
5 GiB, everything from 1 GiB on is unmapped, and what a process has
written to a private mapping of the range between 1 GiB and 5 GiB is
lost: it reads the contents of the file again.

Where the range has an end, the wrong range is unmapped instead of the
right one. The page cache copes with that, as it unmaps every folio that
it removes. The callers which only have unmap_mapping_range() to get
rid of user mappings do not, for example drm_vma_node_unmap(), whose fake
offsets reach beyond 4 GiB on 32-bit, and revoke_iomem() with physical
addresses of more than 32 bits.

Cast to u64 instead. Nothing changes for 64-bit kernels.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 9eab0421fa94 ("mm: fix unmap_mapping_range high bits shift bug")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-36-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index a64919cf0fb0d..6d4a1032ca61a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3582,8 +3582,8 @@ EXPORT_SYMBOL_GPL(unmap_mapping_pages);
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows)
 {
-	pgoff_t hba = (pgoff_t)(holebegin) >> PAGE_SHIFT;
-	pgoff_t hlen = ((pgoff_t)(holelen) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	pgoff_t hba = (u64)holebegin >> PAGE_SHIFT;
+	pgoff_t hlen = ((u64)holelen + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	/* Check for overflow. */
 	if (sizeof(holelen) > sizeof(hlen)) {
-- 
2.53.0



