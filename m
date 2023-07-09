Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A4F3FD4
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 12:39:09 +0000 (UTC)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1qITgr-0001rQ-IR; Sun, 09 Jul 2023 14:39:01 +0200
Message-ID: <c783f635-f839-638c-5e32-ef923be432ad@leemhuis.info>
Date: Sun, 9 Jul 2023 14:39:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Content-Language: en-US, de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Suren Baghdasaryan <surenb@google.com>,
 David Hildenbrand <david@redhat.com>, Jiri Slaby <jirislaby@kernel.org>,
 =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
 Jacob Young <jacobly.alt@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20230709111345.297026264@linuxfoundation.org>
 <20230709111345.516444847@linuxfoundation.org>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [PATCH 6.4 7/8] fork: lock VMAs of the parent process when
 forking
In-Reply-To: <20230709111345.516444847@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1688906350;181469a3;
X-HE-SMSGID: 1qITgr-0001rQ-IR

On 09.07.23 13:14, Greg Kroah-Hartman wrote:
> From: Suren Baghdasaryan <surenb@google.com>
> 
> commit 2b4f3b4987b56365b981f44a7e843efa5b6619b9 upstream.
> 
> Patch series "Avoid memory corruption caused by per-VMA locks", v4.
> 
> A memory corruption was reported in [1] with bisection pointing to the
> patch [2] enabling per-VMA locks for x86.  Based on the reproducer
> provided in [1] we suspect this is caused by the lack of VMA locking while
> forking a child process.
> [...]

Question from someone that is neither a C nor a git expert -- and thus
might say something totally stupid below (and thus maybe should not have
sent this mail at all).

But I have to wonder: is adding this patch to stable necessary given
patch 8/8?

FWIW, this change looks like this:

> ---
>  kernel/fork.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -662,6 +662,12 @@ static __latent_entropy int dup_mmap(str
>  		retval = -EINTR;
>  		goto fail_uprobe_end;
>  	}
> +#ifdef CONFIG_PER_VMA_LOCK
> +	/* Disallow any page faults before calling flush_cache_dup_mm */
> +	for_each_vma(old_vmi, mpnt)
> +		vma_start_write(mpnt);
> +	vma_iter_set(&old_vmi, 0);
> +#endif
>  	flush_cache_dup_mm(oldmm);
>  	uprobe_dup_mmap(oldmm, mm);
>  	/*

But when I look at kernel/fork.c in mainline I can't see this bit. I
also only see Linus' change (e.g. patch 8/8 in this series) when I look at
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/kernel/fork.c

What am I missing?

Ciao, Thorsten (who noticed this just by chance)
