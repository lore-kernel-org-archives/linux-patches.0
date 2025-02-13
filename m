Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5444426B0BC;
	Thu, 13 Feb 2025 14:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458644; cv=none; b=KKNdYDArt/5BOshnfptAiHcDC2coUANQI0wHGRvvEqO0uspKvCPIpMtMeAXD/BOZPc3nf0VsCGnnZMMNdWUqJRJEeQoye381rkd6f16FkM/AoJ5ctdOFLu2sfYS38RhIH8fzwfZ1/e28rcsGfxTKKWGA6aqzXNA01oqxeltbXzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458644; c=relaxed/simple;
	bh=9R4JYlMq7hj/LHNe8jxsDotkO4DyR28/+8gau7yJ7eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXxnOZxv0ZmaqPU7GKKvE97+xjhv7mLeIrgWHmvdMSSKeonZkuRJ6BP/V+upQlf1hV2Sh4XVe0iLBZNR2HJv88OYJWSMu3bo8LBVav6tJJ/a6j5QKyr/ygLT588Vg5Hhjp+UX56IPVNzYzFXxRNA4sJGFeR6lX2byJdVb6+to6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5nXUHIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5nXUHIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEEEC4CED1;
	Thu, 13 Feb 2025 14:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458644;
	bh=9R4JYlMq7hj/LHNe8jxsDotkO4DyR28/+8gau7yJ7eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5nXUHIKhs4EWVLkSfbirEtJs7kEg52sJrovwaZcMgGhEFmaWzm1/SALdAeE/BkM6
	 usSP/ns7HtQnzZjKxKhYrsjSljdrY91KBJiO8E3TjU7l39XtOFjjr4cFRPfpCti9tF
	 o9M2Dwr7aoxUPz7VcPVLY9+GBspJ2Qc87f2m+OIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 030/443] printk: Fix signed integer overflow when defining LOG_BUF_LEN_MAX
Date: Thu, 13 Feb 2025 15:23:15 +0100
Message-ID: <20250213142441.787453956@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit 3d6f83df8ff2d5de84b50377e4f0d45e25311c7a ]

Shifting 1 << 31 on a 32-bit int causes signed integer overflow, which
leads to undefined behavior. To prevent this, cast 1 to u32 before
performing the shift, ensuring well-defined behavior.

This change explicitly avoids any potential overflow by ensuring that
the shift occurs on an unsigned 32-bit integer.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Acked-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20240928113608.1438087-1-visitorckw@gmail.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index f446a06b4da8c..07668433644b8 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -523,7 +523,7 @@ static struct latched_seq clear_seq = {
 /* record buffer */
 #define LOG_ALIGN __alignof__(unsigned long)
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
-#define LOG_BUF_LEN_MAX (u32)(1 << 31)
+#define LOG_BUF_LEN_MAX ((u32)1 << 31)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
-- 
2.39.5



