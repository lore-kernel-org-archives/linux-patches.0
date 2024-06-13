Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF56147C98;
	Thu, 13 Jun 2024 12:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280080; cv=none; b=d4quC9q64nP7KW72gp5X6FcML0Vqsga8pzw1p1Bi7Hx56AaQ34Mkw91hOfXX/kdyvdYknGO4/7cjJgSiqhfvW6w24pJqAGWvurcg80X5kw2sRL7zaIpx36nshkgADqHligGF3lZ6dZLbEewf6cGlnUiYkUGgKcj28jc74gMefy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280080; c=relaxed/simple;
	bh=+YnxLzlUe82tkfq5r/zqX6oBoIISykDUaKuyD/hJhXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dE2XDc2UJnRGb0XLLb/MUz/oCp20de9X5S76/gt40abt2IJdIGz7RKJNlo/bgp7azNptWhD08WQs35nXZssg48zZdcA2FwW0o1cOQ1Qw+Qh/f1LajUZFE0RtmU8SlzEiTSc9OKNWNAgnmfrr1q//iSyyYBYAFZyGGFV9cYz9LZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFA+XTKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFA+XTKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED7BC2BBFC;
	Thu, 13 Jun 2024 12:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280080;
	bh=+YnxLzlUe82tkfq5r/zqX6oBoIISykDUaKuyD/hJhXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFA+XTKszN3gcaRWu5lS9Ka2IiAwlFrBt87soC64F46yut32RjmkaqHWng0gY2Rru
	 Qc5e1as5xkxIBqVS+xb+0roGWZzaFgliX+1gmVTC34M6301UA33jLuKvy9AhDO/15P
	 0LbUCMYoJ1HD4Y9wG43TwzjPK1JsCjq9Y3W9gfKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 136/202] x86/kconfig: Select ARCH_WANT_FRAME_POINTERS again when UNWINDER_FRAME_POINTER=y
Date: Thu, 13 Jun 2024 13:33:54 +0200
Message-ID: <20240613113233.009488534@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 66ee3636eddcc82ab82b539d08b85fb5ac1dff9b ]

It took me some time to understand the purpose of the tricky code at
the end of arch/x86/Kconfig.debug.

Without it, the following would be shown:

  WARNING: unmet direct dependencies detected for FRAME_POINTER

because

  81d387190039 ("x86/kconfig: Consolidate unwinders into multiple choice selection")

removed 'select ARCH_WANT_FRAME_POINTERS'.

The correct and more straightforward approach should have been to move
it where 'select FRAME_POINTER' is located.

Several architectures properly handle the conditional selection of
ARCH_WANT_FRAME_POINTERS. For example, 'config UNWINDER_FRAME_POINTER'
in arch/arm/Kconfig.debug.

Fixes: 81d387190039 ("x86/kconfig: Consolidate unwinders into multiple choice selection")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/20240204122003.53795-1-masahiroy@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig.debug | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index bf9cd83de7773..3abac9327b643 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -307,6 +307,7 @@ config UNWINDER_ORC
 
 config UNWINDER_FRAME_POINTER
 	bool "Frame pointer unwinder"
+	select ARCH_WANT_FRAME_POINTERS
 	select FRAME_POINTER
 	---help---
 	  This option enables the frame pointer unwinder for unwinding kernel
@@ -334,7 +335,3 @@ config UNWINDER_GUESS
 	  overhead.
 
 endchoice
-
-config FRAME_POINTER
-	depends on !UNWINDER_ORC && !UNWINDER_GUESS
-	bool
-- 
2.43.0



