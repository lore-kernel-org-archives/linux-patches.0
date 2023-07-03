Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81444E55D
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 11:50:07 +0000 (UTC)
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-94f7a2b21fdso379603566b.2
        for <patches@lists.linux.dev>; Mon, 03 Jul 2023 04:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688385005; x=1690977005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2SzNF2Xp9ZY8Wj02jDl62Q9tRowvgKYaFK1hebcuMF8=;
        b=pgdnlTh7+dQSQr4HXDzPTcsLOQlcjEHZQKHGP8SUHPN3/ATvqnlbPaxBaM0s7GaUvw
         RNvdRo93wXLXicgZGyBhr6ZaC7R7ulc3EeshDcjqG+ymW8vmixEwqNuGgEZgFwma+dXs
         PuAJ3SfbY6DIDtw7FWQQehgD5uzUfk/kymMLnXbNQaYbsaHYBje2TTwgvzNaVUl5hyAu
         mjU5Htde/TqTtks02Ohuj1rUzDg6n9J+Od7vyRrVjEeU723xdaTuLfKYG9rmCbv1HqKq
         Qwo0hAGqQyNLiF1/67JGjZjZUaJ7oZpn8LbSv7zzUM7/f5VgOaTJPHaDBhaZfaAScZtR
         Tp1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688385005; x=1690977005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2SzNF2Xp9ZY8Wj02jDl62Q9tRowvgKYaFK1hebcuMF8=;
        b=QfQeo/opn8uLwQwpp12cXOOoPOhtacZ72EqpQZfCzWmd72wOTQBoa8nlMjCS+mZTfb
         Gdr/QFX7FZ918gyfvMgZVApc13D4Ff5L5qt4PJtnncFyaPPu4khpmEZKXfl+Tzpr9ZjY
         pIYzoddI+BonVhAKgpSpeF05NwaJkYRZTRBGGyHZF5ZcRTLvZoRU7OKCz+NADecLLEuU
         uMFCzwWKIYnzcwQyY8n4BVj5xTcXhRhF8Dkj1x2LXZOowOT/4jWSpa+2+9xtUIgOwIKn
         khF/XAQIwttguyjm07Hfbdc3q00tORMD2QIT81LyZuRsqC1+K0qEAj86VMfMIHxLmnwI
         DlIQ==
X-Gm-Message-State: ABy/qLbrhRfwEiixdH7k9c3J/GE5tkVcZH0b5vgNynjOboqDRLhkjw/B
	4W4k+qH2b3patAfSsE0S1Abvg7h4gmLvWc8=
X-Google-Smtp-Source: APBJJlFgAj9K0YUTqhagRD6cI8VCPje3jm3GVaqxDZ8a4l8+2/DnyNUX8Fzj6a1eJXu/gYFu03qpStGBcxSRJ3I=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:906:4bcd:b0:992:4ba4:dc4a with SMTP
 id x13-20020a1709064bcd00b009924ba4dc4amr24697ejv.13.1688385005551; Mon, 03
 Jul 2023 04:50:05 -0700 (PDT)
Date: Mon,  3 Jul 2023 11:50:00 +0000
In-Reply-To: <20230624092330.157338-2-benno.lossin@proton.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230624092330.157338-2-benno.lossin@proton.me>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230703115000.2006682-1-aliceryhl@google.com>
Subject: [PATCH 2/7] rust: add derive macro for `Zeroable`
From: Alice Ryhl <aliceryhl@google.com>
To: benno.lossin@proton.me
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, lina@asahilina.net, 
	linux-kernel@vger.kernel.org, nmi@metaspace.dk, ojeda@kernel.org, 
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Benno Lossin <benno.lossin@proton.me> writes:
> Add a derive proc-macro for the `Zeroable` trait. The macro supports
> structs where every field implements the `Zeroable` trait. This way
> `unsafe` implementations can be avoided.
> 
> The macro is split into two parts:
> - a proc-macro to parse generics into impl and ty generics,
> - a declarative macro that expands to the impl block.
> 
> Suggested-by: Asahi Lina <lina@asahilina.net>
> Signed-off-by: Benno Lossin <benno.lossin@proton.me>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

