Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E499142D740;
	Thu, 16 Jul 2026 14:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212004; cv=none; b=UMGk55XHEEct5gexC0W39jfBKLG9o9mCfG+qDaoqgLosl9d3WHJUaw1kOjTjbNqZg5DoxYvAQkcxFUx75d2Ow0OO1F7fvAuEXyik1+rg1Gg2An1ptrgu6zsc0JLjFEr7ppZ4EQA07ph+WVLhDEV1HpE1pitu7AaHQebXjXkPZmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212004; c=relaxed/simple;
	bh=uTrsc55MHd9vLUCcopgih+DkArxs6c2lFwYaiO7/O80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s0QCjs3ypNFMdg8krsVxRX/c32+8Ld7djhxrGjtE30La/TcPIDMD27Ne0KJLO+ycjX83NY4zbKm+VGQv498t24M6TGyzbJ5TXDMVCED+MhrzNYmd+aYCzimL0CbN6Pij7cbFVQVPenFXi926qHYUYp/jOndSE08Fzbzkd+wWC0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jC1qSWPw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jC1qSWPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DC91F000E9;
	Thu, 16 Jul 2026 14:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212002;
	bh=tcCIeOKlC6nNLpULaZQD8AibiikyGg715Qa5U6xXGtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jC1qSWPwv3VbY0wixAzSw65xV/JCjT3c9qWuO8bSva3eA2wAUqC7v0yqi1tEF5WM9
	 qtWkZGgOkpx0bJMgajs+u95831BV1FCSEqwm/RS8v9gxWaBGMPe7A4R1fK/WxTB82K
	 k2YiVYO30AE6moVxSFXEbb5M0Q0yrstGAERNNqr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dan Carpenter <error27@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 162/349] smb/client: Fix error code in smb2_aead_req_alloc()
Date: Thu, 16 Jul 2026 15:31:36 +0200
Message-ID: <20260716133037.006309316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

commit 61f28012e5650c619223decdb7970e0d3162e949 upstream.

The "*num_sgs" variable is a u32 so "ERR_PTR(*num_sgs)" doesn't work.
We would have to do something similar to the previous line where it's
cast to int and then long.  However, it's simpler to store the return in
an int ret variable.

This bug would eventually result in a crash when dereference the invalid
error pointer.

Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Cc: stable@kernel.org
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4253,11 +4253,13 @@ static void *smb2_aead_req_alloc(struct
 	unsigned int req_size = sizeof(**req) + crypto_aead_reqsize(tfm);
 	unsigned int iv_size = crypto_aead_ivsize(tfm);
 	unsigned int len;
+	int ret;
 	u8 *p;
 
-	*num_sgs = cifs_get_num_sgs(rqst, num_rqst, sig);
-	if (IS_ERR_VALUE((long)(int)*num_sgs))
-		return ERR_PTR(*num_sgs);
+	ret = cifs_get_num_sgs(rqst, num_rqst, sig);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	*num_sgs = ret;
 
 	len = iv_size;
 	len += crypto_aead_alignmask(tfm) & ~(crypto_tfm_ctx_alignment() - 1);


