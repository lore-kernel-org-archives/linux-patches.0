Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF6017BEAE;
	Tue, 10 Sep 2024 09:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961691; cv=none; b=qs1nnmhSCXM7up8oigwy8rgAbQpor8UFBGD374gE//uwFye/jUpwBqI39qvK8DkR+T3XW77z/vszzb26C36+TCyQdAd+sNW1l6T6Ejw6UejThM16S9bagxhHIzXjaYvDSX+E5b9inoz+MrPzE040pdAwMmZP8gWm3FmAexrwubs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961691; c=relaxed/simple;
	bh=ny5AKbXf+AvXCQrFg8IH8SG7Tr03m0GPVlnGDUM/xgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrzWDHJr6mG5YD/n97TXwSnem46L7lXA7wbjkd3HRn6Mpv3s8DFJ0Saa82A0VVJJEZPTakGEJcbgg2LHi62mLz6GAJmgk7z/0aT47uae1wsJckJSahsjwaY+1V0mURmCyP2qaBH2NFJjAA4HFFz7Ithtf5WA5deAhAGF+5KoM8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abHpmHwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abHpmHwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DE8C4CEC3;
	Tue, 10 Sep 2024 09:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961690;
	bh=ny5AKbXf+AvXCQrFg8IH8SG7Tr03m0GPVlnGDUM/xgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=abHpmHwFbPf2o9Rv4PuP/CJM4enKuzsB0io7Y6kUmGkye1A/tuehVWzfmvdWuOLYD
	 Gzj9gH4kYrP8eTUs4QuXDqiQ6xDfMcF74DWDnAh+SAyzvfp4iP6LehhoSvb9QrFw0U
	 HVWQVkg0Oi3kHL57E2SO+xWt4G57dy1Q21BRvzXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 155/375] rust: kbuild: fix export of bss symbols
Date: Tue, 10 Sep 2024 11:29:12 +0200
Message-ID: <20240910092627.678190790@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Andreas Hindborg <a.hindborg@samsung.com>

[ Upstream commit b8673d56935c32a4e0a1a0b40951fdd313dbf340 ]

Symbols in the bss segment are not currently exported. This is a problem
for Rust modules that link against statics, that are resident in the kernel
image. Thus export symbols in the bss segment.

Fixes: 2f7ab1267dc9 ("Kbuild: add Rust support")
Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240815074519.2684107-2-nmi@metaspace.dk
[ Reworded slightly. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/Makefile b/rust/Makefile
index f70d5e244fee..47f9a9f1bdb3 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -359,7 +359,7 @@ $(obj)/bindings/bindings_helpers_generated.rs: $(src)/helpers.c FORCE
 quiet_cmd_exports = EXPORTS $@
       cmd_exports = \
 	$(NM) -p --defined-only $< \
-		| awk '/ (T|R|D) / {printf "EXPORT_SYMBOL_RUST_GPL(%s);\n",$$3}' > $@
+		| awk '/ (T|R|D|B) / {printf "EXPORT_SYMBOL_RUST_GPL(%s);\n",$$3}' > $@
 
 $(obj)/exports_core_generated.h: $(obj)/core.o FORCE
 	$(call if_changed,exports)
-- 
2.43.0



