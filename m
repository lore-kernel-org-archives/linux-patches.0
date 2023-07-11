Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B86C17FE0
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 09:40:21 +0000 (UTC)
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-992e6840901so661124966b.0
        for <patches@lists.linux.dev>; Tue, 11 Jul 2023 02:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689068420; x=1691660420;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v6WKBzYvERNDuknj+tWtM9bgJ0GurLsMS9RlnUyPmrc=;
        b=EpcSNWvY8BCvobBorJKTq6sFdxH+VChpySoX1MC6xQdxotL6dpArX2aHBbt8VwonAw
         5U4nkKAdAsXsBjRDjn6EJ/x8bsMuu1doFFJvH1xZRhMq2Oiz20TKlliU+WA6sROLYe+w
         UndpaFiDN9F35Dagtj3aF/edBjBBMAKbbZkhFlBWv4Kaj53V2N4T/s7wsTWL4v90UKNE
         oozF7LlHEEr/6kgi4O2vKtbfvhppt5Arfmrca6t5//9RahqDBJW7JnxkqhX2YB6vYrKZ
         uy6eDDQmJHIAJuEuULa55PMfNx33dz8BOSoG7musUOFxBivEQpP0x6mWwB6qBCUpYUrH
         zU+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689068420; x=1691660420;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v6WKBzYvERNDuknj+tWtM9bgJ0GurLsMS9RlnUyPmrc=;
        b=aQw3fgWre2c0Ar6pZHFHrHFjY3G1SM+VURudUDDKYCz0kLWWGp8UskrYiA9bX4ON/B
         JmNNNyKkAPXLme6Ed8oJbtdX4p48rPd76bWfTWyC9QPUtpEjFJ+K9d8XrrqScC4x5aGn
         MXLhN8TQZAOAFM4+9Sl0DU/Ij1hgPMtYWi4gqVXj/pD0RfIN5YPskLqZNBkoQNbd7D4s
         9+9Kn1W3p30DrVQ/sSpFM25ttbGSZW/VHibsEeMTrXtsfJvUrBXpAXvVteTyUQU12/IO
         lNpMrzsr0EOuHroo5M4VBCTfl/XyV0GQm/gVylGYPFJL14oglxjgaE1OqYkDfGqePD1f
         ap4w==
X-Gm-Message-State: ABy/qLbyjQCtTmPzritzEWwOKHeKaxKQSZ82bbxmLR1QuwRZfZ2XUBMr
	1pTqG+kFrgw1NHd23RQwicOvLT0AlNReajo=
X-Google-Smtp-Source: APBJJlHUsXdQJBPhZBUFRWRdsnO9qm0rj0hfuTLUWJ7cX2ZVGox7Jbt0ZPt5Sv3Bt/Ndtv9MLq3FEJQ9TCS0QmA=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:906:9f26:b0:98e:46da:bfec with SMTP
 id fy38-20020a1709069f2600b0098e46dabfecmr101085ejc.1.1689068420362; Tue, 11
 Jul 2023 02:40:20 -0700 (PDT)
Date: Tue, 11 Jul 2023 09:32:57 +0000
In-Reply-To: <20230711093303.1433770-1-aliceryhl@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230711093303.1433770-1-aliceryhl@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230711093303.1433770-4-aliceryhl@google.com>
Subject: [PATCH 3/9] workqueue: introduce `__INIT_WORK_WITH_KEY`
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Wedson Almeida Filho <walmeida@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

From: Wedson Almeida Filho <walmeida@microsoft.com>

A Rust helper (introduced in a later patch) needs to call
`__INIT_WORK` with a passed key, rather than define one in place.

In order to do that, this moves the initialization code from
the `__INIT_WORK` macro into a new `__INIT_WORK_WITH_KEY` macro
which takes the key as an extra parameter.

Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
Co-developed-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Taken from [1]. Wedson's email updated at Wedson's request. Tejun's
Acked-by taken from [2].

[1]: https://lore.kernel.org/rust-for-linux/20220802015052.10452-7-ojeda@kernel.org/
[2]: https://lore.kernel.org/rust-for-linux/Yvq3IfK4+C94AeE2@slm.duckdns.org/

 include/linux/workqueue.h | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 3992c994787f..c91a84a4723d 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -221,24 +221,31 @@ static inline unsigned int work_static(struct work_struct *work) { return 0; }
  * to generate better code.
  */
 #ifdef CONFIG_LOCKDEP
+#define __INIT_WORK_WITH_KEY(_work, _func, _onstack, _key)		\
+	do {								\
+		__init_work((_work), _onstack);				\
+		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
+		lockdep_init_map(&(_work)->lockdep_map, "(work_completion)"#_work, _key, 0); \
+		INIT_LIST_HEAD(&(_work)->entry);			\
+		(_work)->func = (_func);				\
+	} while (0)
+
 #define __INIT_WORK(_work, _func, _onstack)				\
 	do {								\
 		static struct lock_class_key __key;			\
-									\
-		__init_work((_work), _onstack);				\
-		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
-		lockdep_init_map(&(_work)->lockdep_map, "(work_completion)"#_work, &__key, 0); \
-		INIT_LIST_HEAD(&(_work)->entry);			\
-		(_work)->func = (_func);				\
+		__INIT_WORK_WITH_KEY(_work, _func, _onstack, &__key);	\
 	} while (0)
 #else
+#define __INIT_WORK_WITH_KEY(_work, _func, _onstack, _key)		\
+	do {								\
+		__init_work((_work), _onstack);				\
+		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
+		INIT_LIST_HEAD(&(_work)->entry);			\
+		(_work)->func = (_func);				\
+	} while (0)
+
 #define __INIT_WORK(_work, _func, _onstack)				\
-	do {								\
-		__init_work((_work), _onstack);				\
-		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
-		INIT_LIST_HEAD(&(_work)->entry);			\
-		(_work)->func = (_func);				\
-	} while (0)
+	__INIT_WORK_WITH_KEY(_work, _func, _onstack, NULL)
 #endif
 
 #define INIT_WORK(_work, _func)						\
-- 
2.41.0.255.g8b1d071c50-goog

