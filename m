Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE2D7E
	for <patches@lists.linux.dev>; Fri, 20 May 2022 14:48:00 +0000 (UTC)
Received: by mail-ua1-f51.google.com with SMTP id k14so470035uae.11
        for <patches@lists.linux.dev>; Fri, 20 May 2022 07:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TdE6K5mZnMzfi0LF9qaS0eQuKIQMNnhmY0eqSGQAtho=;
        b=mUUGhPjn5fYL8N//HRUtYG1NSgB+aEK0JW6CWta7a81zxnc8/Qrf1FvIF8u+x3rvTL
         iuaLSaiAd/xVdL8qYJexNCJJpEhs38roYttyPZG418V8yFOkzV3i69Ft/onbcISB7P8l
         K75gO8RRcDmEyIxncusiC4YAa7blx1oPbF323/t7XC4HgcW9v+tYE4Kxw2Faa4wVKPUN
         VfktW63jbnJrFdkIrXHIT6fcSlQ2EbT7aL8n1epYNy1RzCeJDps/qnmIsF4DDT70ipaN
         I4YpVwsIkmDo+3Rj8aQi5hiBiym5zHTz8boJrA1e+iwmi7ITT6R6mQMfal+wcJVBeeWf
         FeYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TdE6K5mZnMzfi0LF9qaS0eQuKIQMNnhmY0eqSGQAtho=;
        b=ujz8AYY87r5AImb6qm93pRFT5NaZ0gMaZI4E3WPieaLuH3qSWr5tH0XCN+kLULviYe
         bgeDAeBEWBEP6INI4OxPv0lPqUhtD5WaG7Gryi/zbfsKBZImH/wYx2XQy6DSSHm+/dTt
         02dVZs8jPfgc3DovqpHEHKYy4OYDQs/m+b1cXCzczo4qwV5/HQ/Ek+MabDyFNqFtuzUi
         RjT9P4LpFocBpWZZDNYKH+MS83AtGZHkDgcK7a5bxzAO0EkcysQmELF5HlydEX4EmNxC
         PIHROWvluGRPU48cBQoD4Q26PmcElJaAYxcvuAwMf8eSMQ2N5V2RTiPUDP1KaDCz9MYf
         2Ciw==
X-Gm-Message-State: AOAM531eQnqEdPwe79A3ndEtwJHJFmdNBGZaP3NBLw+kURXtSVk+yWVa
	BLl6kzP8ZRIPFq5isY3FQDT+Rt/tk86vlGrkZHg=
X-Google-Smtp-Source: ABdhPJywXx59CylkCISwiul4iQPc9BAVpifpqYl1j0iUV215cgLjUETS/cTOj+NSAoh7PLPB4Xk6375lsxP+vKjYdm8=
X-Received: by 2002:ab0:614a:0:b0:368:bf32:5b37 with SMTP id
 w10-20020ab0614a000000b00368bf325b37mr4158060uan.30.1653058079775; Fri, 20
 May 2022 07:47:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220516125405.1675-1-matenajakub@gmail.com> <20220516125405.1675-3-matenajakub@gmail.com>
 <20220520134124.6glbfzhrgzutfor6@box.shutemov.name>
In-Reply-To: <20220520134124.6glbfzhrgzutfor6@box.shutemov.name>
From: =?UTF-8?Q?Jakub_Mat=C4=9Bna?= <matenajakub@gmail.com>
Date: Fri, 20 May 2022 16:48:08 +0200
Message-ID: <CABsDyaJojLh0Hf2X4u44UpD_7P+eghjq9+Ogf=7f4HjAMq9KWg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 2/6] [PATCH 2/6] mm: add merging after mremap resize
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Vlastimil Babka <vbabka@suse.cz>, mhocko@kernel.org, mgorman@techsingularity.net, 
	willy@infradead.org, Liam Howlett <liam.howlett@oracle.com>, 
	Hugh Dickins <hughd@google.com>, riel@surriel.com, rostedt@goodmis.org, 
	peterz@infradead.org, david@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 20, 2022 at 3:39 PM Kirill A. Shutemov <kirill@shutemov.name> w=
rote:
>
> On Mon, May 16, 2022 at 02:54:01PM +0200, Jakub Mat=C4=9Bna wrote:
> > When mremap call results in expansion, it might be possible to merge th=
e
> > VMA with the next VMA which might become adjacent. This patch adds
> > vma_merge call after the expansion is done to try and merge.
> >
> > Signed-off-by: Jakub Mat=C4=9Bna <matenajakub@gmail.com>
> > ---
> >  mm/mremap.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index 303d3290b938..75cda854ec58 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -9,6 +9,7 @@
> >   */
> >
> >  #include <linux/mm.h>
> > +#include <linux/mm_inline.h>
> >  #include <linux/hugetlb.h>
> >  #include <linux/shm.h>
> >  #include <linux/ksm.h>
> > @@ -1022,8 +1023,10 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, uns=
igned long, old_len,
> >                               }
> >                       }
> >
> > -                     if (vma_adjust(vma, vma->vm_start, addr + new_len=
,
> > -                                    vma->vm_pgoff, NULL)) {
> > +                     if (!vma_merge(mm, vma, addr + old_len, addr + ne=
w_len,
> > +                                     vma->vm_flags, vma->anon_vma, vma=
->vm_file,
> > +                                     vma->vm_pgoff + (old_len >> PAGE_=
SHIFT), vma_policy(vma),
> > +                                     vma->vm_userfaultfd_ctx, anon_vma=
_name(vma))) {
>
> Hm. Don't you need to update 'vma' with result of vma_merge()?
>
> 'vma' is used below the point and IIUC it can be use-after-free.
>

Actually, this merge call is always either case 1 or 2 as they are
defined in the vma_merge(). So, either way the 'vma' can absorb its
neighbors but never gets absorbed itself.
But you are right and I will add the update, because otherwise it
would depend on the vma_merge() implementation, which could possibly
change in the future and cause a bug.

> --
>  Kirill A. Shutemov
