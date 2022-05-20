Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246407E
	for <patches@lists.linux.dev>; Fri, 20 May 2022 15:52:49 +0000 (UTC)
Received: by mail-vk1-f178.google.com with SMTP id e144so4306453vke.9
        for <patches@lists.linux.dev>; Fri, 20 May 2022 08:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tpdW7ecTraKhRbFvsmKOuE6oFJXwO3YExgfPm1rem6k=;
        b=iwOJDaYD3rkoWkWTQttkxXrc7bmfCiBueluPS4MvM/SUBPn/XmWiUP4nfjxIyirEyy
         r40MMADjDftUxIlayYfIh11OWDcRYd18Kq2bj3FOAGjHxrLKBhtCz0a2hehKSPHs6+In
         G8/0QMpR9YchPdTTDcAxLCqL5/wpRXKv8FJrplu7Gn4hVlpy6ULxDxQja191vcQfz/9r
         z2Z2WKug9WpP4QL1E1spbNRTcu/HE/VIKnXJCTA76y73Z3vjsrpel6bEm6T0cidcBtY9
         UgZTs9GoHMKRvSG+wcxwinB0aaJ3vUjdgHv+0G6E9FpiPS/aeMhIUPb4RJjE8Iy7Ausr
         i/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tpdW7ecTraKhRbFvsmKOuE6oFJXwO3YExgfPm1rem6k=;
        b=BD5C8LoAKpINhN7dAMkTh8MkPI9fB+MKjciOD9EN2bu4Y4ahP7LHk5WWaGP1oKX+Hn
         Nfmc9LmQdLnX5U+TB+bEwoAfAgugYrcVD49vx2G+HG0kL8HUAjcMKHB56Mz/7EmdUm8G
         43R13SuOKJlyGYd0VWlOTFylP4v3WjIHLyhBttV91tLRFcMUCMmliO1zJNGvvipdDstn
         wwnkHQmk/Xq+L8MlEhlP7smRgOZxDQeEp+PODVm33Ai4zKNbRtcJ765PoJ6VepOplPft
         +uwzDOEcv3jErOjcJv3AAULFqjVKip0ZG+iaebCAngxllHXe55/O/i3KvutK625BjE6G
         CAJQ==
X-Gm-Message-State: AOAM531R0L6DchCpHurhMVhpvjtijn+NXPq467brVTdeCTl4uh9kAmoB
	NTiG9RXprsDaTE2okri6h4kZhGyxq9+tksHiSQc=
X-Google-Smtp-Source: ABdhPJzkmCYAR3lHsKWTR4WJw3EHqbOIe/Gee4gEL4BAfCHI1FQm8jmDahubi6kfWk7b2fsJlMHMycZJU/sHEFJaZww=
X-Received: by 2002:a05:6122:1184:b0:356:f6f5:da0c with SMTP id
 x4-20020a056122118400b00356f6f5da0cmr4344329vkn.36.1653061968101; Fri, 20 May
 2022 08:52:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220516125405.1675-1-matenajakub@gmail.com> <20220516125405.1675-2-matenajakub@gmail.com>
 <20220520132800.hijytnlyjqeesjfj@box.shutemov.name>
In-Reply-To: <20220520132800.hijytnlyjqeesjfj@box.shutemov.name>
From: =?UTF-8?Q?Jakub_Mat=C4=9Bna?= <matenajakub@gmail.com>
Date: Fri, 20 May 2022 17:52:56 +0200
Message-ID: <CABsDya+_Q=JLF2igQ1ZghrCqSUcGokaPbN+VHsA=13Vd0N4igA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/6] [PATCH 1/6] mm: refactor of vma_merge()
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Vlastimil Babka <vbabka@suse.cz>, mhocko@kernel.org, mgorman@techsingularity.net, 
	willy@infradead.org, Liam Howlett <liam.howlett@oracle.com>, 
	Hugh Dickins <hughd@google.com>, riel@surriel.com, rostedt@goodmis.org, 
	peterz@infradead.org, david@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 20, 2022 at 3:26 PM Kirill A. Shutemov <kirill@shutemov.name> w=
rote:
>
> On Mon, May 16, 2022 at 02:54:00PM +0200, Jakub Mat=C4=9Bna wrote:
> > Refactor vma_merge() to make it shorter, more understandable and
> > suitable for tracing of successful merges that are made possible by
> > following patches in the series. Main change is the elimination of code
> > duplicity in the case of merge next check. This is done by first doing
> > checks and caching the results before executing the merge itself. Exit
> > paths are also unified.
> >
> > Signed-off-by: Jakub Mat=C4=9Bna <matenajakub@gmail.com>
>
> Okay, this looks good:
>
> Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>
> I would also consider renaming 'area' to 'vma'. 'area' feels wrong to me,
> but maybe it is only me.

Well, the 'area' is taken from the original code and the name is not
the only thing wrong about it. It is actually used for two purposes,
which is definitely wrong. First purpose is to store the middle VMA
between prev and next for the use of case 8. And the second purpose is
to store the resulting VMA which is passed to
khugepaged_enter_vma_merge() and also the return value of vma_merge().
So, to me it seems that the best approach is to split it into two
variables 'mid' for the first purpose and 'res' for the second one.

>
> --
>  Kirill A. Shutemov
