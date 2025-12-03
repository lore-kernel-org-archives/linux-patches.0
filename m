Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B603F359709;
	Wed,  3 Dec 2025 16:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778891; cv=none; b=T6j9i+Z8t8mHf3Yc2iSI7ZLlBmZM3R3FvEesSYF8xdt287X9la/jr2DEcqhqZz7DQDKJcPn+axYIcrsBiKswYzbRcWDCe821et7Gb52diTt+x0iw3dQU/tXhTGM3pjXVMthPN1jlWI8Q5FRWQOWuWmL1iONzejQ06CG9b5dZ/jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778891; c=relaxed/simple;
	bh=ZL+KayJQr181NOUSbvmLuDjTdy1pNEYiGHFZ3f6A+EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uVErQ2cT3BF5CJgwjn2X7Asl+R9/Rejvh40XahTI4DNlsMgr9CzY0KMDT9NtD/d20mqvu94stOEeZI0jZoKJ7UG/CutQmSLIWnb5Lt2j6Gi+Qo03seg4MUyJmkGOfuHD8ajiowe3Ck8LKoFmvlWYMaZXlWqkbYc2QFSG2XV/K3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9DL7+MH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9DL7+MH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2504DC4CEF5;
	Wed,  3 Dec 2025 16:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778891;
	bh=ZL+KayJQr181NOUSbvmLuDjTdy1pNEYiGHFZ3f6A+EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9DL7+MHuGXBBEfLFIIQAqH8cAVXkj13r5K8ac9ipjlidj3HcZquElxF6yYTE7sym
	 u8BzXQ0RqjZmOHgmPUqwtUSLk5ms4glmonKMOSNi+57lavfRdvH5ra2Uw1WSzYHBiX
	 hBbCVN7AFDaKoMkZdjDhCMkrfCfz/lsz5BOdYCuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/568] bpf: Dont use %pK through printk
Date: Wed,  3 Dec 2025 16:21:33 +0100
Message-ID: <20251203152444.071177134@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f3ef1a8965bb2..bbdae97d50c42 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1082,7 +1082,7 @@ void bpf_jit_prog_release_other(struct bpf_prog *fp, struct bpf_prog *fp_other);
 static inline void bpf_jit_dump(unsigned int flen, unsigned int proglen,
 				u32 pass, void *image)
 {
-	pr_err("flen=%u proglen=%u pass=%u image=%pK from=%s pid=%d\n", flen,
+	pr_err("flen=%u proglen=%u pass=%u image=%p from=%s pid=%d\n", flen,
 	       proglen, pass, image, current->comm, task_pid_nr(current));
 
 	if (image)
-- 
2.51.0



