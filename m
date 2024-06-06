Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E240E198824;
	Thu,  6 Jun 2024 14:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683333; cv=none; b=Uidw7A34WBT3UEFUtjJDujNaZTZUSpFwNQM4cfieU58uLpP9/1jJ16qpTsw02VnxHFljbDd6kC8A0DR+YGJBM0l7JGTLPpu06yR9C9izqPQ0UI2dZMzLRj0yUZcW9SnfGstIlPFa29I25XSutEZiut9hm9OjN9ZV7xi7y2WsILc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683333; c=relaxed/simple;
	bh=Uf5L1MXArgCJ09hjzaY+3bfAS/ZQTnKpMOy+Ff8IXNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldpxmnuOXPMMmGNDhRIuy1AvR86yjS4UIJ3pIiPZcwTAihAcUdXc0zm+i6d2c2OAf9mJOgU/hfw53LP1/HN53CG/uMM7cequp8T6EYYyrHlMs5xItlt0meUcch466+/cPmOglF0llaY7EVtAqlBq3LAGW9xIecc+gPjg2ajutEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6dfD+x2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6dfD+x2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2708C2BD10;
	Thu,  6 Jun 2024 14:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683332;
	bh=Uf5L1MXArgCJ09hjzaY+3bfAS/ZQTnKpMOy+Ff8IXNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6dfD+x2pgDxsB+bHSD2F9Uj4TIjEy7r56LxdOLyBL8MwIL+RILRI+1YPenUgoXLz
	 zLqIsnTfToU3lm4xnOqIS13P0JCaR7DKiExLvmz8Po+9qK/7cemtQ3Hq56i8UVV2gm
	 T1BU0Q+EDJvYkerzWx/BUPNLViAyCGpACDh/KGYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Xiubo Li <xiubli@redhat.com>,
	Chris Down <chris@chrisdown.name>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 274/744] printk: Let no_printk() use _printk()
Date: Thu,  6 Jun 2024 15:59:06 +0200
Message-ID: <20240606131741.171261151@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 8522f6b760ca588928eede740d5d69dd1e936b49 ]

When printk-indexing is enabled, each printk() invocation emits a
pi_entry structure, containing the format string and other information
related to its location in the kernel sources.  This is even true for
no_printk(): while the actual code to print the message is optimized out
by the compiler due to the always-false check, the pi_entry structure is
still emitted.

As the main purpose of no_printk() is to provide a helper to maintain
printf()-style format checking when debugging is disabled, this leads to
the inclusion in the index of lots of printk formats that cannot be
emitted by the current kernel.

Fix this by switching no_printk() from printk() to _printk().

This reduces the size of an arm64 defconfig kernel with
CONFIG_PRINTK_INDEX=y by 576 KiB.

Fixes: 337015573718b161 ("printk: Userspace format indexing support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/56cf92edccffea970e1f40a075334dd6cf5bb2a4.1709127473.git.geert+renesas@glider.be
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/printk.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 8ef499ab3c1ed..e4878bb58f663 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -126,7 +126,7 @@ struct va_format {
 #define no_printk(fmt, ...)				\
 ({							\
 	if (0)						\
-		printk(fmt, ##__VA_ARGS__);		\
+		_printk(fmt, ##__VA_ARGS__);		\
 	0;						\
 })
 
-- 
2.43.0



