Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816037E110;
	Tue, 29 Apr 2025 17:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946343; cv=none; b=TxW9deVv2kp6WYfIE6odaztXzg6e6aGe5y7FTHarpm6DgnGczBlcFyqJXm2S78tk4OnmeuhLiuH739ydsq4JfNpbwG6/j+FHX4WAJtNNmsgeTSD1TBnho5ae8cyZ4RGjterRbQXxn0vD44QfoZx2xKiYjg0ntReSLiG0fTNr5ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946343; c=relaxed/simple;
	bh=IPwAIzpCqiuzae+lF1XqVMKdw3VOyP3AHVEqb4OAVCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KjPSoHdh8zlXJKAw+vZu0TLvefcxioNI+VVPKNjUdTOulMVMdpe/LuzUVNN3fBGw8s6rzDrmJsi8dCMd+6DlV9D6tNeWBwLMpNlWvKW1JjkdvVSihFVg8+06TNRZBAUQeOn5/RpCXJxD9iwPZPLPCx76jjvkEacrognMdxwUvpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3reGn59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3reGn59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36B1C4CEE3;
	Tue, 29 Apr 2025 17:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946343;
	bh=IPwAIzpCqiuzae+lF1XqVMKdw3VOyP3AHVEqb4OAVCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3reGn59XzMtWbx1X0Um0c021pHSOU2ff3Blix4Mga8zwDYY0k+JfirmVG9vWamEy
	 De0XevRKhf2rjeG1eYuAQ/vgtdIhRy/BeNewOmjrCE8i9uOBlb76ZJnlM/R+TGzgc7
	 +ng50FFCNgQ1xzaeB5lkNMtAulKL9vUwTljSK96c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Gary Guo <gary@garyguo.net>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 235/311] kbuild, rust: use -fremap-path-prefix to make paths relative
Date: Tue, 29 Apr 2025 18:41:12 +0200
Message-ID: <20250429161130.652802824@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit dbdffaf50ff9cee3259a7cef8a7bd9e0f0ba9f13 ]

Remap source path prefixes in all output, including compiler
diagnostics, debug information, macro expansions, etc.
This removes a few absolute paths from the binary and also makes it
possible to use core::panic::Location properly.

Equivalent to the same configuration done for C sources in
commit 1d3730f0012f ("kbuild: support -fmacro-prefix-map for external
modules") and commit a73619a845d5 ("kbuild: use -fmacro-prefix-map to
make __FILE__ a relative path").

Link: https://doc.rust-lang.org/rustc/command-line-arguments.html#--remap-path-prefix-remap-source-names-in-output
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Tested-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 0c1b99da2c1f2..65663244e2d5c 100644
--- a/Makefile
+++ b/Makefile
@@ -1070,6 +1070,7 @@ KBUILD_CFLAGS += -fno-builtin-wcslen
 # change __FILE__ to the relative path to the source directory
 ifdef building_out_of_srctree
 KBUILD_CPPFLAGS += $(call cc-option,-fmacro-prefix-map=$(srcroot)/=)
+KBUILD_RUSTFLAGS += --remap-path-prefix=$(srcroot)/=
 endif
 
 # include additional Makefiles when needed
-- 
2.39.5



