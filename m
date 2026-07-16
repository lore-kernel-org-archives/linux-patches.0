Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5D732ED24;
	Thu, 16 Jul 2026 13:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209619; cv=none; b=sNZy7Zbj4B7Yp8IHrhVOyFpUAcNnC+T4zIA8sxLxAYt4Cg2ZAohvpaU7lnW1eS5OMNMYMndOIVZ7q+rvTthhf4JucakjTJ21x6ECIaQxpLIMVA9pXeRxcfBosmPoW5mcDIc1Rp4ZKDzOZ0jNh2b7l6DHmmqG7g+vpswVgozH5VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209619; c=relaxed/simple;
	bh=GANpnAT/x5suSxbPJVtPUYI0/VktAgWtxyADv2rqcQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXNFoWRZiVrmJOSxn9jmivIThbeleqSRcRVeeh0G0ETlA4T+K++K57Y55CzVZOaBU2GR5WlufmbqIh5nH6c8rh56fSPH9K6VziBZUuGWvw/iwLHWP0Kh7jSUoPrG1eNTDIGsMyciTlEb4igfHd/no0cFGJ8gxloaHhLwb7/JmtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUWp800k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUWp800k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3551F00A3D;
	Thu, 16 Jul 2026 13:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209612;
	bh=L8FhVbNi8pgtkT3wf75wSsBh0JxzTYdDwCsvw4lwfFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hUWp800kQPXVuVU3NswqobcjLvpCnY5WtNjzidZH6N5DfhAVFfUX5X9Kb1QbTmdTg
	 S2bkW6Ys6Zd8kg7lrh33GLAFlZMx90xiLYvOwuIkgM1nzw+3Lqpy0hFjnqG3GmU41k
	 VB7FgrvDSIqKDteyH8MOUg3+zPjLkcXkS4jt1IUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dan Carpenter <error27@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 215/518] smb/client: Fix error code in smb2_aead_req_alloc()
Date: Thu, 16 Jul 2026 15:28:03 +0200
Message-ID: <20260716133052.520665805@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4359,11 +4359,13 @@ static void *smb2_aead_req_alloc(struct
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


