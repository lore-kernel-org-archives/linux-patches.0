Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045733;
	b=pCxVDpfTisNdKwh7y1pts17Eb5LDOU59PPwnswAVXhTwjE2qAzpuzvTuRaySjw0uAJkZ
	 GWjwhIOvFLNphC0VaQ4rbOUv07pu/nyVdz0daLJw41D55VT4zoZIM1LZCffJegduXHB2S
	 wsu+DHkFTg3gAn4AbRZlvx8VvJ72h0AH0UD5tKxhRN0S8zalYg+BzjSx4KQZ4yFxoa1ho
	 JeBZPz5bdrJGreF7T3TGQpbYD0UHQ/Lq0io6Y28jxpwFUK0n5HkDjebmSwCDGOURC4h79
	 rraSbmpUfmIwQ8sDZuK0Dx+xLrCy6z2IE8GFJifQwZH/eLDULqgqhPVbTww18xnRRcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9NUsnpy/wKD3P+yFboxiHq2lnnt6rj8cjKloTpeOPbo=;
	b=PdSGizL0LHX3DNoLlH36EZK0xHdwcV3MLoIZl64a99ROuOMqPuzCi1ZfxeheS2J1X+Fn
	 UVCBSvTdv1Eri8cBWk+YJSk4WoB/u47r4/+pZHM9o3U3bQ2NUNpgKSuvZ3nROrgenbcNO
	 vrC6a7UEtzUmOWhpSxc5CMO5GbsPBwp4AQ39MeCFLLZHcuEPZBVGLorBslFE7eMztaK7/
	 kwAnak4ObhfS+gg8VWqq+sObI4HScEcbIk9sHP04eM0UQl+lGye0QwlceukbTGQTjvW/p
	 dP9cD+V1PMivIs0fEDtbStjDyDt/B4HBpxdM34LxuM11Wt84Bu8Cf4moJftTLShq+2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0806VhWn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D4E606A31C;
	Wed, 18 Nov 2026 23:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0806VhWn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82221F000C4;
	Wed, 18 Nov 2026 23:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045733;
	bh=9NUsnpy/wKD3P+yFboxiHq2lnnt6rj8cjKloTpeOPbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0806VhWn3Y0W4dtieViKOZcvdGDV1CDLAf9mN2PQm7mitKC3RItuSgQumdeRfirg0
	 +DdYlwZVkTn7cvCGAj9Q2pF3WNUJCyddgoGIbyKwy7WihTIHQLgUjDpDIp4KjFdQiH
	 J5PuZ1V2tP5+2Tq+/R9czMsF7IZvkXwUqP09taVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1027/2857] tpm: fix zero-length read discarding the pending response
Date: Wed, 18 Nov 2026 15:34:21 +0100
Message-ID: <20261118150238.578099920@linuxfoundation.org>
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
index c3fbbf4d3db79..ff86a1fdb5cdc 100644
--- a/drivers/char/tpm/tpm-dev-common.c
+++ b/drivers/char/tpm/tpm-dev-common.c
@@ -131,6 +131,9 @@ ssize_t tpm_common_read(struct file *file, char __user *buf,
 	ssize_t ret_size = 0;
 	int rc;
 
+	if (!size)
+		return 0;
+
 	mutex_lock(&priv->buffer_mutex);
 
 	if (priv->response_length) {
-- 
2.53.0



