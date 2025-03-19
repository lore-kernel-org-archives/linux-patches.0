Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD4F1C82F4;
	Wed, 19 Mar 2025 14:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395111; cv=none; b=Y2c9rrNKybHq1FH0WLZsttkmzFWsVcYP22SekG9E4m2RBTg+y48GTxh7MJIO6eTtgQ5VndWZiNrA0vqlQ3DrhszlIq1JpdSXIpk+tYpt7g9hqXJE4QTVu+2CXMTP5zrqUv2M1qFQGaiLEbdW4CjE8ol15avyxh73/N3qQrnfxso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395111; c=relaxed/simple;
	bh=/i6SHqbDrDql4mtbJUEaF0kI2sowVmt2tFe0r9ygCNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSN0pMTcvpa2IIEoP57GZjNFnhvHLw00rg0lDvfDcnvpSZMn84iDQq0QMBAzgRCaXH8vcWapzrLZ7AewVTay0FPXJ7wEPq29mZPgx5AjJ4itWUVjGpEXicL5lS06DZOSdm+iCmVIR9fQPm+AjeXvQv0PLjIPGzZ+ml0byovAs2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bp4b9skX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bp4b9skX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5239FC4CEE4;
	Wed, 19 Mar 2025 14:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395111;
	bh=/i6SHqbDrDql4mtbJUEaF0kI2sowVmt2tFe0r9ygCNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bp4b9skXusLtd6g+U81TlP0DViLlg8lt5t7+m8rNoRTpDXNsTpY9rD+yO0mrqM08v
	 bgtJRN6No1Te7m0XSUu2iIY6zxU8AK5qX/pq3GB90WXpc3t20jo6VyTN1hrDOMtm1l
	 5VoYr21mOeSLg1veKxeauEExSo+RVfXOrU/zcDxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Maurer <mmaurer@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 165/231] rust: Disallow BTF generation with Rust + LTO
Date: Wed, 19 Mar 2025 07:30:58 -0700
Message-ID: <20250319143030.917300876@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1958,7 +1958,7 @@ config RUST
 	depends on !MODVERSIONS
 	depends on !GCC_PLUGIN_RANDSTRUCT
 	depends on !RANDSTRUCT
-	depends on !DEBUG_INFO_BTF || PAHOLE_HAS_LANG_EXCLUDE
+	depends on !DEBUG_INFO_BTF || (PAHOLE_HAS_LANG_EXCLUDE && !LTO)
 	depends on !CFI_CLANG || HAVE_CFI_ICALL_NORMALIZE_INTEGERS_RUSTC
 	select CFI_ICALL_NORMALIZE_INTEGERS if CFI_CLANG
 	depends on !CALL_PADDING || RUSTC_VERSION >= 108100


