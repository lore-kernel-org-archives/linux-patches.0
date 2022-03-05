Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB2F6AAD
	for <patches@lists.linux.dev>; Sat,  5 Mar 2022 19:04:06 +0000 (UTC)
Received: by mail-lj1-f180.google.com with SMTP id r20so15178184ljj.1
        for <patches@lists.linux.dev>; Sat, 05 Mar 2022 11:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yDPu/xaKJbdDPmhQDpmRjEgFy5bmctUIRCD39EGUvLg=;
        b=eBnI1VXfagds1G8DpzAeYzz4CY4BK/8v2hq67nTYqGT9gPw7UZ0YhXCKsxxFFmiCnJ
         HuiUq3PyNtTeGgJNiQKW98ebwpbEBHjtfP1gPB8u20pb/9TJF3wyNv5210M+3JWigKxf
         tOo2KOEdtXC6DrYqfWWcdFb/dYiIDFG+Npb9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yDPu/xaKJbdDPmhQDpmRjEgFy5bmctUIRCD39EGUvLg=;
        b=BmD/B01cZK5MMonr90DVZP4oDh+LCk4sWSrpEa4nV5s9usS5jl4SzL9b+aeWWGLxYW
         ebkMwb9AQI7O/y3cLT40ooN7DtYnCfVvqAenypoPxB1XAH8m226SxezoQpw0GAEzxjom
         N1dmcxvQpVD+dntBz14K0ZfPwfVBiFmPjoCRlBCtl734tooXF6OXnbjjY5SuK7lfxDWu
         mFBofP9ggA5Fz3k5ZEgBvQrt/eblXAslKhKE0iT8+Qq422ekDnZ1TfsYR0dW4ggQxNi/
         rnpUwLuLH59T/GSzl2fMu5Zs84ub7QVLFX7v0qUOOkhZvNsfeu/sRsnkVkfHCiiZykQp
         JPVg==
X-Gm-Message-State: AOAM531KevLaRAaA5kfPCFcH3lu8uMJMs+WXiuLXiikye6YhddrFx/UR
	LMcNKwvil5HnFwFHi3/Z22NywGt2z9vMENzCxpQ=
X-Google-Smtp-Source: ABdhPJwtInF3J8WeTzb9+tVQ262jn0IZqz+IHuCgPtb4KLewMZrXBGJGatHsf03trsYDZGso8spdHw==
X-Received: by 2002:a2e:9082:0:b0:246:59ea:f030 with SMTP id l2-20020a2e9082000000b0024659eaf030mr2785279ljg.390.1646507043995;
        Sat, 05 Mar 2022 11:04:03 -0800 (PST)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id f11-20020a19dc4b000000b0044389008f64sm1799811lfj.164.2022.03.05.11.04.03
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Mar 2022 11:04:03 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id w7so5999082lfd.6
        for <patches@lists.linux.dev>; Sat, 05 Mar 2022 11:04:03 -0800 (PST)
X-Received: by 2002:a05:6512:3042:b0:437:96f5:e68a with SMTP id
 b2-20020a056512304200b0043796f5e68amr3018649lfb.449.1646507032344; Sat, 05
 Mar 2022 11:03:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220304202822.d47f8084928321c83070d7d7@linux-foundation.org> <20220305042855.BFBB9C004E1@smtp.kernel.org>
In-Reply-To: <20220305042855.BFBB9C004E1@smtp.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 5 Mar 2022 11:03:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjA82m5VxsjXLN7giO--0rqXq7-WXxy+O2UTjtdYdYZ3g@mail.gmail.com>
Message-ID: <CAHk-=wjA82m5VxsjXLN7giO--0rqXq7-WXxy+O2UTjtdYdYZ3g@mail.gmail.com>
Subject: Re: [patch 3/8] mm: prevent vm_area_struct::anon_name refcount saturation
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, sumit.semwal@linaro.org, 
	Sasha Levin <sashal@kernel.org>, Peter Collingbourne <pcc@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexey Gladkov <legion@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, 
	Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Cyrill Gorcunov <gorcunov@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, 
	David Hildenbrand <david@redhat.com>, Davidlohr Bueso <dave@stgolabs.net>, 
	Dave Hansen <dave.hansen@intel.com>, chris.hyser@oracle.com, 
	Colin Cross <ccross@google.com>, caoxiaofeng@yulong.com, 
	Christian Brauner <brauner@kernel.org>, Suren Baghdasaryan <surenb@google.com>, patches@lists.linux.dev, 
	Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, Mar 4, 2022 at 8:28 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> To ensure anon_vma_name refcount does not overflow, stop anon_vma_name
> sharing when the refcount reaches REFCOUNT_MAX (2147483647), which still
> leaves INT_MAX/2 (1073741823) values before the counter reaches
> REFCOUNT_SATURATED.  This should provide enough headroom for raising the
> refcounts temporarily.

This is a classic case of kref simply being the wrong type for this.

We sh ould move away from that idiotic "saturate with a warning" type,
and just codify that what the page refs do is the RightThing(tm) to
do.

I've ranted against kref for years, I hate that damn thing. It's
literally broken by design with the known leaking behavior.

Oh well. I'm taking this patch as a "fix up refcount problems", and I
guess I need to some day just extract the page_ref code into a nice
type of its own so that it's usable outside of pages.

(Others have copied the page_ref code manually, but there's no "helper
type with functions to use it", which is why people then use that
mis-designed refcount stuff).

              Linus
