Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065339;
	b=QTm8OU4AHbyqdPSgDuNlITCKuTS5or/ondn2srnD+deq8iC5Mji9zR7Miy26RKbXzhQW
	 U6EkJoxBLQRbtp/21TCgH8z0HBY2rg2hRfpxrRobu4pdOoVbITOhN22k2v6V5Lgv5bGUV
	 zSiVMCzeI3K7Zn9Ti1AUbsGo4lUr26z6wlJ1XAfdk5taDPr3vZt2nNzeTQXSlJ+s/wz97
	 PjxJOtDgAjUd97NLjghiRro82l+pq2DjIyn4MDrfAQHZpoZ9vtoGr1jbw7tS1LomJJ0HU
	 BaAKCp1sXIK+TLsdlHl5DG2ZI81I/ixAdI4/tpuExvuSKB/4hC4440gWlPiadhzV6gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EdgXJJzddED8Sb7E67LMosd94JiEwn+pUv/3ouPTtmc=;
	b=WlbgbZQbfqR9wRLMnmkcJA3FFh8/NpFeZXbAhQY+mV2Dwz+kzG3W0F8VGNHdFmgAW2We
	 c4K4a5gJwOU/ju1p6MchhzdW+fP8zxM8pORDzdUciMpot0FbQA8akUyE/GW5/E8e+8DIV
	 k7VooFAk4U08h3Y3fTAzfEfEhl2ypfoTTqWR+o+vYasfIc1t/0334x7KHoiL0NwjwrbXR
	 cqSZcuygpt+mX6OCO9DKtJ6CAQdadkaxP79vqHsfl8DBp5eOAsFstbKIu3SLyYhVB3cPZ
	 DsuNdyrdmd5/KdYolFcGaim3hzmirvs1eN3VPPvhALdupWn2oNEmUuZux99ItKQhCug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pf4FmUkY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C17606A32C;
	Sat,  7 Nov 2026 15:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pf4FmUkY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D964C1F0089F;
	Sat,  7 Nov 2026 15:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065339;
	bh=EdgXJJzddED8Sb7E67LMosd94JiEwn+pUv/3ouPTtmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pf4FmUkY2nY9zFlPgx6Os1039g8/V7GiW6SGBtw7OBIF8PETRWHqzFHnoY9g0BlsG
	 8YBatYVtEnae6G083Ts50Kbv4w5WZ3L+NEGeycEv9rPxsGmbJ/REqUuXOe7b+7oDuK
	 KU7mDkm7qDGcB+nc3ZDiQ4Bqcah8QzJ5IB31qdzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1032/1257] tpm: fix zero-length read discarding the pending response
Date: Sat,  7 Nov 2026 08:55:28 -0500
Message-ID: <20261107135007.827164298@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f942c0c8e402f..6569212dc6b87 100644
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



