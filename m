Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F166FCF
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:26:38 +0000 (UTC)
Received: by mail-lj1-f169.google.com with SMTP id bx6so13475334ljb.3
        for <patches@lists.linux.dev>; Tue, 10 Jan 2023 10:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=umnoYAX8D2Tr68PlIYbZPWDjCMAMX/1KvuLyQtZeqK8=;
        b=jsqv4DOK15Rk14o6RJoHQIf+I8wV5JPFwEOyN3HkV6hcVYU6PH5ZG5I3H5RKC6hQ+6
         jk23DcxEegDUq96itVTOypxgkbghGveZ9+hqVEPvVKzHzECbTMIrPBqnGaBJ3Gu1+7EY
         By5vDoTvy41uWgJplf+l+0r3MwX+yb9vzA1Zw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=umnoYAX8D2Tr68PlIYbZPWDjCMAMX/1KvuLyQtZeqK8=;
        b=SOfC/015+qal2dWmzWxdGB/wHVJgMWC4I/dQ9RsIk/nVcOvHWzW6YWYMU7QS92mfsh
         s7QqDin1moBngMPKI19ZvsG1YR91IowyDw95SgaFVVw8qPPB5V/xZ2A1e4/Wdmp9fLwy
         4eMj/0tvtdTKROAmkJjf9mjSbQFPBrGhIszDffQs3I20DtHnQ1AwFAwneX7cpqEiPs8w
         NIP0I3zPhgRFmkxChaeupN/w5V/NfZ1c7OuXNA/7pgklqBm+XhD2xyhVRCat8gnd7vcp
         /2FxcDDCiHhbysGd9pcwKR/pIDFymqq/TUsHJfF6RY1Vo/gDzOCnonCvnOR9Jn6nI1Se
         eDvQ==
X-Gm-Message-State: AFqh2krhxF935wtMVdWiSWkso9KuiGsV5Jf1OZ/36kT09d69ut9CFrvI
	3cu4gs4rYiB7OzmUhl8GbX7qAT5axS1v+qTwdWpzLg==
X-Google-Smtp-Source: AMrXdXtYN53tGqW+tV4hYqOK9gKGVooKMivQbY8+mErrwYDnvZs612fyy7mOAbc325wj81E4ab8ADcirvi1AYbWkRXc=
X-Received: by 2002:a2e:3c15:0:b0:27f:dca1:8584 with SMTP id
 j21-20020a2e3c15000000b0027fdca18584mr3488840lja.313.1673375196818; Tue, 10
 Jan 2023 10:26:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230110180031.620810905@linuxfoundation.org> <20230110180033.597780936@linuxfoundation.org>
In-Reply-To: <20230110180033.597780936@linuxfoundation.org>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Tue, 10 Jan 2023 13:26:25 -0500
Message-ID: <CAEXW_YQhoJkCNaBKRSLh5OCYn1ObA8dy63ZrgmRgpEaVorBnnQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 057/290] rcu-tasks: Simplify trc_read_check_handler()
 atomic operations
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	"Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 10, 2023 at 1:23 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Paul E. McKenney <paulmck@kernel.org>
>
> commit 96017bf9039763a2e02dcc6adaa18592cd73a39d upstream.

Thanks Greg, I had sent the same patch earlier for 5.15. Just so I
learn, anything I did wrong or should have done differently?

 - Joel


>
> Currently, trc_wait_for_one_reader() atomically increments
> the trc_n_readers_need_end counter before sending the IPI
> invoking trc_read_check_handler().  All failure paths out of
> trc_read_check_handler() and also from the smp_call_function_single()
> within trc_wait_for_one_reader() must carefully atomically decrement
> this counter.  This is more complex than it needs to be.
>
> This commit therefore simplifies things and saves a few lines of
> code by dispensing with the atomic decrements in favor of having
> trc_read_check_handler() do the atomic increment only in the success case.
> In theory, this represents no change in functionality.
>
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  kernel/rcu/tasks.h |   20 +++-----------------
>  1 file changed, 3 insertions(+), 17 deletions(-)
>
> --- a/kernel/rcu/tasks.h
> +++ b/kernel/rcu/tasks.h
> @@ -892,32 +892,24 @@ static void trc_read_check_handler(void
>
>         // If the task is no longer running on this CPU, leave.
>         if (unlikely(texp != t)) {
> -               if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
> -                       wake_up(&trc_wait);
>                 goto reset_ipi; // Already on holdout list, so will check later.
>         }
>
>         // If the task is not in a read-side critical section, and
>         // if this is the last reader, awaken the grace-period kthread.
>         if (likely(!READ_ONCE(t->trc_reader_nesting))) {
> -               if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
> -                       wake_up(&trc_wait);
> -               // Mark as checked after decrement to avoid false
> -               // positives on the above WARN_ON_ONCE().
>                 WRITE_ONCE(t->trc_reader_checked, true);
>                 goto reset_ipi;
>         }
>         // If we are racing with an rcu_read_unlock_trace(), try again later.
> -       if (unlikely(READ_ONCE(t->trc_reader_nesting) < 0)) {
> -               if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
> -                       wake_up(&trc_wait);
> +       if (unlikely(READ_ONCE(t->trc_reader_nesting) < 0))
>                 goto reset_ipi;
> -       }
>         WRITE_ONCE(t->trc_reader_checked, true);
>
>         // Get here if the task is in a read-side critical section.  Set
>         // its state so that it will awaken the grace-period kthread upon
>         // exit from that critical section.
> +       atomic_inc(&trc_n_readers_need_end); // One more to wait on.
>         WARN_ON_ONCE(READ_ONCE(t->trc_reader_special.b.need_qs));
>         WRITE_ONCE(t->trc_reader_special.b.need_qs, true);
>
> @@ -1017,21 +1009,15 @@ static void trc_wait_for_one_reader(stru
>                 if (per_cpu(trc_ipi_to_cpu, cpu) || t->trc_ipi_to_cpu >= 0)
>                         return;
>
> -               atomic_inc(&trc_n_readers_need_end);
>                 per_cpu(trc_ipi_to_cpu, cpu) = true;
>                 t->trc_ipi_to_cpu = cpu;
>                 rcu_tasks_trace.n_ipis++;
> -               if (smp_call_function_single(cpu,
> -                                            trc_read_check_handler, t, 0)) {
> +               if (smp_call_function_single(cpu, trc_read_check_handler, t, 0)) {
>                         // Just in case there is some other reason for
>                         // failure than the target CPU being offline.
>                         rcu_tasks_trace.n_ipis_fails++;
>                         per_cpu(trc_ipi_to_cpu, cpu) = false;
>                         t->trc_ipi_to_cpu = cpu;
> -                       if (atomic_dec_and_test(&trc_n_readers_need_end)) {
> -                               WARN_ON_ONCE(1);
> -                               wake_up(&trc_wait);
> -                       }
>                 }
>         }
>  }
>
>
