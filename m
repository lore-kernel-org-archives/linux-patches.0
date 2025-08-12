Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0887721ABD0;
	Tue, 12 Aug 2025 18:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023222; cv=none; b=puaAuTbp/uSnYq40Mo+m6aeIw46LMYGyoZvpiiuR7ZnmZ2YDCLyVgyyaY6ZcBg4ORQSYArHJA7rkm9BRDMqVyIqPEYvHOys0QtvxBEIBlF/trvXJNZIWflDXObA6IwCB1en9PeGpuL0q+AwQCzDozwUAYKVALCvjPLeYZxCC1bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023222; c=relaxed/simple;
	bh=tj1XpLZ/1ZlN1h7DUBKboco6JqCTm+mVLF+NLDDxnFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JbPwVY/yBTDJHQ6RDNv/EAzGgf9Nvo/T2a1p7eGGoQdiDMN8utUpw/m73X13tObcsv/uLtjHiiAuR8yBewmZYlQbYHnxIMHiTQbgpdLIQhJQ/gAPnPhF6JuGNoV/utp191gobPeVW0Fcf9IiV4trO1eHplpa+20V9N43XV8iil8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ae0krAZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ae0krAZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DF3C4CEF0;
	Tue, 12 Aug 2025 18:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023221;
	bh=tj1XpLZ/1ZlN1h7DUBKboco6JqCTm+mVLF+NLDDxnFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ae0krAZzyphOjRyt81nqlF244qi7k6P8nnvFvSXPR5N4eQqkJOwsF5zzOeOOc1rRX
	 5SSjmZvt3DP2FWvw/wJ2q0yJSLEfyNXCRsnxOttG87tqRKwWgTKfUC0xWUJBaBhIh2
	 QR4HttTqlhjkiotZ0m++j8oKfTybupwBsE9ar5P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	=?UTF-8?q?Jannik=20Gl=C3=BCckert?= <jannik.glueckert@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 017/627] kunit/fortify: Add back "volatile" for sizeof() constants
Date: Tue, 12 Aug 2025 19:25:12 +0200
Message-ID: <20250812173419.974702088@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 10299c07c94aa0997fa43523b53301e713a6415d ]

It seems the Clang can see through OPTIMIZER_HIDE_VAR when the constant
is coming from sizeof. Adding "volatile" back to these variables solves
this false positive without reintroducing the issues that originally led
to switching to OPTIMIZER_HIDE_VAR in the first place[1].

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2075 [1]
Cc: Jannik Glückert <jannik.glueckert@gmail.com>
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Fixes: 6ee149f61bcc ("kunit/fortify: Replace "volatile" with OPTIMIZER_HIDE_VAR()")
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20250628234034.work.800-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/tests/fortify_kunit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/tests/fortify_kunit.c b/lib/tests/fortify_kunit.c
index 29ffc62a71e3..fc9c76f026d6 100644
--- a/lib/tests/fortify_kunit.c
+++ b/lib/tests/fortify_kunit.c
@@ -1003,8 +1003,8 @@ static void fortify_test_memcmp(struct kunit *test)
 {
 	char one[] = "My mind is going ...";
 	char two[] = "My mind is going ... I can feel it.";
-	size_t one_len = sizeof(one) - 1;
-	size_t two_len = sizeof(two) - 1;
+	volatile size_t one_len = sizeof(one) - 1;
+	volatile size_t two_len = sizeof(two) - 1;
 
 	OPTIMIZER_HIDE_VAR(one_len);
 	OPTIMIZER_HIDE_VAR(two_len);
-- 
2.39.5



