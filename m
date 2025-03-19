Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2CA1E7C02;
	Wed, 19 Mar 2025 14:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394947; cv=none; b=u7aFiNA/y2W/2zkktDiCuLwbw6mBWDSuLcc0hhU93BKIn45n28iiEjRnl2glup4ZB03mm9awllycqKCRs9yBejFk7rmNBWCCxu3wsJom22BwFeJiOJ0rw+0t8d1dsCqHnH2aCsOluKs2sFfVMQ9BRTCtSp+tZ98xmhc/2Bo2B98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394947; c=relaxed/simple;
	bh=v3ievAoeyXt68PUz/hK7dKeVU5/EJfkF8MMKCSTdRi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpGS1VRFfz0fili+TFsxim290Wh4Q07gabz7P58U1ibquqwZsEB5EjzR+QuHxmvoP7M+I1EnSVmrJY4gTkf9u40Hqkcbo/2lB2CL6unRoA6GmMHqGbQnQv3sarhNwzZUlbK3mdxyeOuZUq2gHcKpsLxMWnRXRUjjxWPw1DPc/2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxziK5h2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxziK5h2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B77EC4CEE8;
	Wed, 19 Mar 2025 14:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394947;
	bh=v3ievAoeyXt68PUz/hK7dKeVU5/EJfkF8MMKCSTdRi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxziK5h2fRbfxbCA7b842BI1cm0hm5vqVrRLRX7kLSASWJKUTag6uWFbUP3+T6dUv
	 eZ56yxqweOeMKbA8ZvKVbJ++x0y0LrBw79O0Vf+ZTQxW/9QTvAZZvo2KOpONU+eLzl
	 A6xrCqb24R9AZQAcEQ6MbiXl/1td/dN7E8tY2IuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Maurer <mmaurer@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.13 170/241] rust: Disallow BTF generation with Rust + LTO
Date: Wed, 19 Mar 2025 07:30:40 -0700
Message-ID: <20250319143031.933753330@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1959,7 +1959,7 @@ config RUST
 	depends on !MODVERSIONS
 	depends on !GCC_PLUGIN_RANDSTRUCT
 	depends on !RANDSTRUCT
-	depends on !DEBUG_INFO_BTF || PAHOLE_HAS_LANG_EXCLUDE
+	depends on !DEBUG_INFO_BTF || (PAHOLE_HAS_LANG_EXCLUDE && !LTO)
 	depends on !CFI_CLANG || HAVE_CFI_ICALL_NORMALIZE_INTEGERS_RUSTC
 	select CFI_ICALL_NORMALIZE_INTEGERS if CFI_CLANG
 	depends on !CALL_PADDING || RUSTC_VERSION >= 108100


