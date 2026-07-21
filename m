Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E702F3909A9;
	Tue, 21 Jul 2026 18:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658451; cv=none; b=AfgxDaOJhRux7fg1LW1KV+wkXokanDQ4zz/dmNlUmq+I9RKinpgiwkBdis5DvWix43uN3FJtDiibihyW334KJRe3bEWEyfnvMoLNmvaHEJD1yozpd0IC1ZLDDU+W/gG4NjH1LsbueZv7XT4dqs6xL3UvCSDliiAv/e7BB6RAS5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658451; c=relaxed/simple;
	bh=RrdZ+QNtJo6EQaS7+Byb4DTfihcGhvr+jPpSWW4K3ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfx55YKj8zwb0qgIznTNDoEFv9Jr/oubf/gnQbCwTJUqzfuRg3tVcyxeCOKkAQ8S03KSsyf2bxpAKtkf14hyg+M/6Qri5GQ1n3P71JxGpZucCrg1gZ0a0VCOEuS2dmB94oyB/gjQ5Ol26peiwFDxj+jtKjg51qnkT6E2MNvLalo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqhdCbOQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqhdCbOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2751F000E9;
	Tue, 21 Jul 2026 18:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658449;
	bh=266r5sj3dZ4bmDgf3gCmfOgK0uptW2FBSvNbnwoZ+Xc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QqhdCbOQqhj4h92ItBNn2wLQRuovKB/Kn7QYTRSp9Q6k+ZIEZ9pUKhWFZ6R4scO1Z
	 632m0ysMiLKB1/ycOQreGq9lqAMZAzdSLsjY7rJEAmh7NlSOKkqF+ikZluKbUgcU1A
	 UnOPNHZ44hZmzp7Km4hK0gz3r4j3EGtbOCKzju/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 1147/1611] fbdev: sm712: Fix operator precedence in big_swap macro
Date: Tue, 21 Jul 2026 17:21:03 +0200
Message-ID: <20260721152541.217985866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

commit 5dbe5b65df0b0c0ec77492427c274b7b5011890e upstream.

The big_swap(p) macro was intended to swap bytes within 16-bit halves
of a 32-bit value. However, because the bitwise shift operators (<<, >>)
have higher precedence than the bitwise AND operator (&), the original
code failed to perform any shifting on the masked bits.

For example, 'p & 0xff00ff00 >> 8' was evaluated as 'p &
(0xff00ff00 >> 8)', effectively neutralizing the intended swap.

Fix this by adding parentheses to ensure the bitwise AND is performed
before the shift, correctly implementing the byte swap logic.

Fixes: 1461d66728648 ("staging: sm7xxfb: merge sm712fb with fbdev")
Cc: stable@vger.kernel.org
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/sm712.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/sm712.h
+++ b/drivers/video/fbdev/sm712.h
@@ -101,7 +101,7 @@ struct modeinit {
 #define mmio_addr		0x00800000
 #define seqw17()		smtc_seqw(0x17, 0x30)
 #define big_pixel_depth(p, d)	{if (p == 24) {p = 32; d = 32; } }
-#define big_swap(p)		((p & 0xff00ff00 >> 8) | (p & 0x00ff00ff << 8))
+#define big_swap(p)		(((p & 0xff00ff00) >> 8) | ((p & 0x00ff00ff) << 8))
 #else
 #define pal_rgb(r, g, b, val)	val
 #define big_addr		0


