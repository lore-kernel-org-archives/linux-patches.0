Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0BD1A2C25;
	Wed,  3 Dec 2025 15:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775966; cv=none; b=k22d7pw2Wix5Va8pag/z/t4oCy9jAua5v93pMM64OoDIDY5AgFki/2Va/onE1kRBt+HAYInjv57B4pkaCDmgCElrug65SutvnkSiIXL0yz8jbgSaATbIVapU56r5ikBn5bJVkeUGTblgOtSOMccna1pKS9WqLrfQN4y20Nj9/oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775966; c=relaxed/simple;
	bh=dSloz84LHTy3tBotRlvLdzvXtst2isThSBQzaSSwfik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S80zsAccXKmsiAo6gAjuvIg0ORVXNTS2ghR6LktMTRcKhpVPWpIWPaZBgtsUpPCDWevwgTm0/oGjqhpZrAbzN7QiGL/FLyIqlwIizPPpB8s6ekcxcqMiXVsICheZKEoKno0dbqlu2ROsNFiE7LhUZQojznEZPKPxIwdGgDqLZik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVNy5cVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVNy5cVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF97C4CEF5;
	Wed,  3 Dec 2025 15:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775965;
	bh=dSloz84LHTy3tBotRlvLdzvXtst2isThSBQzaSSwfik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVNy5cVXs+OvKEers79Lq9Ws101qt0vyBIzu4yywYz1b7r/JTnso4KscxGqQvWoTf
	 DdxvipUdGpuo4djk1MzCq5a1RN5CsgNej0Kcj7Xg3TwDN9RQQwR0zBLlqyJ/lLWONr
	 8B9FtZWA35JmSb+14DxMuxRH8lnH+st9/ry/J1Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/300] bpf: Dont use %pK through printk
Date: Wed,  3 Dec 2025 16:24:05 +0100
Message-ID: <20251203152402.133766349@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e3aca0dc7d9c6..f97b0f1a4eab2 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1031,7 +1031,7 @@ void bpf_jit_prog_release_other(struct bpf_prog *fp, struct bpf_prog *fp_other);
 static inline void bpf_jit_dump(unsigned int flen, unsigned int proglen,
 				u32 pass, void *image)
 {
-	pr_err("flen=%u proglen=%u pass=%u image=%pK from=%s pid=%d\n", flen,
+	pr_err("flen=%u proglen=%u pass=%u image=%p from=%s pid=%d\n", flen,
 	       proglen, pass, image, current->comm, task_pid_nr(current));
 
 	if (image)
-- 
2.51.0



