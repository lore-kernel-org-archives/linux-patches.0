Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C0111C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:48:25 +0000 (UTC)
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-50bf847b267so2371717a12.3
        for <patches@lists.linux.dev>; Mon, 28 Aug 2023 03:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693219703; x=1693824503;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=phn8WusQ/2+glt4bRRsEQXCtZZReUGFgblYyJRKf5Po=;
        b=GFuup1MGJRUkG1P8N469gD0uIyioKkpXXdaHIwLBn9zp4jpZHnPCabTNzKIMkvngCE
         efLqMtK+bsODFnTy8pPYa96/vr/acZ9NQZ1rXsv8U1pDSWiWnlTLtWlexDJF+JMB50LN
         jNfjeIPqg8zYTlpklUuVXpb19Cre6aXEqlUlOtPvkuZy0JebKEbRNHG8Lo5yJi0nZ7ql
         Vdb57T8pe+vusaWx70f1LRYSIokFStQOCqLHkiafzqaG1xFoQBw/muwgUkNrxZtKqpnE
         2jEWfut/08tKpnpi+gpb3YRo9b1ooTFdz1gKZrI+TgynH1ape5TvDPTJ8/jvPODypjU2
         wqhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693219703; x=1693824503;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=phn8WusQ/2+glt4bRRsEQXCtZZReUGFgblYyJRKf5Po=;
        b=SIl5EfUsS93O5JdJiTEueW/Bg3ifglg81CUmpUJYVnAQGrMBH02WjFOoWB76lWDPiU
         TZY7sWCjfbTAQIp0PIzlggdekVCqgOxQo8YA9+yP5MgDLS88QGwLuDU3EtZ7OXjlb9BQ
         TIth9n5n9BZUy5cwwk2PTtLoSFfzMDMRgsZ6ZC4kCvmtcCTIMxHgYXOhLueTsHeGDIlW
         OEV5R27k56fHAJaWJeF4YGVx/oCyuCjsrZVDE+aWs13bG0v44s0CZ8863zB+iiGexcZB
         eevR+ivCg1feX5YY5Hjwo6y0B2/+W7zSqzNYlkHyHI1DncmyfoYngXUG7+DHJLEWJ6QA
         f+3g==
X-Gm-Message-State: AOJu0YypnVH8YROaiUd6KMNKySLe8AEebbkMOQVZ/dbfTdg/zidat08m
	vFjhlYkTU03xDCgJHZcOCctrWwhYknPv7Js=
X-Google-Smtp-Source: AGHT+IFlKbd+StOuT2cwBajLbBRIWvpPRXWrwlNiRZgLn+CYc2DdKicVqK6mw+3HktcA5RJUAHtt8hdAMRRzYJw=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:cd5e:0:b0:527:247d:8a03 with SMTP id
 d30-20020a50cd5e000000b00527247d8a03mr456270edj.3.1693219703413; Mon, 28 Aug
 2023 03:48:23 -0700 (PDT)
Date: Mon, 28 Aug 2023 10:48:00 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230828104807.1581592-1-aliceryhl@google.com>
Subject: [PATCH v4 0/7] rust: workqueue: add bindings for the workqueue
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

This patchset depends on the patch [1] that changes `Opaque` to be
`!Unpin` for correctness. The patchset is based on the rust-6.6 tag,
since that tag includes that patch.

Changes v3 -> v4:

 * Use `offset_of!` macro from standard library, and drop patch with
   custom implementation.
 * Add name parameter to `work_struct` constructor, and drop patch with
   __INIT_WORK_WITH_KEY.
 * Various improvements to documentation and comments.

More detailed changelogs can be found on the individual patches.

Previous versions:
v1: https://lore.kernel.org/all/20230517203119.3160435-1-aliceryhl@google.com/
v2: https://lore.kernel.org/all/20230601134946.3887870-1-aliceryhl@google.com/
v3: https://lore.kernel.org/all/20230711093303.1433770-1-aliceryhl@google.com/

[1]: https://lore.kernel.org/all/20230630150216.109789-1-benno.lossin@proton.me/

Alice Ryhl (5):
  rust: workqueue: add low-level workqueue bindings
  rust: workqueue: add helper for defining work_struct fields
  rust: workqueue: implement `WorkItemPointer` for pointer types
  rust: workqueue: add `try_spawn` helper method
  rust: workqueue: add examples

Wedson Almeida Filho (2):
  rust: sync: add `Arc::{from_raw, into_raw}`
  rust: workqueue: define built-in queues

 rust/bindings/bindings_helper.h |   1 +
 rust/helpers.c                  |  13 +
 rust/kernel/lib.rs              |   3 +
 rust/kernel/sync/arc.rs         |  46 ++-
 rust/kernel/workqueue.rs        | 679 ++++++++++++++++++++++++++++++++
 scripts/Makefile.build          |   2 +-
 6 files changed, 741 insertions(+), 3 deletions(-)
 create mode 100644 rust/kernel/workqueue.rs

base-commit: 4af84c6a85c63bec24611e46bb3de2c0a6602a51
-- 
2.42.0.rc1.204.g551eb34607-goog

