Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B87F1E9E1
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 20:46:28 +0000 (UTC)
Received: by mail-pg1-f172.google.com with SMTP id 6so2705798pgm.6
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 12:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=94TsYS9Lhx3savK/i0rFKWoF2OB6Clo4zum9Q7WKAV8=;
        b=QkagP8ACYR8CagjP1G4Y5wJdFJ+jYesXPOL5g2+j1fUnp1hkvLCMFRVI4ER/b/Z4mD
         y4j1EEZ9lHH1umfNxhML7hgO8CrD6hGaW+rezADHqexqePWUNB/Xr2fjmDOWqnFkEUbv
         X/wPF8DR34roo3Eytdk9XCQHJT80DCQ6LagvkAiE4uI7BLF3Q1hj/TsNvym4lH0/IidO
         Hk3F/KyLZiM2zsutznNdhHeSDs1fdiHxGYAXVxzjG1VOPv/4hYjHDMNIlJkrO2xEsXO/
         f6jcN4bd6HS1qoAJcUrknp8vuUgDY1k4ZKYNzLfqeCrrFYmyWg4m5Cqa4q/9NHVSDuWA
         EA9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=94TsYS9Lhx3savK/i0rFKWoF2OB6Clo4zum9Q7WKAV8=;
        b=E/D5GQVL9b/2lGsAb8by3GGIpYwhHlDxsl37QtKc+sCkKxa2vsEq1ioLgU39Kg4Jwa
         CKl9VeHSMoU3LyQINlbaGeIfyuziL3k6+PnQNwnJoHilywnkKPc6Zqrl5VxvhYo4tzu5
         qctyCbxPJKHT6WR3+LlDhEf09DaV/uKD4tiqHAX6FfiVQCmnAdESI9KkBHJgnp0yRVCY
         iAaXOXfsfLrcyCEHxiyTrafuqezZdeJJZBKhUHsTaLFq3QSWpALWdQGaGtMewVFg01v9
         xAFgPIfEtX+WQH65RlNGBGc21HREm4sN3SSze7jZUVmRbeCVUf9rRbpv42CuZKG6+/5/
         Mhyg==
X-Gm-Message-State: ACrzQf3u3fWFDjj/iZYo5/23o0yqLbCTRYak3xQ3CfzDTfQewmTYm348
	NVUOCZXcrT5k3x//3gadnAVkxjCtM3eJzE6v1CS2yQ==
X-Google-Smtp-Source: AMsMyM6lWyNpiBMuUpIxE8MbdlCB9fhr4E+gnLs9ulGDCERUWsGS/HRwd7uPd6QgpzzzWpmoyYXNSBqYsniomAJw+RU=
X-Received: by 2002:a05:6a00:1a4a:b0:56d:98e3:4df8 with SMTP id
 h10-20020a056a001a4a00b0056d98e34df8mr3400650pfv.37.1668113187475; Thu, 10
 Nov 2022 12:46:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221109000306.1407357-1-nathan@kernel.org>
In-Reply-To: <20221109000306.1407357-1-nathan@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 10 Nov 2022 12:46:16 -0800
Message-ID: <CAKwvOdkxLXLna0cfkA8ay54vU0NwMj2AFR8CZg3pgpvqOKeXjw@mail.gmail.com>
Subject: Re: [PATCH] x86/vdso: Conditionally export __vdso_sgx_enter_enclave
To: Nathan Chancellor <nathan@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 8, 2022 at 4:04 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Recently, ld.lld moved from '--undefined-version' to
> '--no-undefined-version' as the default, which breaks building the vDSO
> when CONFIG_X86_SGX is not set:
>
>   ld.lld: error: version script assignment of 'LINUX_2.6' to symbol '__vdso_sgx_enter_enclave' failed: symbol not defined
>
> __vdso_sgx_enter_enclave is only included in the vDSO when
> CONFIG_X86_SGX is set. Only export it if it will be present in the final
> object, which clears up the error.
>
> Link: https://github.com/ClangBuiltLinux/linux/issues/1756
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>
> It would be nice if this could be picked up for an -rc release but I
> won't argue otherwise.

Sounds like the lld change got reverted, so this is less urgent now,
but the change still LGTM regardless. Thanks for the patch!

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Fixes: 8466436952017 ("x86/vdso: Implement a vDSO for Intel SGX enclave call")


>
> Alternatively, we could add '--undefined-version' to the vDSO ldflags
> but this does not seem unreasonable to me.
>
>  arch/x86/entry/vdso/vdso.lds.S | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/entry/vdso/vdso.lds.S b/arch/x86/entry/vdso/vdso.lds.S
> index 4bf48462fca7..e8c60ae7a7c8 100644
> --- a/arch/x86/entry/vdso/vdso.lds.S
> +++ b/arch/x86/entry/vdso/vdso.lds.S
> @@ -27,7 +27,9 @@ VERSION {
>                 __vdso_time;
>                 clock_getres;
>                 __vdso_clock_getres;
> +#ifdef CONFIG_X86_SGX
>                 __vdso_sgx_enter_enclave;
> +#endif
>         local: *;
>         };
>  }
>
> base-commit: f0c4d9fc9cc9462659728d168387191387e903cc
> --
> 2.38.1
>
>


-- 
Thanks,
~Nick Desaulniers
