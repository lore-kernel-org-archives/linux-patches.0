Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063594;
	b=FKhForBpXGzKldpG46EuutUMAPxyu15YtC56+b2BhIiuFr9s/UfALObH1ryVO1HBI9q6
	 Xv4qRZ604kVhJhsQGd5EdyzBV/eYGY7diKFPJCC39DniqBdc+HYQJqP8UKlBMiDGhIomh
	 0429GZTzfgLSUg6zLm99mwZC610Ii9Ci2GFbTJ1PALVmOsjO2jk+gXLhNsNePnwQa+Kpt
	 ID290hMKGtqjYpG4K/Rl8Dgc7E0OvNzRxS2X/9jdwRKKc3Vt+SmQSQonoxBsPOolp7jMZ
	 lVm6cEoyWIrbEcYLV9kSPfg35zQ67fJ/JyBgdbsFv3HRYsYXkOyVGE6xIpaGDXvy/1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MfhvwBWnhfuBUs6g+bzS6jvdOE4NsEfdDTJMYiE0YrA=;
	b=ESyiGlTvuMfQwAwzSgce7zp3Nq4wWyO/qP5IgqVmYtHhdAqAWmsE3R8/C0XZ3FFfaIEo
	 TNQU2jsi3QpX5zkAXjYDSGTav6rmRFe9QnA1bxr5L892vcbOUrE0LaUxDLM9Q34iDalms
	 ak1KAknqfyjIClLaq5XZLoDJ3ctJMfFj0pjp4PdnNA6/gDi2wWJ1dwS4QA1G3NnAv7dHI
	 ABvm0dfslHnK4WBknFTnuutCjWyClU93ctvQdWweceSR7ReNyJIxDmDzhoDrPktbKZ9er
	 yVnPys6zl4VChvBMjIkIyZMUAC2XMuGhli0zZkZbPhDilOLPckxItpJOqy4sMrSkXNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cUm+F4DX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B698606D826;
	Sat,  7 Nov 2026 14:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cUm+F4DX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C876B1F008A5;
	Sat,  7 Nov 2026 14:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063594;
	bh=MfhvwBWnhfuBUs6g+bzS6jvdOE4NsEfdDTJMYiE0YrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUm+F4DXdEvP4dvE508zYOAI3OqJVFthQs1cCrwee56FUbfdIcf5t4AHmPbt2W9bq
	 Z0RGyUK5GzHWoOVJTlVuR3e06f+63Vy3SanfmFcHPfH8bb9w8YBmajbewwgkwoXP7F
	 i24yKr4Aqf4zlrUxL8UrLOV4VlrTZJyI5fnLTaDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 719/869] tpm: fix zero-length read discarding the pending response
Date: Sat,  7 Nov 2026 08:56:41 -0500
Message-ID: <20261107134917.217359672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f2a5e09257ddd..a856b4ddbdc2c 100644
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



