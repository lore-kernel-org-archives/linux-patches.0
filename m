Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354365382;
	Wed, 29 Mar 2023 17:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1367DC433D2;
	Wed, 29 Mar 2023 17:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680110700;
	bh=HcR9a4qjBB8LKDYe607WkBKXaWerJixcvHnMfM4MQbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mM0Da/zR0ywsu1h5uDbGPboafXOhhH0p1GVywEQRUjEWuyhH8iHj6V1G4l0f1rVbp
	 4FhHlR2G3U+LguTiTwKRkTv7xn0C1WvJ26ZTJqLGIQKKwy95NWlmHJe5pboYYEJWHd
	 UwI2mFR2P7JSwvirNOUMtnEk68aIY8KO3PINtUbKKplwUyzkfIuvzLDLh4ZVNJ2WaX
	 Mz6ut5KFXihPDAfFxusHsaJvaomG4p9B0SiGqmEi5rVGyDQhTBTLRqpvAIymCjfiS+
	 ONmYuTJFDKMjaygHQJINuyoR4LojG6gInqL1lzr/OLz1OUyeeuFJ4v5vrvlVcwwr8i
	 7JbBh2zqDmy5w==
Date: Wed, 29 Mar 2023 10:24:58 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: gregory.greenman@intel.com, kvalo@kernel.org, ndesaulniers@google.com,
	trix@redhat.com, avraham.stern@intel.com,
	krishnanand.prabhu@intel.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"kernelci.org bot" <bot@kernelci.org>
Subject: Re: [PATCH wireless-next] wifi: iwlwifi: mvm: Avoid 64-bit division
 in iwl_mvm_get_crosstimestamp_fw()
Message-ID: <20230329172458.GA209886@dev-arch.thelio-3990X>
References: <20230329-iwlwifi-ptp-avoid-64-bit-div-v1-1-ad8db8d66bc2@kernel.org>
 <9058a032c177e9b04adbf944ad34c5ed8090d9d6.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9058a032c177e9b04adbf944ad34c5ed8090d9d6.camel@sipsolutions.net>

On Wed, Mar 29, 2023 at 07:20:43PM +0200, Johannes Berg wrote:
> On Wed, 2023-03-29 at 10:05 -0700, Nathan Chancellor wrote:
> > 
> > GCC has optimizations for division by a constant that clang does not
> > implement, so this issue is not visible when building with GCC.
> 
> Huh yeah, we did 32-bit builds with gcc ...
> 
> > Using div_u64() would resolve this issue, but Arnd points out that this
> > can be quite expensive and the timestamp is being read at nanosecond
> > granularity. 
> 
> Doesn't matter though, all the calculations are based on just the
> command response from the firmware, which (tries to) take it in a
> synchronised fashion.

Okay, that is good information, thanks for providing it!

> So taking more time here would be fine, as far as I can tell.
> 
> > Nick pointed out that the result of this division is being
> > stored to a 32-bit type anyways, so truncate gp2_10ns first then do the
> > division, which elides the need for libcalls.
> 
> That loses ~7 top bits though, no? I'd be more worried about that, than
> the time div_u64() takes.

Right, I sent this version of the fix to spur discussion around whether
or not this was an acceptable approach, rather than having the question
sit unanswered in our issue tracker :) I have no problems sending a v2
to use div_u64() and be done with it, which I will do shortly.

Thanks for the quick input, cheers!
Nathan
