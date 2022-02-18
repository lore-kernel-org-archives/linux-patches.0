Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B022F4ABB
	for <patches@lists.linux.dev>; Fri, 18 Feb 2022 18:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EB6C340E9;
	Fri, 18 Feb 2022 18:09:21 +0000 (UTC)
Date: Fri, 18 Feb 2022 13:09:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jakub =?UTF-8?B?TWF0xJtuYQ==?= <matenajakub@gmail.com>
Cc: linux-mm@kvack.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, vbabka@suse.cz, mhocko@kernel.org,
 mgorman@techsingularity.net, willy@infradead.org, liam.howlett@oracle.com,
 hughd@google.com, kirill@shutemov.name, riel@surriel.com,
 peterz@infradead.org
Subject: Re: [RFC PATCH 4/4] [PATCH 4/4] mm: add tracing for VMA merges
Message-ID: <20220218130920.5902d967@gandalf.local.home>
In-Reply-To: <20220218122019.130274-5-matenajakub@gmail.com>
References: <20220218122019.130274-1-matenajakub@gmail.com>
	<20220218122019.130274-5-matenajakub@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Feb 2022 13:20:19 +0100
Jakub Mat=C4=9Bna <matenajakub@gmail.com> wrote:

> diff --git a/include/trace/events/mmap.h b/include/trace/events/mmap.h
> index 4661f7ba07c0..9f6439e2ed2d 100644
> --- a/include/trace/events/mmap.h
> +++ b/include/trace/events/mmap.h
> @@ -6,6 +6,7 @@
>  #define _TRACE_MMAP_H
> =20
>  #include <linux/tracepoint.h>
> +#include <../mm/internal.h>
> =20
>  TRACE_EVENT(vm_unmapped_area,
> =20
> @@ -42,6 +43,60 @@ TRACE_EVENT(vm_unmapped_area,
>  		__entry->low_limit, __entry->high_limit, __entry->align_mask,
>  		__entry->align_offset)
>  );
> +
> +TRACE_EVENT(vm_av_merge,
> +
> +	TP_PROTO(int merged, enum vma_merge_res merge_prev, enum vma_merge_res =
merge_next, enum vma_merge_res merge_both),
> +
> +	TP_ARGS(merged, merge_prev, merge_next, merge_both),
> +
> +	TP_STRUCT__entry(
> +		__field(int,			merged)
> +		__field(enum vma_merge_res,	predecessor_different_av)
> +		__field(enum vma_merge_res,	successor_different_av)
> +		__field(enum vma_merge_res,	predecessor_with_successor_different_av)
> +		__field(int,			diff_count)
> +		__field(int,			failed_count)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->merged =3D merged =3D=3D 0;
> +		__entry->predecessor_different_av =3D merge_prev;
> +		__entry->successor_different_av =3D merge_next;
> +		__entry->predecessor_with_successor_different_av =3D merge_both;
> +		__entry->diff_count =3D (merge_prev =3D=3D AV_MERGE_DIFFERENT)
> +		+ (merge_next =3D=3D AV_MERGE_DIFFERENT) + (merge_both =3D=3D AV_MERGE=
_DIFFERENT);
> +		__entry->failed_count =3D (merge_prev =3D=3D AV_MERGE_FAILED)
> +		+ (merge_next =3D=3D AV_MERGE_FAILED) + (merge_both =3D=3D AV_MERGE_FA=
ILED);

Please indent the above better. That is:

		__entry->diff_count =3D (merge_prev =3D=3D AV_MERGE_DIFFERENT)
				+ (merge_next =3D=3D AV_MERGE_DIFFERENT)
				+ (merge_both =3D=3D AV_MERGE_DIFFERENT);


> +	),
> +
> +	TP_printk("merged=3D%d predecessor=3D%d successor=3D%d predecessor_with=
_successor=3D%d diff_count=3D%d failed_count=3D%d\n",
> +		__entry->merged,
> +		__entry->predecessor_different_av, __entry->successor_different_av,
> +		__entry->predecessor_with_successor_different_av,
> +		__entry->diff_count, __entry->failed_count)

To make the above easier to read for humans, you could have at the start:

#define AV_MERGE_TYPES		\
	EM(MERGE_FAILED),	\
	EM(AV_MERGE_FAILED)	\
	EM(MERGE_OK)		\
	EMe(AV_MERGE_DIFFERENT)

#define EM(a)	TRACE_DEFINE_ENUM(a);
#define EMe(a)	TRACE_DEFINE_ENUM(a);

AV_MERGE_TYPES

#undef EM
#undef EMe

#define EM(a) 	{a, #a},
#define EMe(a)	{a, #a}

Then:

	TP_printk("merged=3D%d predecessor=3D%s successor=3D%s predecessor_with_su=
ccessor=3D%s diff_count=3D%d failed_count=3D%d",

(note, no "\n", get rid of that)

		__entry->merged,
		__print_symbolic(predecessor_different_av, AV_MERGE_TYPES),
		__print_symbolic(successor_different_av, AV_MERGE_TYPES),
		__print_symbolic(predecessor_with_successor_different_av, AV_MERGE_TYPES),
		__entry->diff_count, __entry->failed_count)

Then the output will show strings instead of meaningless numbers.

-- Steve


> +
> +);
> +
> +TRACE_EVENT(vm_pgoff_merge,
> +
> +	TP_PROTO(struct vm_area_struct *vma, bool anon_pgoff_updated),
> +
> +	TP_ARGS(vma, anon_pgoff_updated),
> +
> +	TP_STRUCT__entry(
> +		__field(bool,	faulted)
> +		__field(bool,	updated)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->faulted =3D vma->anon_vma;
> +		__entry->updated =3D anon_pgoff_updated;
> +	),
> +
> +	TP_printk("faulted=3D%d updated=3D%d\n",
> +		__entry->faulted, __entry->updated)
> +);
>  #endif
> =20
>  /* This part must be outside protection */
