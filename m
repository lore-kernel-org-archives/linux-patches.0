Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062528;
	b=fbnE9FJk5EynFnyLaZvqVQD3ticCQFC5PgWKSidhcqlAN5Nu+RidBdqGD32wWHx3Oay/
	 1otab+CWm08lTbjjsshEUjMxLcl8B/qV4l01gUC8xWRLnXnQdH+Jms6xsbvjgZLR75DhX
	 VPSbp3J+LxL/jKsL9UqEDZAi8e/fToH6wVYMxDOvo/71l79NvdmqqcEfebt3vEkc2sFpB
	 UK92DDZmtC71tQwsvB8E9pJQmA9Pe1gHJ7XIUEkoL6192ZxysXTUx7FsiMy47PPyDt8zR
	 AMCwQ3+vJOmokXH1LAsZRTAOgLD8DNsfQSW6K5dBTyo3TVYZ2ybRLDQpP93yU/pGM5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o0OGux6q7meN3RiHw5QBeSUHlSSeYyBEdW0VHIwYpuA=;
	b=JIFVlajhcBCR70389a5ZFDOgNXSszCfa6jl32NTchPJuTVYpzTDodxSkU06y6bIdfypY
	 z0Li6KLKvYYeRu9bWZivTv0SQRAZd9Vd7MutpZEfY6zW6uV9vTSF0k8Ja/Hyzjibul92D
	 8zkbVOJgoSQk5edrirAs0AxkQcAoXErQ/8PsqMsSeVZvIuSxOhubcHuLTlcC7lXV25TQZ
	 DhknFvEbWijclTosBiCSMPZ1w5pk3x1RASmD0MVacSyDlEC/1anI5JCfQI8/oN1C7TMwP
	 Szcp658wNrU25Y4Srm4eqvX9WTzseQDlBo4dNomItpJqq/kMtobsAQ4IBk29WCesMYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V667FF4U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10346606D80F;
	Sat,  7 Nov 2026 14:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V667FF4U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B130A1F0089F;
	Sat,  7 Nov 2026 14:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062527;
	bh=o0OGux6q7meN3RiHw5QBeSUHlSSeYyBEdW0VHIwYpuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V667FF4UUl+7J8wndPbcBohT9VkS19/tlsnbpO+BZJ8O5aqCEl5jm9XF3NZOJUQuw
	 9N+zHuNqycQ5/F4oixldKdCgBmeWn7mKJl7MDy9Zog2lhKBeJuZppN7AZ8h8gksV53
	 q+0S+2X5Arghl0KGLpd36kEXqbsdzTXKkjol+TUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1420/1536] tpm: fix zero-length read discarding the pending response
Date: Sat,  7 Nov 2026 08:57:16 -0500
Message-ID: <20261107135037.711969459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 48ff87444f851..1bfdcb9794e20 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -134,6 +134,9 @@ ssize_t tpm_common_read(struct file *file, char __user *buf,
 	ssize_t ret_size = 0;
 	int rc;
 
+	if (!size)
+		return 0;
+
 	mutex_lock(&priv->buffer_mutex);
 
 	if (priv->response_length) {
-- 
2.53.0



