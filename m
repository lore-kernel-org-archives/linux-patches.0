Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEA824113D;
	Tue, 11 Nov 2025 00:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822587; cv=none; b=nw58luq8CTZMkW57l+q58hI62RrJOWx6vvQ+vzpJT0Q09hIez8C61WM6ZOGamOAI9fU2IsLWFcHSLLNLSr52/xdHlIJcly6GAnH86SGo+zt2YJiIFWZ5SD4fwpb+FjZxZWsF8s8Dz07uThZ16TgM9CWY8MCBZLOwetQ5eyn0Mkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822587; c=relaxed/simple;
	bh=IAGS69NpOa2jkX+C59CLnNBlQYLEbp4hGyOySQUubkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ae6CthwByqkbb12hKyx72OlDnjUyKKEyi4+Hxq4sCvwSQQsKbU4PR2h0kbj9xhwqetuolK5x+JXevK1HWJhrPReGsqnxS9r3SsMmXnFzMGvDP/SYgG6Tzqfq+Tm9K78yfOKGe4UboeLMDi81MuFPjm+AWFg6v7X22bkZoqBXQE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXTR/ffS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXTR/ffS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F447C4AF09;
	Tue, 11 Nov 2025 00:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822587;
	bh=IAGS69NpOa2jkX+C59CLnNBlQYLEbp4hGyOySQUubkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zXTR/ffSY51wyqw4L1O+20SFXecSL2z/R0E8X3MOrT9Y4dLs9PTwSCtqjHfs8vjeJ
	 m163n1p2HM59CyzhBUzPIiRDMrzD8DmVBmfV3U4MDF01/0sbCfe/L3GOVbDRqzIKxk
	 GgFFO0QwpTd0QWS4kzcNz8KrlCLAKuxq2nX/9xu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 124/849] bpf: Dont use %pK through printk
Date: Tue, 11 Nov 2025 09:34:54 +0900
Message-ID: <20251111004539.396365941@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 1e7fd3ee759e0..52fecb7a1fe36 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1296,7 +1296,7 @@ void bpf_jit_prog_release_other(struct bpf_prog *fp, struct bpf_prog *fp_other);
 static inline void bpf_jit_dump(unsigned int flen, unsigned int proglen,
 				u32 pass, void *image)
 {
-	pr_err("flen=%u proglen=%u pass=%u image=%pK from=%s pid=%d\n", flen,
+	pr_err("flen=%u proglen=%u pass=%u image=%p from=%s pid=%d\n", flen,
 	       proglen, pass, image, current->comm, task_pid_nr(current));
 
 	if (image)
-- 
2.51.0



