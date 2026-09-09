Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BBC57D21B;
	Wed,  9 Sep 2026 14:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963314; cv=none; b=MgA7v1PyUpYTrcJO0ALFDnnN2QuC20lhO1Q6Exz7h1ZSygkl/eLuXOWVpVgFQXPDo4qmsE/i3AMytEkRdwiPV2dmu7VQSWeWKRoHXZB1VETMAR3iexPlYfWH9L7ipM59peZD9JhHfEDH17/d9UomwzPkZGEMERhMMhmgS1xXnWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963314; c=relaxed/simple;
	bh=doLA5CjZfEm4JwpymGeciTUh59UTGgd7p+fsI83ZPPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atHn3QV9PQ6O8Td/MefG0EAGDk5e6b2gLcKCaN4tli0HX7lWheIb5x7YWEcqd7KPQig4r/By9c1ccaHJKTif2PESieDAwLcJpgjyivSj3O638L44YbnL6hRgqCwvo8Zw0IfHOWPlGVElBMuL2hFkGAj5G4pPEWS/XNBU3Z9P29U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NrCccZJE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NrCccZJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3641F00A3A;
	Wed,  9 Sep 2026 14:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963313;
	bh=yq69ju8xERyaPo3AGOCIRCME6O7MMxi8ctommpUlzRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NrCccZJEkIx8/ZV37YaQHwLYscB05l6OV7R6eOO5WAKLA5mDcDlpLkKDHnWUzPLwQ
	 ZsmCtZYfjxnpGretvL9ap58Qm2U+3LIWKzKBwVJJEsiNSTTKRa2re/rjSNZ2H/BZrR
	 QE1E9OSUUiHBDc80+Xd6NgmL79NqT+/22fyAOjAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 006/583] objtool/rust: add one more `noreturn` Rust function
Date: Wed,  9 Sep 2026 15:34:51 +0200
Message-ID: <20260909134238.014282222@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

[ Upstream commit c18f35e4904920db4c51620ba634e4d175b24741 ]

Fix the following warning:

rust/kernel.o: warning: objtool: _RNvXNtNtCs1ewLyjEZ7Le_6kernel3str9parse_intaNtNtB2_7private12FromStrRadix14from_str_radix()
falls through to next function _RNvXNtNtCs1ewLyjEZ7Le_6kernel3str9parse_intaNtNtB2_7private12FromStrRadix16from_u64_negated()

The commit 51d9ee90ea90 ("rust: str: add radix prefixed integer
parsing functions") introduces u64::from_str_radix(), whose
implementation contains a panic path for out-of-range radix values.
The panic helper is core::num::from_ascii_radix_panic().

Note that radix is derived from strip_radix() here and is always
within the valid range, so kernel never panics.

Fixes: 51d9ee90ea90 ("rust: str: add radix prefixed integer parsing functions")
Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20251223113538.1016078-1-fujita.tomonori@gmail.com
[ Reworded typo. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index c7d64ab2ea4c4..141ff11f70a4b 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -216,7 +216,8 @@ static bool is_rust_noreturn(const struct symbol *func)
 	 * as well as changes to the source code itself between versions (since
 	 * these come from the Rust standard library).
 	 */
-	return str_ends_with(func->name, "_4core5sliceSp15copy_from_slice17len_mismatch_fail")		||
+	return str_ends_with(func->name, "_4core3num22from_ascii_radix_panic")				||
+	       str_ends_with(func->name, "_4core5sliceSp15copy_from_slice17len_mismatch_fail")		||
 	       str_ends_with(func->name, "_4core6option13expect_failed")				||
 	       str_ends_with(func->name, "_4core6option13unwrap_failed")				||
 	       str_ends_with(func->name, "_4core6result13unwrap_failed")				||
-- 
2.53.0



