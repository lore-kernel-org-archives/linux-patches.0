Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DDC839F7;
	Wed,  7 Aug 2024 15:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043057; cv=none; b=gseiT3Cnvy6uS9gzvUciZ5Qx5U+Q/27c4fanJ5ozb+Qca7sLVG9FHWqH/hqYoHIAp4iEcwLt7fM7XGp8xNnnv7q/37Q6yimH4dGcgjCAPmbsnG3UUsR5vLfgC1lool4WIca2OqB8LUMR60lOCXs6Ys4TkmppjfNaIYbV+/kjF0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043057; c=relaxed/simple;
	bh=JfPUY5JHEkBV5rKW7s+dHKATa8XC5efNPiO2GdsVjhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2NBrM9EkWF37lvje5lTwtV7dIIMWgWSf3VlTd/OF50sFFjH73lnAhaWAws/sBYcR6Pks3ZeDMWTtnDKaf5zZ0IfqUcKNuNKT4yAty8GpLIVX6l4V4Zobtde3+pjgVU/Apm+Nsaizem4YSoTh8vA/zDhLojWH5gCTPnN26gNUeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kzDf2tFg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzDf2tFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A743C4AF0B;
	Wed,  7 Aug 2024 15:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043056;
	bh=JfPUY5JHEkBV5rKW7s+dHKATa8XC5efNPiO2GdsVjhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzDf2tFgGaUXNhEh2zwKTt4dfnZ6WpOMbeW0vufQe8u5PN2684Y5Fo/BKFZ3hD198
	 oSS/u2DfXO4WzE48GD7SAKodMFygnkmlIWCvQK/K2F4TcHP2xBiDfoL5SSGfzMitg/
	 GxdNnPEhWMH602MNvWAlYs0mcb7EmagJvfxYX2XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.10 075/123] rust: SHADOW_CALL_STACK is incompatible with Rust
Date: Wed,  7 Aug 2024 16:59:54 +0200
Message-ID: <20240807150023.230174061@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit f126745da81783fb1d082e67bf14c6795e489a88 upstream.

When using the shadow call stack sanitizer, all code must be compiled
with the -ffixed-x18 flag, but this flag is not currently being passed
to Rust. This results in crashes that are extremely difficult to debug.

To ensure that nobody else has to go through the same debugging session
that I had to, prevent configurations that enable both SHADOW_CALL_STACK
and RUST.

It is rather common for people to backport 724a75ac9542 ("arm64: rust:
Enable Rust support for AArch64"), so I recommend applying this fix all
the way back to 6.1.

Cc: stable@vger.kernel.org # 6.1 and later
Fixes: 724a75ac9542 ("arm64: rust: Enable Rust support for AArch64")
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://lore.kernel.org/r/20240729-shadow-call-stack-v4-1-2a664b082ea4@google.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1906,6 +1906,7 @@ config RUST
 	depends on !MODVERSIONS
 	depends on !GCC_PLUGINS
 	depends on !RANDSTRUCT
+	depends on !SHADOW_CALL_STACK
 	depends on !DEBUG_INFO_BTF || PAHOLE_HAS_LANG_EXCLUDE
 	help
 	  Enables Rust support in the kernel.


