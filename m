Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBDF256C88;
	Tue, 11 Nov 2025 00:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822725; cv=none; b=GdV1osFYqSSCQl3sAiwUU9W0AAVC7YbM6bCcgnSP7PC38N+SZLX31B7a7kAEER2oN+CgDQ6gJnLvEaRa6ha3D6UmTWXqCxG4dJfP0Zr12k1TXcS+FMUE1sA25uF7hPEB/DuOZz8YAEMEKzXGFYSQlG9OZpPzy8FGeGQseEy2rn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822725; c=relaxed/simple;
	bh=HWoEmaM29Esw0d5OE5wgfsQO1YXc7U6Z80GRmwlKgto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QrxquIvGr2SOicOMQ921Ois1fUDkU/6NqOHcKOl8Gm9ykTj2q2/Qof+YUE8YxqOip0Imijli+lWXG9HTBY3SvaaLRzgacjjBDogA0JUPSzoAEZUXsM2K8hm8+J3qfcuRhPdQfAg2Hp+lVHWMS5O2BF6rcIdbA9OLg5hRnj2snCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JMDdEimQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JMDdEimQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D856C113D0;
	Tue, 11 Nov 2025 00:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822724;
	bh=HWoEmaM29Esw0d5OE5wgfsQO1YXc7U6Z80GRmwlKgto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JMDdEimQ+WcDuSuj7AIX/tg89hF6sr1dMcBthvMRPgxTFfAoj3LgiyDmurNMjvtyN
	 TKkdhvq8If7RdpEe4ZQXu32pK4U8/Ju9sRLi0qVi0poyfLCqhVYVkLskxUIgd4rFxQ
	 yqBdZrxBojRXHkTwYJMrKnIUcMiPl+Dr6JeJ9org=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/565] bpf: Dont use %pK through printk
Date: Tue, 11 Nov 2025 09:39:09 +0900
Message-ID: <20251111004529.054588068@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 2caa6b88e0ba0231fb4ff0ba8e73cedd5fb81fc8 ]

In the past %pK was preferable to %p as it would not leak raw pointer
values into the kernel log.
Since commit ad67b74d2469 ("printk: hash addresses printed with %p")
the regular %p has been improved to avoid this issue.
Furthermore, restricted pointers ("%pK") were never meant to be used
through printk(). They can still unintentionally leak raw pointers or
acquire sleeping locks in atomic contexts.

Switch to the regular pointer formatting which is safer and
easier to reason about.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250811-restricted-pointers-bpf-v1-1-a1d7cc3cb9e7@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/filter.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 0477254bc2d30..aef18f0e9450e 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1263,7 +1263,7 @@ void bpf_jit_prog_release_other(struct bpf_prog *fp, struct bpf_prog *fp_other);
 static inline void bpf_jit_dump(unsigned int flen, unsigned int proglen,
 				u32 pass, void *image)
 {
-	pr_err("flen=%u proglen=%u pass=%u image=%pK from=%s pid=%d\n", flen,
+	pr_err("flen=%u proglen=%u pass=%u image=%p from=%s pid=%d\n", flen,
 	       proglen, pass, image, current->comm, task_pid_nr(current));
 
 	if (image)
-- 
2.51.0



