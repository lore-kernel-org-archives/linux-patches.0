Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1753DB336;
	Thu, 16 Jul 2026 14:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211685; cv=none; b=MT580jpoSPdridlRSyP1pyt2QqDy1aEjfnZNjyqMLZAJkXiUt7dtQLz+w3SrSAg44heDf4Z09EQsqzCgsXc2dKT/KJ4wiPfffkX6+aHO7zrptbVn4SYPqwA0KXb/1jCVC8xA8EbQ5I/st3chBQUe8ezmGgfGVQGfgQOz4PiLwTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211685; c=relaxed/simple;
	bh=YUCmkcOE2XIZBvVZjTbDywPq4VMinojAfjlXPANSmjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAWfaHn3jzsaZi3EQbj9QieLXPyAe1cOMFm6oWUNzit0/ZUz+AnORL32ock2H1CrtAxmKwHFtB3FACrd7ogkXHGFPk3IVPK9If5R5oPrTEncXZy2wGyDZ5Z8sikUVuQD2yigW9BXEu48JeY1qVTNtxw14z5NYkPByef85kgp4RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQwRoxm3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQwRoxm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6031F000E9;
	Thu, 16 Jul 2026 14:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211684;
	bh=JyJOspfEXuatUhyAiPUZki7nLuOV59U5dLcmdG5H8Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQwRoxm3C5W07BrOCkveQ7IeJRCy5P/NNUkb3kmBtyxwbBESc6Yr6ANXz6DnYgucM
	 RGEhUgc7DJj6zlMggyiD8/tUqNb2y0i1sfDYwFXzSFPFaKRc1KJEjcJMFOQZ2VQ7t+
	 ZlVzO9KYMyDaZmNqDTQzzZ3rX6N/BxEy8gKEyRvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 040/349] rust: kasan: KASAN+RUST requires clang
Date: Thu, 16 Jul 2026 15:29:34 +0200
Message-ID: <20260716133034.218085151@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Alice Ryhl <aliceryhl@google.com>

[ Upstream commit 5b271543d0f08e9733d4732721e960e285f6448f ]

Kernel KASAN involves passing various llvm/gcc specific arguments to
the C and Rust compiler. Since these arguments differ between llvm and
gcc, it's not safe to mix an llvm-based rustc with a gcc build when
kasan is enabled.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Cc: stable@vger.kernel.org
Fixes: e3117404b411 ("kbuild: rust: Enable KASAN support")
Link: https://patch.msgid.link/20260408-kasan-rust-sw-tags-v3-1-e07964d14363@google.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index f4b91b1857bf86..53eba5cd88ff51 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1974,6 +1974,7 @@ config RUST
 	depends on !CFI_CLANG || HAVE_CFI_ICALL_NORMALIZE_INTEGERS_RUSTC
 	select CFI_ICALL_NORMALIZE_INTEGERS if CFI_CLANG
 	depends on !CALL_PADDING || RUSTC_VERSION >= 108100
+	depends on !KASAN || CC_IS_CLANG
 	depends on !KASAN_SW_TAGS
 	depends on !(MITIGATION_RETHUNK && KASAN) || RUSTC_VERSION >= 108300
 	help
-- 
2.53.0



