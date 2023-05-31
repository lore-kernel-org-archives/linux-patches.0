Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DC3C8FF
	for <patches@lists.linux.dev>; Wed, 31 May 2023 15:00:10 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-568960f4596so59140477b3.1
        for <patches@lists.linux.dev>; Wed, 31 May 2023 08:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685545210; x=1688137210;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kgt3lW2r0aoY0DDLcZTyq/QALzXXToKg0VwThNVsEZs=;
        b=DxCZiH1EJ6GTCeR7M1xZCCD83a49cOiQ9TFOb2cpTE+xJykFniGsMxkSKaNxVhgrie
         1ZUAUK64KCNds1oQP+SCgoYSGdYMWl4o7suvBgY/fiRhtcgkzNsNtzRN+NWwpIus8zx3
         Vae/ZhynetGaQPIjblP8vLMJRXOMjpcH629xoRqz8t5E2fEZrJswrNEjr6nEe/aHzUTs
         RF6bxBNTe+6jyJyimjvXZ6/h8o3aJ6JwIzR0C63FS93ayeG0tDJuGhpRYKeAhQSqums1
         4tURIQ+m9vlVvRiXXfNzi4B2tWPJXtV8fwHUDZ2/v9rrUFsoB2tqZmw9E2ZE5l2J9MU8
         roSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685545210; x=1688137210;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kgt3lW2r0aoY0DDLcZTyq/QALzXXToKg0VwThNVsEZs=;
        b=RTDMey0wJL/JE9YtmCj0KcGOBcMe4CdeB6GM9mRyI+J5QNunAftNOtmSJkMaNngGu5
         EmdeNT6kXJh1QR7bbhuAuxJqZgXiYsjYoxaQdPd/rPfr0YxZf99jmggAQ5vwpFnYFp3X
         zJflpY2WS+/FEmxBrVYSR/+4jpBUd8i/u1ggLIeLd6ih6PDsXliv0MAtkv4D1Otfad0o
         syxOcFX4WRlk+HfVTt0U6eYKO2iN2Wqvwvp03upbK0jLWxIDtxXjdDIYRCwvUGl20XZ1
         bkkLfHLX4hULbBhqNmgZ7tuX8un3CxaW7wbAXbBsuCZvpUffkBZ3B3kjdQESoBfvoSW3
         4DHA==
X-Gm-Message-State: AC+VfDyn8J5kRPlDwiQHh1i5Zi2QpIBuJle+/eniCZg+74EBvROYjMBO
	U0c9qoTlKDWJMAz7x+Jo6HDrsP58phm043k=
X-Google-Smtp-Source: ACHHUZ5PGbClUzmUIu5JqGN5ZZy5XtiWsjT/HcmZjSMbK2ZzZTMOkv46r/SbQAgSQWglSlAAgf/x7TZItrF2jmQ=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a81:ae05:0:b0:565:9f59:664f with SMTP id
 m5-20020a81ae05000000b005659f59664fmr3434986ywh.6.1685545210063; Wed, 31 May
 2023 08:00:10 -0700 (PDT)
Date: Wed, 31 May 2023 14:59:35 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230531145939.3714886-1-aliceryhl@google.com>
Subject: [PATCH v3 0/4] Update thread safety markers
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

In Rust, the `Send` and `Sync` traits are used to mark in what ways a
specific type is thread safe. In this patch series, I add some missing
thread safety markers and improve the documentation related to them.
This change will let you compile some code that would currently fail to
compile even though it doesn't actually violate any thread safety rules.

You can find a definition of what these marker traits mean at [1].

Changes since v2:

 * Removed "for example" as suggested in [2].
 * Added Reviewed-by annotations from v2 review.

[1]: https://stackoverflow.com/a/68708557/1704411
[2]: https://lore.kernel.org/all/20230523165027.71600b4b.gary@garyguo.net/

Alice Ryhl (4):
  rust: sync: reword the `Arc` safety comment for `Send`
  rust: sync: reword the `Arc` safety comment for `Sync`
  rust: specify when `ARef` is thread safe
  rust: task: add `Send` marker to `Task`

 rust/kernel/sync/arc.rs | 12 +++++++-----
 rust/kernel/task.rs     | 10 ++++++++--
 rust/kernel/types.rs    | 13 +++++++++++++
 3 files changed, 28 insertions(+), 7 deletions(-)


base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
2.41.0.rc0.172.g3f132b7071-goog

