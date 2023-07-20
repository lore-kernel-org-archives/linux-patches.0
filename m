Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA5018AF6;
	Thu, 20 Jul 2023 15:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54165C433C7;
	Thu, 20 Jul 2023 15:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689866199;
	bh=cVe5IVCXrI2dTRFYJoEnl0cnQpuSELuvSLGYYEvbTf4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UKcPq9XCIwquJcL3mnGYr3evcDeveAHebalY3TcoJFLG8nvrsD8jh2Wlm9u1eGA7L
	 UmAkmsfQPf55yk8+oH6CFiL52EN+h760zhead+InEDJRosFzUvX7/kBYtzcXiowwFp
	 wMRJamotYNIceen6wFkHvKV1Z/FOXdJr2EcBZ+dmAceP2NXZgu/AfbOaRVaIxb2Tmg
	 kaCqFfkcOvDaihJ1211vVCLMhqh+QVvsPRKSzKq+oTHUlFpjvG7TgZUoITqkJFNjit
	 z/XTixs6VEeqTliLic5ED2ORon889x1b7MvtbmZ+GuvN/9e5xTdFEunHMW+fCDAx/1
	 eyC3SCSoy3Qkg==
Date: Thu, 20 Jul 2023 08:16:36 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
	rodrigo.vivi@intel.com, emma@anholt.net, mwen@igalia.com,
	ndesaulniers@google.com, justinstitt@google.com, trix@redhat.com,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH 2/2] drm/i915: Avoid -Wconstant-logical-operand in
 nsecs_to_jiffies_timeout()
Message-ID: <20230720151636.GA511202@dev-arch.thelio-3990X>
References: <20230718-nsecs_to_jiffies_timeout-constant-logical-operand-v1-0-36ed8fc8faea@kernel.org>
 <20230718-nsecs_to_jiffies_timeout-constant-logical-operand-v1-2-36ed8fc8faea@kernel.org>
 <1a2aeca6-12f7-6316-c6e2-8474fd17255e@linux.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a2aeca6-12f7-6316-c6e2-8474fd17255e@linux.intel.com>

On Thu, Jul 20, 2023 at 09:43:05AM +0100, Tvrtko Ursulin wrote:
> 
> On 18/07/2023 22:44, Nathan Chancellor wrote:
> > A proposed update to clang's -Wconstant-logical-operand to warn when the
> > left hand side is a constant shows the following instance in
> > nsecs_to_jiffies_timeout() when NSEC_PER_SEC is not a multiple of HZ,
> > such as CONFIG_HZ=300:
> > 
> >    drivers/gpu/drm/i915/gem/i915_gem_wait.c:189:24: warning: use of logical '&&' with constant operand [-Wconstant-logical-operand]
> >      189 |         if (NSEC_PER_SEC % HZ &&
> >          |             ~~~~~~~~~~~~~~~~~ ^
> >    drivers/gpu/drm/i915/gem/i915_gem_wait.c:189:24: note: use '&' for a bitwise operation
> >      189 |         if (NSEC_PER_SEC % HZ &&
> >          |                               ^~
> >          |                               &
> >    drivers/gpu/drm/i915/gem/i915_gem_wait.c:189:24: note: remove constant to silence this warning
> >    1 warning generated.
> > 
> > Turn this into an explicit comparison against zero to make the
> > expression a boolean to make it clear this should be a logical check,
> > not a bitwise one.
> 
> So -Wconstant-logical-operand only triggers when it is a
> constant but not zero constant? Why does that make sense is not
> a kludge to avoid too much noise?

Yes, the warning purposefully does not trigger when the constant is a 1
or 0 (as those are usually indicative of an intentional logical
operation):

https://github.com/llvm/llvm-project/blob/dfdfd306cfaf54fbc43e2d5eb36489dac3eb9976/clang/lib/Sema/SemaExpr.cpp#L13917-L13919

In this case, it is 100, so I kind of understand why this might be
ambiguous to the compiler.

> Personally, it all feels a bit over the top as a warning,
> since code in both cases should optimise away. And we may end

I do not necessarily disagree, as you can see from the differential
review that I linked in the message, but I also understand it is a fine
line to tread when writing compiler warnings between wanting to catch
as many potential problems as possible and having too much noise for
developers to sift through. I think this is erring on the side of
caution.

> up papering over it if it becomes a default.

diagtool tree tells me this warning is already on by default.

> Then again this patch IMO does make the code more readable, so

I think so too.

> I am happy to take this one via our tree. Or either give ack to
> bring it in via drm-misc-next:
> 
> Acked-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
> 
> Let me know which route works best.

Thanks for the feedback! Either route is fine with me but if the v3d
patch is going to go in via drm-misc-next, it seems like it would not be
too much trouble to push this one with it.

Cheers,
Nathan
