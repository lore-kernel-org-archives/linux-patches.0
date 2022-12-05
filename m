Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A77F107B1
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 18:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670266618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YCNHamu5OKkFSMiJBfaNJ5Z6zqi4GnZWuw4yb+jZR9o=;
	b=J9mbBs7A5S5fupQ6JoaCt/CowQHJff9sbM9e7/tx/gWR+kMTSyZ34I5+CcNZw/M8dW8bzh
	9aW+cqFlDPUKwZi3W2KVK4Q+Ml5QgZYILYYyvHp8IZ2zpjV7GfxsST1glm19vSzxqmt12P
	8dummsxqeSMjwuFKIdAC67wG811dxlw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-jY6HYjo0PeS4GoiGjdW_6A-1; Mon, 05 Dec 2022 13:56:54 -0500
X-MC-Unique: jY6HYjo0PeS4GoiGjdW_6A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 873B91C05AAC;
	Mon,  5 Dec 2022 18:56:53 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.2.16.84])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB68A1401C22;
	Mon,  5 Dec 2022 18:56:51 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org,  patches@lists.linux.dev,
  tglx@linutronix.de,  linux-crypto@vger.kernel.org,
  linux-api@vger.kernel.org,  x86@kernel.org,  Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>,  Adhemerval Zanella Netto
 <adhemerval.zanella@linaro.org>,  Carlos O'Donell <carlos@redhat.com>,
  Arnd Bergmann <arnd@arndb.de>,  Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v11 3/4] random: introduce generic vDSO getrandom()
 implementation
References: <20221205020046.1876356-1-Jason@zx2c4.com>
	<20221205020046.1876356-4-Jason@zx2c4.com>
Date: Mon, 05 Dec 2022 19:56:47 +0100
In-Reply-To: <20221205020046.1876356-4-Jason@zx2c4.com> (Jason A. Donenfeld's
	message of "Mon, 5 Dec 2022 03:00:45 +0100")
Message-ID: <878rjlr85s.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7

* Jason A. Donenfeld:

> +retry_generation:
> +	/*
> +	 * @rng_info->generation must always be read here, as it serializes @st=
ate->key with the
> +	 * kernel's RNG reseeding schedule.
> +	 */
> +	current_generation =3D READ_ONCE(rng_info->generation);

> +		if (unlikely(READ_ONCE(state->generation) !=3D READ_ONCE(rng_info-

I'm pretty sure you need some sort of barrier here.  We have a similar
TM-lite construct in glibc ld.so for locating link maps by address, and
there the compiler performed reordering.

  _dl_find_object miscompilation on powerpc64le
  <https://sourceware.org/bugzilla/show_bug.cgi?id=3D28745>

I'm not familiar with READ_ONCE, but Documentation/atomic_t.txt suggests
it's a =E2=80=9Cregular LOAD=E2=80=9D, and include/asm-generic/rwonce.h con=
curs.
Likewise, the signal safety mechanism needs compiler barriers (signal
fences).

I'm also not sure how READ_ONCE realizes atomic 64-bit reads on 32-bit
platforms.  i386 can do them in user space via the FPU worst-case (if
the control word hasn't been corrupted).  CMPXCHG8B is not applicable
here because it's a read-only mapping.  Maybe add a comment at least
about that =E2=80=9Cstrong prevailing wind=E2=80=9D?

Thanks,
Florian

