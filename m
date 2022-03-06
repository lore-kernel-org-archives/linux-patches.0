Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1E710EE
	for <patches@lists.linux.dev>; Sun,  6 Mar 2022 00:39:20 +0000 (UTC)
Received: by mail-lf1-f44.google.com with SMTP id z11so5002376lfh.13
        for <patches@lists.linux.dev>; Sat, 05 Mar 2022 16:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8en4x3D3Rsg/390DQsGf7zpMFnrPA9uIThUqXWbX5VQ=;
        b=bKrr0ECQzIOFX5TyirNazif8P09OceAONKiQyW/yEi8g9MJT21Cz/7WbPo9YULkY15
         RWKU8stQUs/9OEoYQyxn4raJjyEdTMZNn9qJelnfy+TgJ0AlDwb3U22Oi7+srHOTkVBm
         KvKfPdjVTlKgnJjBgR6RBRkBgmRovRxx8C86o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8en4x3D3Rsg/390DQsGf7zpMFnrPA9uIThUqXWbX5VQ=;
        b=UfM5cn4FNtqFNBtYlQkBCzGsr3z1RL6Ap//l/ql/N9bbctjfUq8ZlYhzc1/KErGHw4
         hWl6WtzFZwOdp7kKhZmTFm9bmxkjn+u/0X18S0v3jmM3ozxDoztqPfYghPcCPN5PAk7K
         yLn8M6pHSYo3Q8hGj7mwTpZ+UlH0QzTPpUcqq+WJxk8HISk8Iy0Q/63JEvpenZW+94xO
         P3SzxHzUA+CtAgAnnXX8J8YsIAWQnaPXT7ij2tAH3rV3scIft2lHObiqqkzBz4gUNCP+
         kFggxmjJyMXWtMJqoHtkCMywJ1YCt6v0K8E7FtGSkB8gtT+Ns5AlQXRjn2h0R/HY/I0/
         J/rw==
X-Gm-Message-State: AOAM532VQxPGQstd4ktiAClYhb+bdRCvvpKrROo5gYxLadD6GRAzVxZh
	v0FrDOpEhHzG6rPb/B7aiWJSDiMlNV+buyZAYT8eTw==
X-Google-Smtp-Source: ABdhPJzI8E5L4Sw1o6+sYE7Ff0ogW6PSxC3oH6Scun8+7F+IjtPXm1jvlSPm5HPLk2Zhz3yhRKXTyEYoYBwPhub/FdA=
X-Received: by 2002:ac2:4c4f:0:b0:448:1d8d:292c with SMTP id
 o15-20020ac24c4f000000b004481d8d292cmr3647686lfk.51.1646527158595; Sat, 05
 Mar 2022 16:39:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220304211524.10706-1-rdunlap@infradead.org> <CAOkoqZ=Cy_gXNehJP-o66UO=6X8c93e9NJgnBJgZoEMoYiOzUg@mail.gmail.com>
 <20220304194116.613d2fd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220304194116.613d2fd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From: Dimitris Michailidis <d.michailidis@fungible.com>
Date: Sat, 5 Mar 2022 16:39:04 -0800
Message-ID: <CAOkoqZniH-7jc3gMtVSP0Htn4DOQ51QE_DjDW1JmY2dm-ekDHQ@mail.gmail.com>
Subject: Re: [PATCH net-next?] net: fungible: fix multiple build problems
To: Jakub Kicinski <kuba@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org, patches@lists.linux.dev, 
	Dimitris Michailidis <dmichail@fungible.com>, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"

On Fri, Mar 4, 2022 at 7:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 4 Mar 2022 16:39:49 -0800 Dimitris Michailidis wrote:
> > > Also, gcc 7.5 does not handle the "C language" vs. #ifdef preprocessor
> > > usage of IS_ENABLED() very well -- it is causing compile errors.
> >
> > I believe this is the source of the errors you see but it's not the compiler's
> > fault or something specific to 7.5.0. The errors are because when
> > IS_ENABLED() is false some of the symbols in the "if" are undefined and the
> > compiler checks them regardless.
>
> The compiler will need at least a declaration, right? tls_driver_ctx()
> is pretty stupidly hidden under an ifdef, for reasons which I cannot
> recall. Maybe we can take it out?
>
> Same thing could work for fun_tls_tx():
>
>         return skb;
>  }
> +#else
> +struct sk_buff *fun_tls_tx(struct sk_buff *skb, struct funeth_txq *q,
> +                          unsigned int *tls_len);
>  #endif
>
> no?

Yes, including net/tls.h and funeth_ktls.h unconditionally along with
providing dummy definitions for the symbols involved in these errors when
CONFIG_TLS_DEVICE=n would also solve the problem. I'd prefer this over
adding #ifdef to have the compiler check the code regardless of configuration.
