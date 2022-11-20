Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66358623
	for <patches@lists.linux.dev>; Sun, 20 Nov 2022 01:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83F9C433C1;
	Sun, 20 Nov 2022 01:43:35 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ODdiTBv9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1668908614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EMOnb4Eh0QJPg88DCqW7xV2grBHj3iQptuAg9SBqi6s=;
	b=ODdiTBv9ajWI3NjDRVhUjH7AMzmT55WJR8XnvwC+3FnpYhLEW6CQKy/r7IoTO6ScCzbwTG
	60y4/nmZgs/2XqSyiczEoQq0qaMf1QMnaZtfHaCjRvulL7K5lfBrl2B3a00Tlm43j3EhLl
	75+T1ccrLI3izYvLGZW25h+oDpnQqpM=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 58321d7a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 20 Nov 2022 01:43:33 +0000 (UTC)
Date: Sun, 20 Nov 2022 02:43:31 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-crypto@vger.kernel.org, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH v5 2/3] random: introduce generic vDSO getrandom()
 implementation
Message-ID: <Y3mGQyqPBTcoyPpS@zx2c4.com>
References: <20221119120929.2963813-1-Jason@zx2c4.com>
 <20221119120929.2963813-3-Jason@zx2c4.com>
 <Y3liVEdYByF2gZZU@sol.localdomain>
 <Y3l6ocn1dTN0+1GK@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y3l6ocn1dTN0+1GK@zx2c4.com>

On Sun, Nov 20, 2022 at 01:53:53AM +0100, Jason A. Donenfeld wrote:
> shouldn't fork or something, but that seems disappointing. Or more state
> could be allocated in the zeroing region, to hold a chacha state, so
> another 64 bytes, which would be sort of unfortunate. Or something else?
> I'd be interested to hear your impression of this quandary.

Another 128 bytes, actually. And the current chacha in there isn't
cleaning up its stack as one might hope. So maybe the cleanest solution
would be to just bite the bullet and allocate another 128 bytes per
state and make a mini chacha that operates over that? (And I guess hope
it doesn't need to spill and such...)

Jason
