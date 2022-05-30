Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724F828F9
	for <patches@lists.linux.dev>; Mon, 30 May 2022 10:52:52 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id q18so9993374pln.12
        for <patches@lists.linux.dev>; Mon, 30 May 2022 03:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=w5gFWEUTN7CvTurw5Y71IzdCPoiI5JyLb8TnHFiO65M=;
        b=RB/I9ZJt9qT+WGHamOng75ciihaHBSnNkNWb9SsVr6ZsdVffqeX85J0RMI6w9eQ6Y7
         Cno4yv3Xw36n7AzBvSY0qiomAX/Hq9Cn34xffsRhlI3pDEMU+jYuvQCN8wdmUU7bz0A1
         iRZb9QBH2DMB2QZOng4W09ddthAtBQxSWVSlL1wR4ul6wOCBWifExdS7Jh8Jg/7Fv9tA
         d5WAktJPbO5FvLf7wa2voJnp5mOgEQ/a0Pl0yqBx6SsBFLqm1F8HhWfsgCwBx8AYKGbA
         aMfVoA74ZP7H5V0XU10kxrA9OHQCza6AtweAO1uNeOA34wGO9wXTwTo+6f5JNeWdzZf4
         V9zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w5gFWEUTN7CvTurw5Y71IzdCPoiI5JyLb8TnHFiO65M=;
        b=fQQZMrMgXUqUHj5mSA7OV7rvTW8ZVJDDJRuTiHci8xcXxevF3O1WzaGi8G4XkvpP/d
         MYC7IZ+eD1qfhgWb643NbWiIPBAXWy67iGnZiDJbof55dInwVQktLdADqC9COLkZ1c29
         eq+0AUQEYGhHlRMOa+zWZY03ftVrcGAuOn5v3eBz9RMtc8WnusHh5tqpHzYjx3w4pO2j
         0qj77AQ2rhzW5jqU/snzg84GqiXqXBBCQyAJx+YZ3WjvxRziivPuMOP449lqoLWiR1o4
         8VZEBXTr0HaPWu9ct7O5/aCJuy+WQaGXl/8XxCT1cLoaZMOfeLZiRbpmU9jdTNKYx6SY
         aNdg==
X-Gm-Message-State: AOAM531vjDlvuiA6vASAYj8015NkvYa77XeanhCvdYBMpUKkWS599afg
	8M0gxujlvqj37a0TrpgrOVsWyG9wxZq04o73NFg=
X-Google-Smtp-Source: ABdhPJwvimXOSym9fwJtWssibynEoIBVc9qaJYoOEUWn8MRWDS91hkQCQndiDo06egA95PE6mn+DTT3MkuXwFZr1MFg=
X-Received: by 2002:a17:902:b581:b0:161:5f37:6688 with SMTP id
 a1-20020a170902b58100b001615f376688mr55489176pls.145.1653907971898; Mon, 30
 May 2022 03:52:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220527104810.24736-1-matenajakub@gmail.com> <20220527104810.24736-3-matenajakub@gmail.com>
 <20220527234657.nsn6e7jjwttblzyi@box.shutemov.name>
In-Reply-To: <20220527234657.nsn6e7jjwttblzyi@box.shutemov.name>
From: =?UTF-8?Q?Jakub_Mat=C4=9Bna?= <matenajakub@gmail.com>
Date: Mon, 30 May 2022 12:53:08 +0200
Message-ID: <CABsDyaKNkiucxW_MDkssfGrTty1YTVH53BBybLaWOye20AGFag@mail.gmail.com>
Subject: Re: [PATCH 2/2] [PATCH 2/2] mm: add merging after mremap resize
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, mhocko@kernel.org, 
	mgorman@techsingularity.net, willy@infradead.org, 
	Liam Howlett <liam.howlett@oracle.com>, Hugh Dickins <hughd@google.com>, riel@surriel.com, 
	rostedt@goodmis.org, peterz@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 28, 2022 at 1:45 AM Kirill A. Shutemov <kirill@shutemov.name> w=
rote:
>
> On Fri, May 27, 2022 at 12:48:10PM +0200, Jakub Mat=C4=9Bna wrote:
> > When mremap call results in expansion, it might be possible to merge th=
e
> > VMA with the next VMA which might become adjacent. This patch adds
> > vma_merge call after the expansion is done to try and merge.
> >
> > Signed-off-by: Jakub Mat=C4=9Bna <matenajakub@gmail.com>
> > ---
> >  mm/mremap.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index 303d3290b938..c41237e62156 100644
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
> > @@ -1022,8 +1023,11 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, uns=
igned long, old_len,
> >                               }
> >                       }
> >
> > -                     if (vma_adjust(vma, vma->vm_start, addr + new_len=
,
> > -                                    vma->vm_pgoff, NULL)) {
> > +                     vma =3D vma_merge(mm, vma, addr + old_len, addr +=
 new_len,
> > +                                     vma->vm_flags, vma->anon_vma, vma=
->vm_file,
> > +                                     vma->vm_pgoff + (old_len >> PAGE_=
SHIFT), vma_policy(vma),
> > +                                     vma->vm_userfaultfd_ctx, anon_vma=
_name(vma));
>
> The arguement list gets busy. Maybe some variables would help.
> Calculation around vm_pgoff is not obvious and requires some explanation.

Ok, I will add the following comment:

"Function vma_merge() is called on the extension we are adding to the
already existing vma, vma_merge() will merge this extension with the
already existing vma (expand operation itself) and possibly also with
the next vma if it becomes adjacent to the expanded vma and otherwise
compatible."

And I will also introduce three new variables to better explain some
of the arguments:

unsigned long extension_start =3D addr + old_len;
unsigned long extension_end =3D addr + new_len;
pgoff_t extension_pgoff =3D vma->vm_pgoff + (old_len >> PAGE_SHIFT);

>
> > +                     if (!vma) {
> >                               vm_unacct_memory(pages);
> >                               ret =3D -ENOMEM;
> >                               goto out;
> > --
> > 2.35.1
> >
>
> --
>  Kirill A. Shutemov

Jakub Mat=C4=9Bna
