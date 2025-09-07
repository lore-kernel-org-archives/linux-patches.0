Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF424126C02;
	Sun,  7 Sep 2025 20:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277973; cv=none; b=QF847BeSVVS9SvaQa90KRCfoeBgw76SkX2+zSk4X9s8BhUhThs/IndTV79g3sbZminHjWYKaAh7MsilWj/Y+phB8YuKjk1I1yHsLgbBbkh/nMfbX3HmyKN1y4BhHMh2ll9LABRkqKkgeRTorhx+uY3Vb9ZGnCJ9u98X9+iZ9LiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277973; c=relaxed/simple;
	bh=sm4rjEt2/cfk1rbL9MoMwt4cpLuKHfVgt9n7KiCWaMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SHr3puHLq8J3SWn53VdfbdZkAsJTxrrqhDHAgCZog3uN7ofdysXA/xmwb9Uc9WVxaGaREXGomDpGEtdAfdRzl3z1ZbV7HGmOLqbJYtQP789an5zKWyogocUobqqnTUtrCPvwA5AKQzSflA1ESe9Pl/q/pcxEwBSTIX6WHic650A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCkHfweh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCkHfweh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479B4C4CEF0;
	Sun,  7 Sep 2025 20:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277973;
	bh=sm4rjEt2/cfk1rbL9MoMwt4cpLuKHfVgt9n7KiCWaMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JCkHfweh5YZi2UkEhVaUnO84jZIfrY1qnXIQ+Ki2NQBiTk46z9/loaK0Dx3kZGWKL
	 4ukrlVO3qFizTpr1VRLexjMUZN39QgHoiDNB6Kmd2Rhuy40Hgrmk1sFG5GkwYbJAgK
	 /VJKwotfexIGLlS7+BMj4g2c02cKi5k28nkD0fMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Cyril Bur <cyrilbur@tenstorrent.com>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.16 181/183] riscv: Fix sparse warning in __get_user_error()
Date: Sun,  7 Sep 2025 22:00:08 +0200
Message-ID: <20250907195620.132449590@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

commit fef7ded169ed7e133612f90a032dc2af1ce19bef upstream.

We used to assign 0 to x without an appropriate cast which results in
sparse complaining when x is a pointer:

>> block/ioctl.c:72:39: sparse: sparse: Using plain integer as NULL pointer

So fix this by casting 0 to the correct type of x.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508062321.gHv4kvuY-lkp@intel.com/
Fixes: f6bff7827a48 ("riscv: uaccess: use 'asm_goto_output' for get_user()")
Cc: stable@vger.kernel.org
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Cyril Bur <cyrilbur@tenstorrent.com>
Link: https://lore.kernel.org/r/20250903-dev-alex-sparse_warnings_v1-v1-1-7e6350beb700@rivosinc.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
index 22e3f52a763d..551e7490737e 100644
--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -209,7 +209,7 @@ do {									\
 		err = 0;						\
 		break;							\
 __gu_failed:								\
-		x = 0;							\
+		x = (__typeof__(x))0;					\
 		err = -EFAULT;						\
 } while (0)
 
-- 
2.51.0



