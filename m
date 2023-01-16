Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C0EA28
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 00:03:16 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id 188so28514280ybi.9
        for <patches@lists.linux.dev>; Sun, 15 Jan 2023 16:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=utF0T11NIO5fzdSYdTniamVGFsvJmq4s7ZlcItgmdGo=;
        b=pTclYOItmik5tHCwf8CHR9HEI+jxxHl9DpN6G3hseWDVWz0WKC+e5ZjXrboN34vRfX
         33Bav9oBN2rl4ifdPBg9mopNU8+OME5/3vb0EGLRy4hpEnZou3TawUjewrn7VrpwfV2J
         8zmskMMVx/wGqDW8xuV8ZN2/DlU3nNlkcoEtd028kFWatiSJr2nUoPcnzr3dUmbAy7Im
         LsduvSOzVQJoC0UW413NdmK5a5Y6OVmA6G3B8hX79z0EYEtXIJyhHvuZD2ucjwAPqYH2
         4mpDd4N8mFQpWipR19rLRubB60j6njQiMVSDDZ4z7WG5TWm1hOYFmKNloonwJK7x8IUY
         8dIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=utF0T11NIO5fzdSYdTniamVGFsvJmq4s7ZlcItgmdGo=;
        b=adIKt0hR5+e/yywqeUbQotrW9fBbZNVn7jsbnwjMPgY579DCh2pxPbgaG44PMIWKhH
         JrFy+tpjJ3vwYmzdrI03QuB51ci8/EU0mhdFquhsNtCSrHz3J1zndNRw8lGniR+UrDuk
         Tm23EzIYdXcF/yVOZNDriMf9QsHV4Wi134QSZouekTt1yINdHBJGTK/6H6Ck73V3/O5+
         KLIrUFo2aB3ZlgouC91tX7FtsfZG+9A1SrBMJPxKOqD7dEU5Z4C2VHiWSrGV4WHMNScb
         ikm1n/Fxr1EOYlisfKp9KzaPOooW9kwGMpe+Ddvr0h6B6QjZZHoDa+hiQ4cOkTH2BKq8
         GA7A==
X-Gm-Message-State: AFqh2koc99euza+gDlW/FQYBgawlhSDnDXs3XgdSI4a0g1oW47SCdGYL
	w+TyG3nX6Z6GIMwiEVwPP7F2eWjmILB8NK0Lptk=
X-Google-Smtp-Source: AMrXdXsGXvJ6fgLaVz+5qZXQBdJFCTv3K8NVETV+4FyUgyVMQCuNqGCqmRkc0+hweH28ipKE+hbdONR7DsrMxDekZ6E=
X-Received: by 2002:a25:7702:0:b0:7b4:bdd7:e631 with SMTP id
 s2-20020a257702000000b007b4bdd7e631mr4296168ybc.507.1673827395991; Sun, 15
 Jan 2023 16:03:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204912.539790-1-ojeda@kernel.org>
In-Reply-To: <20230109204912.539790-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 16 Jan 2023 01:03:05 +0100
Message-ID: <CANiq72k9OP2TTPty2OcC5Od-R3wHsfhnc0BFR_XYjBtC5zf3gA@mail.gmail.com>
Subject: Re: [PATCH] rust: print: avoid evaluating arguments in `pr_*` macros
 in `unsafe` blocks
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, 
	Domen Puncer Kugler <domen.puncerkugler@nccgroup.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jan 9, 2023 at 9:49 PM Miguel Ojeda <ojeda@kernel.org> wrote:
>
> At the moment it is possible to perform unsafe operations in
> the arguments of `pr_*` macros since they are evaluated inside
> an `unsafe` block:
>
>     let x = &10u32 as *const u32;
>     pr_info!("{}", *x);
>
> In other words, this is a soundness issue.
>
> Fix it so that it requires an explicit `unsafe` block.
>
> Reported-by: Wedson Almeida Filho <wedsonaf@gmail.com>
> Reported-by: Domen Puncer Kugler <domen.puncerkugler@nccgroup.com>
> Link: https://github.com/Rust-for-Linux/linux/issues/479
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to rust-fixes, thanks all!

Cheers,
Miguel
