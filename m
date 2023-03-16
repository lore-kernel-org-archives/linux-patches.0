Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AD523A6
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 08:35:41 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8A80621A38;
	Thu, 16 Mar 2023 08:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1678955739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xyh5uGvhV5m2gmbFTSe9oGg9qP1qtpxgm6fUuA7nZJM=;
	b=hBj89sJnEclTOejEPc5hsl5Ym2lIJ1IM2dz8BxbVlRP5cg/ur8GFQni2lmL3Q0Xm7h6/t/
	ywIgbPNpBIF8opX0GobOLS/OAkWntf7IYPKoGvHz3Q/Ca8wrAw8R55dSNPe7hf8Rht0VV2
	/HAGap/Gr3b/7F7vLeAoLK8TtZOfis8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1678955739;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xyh5uGvhV5m2gmbFTSe9oGg9qP1qtpxgm6fUuA7nZJM=;
	b=i4zbF/imSwtvq8PhPTuHiiOp4K3JXCeEJA7n0z0TCcgcbdG00qZ8aXM97J/ykM5+tkiUTh
	Pgij0CG3Q3IfB9BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7BE5313A2F;
	Thu, 16 Mar 2023 08:35:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id Q+eOHdvUEmSnJQAAMHmgww
	(envelope-from <vbabka@suse.cz>); Thu, 16 Mar 2023 08:35:39 +0000
Message-ID: <997d99e4-6ebd-c23e-ca1e-b62155701cb0@suse.cz>
Date: Thu, 16 Mar 2023 09:35:39 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 10/10] mm/mremap: simplify vma expansion again
Content-Language: en-US
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 maple-tree@lists.infradead.org
References: <20230309111258.24079-1-vbabka@suse.cz>
 <20230309111258.24079-11-vbabka@suse.cz>
 <7a9ca4a6-9713-4e31-9c0f-11ec31817c7a@lucifer.local>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <7a9ca4a6-9713-4e31-9c0f-11ec31817c7a@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/15/23 23:20, Lorenzo Stoakes wrote:
> On Thu, Mar 09, 2023 at 12:12:58PM +0100, Vlastimil Babka wrote:
>> This effectively reverts d014cd7c1c35 ("mm, mremap: fix mremap()
>> expanding for vma's with vm_ops->close()"). After the recent changes,
>> vma_merge() is able to handle the expansion properly even when the vma
>> being expanded has a vm_ops->close operation, so we don't need to
>> special case it anymore.
>>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  mm/mremap.c | 20 ++++----------------
>>  1 file changed, 4 insertions(+), 16 deletions(-)
>>
>> diff --git a/mm/mremap.c b/mm/mremap.c
>> index 411a85682b58..65f5b545601e 100644
>> --- a/mm/mremap.c
>> +++ b/mm/mremap.c
>> @@ -1040,23 +1040,11 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
>>  			 * vma (expand operation itself) and possibly also with
>>  			 * the next vma if it becomes adjacent to the expanded
>>  			 * vma and  otherwise compatible.
>> -			 *
>> -			 * However, vma_merge() can currently fail due to
>> -			 * is_mergeable_vma() check for vm_ops->close (see the
>> -			 * comment there). Yet this should not prevent vma
>> -			 * expanding, so perform a simple expand for such vma.
>> -			 * Ideally the check for close op should be only done
>> -			 * when a vma would be actually removed due to a merge.
>>  			 */
>> -			if (!vma->vm_ops || !vma->vm_ops->close) {
>> -				vma = vma_merge(&vmi, mm, vma, extension_start,
>> -					extension_end, vma->vm_flags, vma->anon_vma,
>> -					vma->vm_file, extension_pgoff, vma_policy(vma),
>> -					vma->vm_userfaultfd_ctx, anon_vma_name(vma));
>> -			} else if (vma_expand(&vmi, vma, vma->vm_start,
>> -					addr + new_len, vma->vm_pgoff, NULL)) {
>> -				vma = NULL;
>> -			}
>> +			vma = vma_merge(&vmi, mm, vma, extension_start,
>> +				extension_end, vma->vm_flags, vma->anon_vma,
>> +				vma->vm_file, extension_pgoff, vma_policy(vma),
>> +				vma->vm_userfaultfd_ctx, anon_vma_name(vma));
>>  			if (!vma) {
>>  				vm_unacct_memory(pages);
>>  				ret = -ENOMEM;
>> --
>> 2.39.2
>>
> 
> Good to eliminate this edge case! Do we have a self-test for this case to assert
> that the issue is fixed by this? I guess a little tricky due to the need for the
> the owning VMA to have ->close() specified.

Yeah that's the problem, it needs some specific setup, unlike the existing
tests.

> In any case, the changes you have made in the previous patch should ensure the
> edge case is no longer required, hence:-
> 
> Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>

Thanks!
