Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047057;
	b=oKQKZTLGHeY/t+qgHOtk66srVMxmTQaewKpT+eEyFvNsFQEjCdI1lnSIIRT6BOQ9X52m
	 4N/7TeJhGhoD0IadolOTxkz+4fyd+Da0FE3d2w+Db7Yft1vWPXH1JXcF9HrotCNz6JTnL
	 1hjADD4XjRGsfTkw+uxG/s9O3l36kNwEBiuNs3q4OTR6lyuSGEfYGiWUiLBw/f0Y5QdLO
	 xB62pLgT2LRbdLXojZVbbMsn73icxjKows9a4U0MzIMCxCZ1CBnF3YdEuDXU5OLKScZaw
	 F3MonzjErUouxRXG+Bs2luIXBXY4FTF/jNYxMr9GuPfqmaVFnsptWSogcyAO3k3nUQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C2wfCPR3YZSzxuOKHcQDRzml9ibLKnsgjz2c9SKRM7c=;
	b=MIPnPSdOub4PH1Jv1xf2vFO8HP8UK+w7NLN3r/tVDPR4EDoloYNDa0zBItmv4BrwJV1+
	 RTXdmtBjSXxLqBvLaPl06VazL8MsV82zjIMuYrYT8GFe3c3JmzV9IfDOf4UFndgzbSOGB
	 tinZqH49RtEJ+59BjWDcDqVP6IoXgJi8F5zaDtWrezsxn4oGSK1lCxVzuxVU9YC8cER8a
	 Ns9ewaLAhk+0YXTIr3jd9QurvdPTSDLoJEntB1nErk67aq6K+Vq659TPwKnPr/rV7B0c7
	 ZvYTwN02nIeVrr0E4ZgxIWbJXUancVOnnt1yrz9ZRcjlVQnz6wQs2bTA4knt/3BmJhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sQYVFhpj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A78A606A334;
	Thu, 19 Nov 2026 00:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sQYVFhpj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B881F000C4;
	Thu, 19 Nov 2026 00:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047057;
	bh=C2wfCPR3YZSzxuOKHcQDRzml9ibLKnsgjz2c9SKRM7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sQYVFhpjOfc+KLzgZEr8Co34aHVATD4DYqq6OfsFoM6EI6WKadB0pms3igEXENuun
	 OZmJIiJIOKgrGZCgIqX2XzziLmYCJlnl7XjE/ieDCMNSC+0Hvsr8kmt2oaZCPyXIZK
	 TsOSNeKuOkZ7zB1IsxszEw9sPeNQUp9ctv1kPMNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Yiqi <yaoyiqi3@huawei.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1501/2857] fbcon: Retry rotated font allocation after failure
Date: Wed, 18 Nov 2026 15:42:15 +0100
Message-ID: <20261118150255.382597406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Yiqi <yaoyiqi3@huawei.com>

[ Upstream commit 7935db1a4a0f83a63590a222500e5016e2f6c85e ]

fbcon_rotate_font() records the font, its geometry and the rotation in
par->rotated before calling font_data_rotate(). If the allocation
fails, the error path clears par->rotated.buf, but the recorded key
already looks up to date, so the next call takes the early-out and
never retries. The rotated putcs/cursor ops keep returning early on
the NULL buffer, and the console stays blank even after memory is
available again.

Also test par->rotated.buf in the early-out, so a failed allocation
is retried on the next call: at the next fbcon_switch(),
fbcon_modechanged() or font change.

Fixes: e4ef723d8975 ("fbcon: Avoid OOB font access if console rotation fails")
Cc: stable@vger.kernel.org
Signed-off-by: Yao Yiqi <yaoyiqi3@huawei.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
[ sashal: adapted the buffer check from par->rotated.buf to par->fontbuffer ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/core/fbcon_rotate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/core/fbcon_rotate.c b/drivers/video/fbdev/core/fbcon_rotate.c
index a3f507825eed8..3105682075c87 100644
--- a/drivers/video/fbdev/core/fbcon_rotate.c
+++ b/drivers/video/fbdev/core/fbcon_rotate.c
@@ -27,7 +27,8 @@ static int fbcon_rotate_font(struct fb_info *info, struct vc_data *vc)
 	u8 *dst;
 
 	if (vc->vc_font.data == par->fontdata &&
-	    par->p->con_rotate == par->cur_rotate)
+	    par->p->con_rotate == par->cur_rotate &&
+	    par->fontbuffer)
 		goto finished;
 
 	src = par->fontdata = vc->vc_font.data;
-- 
2.53.0



