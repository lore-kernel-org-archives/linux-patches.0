Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B491109
	for <patches@lists.linux.dev>; Wed,  3 May 2023 08:40:12 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-54f8a3f1961so51674017b3.0
        for <patches@lists.linux.dev>; Wed, 03 May 2023 01:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683103211; x=1685695211;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tsKroyIYfOmkggcrqdey4GLuHL/j3Hn3ECNrtbDv+4k=;
        b=FreTAQEnryHPqC1s5NFCr/rg08FAyWJ++blo3gR3srCPJIWQb0UIrS35Mj4JRYVGcS
         yIxKzaQKAhNrc+MMIfhu3gstweG2OA1eeSUeZxLxKzOv16T4OIbdG/z6itte0rbfQRh8
         iYLOyxDeydvghUIxpKHvzmrd+AD4Q1xBwRXXufmBiYEJ7wOrx4XgyMVZoCFVBcAx549y
         f0DLrC0U7aAKTvkgLLQWIes+zJFBQQwvu9HHDPgeUtSx1De2In1XceQPUD/Ifn31ru2u
         G8b8gnRqi7lGLyxzpLtqHQ5vVc6vMTgyJEInukz4V5UJCLR95ke/OkUNSMldz95iDcK4
         14yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683103211; x=1685695211;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tsKroyIYfOmkggcrqdey4GLuHL/j3Hn3ECNrtbDv+4k=;
        b=E1lbI2rEE3F4Y2A/lMrWSKNrWO6hDMVQdIVFMamnKlViQ4OeMebCiIVHFOzNCHSFvN
         gRdtJuFZ3mJIR8jo4/Mq6i6vXjqKowjmT6hyKm3oIygrX/ZEmXyFZmyBZ/1hTjGI9Cfd
         a9wvNWmbtCnKLihuC5oxMfheWJ7/yyr4Krl4USBApPhrOZAy8gMR+GP//m7Xg5OqkTPy
         nBYPbiBuWWfLslNAtyg0IXFiy9f06VwvIAyR1LVD5sB6P9PbsLURif0PKhdWTvsn28BK
         lvVFneIP2LspPGmXWp/J8RUSyZL57C5S5PLv30hgVingu3kQY6qqv/NKwObrb6Gg1BEE
         3w+A==
X-Gm-Message-State: AC+VfDwjjVPiT8xIQdP1GTrIakmBMJKYoy7/2Y3sm6/MY6SJbvNkZv07
	7O8AWJ5XuCgbiR4Xh7md815CBeRiwZli8UI=
X-Google-Smtp-Source: ACHHUZ49hHPRm1pH+uSHGjzOViT5H8XUxKiVJ0tGHFWZkkVa6+RFvZX/3w1ZyAFbdz/Qvp6wo0yb3vkYn/DUt/w=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a81:e901:0:b0:54f:b986:9c60 with SMTP id
 d1-20020a81e901000000b0054fb9869c60mr12213286ywm.7.1683103211316; Wed, 03 May
 2023 01:40:11 -0700 (PDT)
Date: Wed,  3 May 2023 08:39:41 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230503083941.499090-1-aliceryhl@google.com>
Subject: [PATCH v1] rust: error: add ERESTARTSYS error code
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

This error code was probably excluded here originally because it never
actually reaches user programs when a syscall returns it. However, from
the perspective of a kernel driver, it is still a perfectly valid error
type, that the driver might need to return. E.g., this can be necessary
when a signal occurs during sleep.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/error.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index 5f4114b30b94..cbde1b2d29f4 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -58,6 +58,7 @@ pub mod code {
     declare_err!(EPIPE, "Broken pipe.");
     declare_err!(EDOM, "Math argument out of domain of func.");
     declare_err!(ERANGE, "Math result not representable.");
+    declare_err!(ERESTARTSYS, "Restart the system call.");
 }
 
 /// Generic integer kernel error.

base-commit: ea76e08f4d901a450619831a255e9e0a4c0ed162
-- 
2.40.1.495.gc816e09b53d-goog

