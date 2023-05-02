Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC41D7E
	for <patches@lists.linux.dev>; Tue,  2 May 2023 12:46:59 +0000 (UTC)
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-506b21104faso4326891a12.1
        for <patches@lists.linux.dev>; Tue, 02 May 2023 05:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683031618; x=1685623618;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ADtw/qW1A9BDeVMPTl0uodglbiJnCrGJeTfJlSlwBKg=;
        b=wK27d6BGvYADsMaxuHyLqpOXqC9pb4EwTrCekKIa0wESUDbdGwNGIUd4yZ8Ws4QWjY
         /vZfRYBoCU/ZiRsqN+VuBaMDzDCiqagJpeG6T0MScGFY2OD/2PWMK3A+KPdMiz1u19f4
         UPspT7ukgGhejZ0AQiFCWEZO1ljco78t2h6Ma08f7O74YSNZWPamlOePA7GGeocoRidd
         zRFOed/rGxVAZ70p58vqLKjAdSVWoBCWFLK6fyNPxhVQnpk2smSrwP+6SUy9BIyZQn0m
         R70Oq1te08FqkVjDEEUUOg8YyzkpBKOQ3DTx8BKmPwRO476QS0joPsxGHSgeBZwo5LeO
         2wtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683031618; x=1685623618;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ADtw/qW1A9BDeVMPTl0uodglbiJnCrGJeTfJlSlwBKg=;
        b=AZT9ve5AFBQ2K8OJxhhKNUyqdpZ0yfj4+hD8eR7bnUw4H4uQxuLkDUQOAasEnt5Zw2
         zU5JvGYlr/yWuHtmN142aIuM8FkRYP9AbJbBevvjKBTb4FyhhWVu4Q6vf2HriD9Pb8M8
         lTmUhRURTRKv2Gy9zS8VRIILb00/7b8LgAga4n8PZ+p92IXGyZsay9RNdpG7VJhwpx9/
         CdOkP7ssIBEEPbHD2FbP2CVuVV8PE26+PA4KqjHGaRnOfvCfQYffCpNMVmq2/qTxKI7I
         Sd0J2EShFhJ3Fs/53brMPTFU3eHtsNLhyONQRgkmOtCpfXM8445NoOzQvm/H5ATZwr18
         3zxA==
X-Gm-Message-State: AC+VfDx7uofQstsNFOmCOjT0xDWU1CYwB5rkosJH+HEvkyyb6VtEoHAz
	jEU8A1OO9azreztALzqZRyNtfEIlS4Oz7Gw=
X-Google-Smtp-Source: ACHHUZ4PGt9JNY1496rQhEH+WLmSav3+qf88yqqFPW52fA2YiYcRFGcqDl4OEBgAI76aE3ZWAWeGyNcuQPShBzg=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:9fe3:0:b0:50b:c83b:22d8 with SMTP id
 c90-20020a509fe3000000b0050bc83b22d8mr2063829edf.3.1683031242984; Tue, 02 May
 2023 05:40:42 -0700 (PDT)
Date: Tue,  2 May 2023 12:40:15 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230502124015.356001-1-aliceryhl@google.com>
Subject: [PATCH] rust: error: allow specifying error type on `Result`
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently, if the `kernel::error::Result` type is in scope (which is
often is, since it's in the kernel's prelude), you cannot write
`Result<T, SomeOtherErrorType>` when you want to use a different error
type than `kernel::error::Error`.

To solve this we change the error type from being hard-coded to just
being a default generic parameter. This still lets you write `Result<T>`
when you just want to use the `Error` error type, but also lets you
write `Result<T, SomeOtherErrorType>` when necessary.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/error.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index 5f4114b30b94..01dd4d2f63d2 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -177,7 +177,7 @@ impl From<core::convert::Infallible> for Error {
 /// Note that even if a function does not return anything when it succeeds,
 /// it should still be modeled as returning a `Result` rather than
 /// just an [`Error`].
-pub type Result<T = ()> = core::result::Result<T, Error>;
+pub type Result<T = (), E = Error> = core::result::Result<T, E>;
 
 /// Converts an integer as returned by a C kernel function to an error if it's negative, and
 /// `Ok(())` otherwise.

base-commit: ea76e08f4d901a450619831a255e9e0a4c0ed162
-- 
2.40.1.495.gc816e09b53d-goog

