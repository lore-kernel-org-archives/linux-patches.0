Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF21202648;
	Wed,  6 Nov 2024 12:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896810; cv=none; b=l4j5HoGHerNm+sa6MiRhs8YpRMnQGP+8ws1W13g2fP2r/r6W0uQCMmOkzNGhsjZraWKkwzRkXWyUavJEmFqoq5vuRuAGWkWUNDDJTa+dB4kKJUZ5kJZvikT+7ZWhGFTeJBJgOOapAcH/9vkV+Aio/B6VRnw9Brhde3+Q9EN3u1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896810; c=relaxed/simple;
	bh=tmJX4MM3hE9XdTeCfCYzIXuTwZywYTAAD7/R+AK/XmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMxSUjr5ZSRWt4xlH2AMMoXwbWlHDtE1+XEtRulHt++Co+osfy7dT+uvo9huLDaTIs/Tc/LufsciQ/fv1DIoonqhZII9jUJxSeRirrmuBRQHRoN0HMGL6gxuRFooOIazcvcGbcplbR6+PKGz9uNb3n3dQCPL3wRKY7UFbGanhYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qCDZPx43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qCDZPx43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290FBC4CED4;
	Wed,  6 Nov 2024 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896809;
	bh=tmJX4MM3hE9XdTeCfCYzIXuTwZywYTAAD7/R+AK/XmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qCDZPx43Rhwjo2logR92dWpEjg0N6W/ACmbyGrCXNWsQ8V3iup00UiCTDXvYCIgXZ
	 gWWSzzdnNlWhU+nBQhnweMaDlwybDAslepc5KOK/MeNcWKi1Pz1zVyMwh/r/M7p9Qb
	 AxrDxoY67jVV/Gu1MuZTvZ3CX6N9/iDJtf911glM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+908886656a02769af987@syzkaller.appspotmail.com,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrew Pinski <pinskia@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/110] kasan: Fix Software Tag-Based KASAN with GCC
Date: Wed,  6 Nov 2024 13:04:46 +0100
Message-ID: <20241106120305.399029081@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Elver <elver@google.com>

[ Upstream commit 894b00a3350c560990638bdf89bdf1f3d5491950 ]

Per [1], -fsanitize=kernel-hwaddress with GCC currently does not disable
instrumentation in functions with __attribute__((no_sanitize_address)).

However, __attribute__((no_sanitize("hwaddress"))) does correctly
disable instrumentation. Use it instead.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=117196 [1]
Link: https://lore.kernel.org/r/000000000000f362e80620e27859@google.com
Link: https://lore.kernel.org/r/ZvFGwKfoC4yVjN_X@J2N7QTR9R3
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218854
Reported-by: syzbot+908886656a02769af987@syzkaller.appspotmail.com
Tested-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrew Pinski <pinskia@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Fixes: 7b861a53e46b ("kasan: Bump required compiler version")
Link: https://lore.kernel.org/r/20241021120013.3209481-1-elver@google.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler-gcc.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index bf78da28e8427..5b481a22b5fe2 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -116,7 +116,11 @@
 #define KASAN_ABI_VERSION 3
 #endif
 
+#ifdef __SANITIZE_HWADDRESS__
+#define __no_sanitize_address __attribute__((__no_sanitize__("hwaddress")))
+#else
 #define __no_sanitize_address __attribute__((__no_sanitize_address__))
+#endif
 
 #if defined(__SANITIZE_THREAD__) && __has_attribute(__no_sanitize_thread__)
 #define __no_sanitize_thread __attribute__((__no_sanitize_thread__))
-- 
2.43.0



