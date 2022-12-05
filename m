Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB79415C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:14:13 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id q190so3107533iod.10
        for <patches@lists.linux.dev>; Mon, 05 Dec 2022 11:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFyCIXZXXj52B6+TRuXYxnhDZPZi9MBnfF7ElnTFN0o=;
        b=KQGUU1Mz8tE4FwG55UuWK/DUEkyHdjC6KTQ4N+hj3x0ZlJuuTc/kGeD5/B6LgnUu/S
         xvJeckIeV8aKAbciCxa3sgM6JZxhtmx9pd4+am3DyFTPmz04pnk1xB/g4kahK7DENpu+
         rmKjl1FEIA/X1Ff3dM3ZgxaFCX3lKhsKjUlyxcBQqMl0OKlVgWU5h11YGOaWFIZsxRyt
         XwqdPO2DUJ2AuRL6F7yTO8blbdlbbTuR9F5rQKRp0SUtegBSmO8uVO6Yi0gcps2NbhaW
         zzS/ckngN3ZtcWj88HJFBh7DfGVIhhGFeAXbN7TEkpnK1GoeTaafGNV0gYvUCz0U7AM5
         tvow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZFyCIXZXXj52B6+TRuXYxnhDZPZi9MBnfF7ElnTFN0o=;
        b=TMfzerTMyzuSYgpfTZY27mZ/CBboFDuywtQwyMxZfSSaEJ6POA/RW4BlCppUM2Z3/G
         UXKv7SuXP4xm9ze9Ci2+7CURst3ZGPrZHRXGVb3VY1Lpq2WHYgonYHh94bDBT5SWSJLj
         jHff7vqQJtdc4E3LJ94T2WRurHId+F3giQy7s9UO5ZTZFFNhhPLjFHHrFn2HCVtnAKNy
         vdSMx9W0yanlKDl5l0GUPDHqD5rbA7CpCYgVEeQXg4hT6eK/dptDl6A1ZGa9ENj0V+H2
         mz3gbirLtgOHETs1LZA3PzVW9R5pc8QN8LewGHxYjMrgo3p1mcmJjkBijWjdDGY5PYf4
         OeXg==
X-Gm-Message-State: ANoB5plmySCAcHfWsn9RZZBxizzORyGEdeFmYgGXn7MNeP43fD0jrEqp
	kppITLcFT40Xb3Ou3y12jbgqlm6VkzjLEw4lg9Fl7A==
X-Google-Smtp-Source: AA0mqf5z+bsAKNYfj1j6BbUt9D4MCk7ZIBrj8IAdK2ejaTvyL2OacLKX78s44UxNUH1xT8V7DYXP6zYQ+wAgnvyJhN4=
X-Received: by 2002:a5d:97c9:0:b0:6a2:e3df:a40e with SMTP id
 k9-20020a5d97c9000000b006a2e3dfa40emr38722107ios.113.1670267652805; Mon, 05
 Dec 2022 11:14:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221205020046.1876356-1-Jason@zx2c4.com> <20221205020046.1876356-2-Jason@zx2c4.com>
In-Reply-To: <20221205020046.1876356-2-Jason@zx2c4.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 5 Dec 2022 20:13:36 +0100
Message-ID: <CAG48ez2R=Ov2Z9zn_W9+C3gHqOkPdQKAY=4SMWDUG=NfP=3eJw@mail.gmail.com>
Subject: Re: [PATCH v11 1/4] random: add vgetrandom_alloc() syscall
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, tglx@linutronix.de, 
	linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 5, 2022 at 3:01 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> +       mm->def_flags |=
> +               /*
> +                * Don't allow state to be written to swap, to preserve forward secrecy.
> +                * This works in conjunction with MAP_LOCKED in do_mmap(), below, which
> +                * actually does the locking (and associated permission check and accounting).
> +                * Here, VM_LOCKONFAULT together with VM_NORESERVE simply make the mlocking
> +                * happen the first time it's actually used, the same as when calling
> +                * mlock2(MLOCK_ONFAULT) from userspace.
> +                */
> +               VM_LOCKONFAULT | VM_NORESERVE |

Have you checked the interaction with this line in dup_mmap()?
"tmp->vm_flags &= ~(VM_LOCKED | VM_LOCKONFAULT);"

As the mlock.2 manpage says, "Memory locks are not inherited by a
child created via fork(2)". I think the intention here is that the VMA
should stay unswappable after fork(), right?

Of course, trying to reserve more mlocked memory in fork() would also
be problematic...
