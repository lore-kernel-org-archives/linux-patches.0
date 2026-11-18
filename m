Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058659;
	b=VEG4R2y3Nh2QQ2iq1GbuAay6q1ZIAVOWoLStsijvrDbxGsH0FGIw62C6RHzRPFfAu1ce
	 yleOmAfUp4rj5qV23Fqmd5l7fdjmYImEhWWqM7KbSENV5K2dvt2vgFEjaWUunvrbIRxGf
	 FGyhBzeR86KHU4Ng7Cb+CD8wb4c6xWd/9EvnDUokcFVMVirlETku5yORB+G3y3NFJjyBy
	 QCTX/oAbQUKukDJ8a7tYHoC1lLVtXE8KC5Wu1fcUDnaTfzuseoiaYv30uuxdtUlyE85ro
	 polltwtKJAptOC1wVaLRgjvpAJx2kmy0v0bdWMXJ1I1O+J6OLRzOCw9lEOdO6iDQtwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5zKaai8FkaMpdWfbIHYALjV9plTGErUkPx4vphgW2hI=;
	b=FHfr070IzBnrepyvK1Wuh5DOkjocxY6mrW5vm3QvfUzY71EyLtABGzr4mXFPzPzlLSUg
	 G9brPiVcy9fUy8RHvGCHt+lbDmxKSe+kGCrmZpVmDIT0Eu1whQuQkXH7mS3687cZ9IW1Q
	 KMwHV1TJoJa433Q+yE2JKgplr3U7C7oBaQkTsNA7xjdTp4rEY+6oQWzPg4+/bWYxY267t
	 SqCG7gNuLW6/AkiLH5m6No0s7iSOx0lXJH5fOaYoL0i/WFIHK3hmoXo1WQTJCEz2aa+SL
	 w3BaNxUWpQkGMtXYPx61msfGZGuWlreX1vlTAPUty1jMDpUX3ScY2JHuQStqACctRng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SP47/hQ+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFCA606A325;
	Thu, 19 Nov 2026 03:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SP47/hQ+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913B31F000C4;
	Thu, 19 Nov 2026 03:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058659;
	bh=5zKaai8FkaMpdWfbIHYALjV9plTGErUkPx4vphgW2hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SP47/hQ+9MJawpildNMcq7CKbSS5mJipZ354zoBfQbj5cH7ogTPzRV6seRy3ag0RJ
	 WFRQ6l2NV8u9suUXtyE8U8acbD0bEG9pIwYK9n5QIcVF0rN/Ww6mmJuKr5dHU24mZU
	 p5+n23vlA66FZXLi/59PTIFm9PxzO13T5f+qZAgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0563/1848] tpm: fix zero-length read discarding the pending response
Date: Wed, 18 Nov 2026 15:43:21 +0100
Message-ID: <20261118145938.536421618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 6fc1b05077b8ac7c3193616f0bc419f6185988c6 ]

POSIX requires that a read() with a count of zero returns zero and
has no other effects.  tpm_common_read() treats such a call as a
consumed response: it marks the pending response as read and drops
it, so the response can never be retrieved; subsequent reads return
zero and the next write() is allowed to overwrite the response
buffer, silently breaking the command/response pairing of the TPM
character devices.

Return early when the caller passes a zero count, leaving any
pending response untouched for the next read.  A zero-length read
will not report a deferred asynchronous error; POSIX permits read()
to skip error detection for a zero count.

Cc: stable@vger.kernel.org
Fixes: 9488585b21be ("tpm: add support for partial reads")
Assisted-by: GLM-5.3
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://lore.kernel.org/r/3f15140ab3c26e98b49d6aceaaa826585d56960b.1791015549.git.xiaopei01@kylinos.cn
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm-dev-common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
index fde81ecbd6a3b..012ff0b73aa53 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -132,6 +132,9 @@ ssize_t tpm_common_read(struct file *file, char __user *buf,
 	ssize_t ret_size = 0;
 	int rc;
 
+	if (!size)
+		return 0;
+
 	mutex_lock(&priv->buffer_mutex);
 
 	if (priv->response_length) {
-- 
2.53.0



