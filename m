Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9943FB33
	for <patches@lists.linux.dev>; Wed, 18 Oct 2023 18:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bVbIWj/i"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5832ea25c7eso203590eaf.3
        for <patches@lists.linux.dev>; Wed, 18 Oct 2023 11:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1697652863; x=1698257663; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b5ifuSh3pAXhwmN6aI2xPo6Qr4r8ZyUW95PzWHa09WA=;
        b=bVbIWj/iXruO5HRrMzZaXhY7JMJP+wLDeyMlMLwSfjtD/t+1dOvaRFmO/B12mFnQ6v
         QVr93G3h8Pa6Qn10xbZGIWVNw5qBMQ0F+JxLIu/riFOf3I6c1i+s/OZDklN0vvx0t5nK
         LUq5/A2/g9LoN9mhrjgBDMB3MLFlH8/cxSQJU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697652863; x=1698257663;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b5ifuSh3pAXhwmN6aI2xPo6Qr4r8ZyUW95PzWHa09WA=;
        b=XpS07ZLsRF/f46BABwezGOOLeQ4ufTU0se6P/BaoIohAMnEXQ5Dvvm0l7I2rRGqt07
         AjItAxIEtsxGLEwt8N6YK5in8LFj8LpWxKVQiTD1UjFeNs2hZNGwcaxlncavgVM+jrv3
         bbxPmxnqZ/e914ZgUUCsNlcZyedjBCdPvPOd8VGxqiyJOe8lRu74Yk3JJwCGJuBLL7t4
         lrcY/z+t19l/sNYxXyzurplVEJeIzgvMkpIIAyazGHV3NaiCM/hlowpggmrjKKKQdWpk
         S1ftzOIffOq7ZzbIMGI7eSOvjPY8tXV5VgvlIKO9ccYBYsfXyGEUNUp9sWk0sG14H3Ig
         RPdA==
X-Gm-Message-State: AOJu0YwhBpmZkzlhF0rW4skkkWEcfqqYVrdSKFfs7bE89JUe7FAPa3i5
	KtMnA3a3dXvrX+9XYkOkkedvCA==
X-Google-Smtp-Source: AGHT+IF8xi8GFiUQY06uOeWqByr5z7EFVgeVDoRSw3v4/DxmzcbtqXvuu1i8IZohOlGRjH61x3+iMg==
X-Received: by 2002:a05:6358:3a0f:b0:166:f348:a8b3 with SMTP id g15-20020a0563583a0f00b00166f348a8b3mr2010476rwe.28.1697652863564;
        Wed, 18 Oct 2023 11:14:23 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id h26-20020aa796da000000b006bae6eea9d0sm3657643pfq.49.2023.10.18.11.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 11:14:23 -0700 (PDT)
Date: Wed, 18 Oct 2023 11:14:22 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: rostedt@goodmis.org, mhiramat@kernel.org, ndesaulniers@google.com,
	trix@redhat.com, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] eventfs: Use ERR_CAST() in eventfs_create_events_dir()
Message-ID: <202310181114.55457CFE@keescook>
References: <20231018-ftrace-fix-clang-randstruct-v1-1-338cb214abfb@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018-ftrace-fix-clang-randstruct-v1-1-338cb214abfb@kernel.org>

On Wed, Oct 18, 2023 at 11:10:31AM -0700, Nathan Chancellor wrote:
> When building with clang and CONFIG_RANDSTRUCT_FULL=y, there is an error
> due to a cast in eventfs_create_events_dir():
> 
>   fs/tracefs/event_inode.c:734:10: error: casting from randomized structure pointer type 'struct dentry *' to 'struct eventfs_inode *'
>     734 |                 return (struct eventfs_inode *)dentry;
>         |                        ^
>   1 error generated.
> 
> Use the ERR_CAST() function to resolve the error, as it was designed for
> this exact situation (casting an error pointer to another type).
> 
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1947
> Fixes: 5790b1fb3d67 ("eventfs: Remove eventfs_file and just use eventfs_inode")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Yes, please. That's the correct method to do such casts. Thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
