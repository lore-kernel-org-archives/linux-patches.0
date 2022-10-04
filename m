Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0333443C
	for <patches@lists.linux.dev>; Tue,  4 Oct 2022 22:56:57 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id f23so13911483plr.6
        for <patches@lists.linux.dev>; Tue, 04 Oct 2022 15:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=QyAhz6ALR6OknrHi21cM45DVng3FrSfTwVHduk++aVc=;
        b=T8c6l4OEzQQlUGOM/Wu/f8con4dQ+VQ7A4dDgGymjbAxIfZBa/pDz3Z7i81RA37Jra
         bSFirZ7L7kRWgVWJszfW/uoy37k+Tb/Kv5tyfQ8KXrsC1wtkGRdtWR2xKau0IkqKmKUC
         Hp48AQ6aqlOAejj63soiAFfOaC7ZkDGYE2Cwy70INzcUOljB8/9yCXYXSF5yCIP41GYu
         8eDRtuYL3xU32myu+awpCVrEnp9yEpUnqasxIFjQBazADn78lfKPCIfwB08bv40x3kQy
         nA7nktqzR3SxWXByjG2jJwBXK4of04+CTc+3mGV6U7XaDCPtzJVpe+KsX0LSU6RWZnwV
         GgNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=QyAhz6ALR6OknrHi21cM45DVng3FrSfTwVHduk++aVc=;
        b=bZkBRTZ3u/8ZSOvyw3NzthCkE3iswBMHcMig+dBROcIergLHecgvCmYQnVdqkx7xPK
         4ssyaAIsxUeXk0TAPfaklOMIBlhEnXoSeAeUSuuQUulX68+HD5qNbUR0Px0+AwL2LZma
         KXfz2pZHSlTR19VchBZlsRN4B9c8i80qUsFMc1DaV4HGCsYGQDftHM2ogmMGB8T1xuW+
         ESj216rny1wfNMXhHtVZhxhpHJS3Nka6zSiSC3kyNps/+iJcRqoIDS1gXYNM+szzX3Nr
         OgMrFL6AVGY9ctpVhShVyB1Op9YJQmbMKFcBHe2ZQksNSh31YERpkBRC6Nn5pBLgmJJW
         8z4Q==
X-Gm-Message-State: ACrzQf2q7PxPtyXrShlNvykV0Iz+iVe+TFWhs3UgfA2WQSDlh9Hfd8V8
	RBX+Q15hvAF819eHhARtzCu4rsIKad37Q5cN0PE0vw==
X-Google-Smtp-Source: AMsMyM7fvdim6OhTKFokNtsHeGXAckZrL5jgxA67YFYqvLFqCJUb8Qamapk9O7Ss5n/7Iv0KW5fe1mFEG9uGLxXpPlk=
X-Received: by 2002:a17:90b:3a88:b0:209:f35d:ad53 with SMTP id
 om8-20020a17090b3a8800b00209f35dad53mr1985982pjb.102.1664924217153; Tue, 04
 Oct 2022 15:56:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221004144145.1345772-1-nathan@kernel.org>
In-Reply-To: <20221004144145.1345772-1-nathan@kernel.org>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 4 Oct 2022 15:56:45 -0700
Message-ID: <CAKwvOdm=ZHjoF+j+ivj17t3OMpTA-5Dx71+g3KRSHO=L6RRpEA@mail.gmail.com>
Subject: Re: [PATCH -next] fs/ntfs3: Don't use uni1 uninitialized in ntfs_d_compare()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tom Rix <trix@redhat.com>, 
	ntfs3@lists.linux.dev, llvm@lists.linux.dev, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 4, 2022 at 7:42 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Clang warns:
>
>   fs/ntfs3/namei.c:445:7: error: variable 'uni1' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>                   if (toupper(c1) != toupper(c2)) {
>                       ^~~~~~~~~~~~~~~~~~~~~~~~~~
>   ./include/linux/ctype.h:64:20: note: expanded from macro 'toupper'
>   #define toupper(c) __toupper(c)
>                     ^
>   fs/ntfs3/namei.c:487:12: note: uninitialized use occurs here
>           __putname(uni1);
>                     ^~~~
>   ./include/linux/fs.h:2789:65: note: expanded from macro '__putname'
>   #define __putname(name)         kmem_cache_free(names_cachep, (void *)(name))
>                                                                         ^~~~
>   fs/ntfs3/namei.c:445:3: note: remove the 'if' if its condition is always false
>                   if (toupper(c1) != toupper(c2)) {
>                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   fs/ntfs3/namei.c:434:7: error: variable 'uni1' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
>                   if (!lm--) {
>                       ^~~~~
>   fs/ntfs3/namei.c:487:12: note: uninitialized use occurs here
>           __putname(uni1);
>                     ^~~~
>   ./include/linux/fs.h:2789:65: note: expanded from macro '__putname'
>   #define __putname(name)         kmem_cache_free(names_cachep, (void *)(name))
>                                                                         ^~~~
>   fs/ntfs3/namei.c:434:3: note: remove the 'if' if its condition is always false
>                   if (!lm--) {
>                   ^~~~~~~~~~~~
>   fs/ntfs3/namei.c:430:22: note: initialize the variable 'uni1' to silence this warning
>           struct cpu_str *uni1, *uni2;
>                               ^
>                               = NULL
>   2 errors generated.
>
> There is no point in calling __putname() in these particular error
> paths, as there has been no corresponding __getname() call yet. Just
> return directly in these blocks to clear up the warning.
>
> Fixes: a3a956c78efa ("fs/ntfs3: Add option "nocase"")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1729
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  fs/ntfs3/namei.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
> index 315763eb05ff..5d3a6ce3f05f 100644
> --- a/fs/ntfs3/namei.c
> +++ b/fs/ntfs3/namei.c
> @@ -431,10 +431,8 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
>
>         /* First try fast implementation. */
>         for (;;) {
> -               if (!lm--) {
> -                       ret = len1 == len2 ? 0 : 1;
> -                       goto out;
> -               }
> +               if (!lm--)
> +                       return len1 == len2 ? 0 : 1;

I know the code originally used this, but I can't help but look at
this and think that it should be:

return len1 != len2;

Do you mind cleaning it up while you're here?

Otherwise LGTM;

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

You may retain my RB tag whether you send that suggestion in a v2 or not.

>
>                 if ((c1 = *n1++) == (c2 = *n2++))
>                         continue;
> @@ -442,10 +440,8 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
>                 if (c1 >= 0x80 || c2 >= 0x80)
>                         break;
>
> -               if (toupper(c1) != toupper(c2)) {
> -                       ret = 1;
> -                       goto out;
> -               }
> +               if (toupper(c1) != toupper(c2))
> +                       return 1;
>         }
>
>         /*
>
> base-commit: d45da67caedacd500879de5e649360cc70777af7
> --
> 2.37.3
>


-- 
Thanks,
~Nick Desaulniers
