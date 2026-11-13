Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585669;
	b=Rez374J6+kn1xJTgoBsZbsGF+wM9gpPl14BaIboeltkPYfi9p5k0mLoBZx3LqOZv58jE
	 2Tcghthig6yHRZFsCJ2zMpo3uC+S9B5jcQAEIC5SuSucaOzUJEiCmZqA1kieBw2m4i0lX
	 7n5Qt6WaU5LCv648vovL3RrsHzHULrExJ9jczGth69x6sO8uPM3OJKnodn0GAeTnZN4G1
	 epcHIJ8yrClVtuyHceO8c2H5/P0KFdAfl6IXhm71CL2KTPK1d4K28P/Zfga3BUnGEZ3Cu
	 xWcqIx4TCTovYapMWmCalOP4V4tHrEyx1pnYHwzplSqJ4d2wGeZpu2FxSgacyh865uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4HvcEf3jn2+1iz5K0uGWg/RynuxiPaiAbCy47u3PV/4=;
	b=i1SyDcTR7okaooD5bOHEPXASb5nTwEqlS5RKlrT8WZmdF3tjJ1M9jLj1IepxQYE5gggm
	 IxszzFpCcpJQoqI2t1DuRoDJmuXEgV1lgbNWogbalTF/bjArNJ3yImMnDnH5rOvwbspJu
	 JrZtNHOKNrgMyssdomzrtyPjTCGJjJQKoQXyVMsuhGiWUuxEHlmlP7fWTqZ/1/PwWKZrt
	 bE+jIrPtW5J+97HXWe83BlVcPzV68q70Pv2hg4dFIo5LHZjDZyqQu+pjdTrOSsugnii4q
	 G3f++jbEyv3bEgZXXR2ROchQgm6pSpazjPEwKfwCvAyYv1efPLGRI/P5ACIHNi1Lveg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dEhme36s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D64E606B2DB;
	Fri, 13 Nov 2026 16:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dEhme36s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E14A1F000C4;
	Fri, 13 Nov 2026 16:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585669;
	bh=4HvcEf3jn2+1iz5K0uGWg/RynuxiPaiAbCy47u3PV/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dEhme36sok4nAkQQmKqPUSVgCuVNmbAvcvP9Wh/M2dXbfruoqTOwBY/c39sBZfxcF
	 0lV7i4OWVE3TDIFnNZkhn3NjS2e22wdXv9BynvIPjZgMh8GVYBN9I6MEC1kNUdABRu
	 sOGszjSVvCD1IMzZ/ZTfhiSYlmxjeqnTT9U3XIyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samarth Narang <samarth.colleges@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lance Yang <lance.yang@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 230/507] mm/ksm: keep soft-dirty when merging a page
Date: Fri, 13 Nov 2026 10:48:54 -0500
Message-ID: <20261113153802.293545327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samarth Narang <samarth.colleges@gmail.com>

[ Upstream commit 2efc6332f18bfd848f74f3d5ba45b31450601faa ]

replace_page() maps the KSM page with a PTE built from scratch, so the
soft-dirty bit of the PTE it replaces is lost.  A page written since
"clear_refs 4" then no longer shows as soft-dirty once it is merged, and a
soft-dirty based dumper treats it as unchanged.

Copy the soft-dirty bit from the original PTE to the new PTE.

Link: https://lore.kernel.org/20261021182157.1873726-1-samarth.colleges@gmail.com
Fixes: 0f8975ec4db2 ("mm: soft-dirty bits for user memory changes tracking")
Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/ksm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index fe42c17490b89..b1f361983e553 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1462,6 +1462,10 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 		dec_mm_counter(mm, MM_ANONPAGES);
 	}
 
+	/* Preserve soft-dirty when replacing the page. */
+	if (pte_soft_dirty(orig_pte))
+		newpte = pte_mksoft_dirty(newpte);
+
 	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
 	/*
 	 * No need to notify as we are replacing a read only page with another
-- 
2.53.0



