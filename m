Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8C01FC1
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 05:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669267735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oGhflT7lV91BCnp7NtGE7AqpEj9layA6kO876k2xPIw=;
	b=B2JD/KkY86CIXXoQLNTh/a5TQzlqGO58ldcF6NziahbLyGdlbO1FL3KwUpM2zzsYzs29kH
	+Of6GyeMa821AVYVoTPCcaSEgdsMTvrqEHApZRPjTEjH+h+9S4Z0h3DB9H5FAHME9gVpNm
	awXLqMR+AIRq+TTfpAYBTUwGI/wkizs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-_rHe_3x8NNe4hAAvHdr-eQ-1; Thu, 24 Nov 2022 00:28:50 -0500
X-MC-Unique: _rHe_3x8NNe4hAAvHdr-eQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02B45101A528;
	Thu, 24 Nov 2022 05:28:50 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.2.16.44])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 318811401C20;
	Thu, 24 Nov 2022 05:28:48 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org,  patches@lists.linux.dev,
  tglx@linutronix.de,  linux-crypto@vger.kernel.org,  x86@kernel.org,  Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>,  Adhemerval Zanella Netto
 <adhemerval.zanella@linaro.org>,  Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH v6 2/3] random: introduce generic vDSO getrandom()
 implementation
References: <20221121152909.3414096-1-Jason@zx2c4.com>
	<20221121152909.3414096-3-Jason@zx2c4.com>
	<87r0xulzfd.fsf@oldenburg.str.redhat.com> <Y37EHHq41KBvgr8z@zx2c4.com>
Date: Thu, 24 Nov 2022 06:28:44 +0100
In-Reply-To: <Y37EHHq41KBvgr8z@zx2c4.com> (Jason A. Donenfeld's message of
	"Thu, 24 Nov 2022 02:08:44 +0100")
Message-ID: <875yf47wfn.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7

* Jason A. Donenfeld:

> Hi Florian,
>
> On Wed, Nov 23, 2022 at 11:48:06AM +0100, Florian Weimer wrote:
>> * Jason A. Donenfeld:
>> 
>> >   static void *vgetrandom_alloc(size_t *num, size_t *size_per_each, unsigned int flags)
>> >   {
>> >     unsigned long ret = syscall(__NR_vgetrandom_alloc, num, size_per_each, flags);
>> >     return ret > -4096UL ? NULL : (void *)ret;
>> >   }
>> 
>> The traditional syscall function returns -1 on error and set errors, so
>> using unsing long and the 4096 is quite misleading.
>
> Not sure I have any idea at all whatsoever about what you're talking
> about. Firstly, the function you quoted is from the "sample userspace
> code" in the commit message, so it might not be code for the context you
> have in mind.

I'm talking about the syscall function that is available through
userspace via <sys/syscall.h>.

> Secondly, it's just doing the thing to figure out if the return value is
> an error value or a pointer. Were we in glibc, we'd write this as:
>
>     return INTERNAL_SYSCALL_ERROR_P(r) ? NULL : (void *) r;
>
> Right? And if you look at the expansion of that glibc macro, it's just:
>
>   #define INTERNAL_SYSCALL_ERROR_P(val) \
>     ((unsigned long int) (val) > -4096UL)
>
> So it looks like the same exact thing?

syscall already does internally (with a translation to -1, not NULL), so
the caller shouldn't do it again.  The userspace syscall function does
*not* return an error code.

Thanks,
Florian

