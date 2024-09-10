Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB7D194145;
	Tue, 10 Sep 2024 10:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962910; cv=none; b=AJiCMCBR1AB3nB9AGBwNvOsfEq9jyggUsBcJVOrdVWNz/JmDne7S7OtrMEbBwHzEYAxC6AIXigMOQwlBvTsch/dpnq5WTAgP3RjLfIfHF8ytgoajndTbzQOcsp1i/lpNILVxVFSVYIhvymeeBF5l2vp9CZQolbxgUVHikaEjbx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962910; c=relaxed/simple;
	bh=EvJRA65rktbE4vZx6SbyoRsBRkvE3XUkB/xNzsUNAp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1/5LhWVd/ZLwjFZEnmmou4ogHt6H7qkvI8SzXpHF846PNbJV6OV7nh63FmP+CmbjMPfJ2QXiE/J1wo5WG7gmHPiRbvyqxMTksfsBai9X/dNyD8H2GUP+XHbHssKVF4P8pSYizpx8Hz5664egPfC7N+VpZBt0XXz89OFWxS2aGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/7W6G1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/7W6G1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B501C4CEC3;
	Tue, 10 Sep 2024 10:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962910;
	bh=EvJRA65rktbE4vZx6SbyoRsBRkvE3XUkB/xNzsUNAp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/7W6G1ll20BQpPSVCbyhxrPwwmds41RvpONjNSto4ilVOXDfAuPilPTnXrKkQ+eW
	 tqfZfw8o+uR7XyhqgrLG4aEbpy4dsisgsz0rbTFnkVzdyzv8hOKwztuThnewXfwi4L
	 VX5B6ng6ff9xWOUoojuoamU9uvkq2dqu16YfdHoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Maurer <mmaurer@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/192] rust: Use awk instead of recent xargs
Date: Tue, 10 Sep 2024 11:31:35 +0200
Message-ID: <20240910092600.922574703@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Maurer <mmaurer@google.com>

[ Upstream commit 45f97e6385cad6d0e48a27ddcd08793bb4d35851 ]

`awk` is already required by the kernel build, and the `xargs` feature
used in current Rust detection is not present in all `xargs` (notably,
toybox based xargs, used in the Android kernel build).

Signed-off-by: Matthew Maurer <mmaurer@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Link: https://lore.kernel.org/r/20230928205045.2375899-1-mmaurer@google.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Stable-dep-of: b8673d56935c ("rust: kbuild: fix export of bss symbols")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/Makefile | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/rust/Makefile b/rust/Makefile
index 6d0c0e9757f2..9321a4c83b71 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -303,9 +303,7 @@ $(obj)/bindings/bindings_helpers_generated.rs: $(src)/helpers.c FORCE
 quiet_cmd_exports = EXPORTS $@
       cmd_exports = \
 	$(NM) -p --defined-only $< \
-		| grep -E ' (T|R|D) ' | cut -d ' ' -f 3 \
-		| xargs -Isymbol \
-		echo 'EXPORT_SYMBOL_RUST_GPL(symbol);' > $@
+		| awk '/ (T|R|D) / {printf "EXPORT_SYMBOL_RUST_GPL(%s);\n",$$3}' > $@
 
 $(obj)/exports_core_generated.h: $(obj)/core.o FORCE
 	$(call if_changed,exports)
-- 
2.43.0



