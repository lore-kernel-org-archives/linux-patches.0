Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A408C21079
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:49:57 +0000 (UTC)
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-96fffd1ba46so57666466b.0
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 06:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685627395; x=1688219395;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=az0YAt2KTk16nw2JnbQbsBwE6ykYTuim3D59K9WH+fw=;
        b=f0NVKnLT6zT+WJcXI/mgsB1RJu7ayQo/PmjvmqEjy4BKO1oF0CUDIGmF1Py4hgizlm
         cC/GDDrvtyAPc0iyKHkXMfEaBm/kRQYss84Gj02VgxmApJh9i1J5Y9EzwpjOI4zcofff
         6KL5DSSGvLYDJ37W3hL8/4o0N/nXPCAlLEHH3RX3gDbz1jqH3ri8sfosyh9YBI/WNvDi
         tGfSmu8Y9tuPYhuhMT853gwRACSeGK3X9kzCyRBKRfHKZGyAortUk8PiebJlG1JXdwMJ
         peRS9BRK08EB08n/nfekR46px7ccFRpU6h8jzGakPHG7M9E2IfPsF20HOA2CpGYdriYS
         ASHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685627395; x=1688219395;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=az0YAt2KTk16nw2JnbQbsBwE6ykYTuim3D59K9WH+fw=;
        b=Xw+nKzKf1lgDBD9WuHMRBw66/uMQj5SBdeugKyS5TCkcaxt+WEdevfXad4srj65tnM
         GtNV2/q/4mHjF/SUeEOvWdHRYCYM4KaQR2lQVfhppU/Uqdovtv3nKUirChx8N+qq/Qnd
         SDbycxFRQ4BsLWSo48TW/hogdXSa+Fg/ksJlo36kxr2ZzjfAbJp25CQEdhkviA2F9ZY/
         Ktmd50TUpQHlZ4ZC3IirqvPcRm0EXWqHlkV/paQHZmC0cGAPaHqOyZXShESwfhO6/Iwr
         xNsY6Wt69lukgQy8LnnFYevyjkjntnebGm9MN+Y3jxxW1vfhStNBXuJVS2+J+ZwJrdus
         6gZQ==
X-Gm-Message-State: AC+VfDy0WU92RX8E/wk8P7NLW6D4O/7uVNoI0vgNIvPQi2qdfwOdeoMU
	ESO8urTEI2YFwOrv3zEKgp2DUr4SoQqQgwY=
X-Google-Smtp-Source: ACHHUZ6y558j5AwsRrstwPTYGwrzuoI4R2q5Hll3BeCCQsm0d7NK4qsQFtXx0QME/IjY8y5dnLNNjCUJZBL7QmI=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:907:270c:b0:965:b935:91f6 with SMTP
 id w12-20020a170907270c00b00965b93591f6mr2284491ejk.14.1685627395637; Thu, 01
 Jun 2023 06:49:55 -0700 (PDT)
Date: Thu,  1 Jun 2023 13:49:38 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230601134946.3887870-1-aliceryhl@google.com>
Subject: [PATCH v2 0/8] rust: workqueue: add bindings for the workqueue
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Tejun Heo <tj@kernel.org>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

This patchset contains bindings for the kernel workqueue.

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

Changes since v1:

Most of this patchset was rewritten based on Gary's example for how
field projections can be used with the workqueue.

I have also added some examples of how the workqueue bindings will be
used. You can find those in the last patch of this patchset.

v1: https://lore.kernel.org/all/20230517203119.3160435-1-aliceryhl@google.com/

Alice Ryhl (5):
  rust: workqueue: add low-level workqueue bindings
  rust: workqueue: add helper for defining work_struct fields
  rust: workqueue: implement `WorkItemPointer` for pointer types
  rust: workqueue: add `try_spawn` helper method
  rust: workqueue: add examples

Wedson Almeida Filho (3):
  rust: add offset_of! macro
  rust: sync: add `Arc::{from_raw, into_raw}`
  rust: workqueue: define built-in queues

 rust/bindings/bindings_helper.h |   1 +
 rust/helpers.c                  |   8 +
 rust/kernel/lib.rs              |  37 ++
 rust/kernel/sync/arc.rs         |  42 ++-
 rust/kernel/workqueue.rs        | 631 ++++++++++++++++++++++++++++++++
 scripts/Makefile.build          |   2 +-
 6 files changed, 719 insertions(+), 2 deletions(-)
 create mode 100644 rust/kernel/workqueue.rs


base-commit: d09a61024f6b78c6a08892fc916cdafd87b50365
-- 
2.41.0.rc0.172.g3f132b7071-goog

