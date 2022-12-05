Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE50915C8B
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 20:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2F3C433D7;
	Mon,  5 Dec 2022 20:02:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="MRX1z0ch"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1670270558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PyZtCU+2gsCu7KCwhkt8a9c6R0xPU3y4F0anDuzkzwY=;
	b=MRX1z0chvZFKzyr0XVk/4fJ7RUniJro8ZYda1qQWry7EVFIy3BnXhJQcimO33iXiG7hF+P
	Bo7DVHXbyvqu/FJdu78o5chMiY0aGo2PqBVrp79vtzaFbLw52sC16UNro89nCkvoVig/hh
	TNWk5yOc4J2ke52xCFS4TH3Ad6f6z20=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id aceab3d5 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 5 Dec 2022 20:02:37 +0000 (UTC)
Date: Mon, 5 Dec 2022 21:02:34 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Jann Horn <jannh@google.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	tglx@linutronix.de, linux-crypto@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>,
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v11 1/4] random: add vgetrandom_alloc() syscall
Message-ID: <Y45OWhyN+U975vIN@zx2c4.com>
References: <20221205020046.1876356-1-Jason@zx2c4.com>
 <20221205020046.1876356-2-Jason@zx2c4.com>
 <CAG48ez2R=Ov2Z9zn_W9+C3gHqOkPdQKAY=4SMWDUG=NfP=3eJw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAG48ez2R=Ov2Z9zn_W9+C3gHqOkPdQKAY=4SMWDUG=NfP=3eJw@mail.gmail.com>

Hi Jann,

On Mon, Dec 05, 2022 at 08:13:36PM +0100, Jann Horn wrote:
> On Mon, Dec 5, 2022 at 3:01 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > +       mm->def_flags |=
> > +               /*
> > +                * Don't allow state to be written to swap, to preserve forward secrecy.
> > +                * This works in conjunction with MAP_LOCKED in do_mmap(), below, which
> > +                * actually does the locking (and associated permission check and accounting).
> > +                * Here, VM_LOCKONFAULT together with VM_NORESERVE simply make the mlocking
> > +                * happen the first time it's actually used, the same as when calling
> > +                * mlock2(MLOCK_ONFAULT) from userspace.
> > +                */
> > +               VM_LOCKONFAULT | VM_NORESERVE |
> 
> Have you checked the interaction with this line in dup_mmap()?
> "tmp->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);"
> 
> As the mlock.2 manpage says, "Memory locks are not inherited by a
> child created via fork(2)". I think the intention here is that the VMA
> should stay unswappable after fork(), right?
> 
> Of course, trying to reserve more mlocked memory in fork() would also
> be problematic...

Thanks for pointing that out! Indeed that seems problematic.
Fortunately, the use of WIPEONFORK at the same time as LOCKONFAULT means
that memory doesn't actually need to be reserved in fork() itself. So
something like the below seems correct and doable.

Jason

diff --git a/kernel/fork.c b/kernel/fork.c
index ec57cae58ff1..cd53ffff615d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -656,7 +656,9 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 			tmp->anon_vma = NULL;
 		} else if (anon_vma_fork(tmp, mpnt))
 			goto fail_nomem_anon_vma_fork;
-		tmp->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
+		if ((tmp->vm_flags & (VM_LOCKONFAULT | VM_WIPEONFORK)) !=
+		    (VM_LOCKONFAULT | VM_WIPEONFORK))
+			tmp->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);
 		file = tmp->vm_file;
 		if (file) {
 			struct address_space *mapping = file->f_mapping;

