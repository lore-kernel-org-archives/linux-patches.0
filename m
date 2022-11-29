Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595FEAD5E
	for <patches@lists.linux.dev>; Tue, 29 Nov 2022 19:22:03 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id n20so36301701ejh.0
        for <patches@lists.linux.dev>; Tue, 29 Nov 2022 11:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ar/RYsQiETTjjxvJHozBvp1MbTSOUxcuqSLEZv8K3bo=;
        b=IZYwoODGdd+jwA/cpGNGwv5RVNFFusI8KtBABIIbcRkVrJJzhiK5zIEiLspZbzaaGV
         oDqhcwPKD170JD0iiSgVyx0TsbAg7frOFJ8dsJE96I066PsCjGnHiSSFtTGxXmHY2pGJ
         KWokkMaojB7NcgoV7YICB5tu9WMwDvVV028vLwOvTaAVGK7/TQPYjd2c6hmwOhX74zTa
         GHI9zhXKwwBa3HfHwW6hAfKSBN3o1bN3JzI0Djl4bJv73ol6x54lpqcT2rY1Cff3vJYv
         M4aXg73DQBVbhTZdxdtFDCAW0ufVEp5RfUmSVsJVJ+0fbUExxf9ymveozQBAX1zUZtqg
         OEcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ar/RYsQiETTjjxvJHozBvp1MbTSOUxcuqSLEZv8K3bo=;
        b=34EaFbf58xVCpegOqavwaQvU7sa6uTbpHn8u7nA32DDFyNiSardPrme/TczsX74MBx
         sta9k/YnShCaGTbHT35QEiYHefOnfEE5iLg4FXZsogmDeCsAO0cmBrecGDwhb7PpB8Jo
         PgLNZRHbJszyblnpOKM1dbMQ5w0aQ1qVZipyiQFNSYspcPciX9TRMAxZxIzhDCEktPmb
         oze4GB7K8nutOrvDx92SdNr1p5MmGcTofKar8gMzXyNgfVhhSTeS/nZkIWfflsGRybqE
         VqX8M2MIE9umKrpOOF5c0iygo9XGX6AJGFxXRfCbb/nVlta4qSzd4HDLqiNNAhYy1DsY
         jpKQ==
X-Gm-Message-State: ANoB5pkhVtUswVcve2+vby/gq54qrijgGGyrlHZm177incKYO3v4WQ/E
	yLJi6GD/TPQtZp6PokSocY/iJey7dXoy3U9sUtG5ww==
X-Google-Smtp-Source: AA0mqf4qO90v/zRQdgdyCplcsQ+yuw299RAUrvggn/40wCgn8ZzFOwXKlOY48E7OUmgZx4s0SleJmYDAXCRbrO5Gw/U=
X-Received: by 2002:a17:907:72d2:b0:7bc:15fc:5398 with SMTP id
 du18-20020a17090772d200b007bc15fc5398mr21465243ejc.438.1669749721411; Tue, 29
 Nov 2022 11:22:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221129190123.872394-1-nathan@kernel.org>
In-Reply-To: <20221129190123.872394-1-nathan@kernel.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 29 Nov 2022 11:21:25 -0800
Message-ID: <CABCJKud96Jrz-NXeW+EW8VwcgYyd1WA=b+H0f-kcWSxkd8PzKw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix lack of section mismatch warnings with LTO
To: Nathan Chancellor <nathan@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Tom Rix <trix@redhat.com>, Nicolas Schier <nicolas@fjasle.eu>, 
	Vincent Donnefort <vdonnefort@google.com>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
	Steffen Klassert <steffen.klassert@secunet.com>, Daniel Jordan <daniel.m.jordan@oracle.com>, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 29, 2022 at 11:02 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
>
> Hi all,
>
> Vincent recently reported an issue with lack of section mismatch
> warnings with LTO. This is due to commit 6c730bfc894f ("modpost: handle
> -ffunction-sections"), which ignores all function sections for modpost.
>
> I believe this is incorrect, as these function sections may still refer
> to symbols in other sections and they will ultimately be coalesced into
> .text by vmlinux.lds anyways.
>
> The first patch fixes a warning that I see with allmodconfig + ThinLTO
> builds after applying the second patch. The second patch moves ".text.*"
> into TEXT_SECTIONS so that modpost audits them for mismatches.
>
> I expect this to go via the kbuild tree with an ack from the padata
> maintainers.
>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: linux-crypto@vger.kernel.org
>
> Nathan Chancellor (2):
>   padata: Do not mark padata_mt_helper() as __init
>   modpost: Include '.text.*' in TEXT_SECTIONS
>
>  kernel/padata.c       | 4 ++--
>  scripts/mod/modpost.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

These look good to me. Thanks for fixing the issue, Nathan!

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
