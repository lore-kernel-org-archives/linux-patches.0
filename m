Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA138152179;
	Tue, 23 Jul 2024 11:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721735551; cv=none; b=XtEPOrrHmCaxfcxsVXj6SrZlNpEfQb8x1HInWZ+65X3qlES9L4Th6eiPiqePpnAenLQliONY4fYDOrMnkTdXwKjT2GrWNjE1f50NI/IwwnAHrsOrvNzUYk0POHojHAOW/cMIxce+azmYj4ysXvNfMBrAUSgFSqveIAUGE/AIjA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721735551; c=relaxed/simple;
	bh=G0CebsfWLIqYG1o71uPfB4w0UIAw5AvfpZWeNpSPP6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCGrm1NqnZDnyqMn44E0nihh/rjqptzMqoNAxF0UyL8NEQIHH2w6xWCk+YN7BCiWMYt/TtzHJFrKZKVxl0REf5s1+JoOBh7JnnHdCmwoW+Py15z51vQ3lpqXJyeYuqRbZBaQa8dJF76EbcTS7U2zjjGZ5Y0PXo0vwimUeCjJS0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjgYvvlc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjgYvvlc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A95C4AF09;
	Tue, 23 Jul 2024 11:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721735550;
	bh=G0CebsfWLIqYG1o71uPfB4w0UIAw5AvfpZWeNpSPP6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjgYvvlctCLWKLIXF4ih1HjB1oSLx56DXk9VPF+xHqU39JiZcc6NZI2sQJMiWurjK
	 fcbcKUeGceUGcqMBDe4O8Cf9Kki/iSnP4kiRwp0WBSl+xiBGvGeI5K3eEBFn7FsY2S
	 sDqZd+zhNsUPmAuA0hmuUJHVpAgP0GZPlbXeNySM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Ge <gehao@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.10 7/9] tpm: Use auth only after NULL check in tpm_buf_check_hmac_response()
Date: Tue, 23 Jul 2024 13:52:01 +0200
Message-ID: <20240723114047.542651110@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723114047.281580960@linuxfoundation.org>
References: <20240723114047.281580960@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Ge <gehao@kylinos.cn>

commit 7dc357d343f134bf59815ff6098b93503ec8a23b upstream.

Dereference auth after NULL check in tpm_buf_check_hmac_response().
Otherwise, unless tpm2_sessions_init() was called, a call can cause NULL
dereference, when TCG_TPM2_HMAC is enabled.

[jarkko: adjusted the commit message.]
Cc: stable@vger.kernel.org # v6.10+
Fixes: 7ca110f2679b ("tpm: Address !chip->auth in tpm_buf_append_hmac_session*()")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-sessions.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
index 2281d55df545..d3521aadd43e 100644
--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -746,15 +746,16 @@ int tpm_buf_check_hmac_response(struct tpm_chip *chip, struct tpm_buf *buf,
 	struct tpm2_auth *auth = chip->auth;
 	off_t offset_s, offset_p;
 	u8 rphash[SHA256_DIGEST_SIZE];
-	u32 attrs;
+	u32 attrs, cc;
 	struct sha256_state sctx;
 	u16 tag = be16_to_cpu(head->tag);
-	u32 cc = be32_to_cpu(auth->ordinal);
 	int parm_len, len, i, handles;
 
 	if (!auth)
 		return rc;
 
+	cc = be32_to_cpu(auth->ordinal);
+
 	if (auth->session >= TPM_HEADER_SIZE) {
 		WARN(1, "tpm session not filled correctly\n");
 		goto out;
-- 
2.45.2



