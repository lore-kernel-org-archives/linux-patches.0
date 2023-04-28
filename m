Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765FA17D8;
	Fri, 28 Apr 2023 06:15:22 +0000 (UTC)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-94eff00bcdaso1759535766b.1;
        Thu, 27 Apr 2023 23:15:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682662520; x=1685254520;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nKg0o2X3zUwk7C1FxgskinEP8Y3FsAVaj1+iPRtrTLM=;
        b=TKbox3oE42vpvShNb/Racd0MvQKrzPO2op+Hh0HgqqHlu4D+cHXaQYrwFq85Jrj1WE
         l7ZvR5vezCxlK0VmVW2CQKTl3fq5JIPPt6B6wyIMaJB/RBYyirq0Zw6GsDdgQEKGJEbc
         u8kRatLNgYvJj7ess6JluXBzy8eArvX2bj82Pu32Khm5IrV0HAZlOiB7ZqqO91oM1ija
         VQyWPZKMYFyUVYAALXNZAJucVhTlVEqJJtkTVr9dn6uXAbkMevZqPzJqbMK4Ra+3QeBQ
         r8OVuHg4p6imRcD8OYXXm5z4wASQJn71IpRxOhJHvr90Ew6eOJmTXxdYrMJeVtNdIIVM
         M0Gg==
X-Gm-Message-State: AC+VfDyg8sg28UZxJnVKuTnT5FeSsGjqwdsbuXqaA2lAh0b1Yp73HMDt
	mboY/yqzMMMgkZLRdfvWUz8=
X-Google-Smtp-Source: ACHHUZ6EMvsXSqUHkSdrzd/E0ByCGNrcKMWu7/ohpHqyvp5f/plsxP+8DlyngVbdVoo0IoCjp1iLbg==
X-Received: by 2002:a17:907:9347:b0:94e:ed5d:8777 with SMTP id bv7-20020a170907934700b0094eed5d8777mr4092020ejc.25.1682662520293;
        Thu, 27 Apr 2023 23:15:20 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:59? ([2a0b:e7c0:0:107::aaaa:59])
        by smtp.gmail.com with ESMTPSA id 26-20020a170906101a00b0095729352bf3sm9256078ejm.215.2023.04.27.23.15.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 23:15:19 -0700 (PDT)
Message-ID: <a21cbbb4-6fe0-c154-6064-517dad716aa0@kernel.org>
Date: Fri, 28 Apr 2023 08:15:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH for v6.3 regression] mm/mremap: fix vm_pgoff in
 vma_merge() case 3
Content-Language: en-US
To: Greg KH <greg@kroah.com>, Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, lstoakes@gmail.com,
 regressions@lists.linux.dev, linux-mm@kvack.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, Fabian Vogt <fvogt@suse.com>,
 stable@vger.kernel.org
References: <20230427140959.27655-1-vbabka@suse.cz>
 <2023042719-stratus-pavestone-505e@gregkh>
From: Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <2023042719-stratus-pavestone-505e@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27. 04. 23, 16:27, Greg KH wrote:
> On Thu, Apr 27, 2023 at 04:09:59PM +0200, Vlastimil Babka wrote:
>> After upgrading build guests to v6.3, rpm started segfaulting for
>> specific packages, which was bisected to commit 0503ea8f5ba7 ("mm/mmap:
>> remove __vma_adjust()"). rpm is doing many mremap() operations with file
>> mappings of its db. The problem is that in vma_merge() case 3 (we merge
>> with the next vma, expanding it downwards) vm_pgoff is not adjusted as
>> it should when vm_start changes. As a result the rpm process most likely
>> sees data from the wrong offset of the file. Fix the vm_pgoff
>> calculation.
>>
>> For case 8 this is a non-functional change as the resulting vm_pgoff is
>> the same.
>>
>> Reported-and-bisected-by: Jiri Slaby <jirislaby@kernel.org>
>> Reported-and-tested-by: Fabian Vogt <fvogt@suse.com>
>> Link: https://bugzilla.suse.com/show_bug.cgi?id=1210903
>> Fixes: 0503ea8f5ba7 ("mm/mmap: remove __vma_adjust()")
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> Cc: <stable@vger.kernel.org>
>> ---
>> Hi, I'm sending this patch on top of v6.3 as I think it should be
>> applied and backported to 6.3-stable rather sooner than later.
>> This means there would be a small conflict when merging mm/mm-stable
>> later. Alternatively it could be added to mm/mm-stable and upcoming 6.4
>> pull request, but then the stable backport would need adjustment.
>> It's up to Linus and Andrew.
> 
> That's not how the stable tree works, sorry, it needs to be in Linus's
> tree _first_.

In upstream as:
commit 7e7757876f258d99266e7b3c559639289a2a45fe
Author: Vlastimil Babka <vbabka@suse.cz>
Date:   Thu Apr 27 16:09:59 2023 +0200

     mm/mremap: fix vm_pgoff in vma_merge() case 3

Please queue for 6.3.1.

thanks,
-- 
js
suse labs

