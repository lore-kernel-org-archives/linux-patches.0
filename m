Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33046118
	for <patches@lists.linux.dev>; Wed, 16 Nov 2022 15:48:05 +0000 (UTC)
Received: by mail-vk1-f180.google.com with SMTP id g4so8457741vkk.6
        for <patches@lists.linux.dev>; Wed, 16 Nov 2022 07:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cm1isLk+8vbm+bLY9nZ147ppO6t50uTaIeUdkcD8IUY=;
        b=JzggrZ4S7tuCVYW5rAqyYRbT0zDRQbqJQ1UxsUI6glLRm6/ljV32tV1z9doymKQRUJ
         nB7Nc8vllTjz55V9km62KEnSLNk20Z/J29T8z3lid5hQbpGlFX5Dsqgl/p/YtvSCcqUY
         YGfgYfCCAEqRXmA5/POGBMrVISC27e+08FrcTNYLHHiFjGjdrfLZg3LFt0xy20YM5mFN
         swRI1XEDAZEumN3n/cMVrBn7CuePi58fdJFFM2jD3xKA0HLYcJ3TJJFz7QCVpwBYEhQq
         f1LJKSTV8qrw3HprDn1EYzy+Kg+c/DK/IqU6iiol825Tq7Th+wCYC1IEkkxeAZcFx5vx
         bi7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cm1isLk+8vbm+bLY9nZ147ppO6t50uTaIeUdkcD8IUY=;
        b=BBz76RHNHqhIBQG6OkJw0JUHEZGyyaywrz6ek8R68LGjBO23nLnwIIApceqTPWqATp
         lY47+/1x4/hmQOen9liQ3kj4QES7eF68yIFCypYlDSzslKpnlsjXBWRnU+AxXSBpnxxV
         EJX9oT4B5DOFkR1mGGLE8ruWSqiAvy9BmPzU6OYgbC7rUHfpmo69LjPpr68FdmJFXrdd
         d/Qt/QuZdyMwUWii47loB/vWue7j0hr2wWKQQtPXul/LHRQCFaaDCjIeDctS6MZqBDTP
         8KTy7oIFw39BttCJmfnLjqIi4wFrdCDkAycCvlVbvg+cE3QQZuQO+zaxS6CvyCGJJtxD
         Lh7g==
X-Gm-Message-State: ANoB5pmN1ztToRBUpimBy8m0FbRd4ZDNkdubNzuPfJlokXirF98iXhLo
	vNlI3dsyEeOXbLKxcHAKfA0FThwEYv8wBzcOFuQ=
X-Google-Smtp-Source: AA0mqf6I5OMkmNh7iJcCT2U1buGOGFfHVonLSG6rXo8DCAGrruxerAbIgeVFvfW9m/dxtVo/X/4vWcAHcIYjuSrDiWs=
X-Received: by 2002:a05:6122:17a1:b0:3bb:eb08:6ee with SMTP id
 o33-20020a05612217a100b003bbeb0806eemr11861379vkf.4.1668613684637; Wed, 16
 Nov 2022 07:48:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221114124458.806324402@linuxfoundation.org> <20221114124504.652482817@linuxfoundation.org>
 <Y3S5dFSZnPKXsvWZ@duo.ucw.cz>
In-Reply-To: <Y3S5dFSZnPKXsvWZ@duo.ucw.cz>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Thu, 17 Nov 2022 00:47:47 +0900
Message-ID: <CAKFNMonue2MWXDxZL6P1ZYdnwfCx4Mh3+aQiPQTOGh5ak9XGQA@mail.gmail.com>
Subject: Re: [PATCH 6.0 134/190] nilfs2: fix deadlock in nilfs_count_free_blocks()
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, 
	syzbot+45d6ce7b7ad7ef455d03@syzkaller.appspotmail.com, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

Hi,
On Wed, Nov 16, 2022 at 7:20 PM Pavel Machek wrote:
>
> Hi!
>
> > From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> >
> > commit 8ac932a4921a96ca52f61935dbba64ea87bbd5dc upstream.
> ...
> > However, there is actually no need to take rwsem A in
> > nilfs_count_free_blocks() because it, within the lock section, only reads
> > a single integer data on a shared struct with
> > nilfs_sufile_get_ncleansegs().  This has been the case after commit
> > aa474a220180 ("nilfs2: add local variable to cache the number of clean
> > segments"), that is, even before this bug was introduced.
>
> Ok, but these days we have checkers that don't like reading variables
> unlocked, and compiler theoretically could do something funny.
>
> So this should have READ/WRITE_ONCE annotations... this is incomplete,
> but should illustrate what is needed. Likely some helper for updating
> ncleansegs should be introduced.

If the compiler omits an update in the middle, it's okay for
nilfs_count_free_blocks() and other read-only callers.

In fact if I introduce such helper function like
nilfs_sufile_set_ncleansegs() with WRITE_ONCE, I use
nilfs_sufile_get_ncleansegs() first and nilfs_sufile_set_ncleansegs()
last within functions that update the counter, rather than each time
they increment or decrement it.  But, I didn't see any point in using
WRITE_ONCE/READ_ONCE like this.

Just be sure, the functions that update the counter are already
exclusive with another semaphore (sufile->mi_sem), so updating it
without the intermediate result won't break the counter.

If there's a real problem with some kind of checkers giving warnings
as you mentioned, that's probably the real reason to apply those
annotations.
I would like to deal with it for the mainline in that case.

Thanks,
Ryusuke Konishi

>
> Best regards,
>                                                                 Pavel
>
> diff --git a/fs/nilfs2/sufile.c b/fs/nilfs2/sufile.c
> index 63722475e17e..58dddc0b1d88 100644
> --- a/fs/nilfs2/sufile.c
> +++ b/fs/nilfs2/sufile.c
> @@ -122,7 +122,7 @@ static void nilfs_sufile_mod_counter(struct buffer_head *header_bh,
>   */
>  unsigned long nilfs_sufile_get_ncleansegs(struct inode *sufile)
>  {
> -       return NILFS_SUI(sufile)->ncleansegs;
> +       return READ_ONCE(NILFS_SUI(sufile)->ncleansegs);
>  }
>
>  /**
> @@ -418,7 +418,9 @@ void nilfs_sufile_do_cancel_free(struct inode *sufile, __u64 segnum,
>         kunmap_atomic(kaddr);
>
>         nilfs_sufile_mod_counter(header_bh, -1, 1);
> -       NILFS_SUI(sufile)->ncleansegs--;
> +       /* nilfs_sufile_get_ncleansegs() leads this without taking lock */
> +       WRITE_ONCE(NILFS_SUI(sufile)->ncleansegs,
> +                  READ_ONCE(NILFS_SUI(sufile)->ncleansegs) - 1);
>
>         mark_buffer_dirty(su_bh);
>         nilfs_mdt_mark_dirty(sufile);
>
> --
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
