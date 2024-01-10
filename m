Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A084F1FA
	for <patches@lists.linux.dev>; Wed, 10 Jan 2024 17:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-28bd623c631so3966272a91.3
        for <patches@lists.linux.dev>; Wed, 10 Jan 2024 09:53:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704909210; x=1705514010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=quyVSdnppz8w0YPUQzzVyzANCKAuU/PcHNsts+I2z4s=;
        b=AlPloKdQudSNG/AuBGCYLAe4+Tjehtla/+NTaAZ9qhUCpUai+CnPNnwUd7ON/hfsl/
         bXcJ2LX0eOi48c1qyljGK58eu6Vmpijcb6pxaVJxUizcLcfIIMWHUgfdU86AoAl79e5N
         Dxa3Kl+lR4b0QGWyhEYFfcu/xZAwJy4fhODrFrUilbGJcoyfQ/LB9KGl17aYqvDbz4il
         AkL9DeJ2OYG6T3bVwI/WtDG+J5/gVJ9oAkS7JDo4NkLfYARjvzcd+IFSGeCU2KQdviI+
         i+5TxkuEggRxOZgTO6GBwzu7FqLjSCKWr6yvgIb629S+oRc9vQ3ZvxusxnadcDmvDI4W
         j3UQ==
X-Gm-Message-State: AOJu0YxiMGLBwUao5ksYHoJ8K0jYpce327CC+62HLbA2Up0FLDQv5LZL
	Yp26fWWba8zLci0mKj1SGs1Fwd+5dF6sJRf3Qdc=
X-Google-Smtp-Source: AGHT+IHrKEA9A15zuS4dmV0QjZovE8jdobS9FxQvBvDSb65iQnzMpB77JE1mM0dshtFLLIWhQCIQDpT2PIjEgJn1vu4=
X-Received: by 2002:a17:90a:9746:b0:28d:c3ec:8028 with SMTP id
 i6-20020a17090a974600b0028dc3ec8028mr869411pjw.12.1704909209857; Wed, 10 Jan
 2024 09:53:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <2024010711-skeletal-material-15e8@gregkh> <20240109214955.451513-1-namhyung@kernel.org>
 <2024011043-unearned-manned-12b7@gregkh>
In-Reply-To: <2024011043-unearned-manned-12b7@gregkh>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 10 Jan 2024 09:53:17 -0800
Message-ID: <CAM9d7cj3fdaKVehz+E3Fd_Zf91hy31z19goM84qq+cc8WZe7RQ@mail.gmail.com>
Subject: Re: [PATCH for-5.15] perf inject: Fix GEN_ELF_TEXT_OFFSET for jit
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, allen.lkml@gmail.com, 
	Vegard Nossum <vegard.nossum@oracle.com>, Darren Kenny <darren.kenny@oracle.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, 
	Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>, Lieven Hey <lieven.hey@kdab.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, Jan 9, 2024 at 11:59=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jan 09, 2024 at 01:49:55PM -0800, Namhyung Kim wrote:
> > From: Adrian Hunter <adrian.hunter@intel.com>
> >
> > When a program header was added, it moved the text section but
> > GEN_ELF_TEXT_OFFSET was not updated.
> >
> > Fix by adding the program header size and aligning.
> >
> > Fixes: babd04386b1df8c3 ("perf jit: Include program header in ELF files=
")
> > Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> > Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Ian Rogers <irogers@google.com>
> > Cc: Jiri Olsa <jolsa@kernel.org>
> > Cc: Lieven Hey <lieven.hey@kdab.com>
> > Link: https://lore.kernel.org/r/20221014170905.64069-7-adrian.hunter@in=
tel.com
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > [namhyung: use "linux/kernel.h" instead to avoid build failure]
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > ---
> >  tools/perf/util/genelf.h | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
>
> What is the git commit id of this change in Linus's tree?

Sorry I forgot to add that.  It's 89b15d00527b7825ff19130ed83478e80e3fae99

Thanks,
Namhyung
