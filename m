Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F032417E0;
	Wed,  4 Feb 2026 15:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218882; cv=none; b=azEpiIGGLIuC18bERbL8oeBb/fRbpwgnLeNyvpZSbHcSgH27LudnRlNnkXqppPjng4aa1U69zqWTEyfE66jPzv9EanEkLuKTQNmSunNqduOoaCmGKc1l/DjNQJWx7N7G6T5RIITbyg/7a+Ol4ptVY80D42ES/abjvjmzTJtVZ40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218882; c=relaxed/simple;
	bh=u1ArZm6J2hpQHIYTRMoMATHUNEzaN9pzp/h5Rv+sGCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uXmqzlgZBhqUjN5Ewl5beP4DGWEl+nTC/DNbjJQu0nN55r+8SRWnlqPDEF6kTM6rBMsuaNwCT2SifdanrpWb4+AmK7ryNu1mB4Suh0FJHzGly05TRJ7OdDm0GOE/ywZ1Qy1uMiYE3b02GtXLGidHYoWXLrDZf31ibrwKCgUXXb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOQ2vvPa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOQ2vvPa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77342C4CEF7;
	Wed,  4 Feb 2026 15:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218881;
	bh=u1ArZm6J2hpQHIYTRMoMATHUNEzaN9pzp/h5Rv+sGCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MOQ2vvPaJgfUnu6LtNBawrnvG9i0YXBa7TM9UoHWG4JpoEkFKxCc8jPu/hsDBmNZn
	 nj/+QmeJzuhhCTWS2cmR4/WxBPCz5FUtLVeppXFzevLAU0TgB39XsyIL2ciRq3wVfY
	 jPw+l7M0Vyl8SwzBqfJxS4P4KN1G7kVjOUbpk/Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 56/87] scripts: generate_rust_analyzer: remove sysroot assertion
Date: Wed,  4 Feb 2026 15:40:54 +0100
Message-ID: <20260204143848.934289751@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Onur Özkan <work@onurozkan.dev>

commit 1b83ef9f7ad4635c913b80ef5e718f95f48e85af upstream.

With nixpkgs's rustc, rust-src component is not bundled
with the compiler by default and is instead provided from
a separate store path, so this assumption does not hold.

The assertion assumes these paths are in the same location
which causes `make LLVM=1 rust-analyzer` to fail on NixOS.

Link: https://rust-for-linux.zulipchat.com/#narrow/stream/x/topic/x/near/565284250
Signed-off-by: Onur Özkan <work@onurozkan.dev>
Reviewed-by: Gary Guo <gary@garyguo.net>
Fixes: fe992163575b ("rust: Support latest version of `rust-analyzer`")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251224135343.32476-1-work@onurozkan.dev
[ Reworded title. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/generate_rust_analyzer.py |    3 ---
 1 file changed, 3 deletions(-)

--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -170,9 +170,6 @@ def main():
         level=logging.INFO if args.verbose else logging.WARNING
     )
 
-    # Making sure that the `sysroot` and `sysroot_src` belong to the same toolchain.
-    assert args.sysroot in args.sysroot_src.parents
-
     rust_project = {
         "crates": generate_crates(args.srctree, args.objtree, args.sysroot_src, args.exttree, args.cfgs, args.core_edition),
         "sysroot": str(args.sysroot),


