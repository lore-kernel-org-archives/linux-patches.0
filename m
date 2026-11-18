Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036966;
	b=hmUMIAUhL2U+i3NAyZTwnv5rqjvLSJtOS9iAaWccPIhY1U7dq+ivp7Zmbsn3/EHjqP9A
	 pD65dHrCTZj0hRkN3Zy6aamf7q7xARRX1xka8WwR3AuE27Qv3lcJbPyJn2ZIiWgwvPURi
	 Wie7jpK4yI1pbsrY2PWKi/YQZ1qj0r/2vnWLIUif9mSdVEO9Ih/rgP0fGQRUnQwuXLx5x
	 MwWpNo5bgy38RohQwVuIMaebU3DfNqzrwyIU6TAtVSdjbCvVO0szw/9k55B+PmdvQrNLB
	 qt0ajlowgfsff5UVHhC/3e3bZNKusBNR33xJVqINptYgEcH7lj53UE1XQ/58T9k4o8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y/VpvmfD+od6S0OyEP+H4W3BAf0OuYrZji9XaMZVi0Q=;
	b=cQBJ8Kw+wR+hPqp8ouAk2M3IT0cttJ2X8KyGXuSzb2lfXjl9bOMobFPhJU+YqnGc/OXN
	 JVPzGkO6Q8U7cFj9L3/R8Cq3vut9BhRSwM2sq4+08rKTQqO+StesKEJ9A7X9qtWAsgXNu
	 x48GZJoOcMWLsrELcwZ3FU4kgjCY3l0I/iNsRPjyw4g4a/qmBrjjYbh9xL6LWF8Ai8lYM
	 9zgfCVcPF9OIj3aVnl1i7VHoVVzOD4n1XdVEtfRidStvByiKD6QM0VyH3nDde8aHr9nD+
	 MoiM0e+kQTPEGUJNyF7hrNDxQSdVrTTp7zq7+WRnqKMUuRlN9jmD4tShjx8RBBtThSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tzapHscv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F905606A320;
	Wed, 18 Nov 2026 21:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tzapHscv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D7B1F000C8;
	Wed, 18 Nov 2026 21:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036965;
	bh=y/VpvmfD+od6S0OyEP+H4W3BAf0OuYrZji9XaMZVi0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tzapHscvxy9RsscgDUQDQIrjcdjM3k7LKLkYyr3qN5BKEcBS+nAeKgGUdQy1o3YJc
	 2b0nn4pDULlN1XNOT7MA+AllRHKGTewPaBpyLyYj9wRa9KP0dMVr47O5IKo9v1VYz+
	 bvbKahcTTcM9pZMgmiFZD9/ODhz/DLmpPOA0KYsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1203/3318] tpm: fix zero-length read discarding the pending response
Date: Wed, 18 Nov 2026 15:30:25 +0100
Message-ID: <20261118150356.261435513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



