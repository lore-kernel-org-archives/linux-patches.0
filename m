Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C09776F1B;
	Tue, 21 May 2024 12:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716294745; cv=none; b=HhOhRSr5oLRpmj8Ez5WYUIqpqf0GFE3rQ+zQmVgoUTu5BSSblET2i/ljNtRbWqpc7jsCBnYFlyUk6lq04FERz8GmJp2V9UlPsItriionavqYuPTnSG3CREGjU20deOHc14KUTB1JVJMHh44LtpznXS9RuwMCmJLhnwdiz5iGnCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716294745; c=relaxed/simple;
	bh=lJH99oEfELQo4YpxFi9oSnZr1WynJ4J1GXjG73y39yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hqgz6LLFDR+BPP7NQSa/QuE9QQXLHOUJOsFHV72aRNz4aF6ohCIfv2wBiupTYxv6aVpZw5/DZ2nQInjLHDeeebtLM474cTpe12MIljnlJWBPeKD8SXIt02GaQSbcz9Vzt6w/9adBmDcNxxh0hBKXsz4C1y+q8xgoaKIqxoSWl0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=csNPwieI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="csNPwieI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C906C2BD11;
	Tue, 21 May 2024 12:32:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="csNPwieI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1716294742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bOeW+XNOZlEkfc+I6ht2irFCJlPanLIdFnPaPKj/f3k=;
	b=csNPwieIdOzQfSLoGZnqiMjjip5EKQIo/6RLLoUAwB2Pyn95T9sN0R5Ak8dLeh6VaBLN1r
	DPwt+3zJpLFN1u5NTarkvpU7OBxK6L42JOrNeYQKkpgvGYcSCekH8XYmIzfuVYjoWCwfoF
	X05lwNv9Zw8+7LDYV+W8AqALn3N4Srs=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 88714705 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Tue, 21 May 2024 12:32:22 +0000 (UTC)
Date: Tue, 21 May 2024 14:32:20 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	tglx@linutronix.de, adhemerval.zanella@linaro.org
Subject: Re: [PATCH v15 2/5] random: add vgetrandom_alloc() syscall
Message-ID: <ZkyUVOXzYg7h9OqV@zx2c4.com>
References: <20240521111958.2384173-1-Jason@zx2c4.com>
 <20240521111958.2384173-3-Jason@zx2c4.com>
 <87msoj5qth.fsf@oldenburg.str.redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87msoj5qth.fsf@oldenburg.str.redhat.com>

On Tue, May 21, 2024 at 01:48:10PM +0200, Florian Weimer wrote:
> * Jason A. Donenfeld:
> 
> > Libc is expected to allocate a chunk of these on first use, and then
> > dole them out to threads as they're created, allocating more when
> > needed. The returned address of the first state may be passed to
> > munmap(2) with a length of `num * size_per_each`, in order to deallocate
> > the memory.
> 
> I think “first use” actually means “processs start” here?  We don't have
> a way to report failure from arc4random and similar interfaces.

First use, actually. On failure this just falls back to slow syscall
getrandom() with identical semantics.

Adhemerval has a branch of libc where he implemented this, if you're
interested. He's in CC to send the link.

Jason
