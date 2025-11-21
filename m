Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9C82343C0;
	Fri, 21 Nov 2025 13:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732345; cv=none; b=tGoaUuUAogYFg2hWGpZSB5TZ9fGVT67wOCBYdOz1dm91geymRiCLGSH7hrxN9Ih0LwesjoIzhL5Oif+ETtzz12mb2kuKQbMPmDAZ8XWxLyEBJUu90kRPC85+4tFYaQBxJd05ugiSlIpHHy3Bw48XqUTyvBYAEKHZU592JJVJL0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732345; c=relaxed/simple;
	bh=whHaE9iC4HOGy/2j56nuddr+E1Ht1ag2UwoQuP6ZylA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o64mWcAL95XaQBjaHkBygKpnn/3YI2dQR2PrEZ0VJWm8f4mYIJwlyOEflAR2sF1/lDLaXeAZ5ECA13JY8RZvoyR66gxo5KVXNLWrHvCrOf5CjaehcjFtwSPADCQ3UGbQscZXMtK3S9ZNwT9f/edhDLFknkOpU+QgyXAfSdrDXDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvEaHDXs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvEaHDXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FFCC4CEF1;
	Fri, 21 Nov 2025 13:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732344;
	bh=whHaE9iC4HOGy/2j56nuddr+E1Ht1ag2UwoQuP6ZylA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvEaHDXsXW/N22uebxr1hNx/mfAEKqyToDykPSwz76UKxQVUwTdzNslFw81EQqaXF
	 gGb8FvaZXs2TXmmqtrhwmloEGfptvOp6x3O/e3jaLhbeSidbspnTQNxmYQtbQziSYr
	 xQ0BC9eNZq8+K6mVLcvfHuNGfifYC4JYik1JOAlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/529] bpf: Dont use %pK through printk
Date: Fri, 21 Nov 2025 14:06:00 +0100
Message-ID: <20251121130233.193161120@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index adf65eacade06..4ffea87e6fb64 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1065,7 +1065,7 @@ void bpf_jit_prog_release_other(struct bpf_prog *fp, struct bpf_prog *fp_other);
 static inline void bpf_jit_dump(unsigned int flen, unsigned int proglen,
 				u32 pass, void *image)
 {
-	pr_err("flen=%u proglen=%u pass=%u image=%pK from=%s pid=%d\n", flen,
+	pr_err("flen=%u proglen=%u pass=%u image=%p from=%s pid=%d\n", flen,
 	       proglen, pass, image, current->comm, task_pid_nr(current));
 
 	if (image)
-- 
2.51.0



