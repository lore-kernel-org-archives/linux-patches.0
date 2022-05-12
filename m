Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D3F2F31
	for <patches@lists.linux.dev>; Thu, 12 May 2022 21:30:19 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id x52so5930518pfu.11
        for <patches@lists.linux.dev>; Thu, 12 May 2022 14:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:user-agent:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=BIPrJxqbXAd+295s29/rrMW5CvpwBx6wdUxINV63DAg=;
        b=Zg5truXSUHQKziPjOTc4E2O6KDJH+6qHbxL+9Law57qzVH6SVKpT2voeDHzzyvzj5b
         uggFLFxEqgtXYEb9pQplsYNKt0VUIvBSB/e/jlS+B4YlmJCuXVMoilgQjYogEfO1ShEk
         8oRI17+p6b147utmqg5HMg+CqdgII9RBkSRNc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=BIPrJxqbXAd+295s29/rrMW5CvpwBx6wdUxINV63DAg=;
        b=ZlFEwRWfBUTtyYfXKMluUPwLlNaZ45kIn92c1plVZoR6rEKiWg2z8vLiwnFuD1WsPX
         6j6UfYLKnBe0f2oLW0QxEhQcQ7v1qQ68gSPKavbwptxOeCkImDySYxgjtt/qPh0edR8j
         AkZFoZWwUR2bHwwDBBjp87zfJi3N4KooaQCCQ0pYkrVRECTX4wu3O5TE7FOlH6a/1Z6i
         Vrlxv7uuN+r0mwLXE6+QcGCJEeYio+fZEIRWym6DwjsrV1o6g+/1t2c7u0bKlHBE0jfh
         SYqh4dCCVUpF2sxWOHlN0F0RcWfXSB9E7OEKE/K9UlJhbM9puUXP57nnc0A6rrTkJtth
         Y+0A==
X-Gm-Message-State: AOAM533L0OgH/eU7WiRaxnJ6TlGNtT1gXhht3jtYXn99f9dDFGyyolKy
	N4yqhZRaR+/lZoYNUtTs5srGzw==
X-Google-Smtp-Source: ABdhPJzDDlG5ka/o2WcllRfswJSM7NjDXKFvt55zHZ+GNjiCVBiiEna26O0pZFz3O+Zji3jW2c7Ibw==
X-Received: by 2002:a05:6a00:c8f:b0:510:60cf:55fa with SMTP id a15-20020a056a000c8f00b0051060cf55famr1314141pfv.37.1652391019468;
        Thu, 12 May 2022 14:30:19 -0700 (PDT)
Received: from [127.0.0.1] (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id q16-20020a170902edd000b0015f3d8759e4sm350899plk.167.2022.05.12.14.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 14:30:19 -0700 (PDT)
Date: Thu, 12 May 2022 14:30:17 -0700
From: Kees Cook <keescook@chromium.org>
To: Nathan Chancellor <nathan@kernel.org>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
CC: Sami Tolvanen <samitolvanen@google.com>,
 Nick Desaulniers <ndesaulniers@google.com>, Tom Rix <trix@redhat.com>,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] drm/i915: Fix CFI violation with show_dynamic_id()
User-Agent: K-9 Mail for Android
In-Reply-To: <20220512211704.3158759-1-nathan@kernel.org>
References: <20220512211704.3158759-1-nathan@kernel.org>
Message-ID: <DEB6A9AC-845E-4656-A596-E6341D3C287F@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



On May 12, 2022 2:17:04 PM PDT, Nathan Chancellor <nathan@kernel=2Eorg> wr=
ote:
>When an attribute group is created with sysfs_create_group(), the
>->sysfs_ops() callback is set to kobj_sysfs_ops, which sets the ->show()
>callback to kobj_attr_show()=2E kobj_attr_show() uses container_of() to
>get the ->show() callback from the attribute it was passed, meaning the
>->show() callback needs to be the same type as the ->show() callback in
>'struct kobj_attribute'=2E
>
>However, show_dynamic_id() has the type of the ->show() callback in
>'struct device_attribute', which causes a CFI violation when opening the
>'id' sysfs node under drm/card0/metrics=2E This happens to work because
>the layout of 'struct kobj_attribute' and 'struct device_attribute' are
>the same, so the container_of() cast happens to allow the ->show()
>callback to still work=2E
>
>Change the type of show_dynamic_id() to match the ->show() callback in
>'struct kobj_attributes' and update the type of sysfs_metric_id to
>match, which resolves the CFI violation=2E
>
>Fixes: f89823c21224 ("drm/i915/perf: Implement I915_PERF_ADD/REMOVE_CONFI=
G interface")
>Signed-off-by: Nathan Chancellor <nathan@kernel=2Eorg>

This matches my own investigation into the error=2E Thanks for putting the=
 patch together! :)

Reviewed-by: Kees Cook <keescook@chromium=2Eorg>


--=20
Kees Cook
