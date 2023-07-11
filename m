Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA5417FE9
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 09:33:58 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-c64ef5bde93so6488299276.0
        for <patches@lists.linux.dev>; Tue, 11 Jul 2023 02:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689068037; x=1691660037;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i+zDEU10wYnr89r/fFOaqQkCw/zLk+nePTObPe5KGak=;
        b=4cOhTU9J7VvWcpswEGbcooTo36VAK9TcuU2c6+Hur/0i1hcy3Tc3+j8tqPjGWJXh0F
         vArzmq0YYav0AhtC0YABYFyw/vGTZZpGTBVKGjSalFfCd7p/Fd+PfJ4rTr5MA+KypJMg
         jZziMqtHCxaXQ016l56d+FP+93N0bs9EwvrcEEZ5+N56TDyB0LHezclxnDyS4HSFuwyw
         V+bLokMXh1FDeCHSlcb1iy8WqLa2VcAQe37sb2wCt3dwSTJ1vDEsbryfbBh7TZ5pRgCe
         7BbsjesnBgGZDUCAVfSLO5jRzgC3EL3PPkd0piev9chZHjo/otF3aQWm/CBDy12n5FyI
         AAYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689068037; x=1691660037;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i+zDEU10wYnr89r/fFOaqQkCw/zLk+nePTObPe5KGak=;
        b=l7QGU/qKe2HBw1wJXhMcyNzPOSDBMs7rZ9P4Cg4m5fatMpmeL7AkFMT6CUUj+Ufbnx
         Hbe9bN1xz70wFJFYxXqwJdKhHhWduRvLzNMCY4tWZnEbj6SWaKdRcjIzzRKXMuOcKYOc
         Us1SY9oxCWJ+MwPagRl8PIPYbqxNIg+Is/jZJ81RtI/Rfr1GerWO4Bm7GUCcgrm3A4Tq
         iwSxLgE2EtHJDVfx7FtBSkbIzgfGZB/wN6mjMptt6gecTVMeebj/bdiohQxjnyCHp+u2
         Q9+yqcnn/xrUhW7OPz9WSUCeIoyNYSs2s9MaFzF8bo6qJON5KfsJKjiFRU7s4eS0AHib
         4lJg==
X-Gm-Message-State: ABy/qLZQHyqQ8mF1076lQ3xH1qkfk8bIYV6sVsWqDwYARDZ+F48Y1Lwk
	J5xcug5LYTXz4ZsD0HhJexwrP4a3D0+Wvt8=
X-Google-Smtp-Source: APBJJlG7CVg8ZIjiHugsIIAwsKz38An7XLFFQ67zguULn2KMYeTniDrNRdInRiElbolNDz0ZuyBpq8JoTzIBmpc=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:ad54:0:b0:c1a:dc07:1d74 with SMTP id
 l20-20020a25ad54000000b00c1adc071d74mr135384ybe.0.1689068037722; Tue, 11 Jul
 2023 02:33:57 -0700 (PDT)
Date: Tue, 11 Jul 2023 09:32:54 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230711093303.1433770-1-aliceryhl@google.com>
Subject: [PATCH v3 0/9] rust: workqueue: add bindings for the workqueue
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

This patchset contains Rust bindings for the kernel workqueue.

One of the primary goals behind the design used in this patch is that we
must support embedding the `work_struct` as a field in user-provided
types, because this allows you to submit things to the workqueue without
having to allocate, making the submission infallible. If we didn't have
to support this, then the patch would be much simpler. One of the main
things that make it complicated is that we must ensure that the function
pointer in the `work_struct` is compatible with the struct it is
contained within.

The original version of the workqueue bindings was written by Wedson,
but I have rewritten much of it so that it uses the pin-init
infrastructure and can be used with containers other than `Arc`.

Changes v2 -> v3:

 * Moved dependency patches so they are first.
 * Various documentation and comment improvements.
 * Changed implementation of `Arc::from_raw`.
 * Use __INIT_WORK_WITH_KEY instead of __INIT_WORK and use `LockClassKey`
   where appropriate.
 * Removed PhantomPinned from Work. This depends on [1] for correctness.

More detailed changelogs can be found on the individual patches.

v1: https://lore.kernel.org/all/20230517203119.3160435-1-aliceryhl@google.com/
v2: https://lore.kernel.org/all/20230601134946.3887870-1-aliceryhl@google.com/

[1]: https://lore.kernel.org/all/20230630150216.109789-1-benno.lossin@proton.me/

Alice Ryhl (5):
  rust: workqueue: add low-level workqueue bindings
  rust: workqueue: add helper for defining work_struct fields
  rust: workqueue: implement `WorkItemPointer` for pointer types
  rust: workqueue: add `try_spawn` helper method
  rust: workqueue: add examples

Wedson Almeida Filho (4):
  rust: add offset_of! macro
  rust: sync: add `Arc::{from_raw, into_raw}`
  workqueue: introduce `__INIT_WORK_WITH_KEY`
  rust: workqueue: define built-in queues

 include/linux/workqueue.h       |  17 +-
 rust/bindings/bindings_helper.h |   1 +
 rust/helpers.c                  |   8 +
 rust/kernel/lib.rs              |  39 ++
 rust/kernel/sync/arc.rs         |  49 ++-
 rust/kernel/workqueue.rs        | 659 ++++++++++++++++++++++++++++++++
 scripts/Makefile.build          |   2 +-
 7 files changed, 767 insertions(+), 8 deletions(-)
 create mode 100644 rust/kernel/workqueue.rs


base-commit: d2e3115d717197cb2bc020dd1f06b06538474ac3
-- 
2.41.0.255.g8b1d071c50-goog

