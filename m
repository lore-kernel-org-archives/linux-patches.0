Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9390818BC36;
	Wed, 19 Mar 2025 14:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395253; cv=none; b=t0/+rok1/Y659XTvnzbxl5gw5AIJalPmPHKBxrQAl3imPgUzJ6S/h9Pxo0nUydO0BDCOWkMu6UobuO62K83lUUmohyO+v5oqf3Ski4Wn7JrKuW4YOcBUE2Nl1rv2VYb7DYZvzF5F5rMySyrputxHk/wUqkunDtkMBYxoASDuGF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395253; c=relaxed/simple;
	bh=rgxEptthWvxCW7KZtRJaeIQ4mFF7Fe8aandiQdVQRys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RbDniXe6psd6zYV5vuYNWFpAhcPLlEhL1gmR2gZvybGLFd710F6NTOS7FrF0j3bCOdoH6L3DXMzaMUWMkOhzbT0JqafMz/5J4RUIutCC7qkfcBuoeDG0heB9RoBIPlRYolqifqUoQOjsIyMwpo0BJV+ALjyfUOViK/hq4KGS0t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4ueFq4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4ueFq4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEC2C4CEE4;
	Wed, 19 Mar 2025 14:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395253;
	bh=rgxEptthWvxCW7KZtRJaeIQ4mFF7Fe8aandiQdVQRys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4ueFq4DPkyfG5EqAWv4jcV/wml9pjLuL3EXa3QkMVuXtfC85VgTLsVZJRji6x6mP
	 06h1Z2islpH3WzYBUfz2hHuMNLsrbYzpq/r2ztlKrFn6rnGHMA25VF6IZHONPZ6qth
	 SZkbLKsUhvHvLNODYvSheFgX2vGy/0dw0iQJRSXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Maurer <mmaurer@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.6 135/166] rust: Disallow BTF generation with Rust + LTO
Date: Wed, 19 Mar 2025 07:31:46 -0700
Message-ID: <20250319143023.672161394@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1908,7 +1908,7 @@ config RUST
 	depends on !GCC_PLUGINS
 	depends on !RANDSTRUCT
 	depends on !SHADOW_CALL_STACK
-	depends on !DEBUG_INFO_BTF || PAHOLE_HAS_LANG_EXCLUDE
+	depends on !DEBUG_INFO_BTF || (PAHOLE_HAS_LANG_EXCLUDE && !LTO)
 	help
 	  Enables Rust support in the kernel.
 


