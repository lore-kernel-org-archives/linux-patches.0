Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB310D518;
	Mon, 27 May 2024 19:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836623; cv=none; b=pIxbyLbg4i/6Wibxi0YVuJQiEMwcdcVZD+WGN+3Ne90ORLNa7GjeHBNJyiea8ge8oKW0icUkC5E0ZKHi6xlYQziF5g0wm/JO5lTcTKNdXWL7KMTXwIt7qniGX5nTgXsG7CD7H7TjjMXGBypQG05puEHTtWMw89mxBlZFg1P00yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836623; c=relaxed/simple;
	bh=AUsG1/mhlk/fIc1Jo/4iv4cJnIobAEZJFPOnwBNpv+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Stc1NP+g3QWwVg824oTt33P3+5dTHLIkmAaVLTaQ2cj480g3h2iuXUOpIC7L0prhjSraZA13v5oYlF5228F+LAojd8UsWok5FMhI8EcrjLS8wq1ee5wf8CYnKcyBSeXpozdBquNDEroRujKfTZHXcKp1JqHwZ1igM+C9nXuEb6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fS5QzHnr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fS5QzHnr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16371C2BBFC;
	Mon, 27 May 2024 19:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836623;
	bh=AUsG1/mhlk/fIc1Jo/4iv4cJnIobAEZJFPOnwBNpv+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fS5QzHnrZl9KnmPow8LscreGBxEhyrDhI7sflvbF12PjaCr2LCK7ZWEAStAqXOIFR
	 iboEtwad5YbVNyT2D6rqQpLyUKYX9JTU69ZSVa2h0wguGWYzvHsFMWG8qmP1xqogIg
	 E1vBXfvE1edpz+017Bl+el2AtunTJugrb7nLvsNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 125/427] x86/microcode/AMD: Avoid -Wformat warning with clang-15
Date: Mon, 27 May 2024 20:52:52 +0200
Message-ID: <20240527185613.586051481@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9e11fc78e2df7a2649764413029441a0c897fb11 ]

Older versions of clang show a warning for amd.c after a fix for a gcc
warning:

  arch/x86/kernel/cpu/microcode/amd.c:478:47: error: format specifies type \
    'unsigned char' but the argument has type 'u16' (aka 'unsigned short') [-Werror,-Wformat]
                           "amd-ucode/microcode_amd_fam%02hhxh.bin", family);
                                                       ~~~~~~        ^~~~~~
                                                       %02hx

In clang-16 and higher, this warning is disabled by default, but clang-15 is
still supported, and it's trivial to avoid by adapting the types according
to the range of the passed data and the format string.

  [ bp: Massage commit message. ]

Fixes: 2e9064faccd1 ("x86/microcode/amd: Fix snprintf() format string warning in W=1 build")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240405204919.1003409-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 13b45b9c806da..620f0af713ca2 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -465,7 +465,7 @@ static bool early_apply_microcode(u32 cpuid_1_eax, u32 old_rev, void *ucode, siz
 	return !__apply_microcode_amd(mc);
 }
 
-static bool get_builtin_microcode(struct cpio_data *cp, unsigned int family)
+static bool get_builtin_microcode(struct cpio_data *cp, u8 family)
 {
 	char fw_name[36] = "amd-ucode/microcode_amd.bin";
 	struct firmware fw;
-- 
2.43.0



