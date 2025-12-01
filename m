Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E9C30BB98;
	Mon,  1 Dec 2025 11:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588375; cv=none; b=vEeAz+D92f9qQ6aQQEcvIcoNi50fwSYgKlwD7fHc8xkjp3XpUyjYKiV1syFMdqU4xS5J3WPgZ+Qb3Pm5UYVCu26jvGjQ0ELYDDJWaqu9oxEgLdqLqgRWaiSxJkFQ5DobeXEq4s0EMFf65AMY0JozXOcvaoHxhL/gAMwRseRLVL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588375; c=relaxed/simple;
	bh=C5CQ8stVSPXsJHd6S7VFQJT6pg7eYlcrw9JICnzlLsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d7tTGOu39dsWipXnACVToxlV9ds6tvAGzUtATh278WifuX+pt9QfmeY7+/MuNv71ikxKuDBX1lx3hIbv8p7bEZFgkUjFzqXKmmwHh0WwD8ZKgh45OXlKA1Q3W68CS918aXZJLRGVNv+m1EAg94akfZKKWYBTn7jL5CGScF50hA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTvPg4sn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTvPg4sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA803C4CEF1;
	Mon,  1 Dec 2025 11:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588375;
	bh=C5CQ8stVSPXsJHd6S7VFQJT6pg7eYlcrw9JICnzlLsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LTvPg4snI9/LLrd5vV/+IODLd6zEJ5qy/q21sgLOfvbRk2QTINvv1NJX64wGuE0z4
	 5PutLyf49U9JVn1glKCrB4GUg82kCbbONfJm0zVrX3pbfwC9WgoOudowFril+ql31J
	 HmPqyyH8EEkaTmNMdD6xx6cOlmMWe5uHE77mKfow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/187] bpf: Dont use %pK through printk
Date: Mon,  1 Dec 2025 12:22:15 +0100
Message-ID: <20251201112242.236219935@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0bec300b2e516..41ec70a74b2e0 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -980,7 +980,7 @@ void bpf_jit_prog_release_other(struct bpf_prog *fp, struct bpf_prog *fp_other);
 static inline void bpf_jit_dump(unsigned int flen, unsigned int proglen,
 				u32 pass, void *image)
 {
-	pr_err("flen=%u proglen=%u pass=%u image=%pK from=%s pid=%d\n", flen,
+	pr_err("flen=%u proglen=%u pass=%u image=%p from=%s pid=%d\n", flen,
 	       proglen, pass, image, current->comm, task_pid_nr(current));
 
 	if (image)
-- 
2.51.0



