Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E173D9029;
	Mon,  4 May 2026 14:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903307; cv=none; b=nyJ3sQk/m/iHvF68Ef6maPVk+ulX6yx8K4cLLS0fG9UXcF634Mg0Sg5NFIGlia6iWeqHACzcQqOwNZNmfbdR6TzduHKK5OEH/yNXP4Ez7t+Daif9kSc824ISAPtzzCft7lh04O5zsIpKWeVvBAn6wXRSz51XYzAO/6kTKz+1b0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903307; c=relaxed/simple;
	bh=ZhE26Jt8ExwUmyp1Tm4fUvQi9yTQiK3sDr6yvG/oJJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1AODdHGI3B4auaKxS3oQsmnHSpd2s/5KM06vtzH/fNrHXeXC4513Kf8vmgEVBVt2f2Rdw8OzGLQr1Kp/4bGctkMiWql77fUq+85zjLWmkGWZKSmQ3IFXBxL5i6jFupXa/XE3lFjC6K5f5O4ZVQApbLobDT/2cMCRZJ5xrlwH70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6nCJdDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6nCJdDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D1DC2BCC4;
	Mon,  4 May 2026 14:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903307;
	bh=ZhE26Jt8ExwUmyp1Tm4fUvQi9yTQiK3sDr6yvG/oJJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6nCJdDNOaFDnL34ZuMQ9agmMmJ9Wmaa5cb4Rw7NF9Q1os0MKW4CTske5Yat/0IFT
	 /0ImwCDjyD6u75GQhX8LGFPRWt3Zb4zhW/Bzi9Btk3LWtWRVj3C698S7nrdTZMYC7V
	 FEGSyW+UL/uZMEoJCL9FT/yY6KMzlmrez9pnyhwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gunnar Kudrjavets <gunnarku@amazon.com>,
	Justinien Bouron <jbouron@amazon.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 7.0 184/307] tpm2-sessions: Fix missing tpm_buf_destroy() in tpm2_read_public()
Date: Mon,  4 May 2026 15:51:09 +0200
Message-ID: <20260504135149.801648240@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gunnar Kudrjavets <gunnarku@amazon.com>

commit f0f75a3d98b7959a8677b6363e23190f3018636b upstream.

tpm2_read_public() calls tpm_buf_init() but fails to call
tpm_buf_destroy() on two exit paths, leaking a page allocation:

1. When name_size() returns an error (unrecognized hash algorithm),
   the function returns directly without destroying the buffer.

2. On the success path, the buffer is never destroyed before
   returning.

All other error paths in the function correctly call
tpm_buf_destroy() before returning.

Fix both by adding the missing tpm_buf_destroy() calls.

Cc: stable@vger.kernel.org # v6.19+
Fixes: bda1cbf73c6e ("tpm2-sessions: Fix tpm2_read_public range checks")
Signed-off-by: Gunnar Kudrjavets <gunnarku@amazon.com>
Reviewed-by: Justinien Bouron <jbouron@amazon.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-sessions.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm2-sessions.c
+++ b/drivers/char/tpm/tpm2-sessions.c
@@ -203,8 +203,10 @@ static int tpm2_read_public(struct tpm_c
 	rc = tpm_buf_read_u16(&buf, &offset);
 	name_size_alg = name_size(&buf.data[offset]);
 
-	if (name_size_alg < 0)
+	if (name_size_alg < 0) {
+		tpm_buf_destroy(&buf);
 		return name_size_alg;
+	}
 
 	if (rc != name_size_alg) {
 		tpm_buf_destroy(&buf);
@@ -217,6 +219,7 @@ static int tpm2_read_public(struct tpm_c
 	}
 
 	memcpy(name, &buf.data[offset], rc);
+	tpm_buf_destroy(&buf);
 	return name_size_alg;
 }
 #endif /* CONFIG_TCG_TPM2_HMAC */


