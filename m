Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A554E6CDC5;
	Tue, 14 May 2024 10:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683861; cv=none; b=Lrv0WtyqZqN22VnqZfEdz3LKMbPACByM5jpKl8dMP3M77lUgpMsIKc9PVX3UbXLv0BaFJEPapKYXx/A/5mMCJROoiS9qrNJQK+gEy8Z7CBxta2yUuXXgXM/6StYuo5au9nQmXSHOxwwBBj6uN6gyKzW/kPkBiiREix+bLO1DQTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683861; c=relaxed/simple;
	bh=+YlKxxzC6G5tuVmwPPsHiTpUe7UvrWzU+Bw2rSeXZ9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLLaChXLLBnNwfVRj3XGa9j67YCSocfgSKGMk4+5i77Cqb2nIpVvY74fGovNoS5baqY01cSZmVsb1IuPK4BtPEm4yPcmWPQ7hC/aBC4z2WC5GzUbuEtn9hVWg/r49dTIdbb4OY4xIFnU5hNpsnnANhTQqVeOYs8VMi/nPbpLsz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+KhArla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+KhArla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DC3C2BD10;
	Tue, 14 May 2024 10:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683861;
	bh=+YlKxxzC6G5tuVmwPPsHiTpUe7UvrWzU+Bw2rSeXZ9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+KhArla4DGgWVIs9Ihu8VFhcI+iZKp41tNb5/7Y5lePVJYFYxM9eQ+uaF0TMFQgz
	 1XwNWPrirx0oTh/oHUZqzguHDq6mJuGlxwf6OxxH5hbMKHGlr5W/zPLWW82J8Cpsd3
	 qQ/KLeH21JyQL+otuCIxewbZnhxRX8AhEYrihNt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	syzbot+355c5bb8c1445c871ee8@syzkaller.appspotmail.com,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.8 278/336] kmsan: compiler_types: declare __no_sanitize_or_inline
Date: Tue, 14 May 2024 12:18:02 +0200
Message-ID: <20240514101049.116398764@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Potapenko <glider@google.com>

commit 90d1f14cbb9ddbfc532e2da13bf6e0ed8320e792 upstream.

It turned out that KMSAN instruments READ_ONCE_NOCHECK(), resulting in
false positive reports, because __no_sanitize_or_inline enforced inlining.

Properly declare __no_sanitize_or_inline under __SANITIZE_MEMORY__, so
that it does not __always_inline the annotated function.

Link: https://lkml.kernel.org/r/20240426091622.3846771-1-glider@google.com
Fixes: 5de0ce85f5a4 ("kmsan: mark noinstr as __no_sanitize_memory")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: syzbot+355c5bb8c1445c871ee8@syzkaller.appspotmail.com
Link: https://lkml.kernel.org/r/000000000000826ac1061675b0e3@google.com
Cc: <stable@vger.kernel.org>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler_types.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -278,6 +278,17 @@ struct ftrace_likely_data {
 # define __no_kcsan
 #endif
 
+#ifdef __SANITIZE_MEMORY__
+/*
+ * Similarly to KASAN and KCSAN, KMSAN loses function attributes of inlined
+ * functions, therefore disabling KMSAN checks also requires disabling inlining.
+ *
+ * __no_sanitize_or_inline effectively prevents KMSAN from reporting errors
+ * within the function and marks all its outputs as initialized.
+ */
+# define __no_sanitize_or_inline __no_kmsan_checks notrace __maybe_unused
+#endif
+
 #ifndef __no_sanitize_or_inline
 #define __no_sanitize_or_inline __always_inline
 #endif


