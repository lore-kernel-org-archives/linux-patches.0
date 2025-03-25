Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6CC266EF3;
	Tue, 25 Mar 2025 12:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905708; cv=none; b=cYVoLhBmubEwoaY6xAkNKjVcPfBD6TIAryJIiaGlfL2ta005WpzHmRVc8NihpthHUZf6PKke56aMM0peZS3cWEkzLQ7EmjbwK5z2vL6Yta3FO7fgXR4VQgM0hPFmXY3+PrrAX+cK3APQgwv/g6EIx/2VAffviKHEPhkYeJ4OgvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905708; c=relaxed/simple;
	bh=rlpOlDxN3WzmR+CuR/9q+d9b+2wDmqLAOndV9rCNat4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lrvlb64nfYzmnPFtVtMG42QrScY+xYeEpJnW4R+Oy0bKXPM7sH0W+UVGVJtWL44aqE+rVI1mSBScYIU/fNHuXibdvg7PSc1XfPtVHVOGdAfjX7lfj4x4D+kOX6bRN1aih/x+RuKEOyhHp4AK5OqMC83rKJuMfYXZ/vx4lPJUxtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGRXM/Y2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGRXM/Y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08561C4CEE4;
	Tue, 25 Mar 2025 12:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905708;
	bh=rlpOlDxN3WzmR+CuR/9q+d9b+2wDmqLAOndV9rCNat4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGRXM/Y2nyTfRcn1GUC4ADCkTPoJbLk9aSphLgTUgEHYkIDUk0nZMOf5jV682SsVp
	 tk7xXUiTY6y6EY8/zgAmecWXlAQFQOxAVFzvvGj4RJ9mVEzlbeSOGEyvG3UG8hufzS
	 T3LgLF3uLvm74gjPqNnGnkGl8ZY9fSYZQwt94cKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Maurer <mmaurer@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.1 121/198] rust: Disallow BTF generation with Rust + LTO
Date: Tue, 25 Mar 2025 08:21:23 -0400
Message-ID: <20250325122159.829227300@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Maurer <mmaurer@google.com>

commit 5daa0c35a1f0e7a6c3b8ba9cb721e7d1ace6e619 upstream.

The kernel cannot currently self-parse BTF containing Rust debug
information. pahole uses the language of the CU to determine whether to
filter out debug information when generating the BTF. When LTO is
enabled, Rust code can cross CU boundaries, resulting in Rust debug
information in CUs labeled as C. This results in a system which cannot
parse its own BTF.

Signed-off-by: Matthew Maurer <mmaurer@google.com>
Cc: stable@vger.kernel.org
Fixes: c1177979af9c ("btf, scripts: Exclude Rust CUs with pahole")
Link: https://lore.kernel.org/r/20250108-rust-btf-lto-incompat-v1-1-60243ff6d820@google.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1925,7 +1925,7 @@ config RUST
 	depends on !GCC_PLUGINS
 	depends on !RANDSTRUCT
 	depends on !SHADOW_CALL_STACK
-	depends on !DEBUG_INFO_BTF || PAHOLE_HAS_LANG_EXCLUDE
+	depends on !DEBUG_INFO_BTF || (PAHOLE_HAS_LANG_EXCLUDE && !LTO)
 	help
 	  Enables Rust support in the kernel.
 


