Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25832264AA;
	Tue,  6 Jan 2026 17:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721096; cv=none; b=qHd5608BODfYJXJtqJEokG2EZ4OmbxFylDtjQT7TKFj/D22/8A/0iZgZsbjzQJ55DGXM4m7v2ehHqepeUswrawzw7euabbrtS6rOkoFyj3vbGhYsK1hxhpqdWKANs4xgcOzQ9iTp3JD6GN/KgFpuhWM5v9EH2mdHzkPJMc2Uq2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721096; c=relaxed/simple;
	bh=QXwwKGMZEu8oydY082jgYrvByMIDMrRaIwx76IDAmlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reMXc2CQZf9VFV03reTK8rlGmuIXjHVnPPxvjiQhew8P4ffs6BE63i76dMq/E/E7nTxsKqsK7v3JFeHryL7DYhV5aQ87DLjwDxY6xq6Pmsd3gfZ4XkpMdmeINSvMubuTRBoTFbbR1A9Pt9vb2SlS8HtMXvIKo9zgcu/VL8fKp8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XwshiF4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XwshiF4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2AF8C116C6;
	Tue,  6 Jan 2026 17:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721096;
	bh=QXwwKGMZEu8oydY082jgYrvByMIDMrRaIwx76IDAmlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XwshiF4YgjLiJPMPGh/Lf7Z1D1rqdnnIUjk2RtAVNDWFpEfWN77yyqBTz+1RShKzg
	 5dV+rXZTrEJKYN3z9bwk5NJw4yp92pcStFZrPt4MCwbkgmAzQSvMzGhtoxvgDkyQer
	 yXYZfKZRkYxMyHDtsfOgpOaQno2AsGAsX6ZyJgms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.12 435/567] compiler_types.h: add "auto" as a macro for "__auto_type"
Date: Tue,  6 Jan 2026 18:03:37 +0100
Message-ID: <20260106170507.444053363@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: H. Peter Anvin <hpa@zytor.com>

commit 2fb6915fa22dc5524d704afba58a13305dd9f533 upstream.

"auto" was defined as a keyword back in the K&R days, but as a storage
type specifier.  No one ever used it, since it was and is the default
storage type for local variables.

C++11 recycled the keyword to allow a type to be declared based on the
type of an initializer.  This was finally adopted into standard C in
C23.

gcc and clang provide the "__auto_type" alias keyword as an extension
for pre-C23, however, there is no reason to pollute the bulk of the
source base with this temporary keyword; instead define "auto" as a
macro unless the compiler is running in C23+ mode.

This macro is added in <linux/compiler_types.h> because that header is
included in some of the tools headers, wheres <linux/compiler.h> is
not as it has a bunch of very kernel-specific things in it.

[ Cc: stable to reduce potential backporting burden. ]

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler_types.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -14,6 +14,19 @@
 #ifndef __ASSEMBLY__
 
 /*
+ * C23 introduces "auto" as a standard way to define type-inferred
+ * variables, but "auto" has been a (useless) keyword even since K&R C,
+ * so it has always been "namespace reserved."
+ *
+ * Until at some future time we require C23 support, we need the gcc
+ * extension __auto_type, but there is no reason to put that elsewhere
+ * in the source code.
+ */
+#if __STDC_VERSION__ < 202311L
+# define auto __auto_type
+#endif
+
+/*
  * Skipped when running bindgen due to a libclang issue;
  * see https://github.com/rust-lang/rust-bindgen/issues/2244.
  */


