Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA6A449B2
	for <patches@lists.linux.dev>; Wed, 17 May 2023 20:31:22 +0000 (UTC)
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-510e51cb569so30583a12.3
        for <patches@lists.linux.dev>; Wed, 17 May 2023 13:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684355481; x=1686947481;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lH+GB88mGkyXoacAsII55I8gutXKBDvKTQDFdPjI6tA=;
        b=iA2BlPMqXXvqmmp3XPbvS7PLetJ5ETCu6u7dP0UxkrlowV8oa2J3RE2PCj8b/Qpxxu
         U6IF3gWzURzAG9NFlWH1u/zSdMyiL08wwcLJNrZKdYlzpVAGnlv8ndQrnJlPcD0SVME/
         VChEVvPcEWnniohJDXcaCGfRWgicgKyXck88tVTYfzygqlSwkdfZCNMonNMrQ7tNjjhj
         UTWPo7cs+3zWxknZ6ZtvRw8SC/fAIjuZiS54vc6APSnRpga9SKVmAhj+d0coqTkc5OLj
         jXpU2I+e18A0d2/tTlASL7C9q0TrS9/sPTOMfsyPdttoIoKk1xl/KgkWH67RraMnNaNS
         LDFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684355481; x=1686947481;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lH+GB88mGkyXoacAsII55I8gutXKBDvKTQDFdPjI6tA=;
        b=iQf+XsPYZQqqcxYsW3zstaE1dXLd/X4fAmDrRwQqB6ngr+2etIeRXPE2NoCNDqaJ0k
         YIYIRgUNOHiU9eTYDPab3OqFfQjFsQsM22eodn66qXVqDc2cOKinIwdHZSvDUwzjVguM
         JmnaGoSraF0u69bPPkv9osqnRkGbYHi6kaop7AmSFieQ7eCOwrVzIdSPtO6NAe4/dfZZ
         tDX0ULBwIunTmlmMfar6vYc+eYB0D10vALaGxPaQOal9EibPnVFw6CxgcWBX8WFiC/fv
         qyO2PrNaUQuBMKzDpwl6gNb70byrlzkSCtdLLiGLMlB+7usa+hGNARLm9Se5GUr/UagY
         txoA==
X-Gm-Message-State: AC+VfDzrZegEsc+Hkt+g3VjjLw1/KnXDKtw7g0xb1A7yHrlBOGS40sH1
	7/TXY/oytXiGrv0x5qU+A4LLaU9yy/qpr80=
X-Google-Smtp-Source: ACHHUZ5NQv9HGjuTBobENJHcvpXZZpSXuuO1c8KW0QDXzB22J46Eslk8NvD3T8PrLP+VbYTzkg6vTUpii/ZwK4M=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:8d1b:0:b0:504:7684:a23c with SMTP id
 s27-20020a508d1b000000b005047684a23cmr1511969eds.8.1684355481334; Wed, 17 May
 2023 13:31:21 -0700 (PDT)
Date: Wed, 17 May 2023 20:31:12 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517203119.3160435-1-aliceryhl@google.com>
Subject: [PATCH v1 0/7] Bindings for the workqueue
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

This patch could be significantly simplified if we already had the field
projection bindings. However, we have decided to upstream the current
version that does not depend on field projection first - the PR that
introduces field projections will then include a commit that simplifies
the workqueue implementation. (In particular, it would simplify the 5th
patch in this series.)

The first version of the workqueue bindings was written by Wedson, but
I have rewritten much of it so that it uses the pin-init infrastructure
and can be used with containers other than `Arc`.

Alice Ryhl (4):
  rust: workqueue: add low-level workqueue bindings
  rust: workqueue: add helper for defining work_struct fields
  rust: workqueue: add safe API to workqueue
  rust: workqueue: add `try_spawn` helper method

Wedson Almeida Filho (3):
  rust: add offset_of! macro
  rust: sync: add `Arc::{from_raw, into_raw}`
  rust: workqueue: define built-in queues

 rust/helpers.c           |   8 +
 rust/kernel/lib.rs       |  37 ++
 rust/kernel/sync/arc.rs  |  44 +++
 rust/kernel/workqueue.rs | 715 +++++++++++++++++++++++++++++++++++++++
 scripts/Makefile.build   |   2 +-
 5 files changed, 805 insertions(+), 1 deletion(-)
 create mode 100644 rust/kernel/workqueue.rs


base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
2.40.1.606.ga4b1b128d6-goog

