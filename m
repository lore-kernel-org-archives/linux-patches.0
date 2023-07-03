Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD470DF56
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 11:58:20 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-576d63dfc1dso50602747b3.3
        for <patches@lists.linux.dev>; Mon, 03 Jul 2023 04:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688385499; x=1690977499;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=waeGDoVgGDH94No5qzti6s6z1JdLzgejSmKbt77NSm4=;
        b=n4DSn/SR8jW6zJisAJudqF9kgG9Pqv7i8vnxTpRtFOtxvSaZj15fVx+EtgG1vTFbGd
         UbJ/ehSb1pcQwECTOdfVFUhtgAaIdXN2JvtJ6/S9iP7uOHqxWF/Hl7MtVTDRxTHkmMBz
         JN1h8sHm/n0fP3d6khiTMAY3w5DF1C6pG2fIFb0/hXValDWqJB+ZuZu80gddy/gJqIBN
         zcXZ9hQytHsS4UAmWXkKlYYZYmZyMHBpRjAC/xF9w5Jj379G5gl651yTSdjiSPuu5XZX
         r4tCuWozs8XfHLNvcBcT30GwP5F025LxGCo3YuFm6r4/azx/r/rbdQG9OIfG0FgxDLx4
         EKGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688385499; x=1690977499;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=waeGDoVgGDH94No5qzti6s6z1JdLzgejSmKbt77NSm4=;
        b=AskY5K9foF1G1JnvpUQ5XY1g7Ee1Z7JnCrR97+Zd7xJENPqYTzDOy0GECIi4bxR9ps
         SI2ysAntokl+vIyCQ8BGtekkrvEkJpWLIpQK8UIjlyW23p7zSrgNv6N4P2vzmh0Y8Z0b
         YaXPlZiRkFf2j88Kew0WGHUy+Ko9zPiGHiRAXf5dQ7Ggd6Vw5IZcQmiq7I26VSDpS4zj
         3qAzF5DLKF9ygqvALKBaDhi4Yb4MACOGbAwI4W9aTMZ0Nd4A43KLZb27RsizYOHFbqQO
         bdHjYzmcaFwGy7EY1Di/UAD7L7/4/ibnY+rli+JUdap643gHI2hF0nHYPt4R+9BIgnPf
         vPwg==
X-Gm-Message-State: ABy/qLYYr7EV4abBM5jwlDUkejPnBmAllUEHW+kc/qMSWFf4gqeiJD2l
	Ot0xVS9SI60JaI1/q3efr0LrYe2q0Pi6O+o=
X-Google-Smtp-Source: APBJJlHCsEa6ZqPl05Kk8kCJRBjFUQKdWC53i0Nx85xGnPc/NmX5y0re3ZTmg8qKPxbtdgNrcbil/bu/BsKvBU8=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a05:6902:4eb:b0:c10:e586:4c7f with SMTP
 id w11-20020a05690204eb00b00c10e5864c7fmr76067ybs.12.1688385499497; Mon, 03
 Jul 2023 04:58:19 -0700 (PDT)
Date: Mon,  3 Jul 2023 11:58:14 +0000
In-Reply-To: <20230624092330.157338-5-benno.lossin@proton.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230624092330.157338-5-benno.lossin@proton.me>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230703115814.2294010-1-aliceryhl@google.com>
Subject: [PATCH 5/7] rust: init: add `..Zeroable::zeroed()` syntax for zeroing
 all missing fields
From: Alice Ryhl <aliceryhl@google.com>
To: benno.lossin@proton.me
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, lina@asahilina.net, 
	linux-kernel@vger.kernel.org, nmi@metaspace.dk, ojeda@kernel.org, 
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Benno Lossin <benno.lossin@proton.me> writes:
> Add the struct update syntax to the init macros, but only for
> `..Zeroable::zeroed()`. Adding this at the end of the struct initializer
> allows one to omit fields from the initializer, these fields will be
> initialized with 0x00 set to every byte. Only types that implement the
> `Zeroable` trait can utilize this.
> 
> Suggested-by: Asahi Lina <lina@asahilina.net>
> Signed-off-by: Benno Lossin <benno.lossin@proton.me>

I'm a bit surprised by how large this change is, but it looks ok.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

