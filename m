Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C6E111AD
	for <patches@lists.linux.dev>; Wed, 17 May 2023 20:08:34 +0000 (UTC)
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-50d88a986afso1474243a12.0
        for <patches@lists.linux.dev>; Wed, 17 May 2023 13:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684354112; x=1686946112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WVkaYtQTj8iUhQoCH4E7KYFvPTbFMzSMw0B5Ujo6j7U=;
        b=k/7Al0AtAF6zKhw0lzSRawbRH6pCbg1kV1kmPFxrNcXxZZYRNvdWDqo5+Or3482dNP
         c5fXAAOIyOdgdQnsxZsnHrrdaSSFW6pS6MFD9QS3xPcTs7/2pKsMhqtcbzr7t9NAWTNt
         /l5t3O8F+7nfkfHvCAVmULq94St6KRSnCzLp/wtq0RI1lvTJjYjREhVebxAfmpX790tX
         bE9vFcQaAVvXxAKahSHmzirCs6T7b2PFBDoJfqyJbxUIb8VJgU/B6rWmDJUfZZ0Z+9iZ
         6HIcs8qwMqxTNOhL9TeOLNkASwPfLLroCSB02PAeXZL/qmNASCFOEbmYw9mQZCnFAedm
         d/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684354112; x=1686946112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WVkaYtQTj8iUhQoCH4E7KYFvPTbFMzSMw0B5Ujo6j7U=;
        b=QYXIP7A6iUJKd+i+097kySawQf1rcqFbGOd1ltQEFIRCiNt0gZQAh1RrgyBH6Ns0+v
         kMLWM3sjlU3z7b0yH9GKuLnHW70D1HwAPDZyV4Cjj44kS7oDK5Ez7qbTdt3BRz7zNh5G
         lsrGWgtgerLl+vG2Px4U6gbU5rTh9RyDREovTTVvDTB+EaGkmcLktXpX/XIU7Hi190Nc
         XkVAaEgO8I6RINA+7Yi7q4PqtLfD7vDYYjkAwMpnd4N6yMciO4Ewsb7EcMWag8qdk7Qh
         yXTGLoMWudw3eMfO0VkG2t7gjVrjbeTfy+Y/Yu7NUN7gnnglVswftOtpMDRGdTancJ30
         tqrw==
X-Gm-Message-State: AC+VfDw21fMKyJu/tPV4AJkb5v+4R0NAT1/62jJUQnmk9SyL0ej7FcS7
	UTnhoAyOBi7vznmzVgJaK5Ad/TfWWV9FX5k=
X-Google-Smtp-Source: ACHHUZ4fXXzkgZEE7kXW29z7xI8+JKUgG3Ttr9/nlpSJe9h8kBZqv80+Xkmr0bhvapKwvhzU0djTZltE3Lse/7w=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:aac5:0:b0:510:b4dc:1656 with SMTP id
 r5-20020a50aac5000000b00510b4dc1656mr1476722edc.3.1684354112325; Wed, 17 May
 2023 13:08:32 -0700 (PDT)
Date: Wed, 17 May 2023 20:08:13 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230517200814.3157916-1-aliceryhl@google.com>
Subject: [PATCH v1 1/2] rust: sync: add `Arc::ptr_eq`
From: Alice Ryhl <aliceryhl@google.com>
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alice Ryhl <aliceryhl@google.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

Add a method for comparing whether two `Arc` pointers reference the same
underlying object.

This comparison can already be done by getting a reference to the inner
values and comparing whether the references have the same address.
However, writing `Arc::ptr_eq(a, b)` is generally less error-prone than
doing the same check on the references, since you might otherwise
accidentally compare the two `&Arc<T>` references instead, which wont
work because those are pointers to pointers to the inner value, when you
just want to compare the pointers to the inner value.

Also, this method might optimize better because getting a reference to
the inner value involves offsetting the pointer, which this method does
not need to do.

Co-developed-by: Wedson Almeida Filho <walmeida@microsoft.com>
Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/sync/arc.rs | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index e6d206242465..274febe3bb06 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -221,6 +221,11 @@ impl<T: ?Sized> Arc<T> {
         // reference can be created.
         unsafe { ArcBorrow::new(self.ptr) }
     }
+
+    /// Compare whether two [`Arc`] pointers reference the same underlying object.
+    pub fn ptr_eq(this: &Self, other: &Self) -> bool {
+        core::ptr::eq(this.ptr.as_ptr(), other.ptr.as_ptr())
+    }
 }
 
 impl<T: 'static> ForeignOwnable for Arc<T> {

base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
2.40.1.606.ga4b1b128d6-goog

