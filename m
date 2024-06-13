Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4BF4A07;
	Thu, 13 Jun 2024 12:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282071; cv=none; b=C60Yc/DHZkRj56yDwZGb7tvlUI0QQZv+8B3zNqCc5kOxjVmpqqGr/vkaiQV15YZhERS/noQRPDA1a4frosdTKhgLobdqV4hRX9DPOjTSguH0FeaBd5XGXolacmz5KldyPpnYkKjN94JoXJ0sl05HbqcDeEpCWHF3tyPfLwgwiGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282071; c=relaxed/simple;
	bh=xTT1mBoVWyIXcX3yqpz/y1ajo+MRDKsgRbv8dYqQqO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaYDJB98id/9bALyz9FfES3mx5nL37A6/+yQ4y3oXLStJCggHgJAtAfH+xLnuez7T0QytKfzC0sRHTD56pJ06gZ/miL5tjMSIjo7NICrgFgWh/0Ouk0LhAC45eRLYvu0lgV6fRI7RKS7BMtj+qKLdH17Y9xQJQndfVf7k/kOSe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ba0FdUnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ba0FdUnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73980C2BBFC;
	Thu, 13 Jun 2024 12:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282070;
	bh=xTT1mBoVWyIXcX3yqpz/y1ajo+MRDKsgRbv8dYqQqO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ba0FdUnGzdgXbB/lJqYxX8zWvJa/SR08TSZkbSr90jKfDr6IwPt7wGPI43g4tWlQ/
	 v+6S0X1E0drXT2y3VlS2fErzhx4N9HfpxL6iO8nMWgGZ+brtiLuduwC11hDRRnkSfT
	 hZdJ+UfqY6LZItpApruQLJCxkxWpfSCuwvIfSJQw=
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
Subject: [PATCH 5.15 121/402] printk: Let no_printk() use _printk()
Date: Thu, 13 Jun 2024 13:31:18 +0200
Message-ID: <20240613113306.854795726@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9497f6b983399..c4fb84822111d 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -129,7 +129,7 @@ struct va_format {
 #define no_printk(fmt, ...)				\
 ({							\
 	if (0)						\
-		printk(fmt, ##__VA_ARGS__);		\
+		_printk(fmt, ##__VA_ARGS__);		\
 	0;						\
 })
 
-- 
2.43.0



