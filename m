Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDFC18B462;
	Tue, 10 Sep 2024 09:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962105; cv=none; b=dWPZz0Lz9sJ+4/PkVSAXzWjpakmH6W20xX0gr6GpX3geKy3rlPv7moIKYZNN+MiMLyHUrDEK/uCUkDIh4WU+SzYoOKny4EyrCMLEw5IkJO1/PESttJGj8fRH82JCfVfyMgS0DERbhSSL+PrcoyO1uU7CvhM0JolzQpx6/D2tamE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962105; c=relaxed/simple;
	bh=z65fNxK50n09+t/9JkDlmzzKHTxLHT4tynJS3Jb66Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5QidVXNULe3rmgFuzMKPhiAXR7MMxbSpu7+eEkN5rVZcSVU8Gq0HX9xurTiFMm4CGw6xVtsFQSO9+W1D/JNF+ZQDbcAO4X4cO7fhuSaA+g6FFvkKIcbuHKUMrGAcuKjblatGL4WZGLgrz+Eg+NTXU7pDH9OthmjdEUMDVKdnEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9pJ+HW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9pJ+HW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E71AC4CECD;
	Tue, 10 Sep 2024 09:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962104;
	bh=z65fNxK50n09+t/9JkDlmzzKHTxLHT4tynJS3Jb66Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9pJ+HW3gWRZOcfUyx3CdQ/PsLr3lQpjVvEgxylUCx75n7vqnyP6hlX6PUUeZmXuI
	 WbiJWy8z9okddkEzz9h7p5+xpbUDEm1P3qd89hZ8EBJ06MOrUz7wR3xshkac+jxnKO
	 B5JjeZl9hjnSDVuDW7tZSw516a7TT7wZBOK6TdFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sukrut Bellary <sukrut.bellary@linux.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.10 297/375] misc: fastrpc: Fix double free of buf in error path
Date: Tue, 10 Sep 2024 11:31:34 +0200
Message-ID: <20240910092632.536461518@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Sukrut Bellary <sukrut.bellary@linux.com>

commit e8c276d4dc0e19ee48385f74426aebc855b49aaf upstream.

smatch warning:
drivers/misc/fastrpc.c:1926 fastrpc_req_mmap() error: double free of 'buf'

In fastrpc_req_mmap() error path, the fastrpc buffer is freed in
fastrpc_req_munmap_impl() if unmap is successful.

But in the end, there is an unconditional call to fastrpc_buf_free().
So the above case triggers the double free of fastrpc buf.

Fixes: 72fa6f7820c4 ("misc: fastrpc: Rework fastrpc_req_munmap")
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Sukrut Bellary <sukrut.bellary@linux.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20240902141409.70371-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1912,7 +1912,8 @@ static int fastrpc_req_mmap(struct fastr
 				      &args[0]);
 	if (err) {
 		dev_err(dev, "mmap error (len 0x%08llx)\n", buf->size);
-		goto err_invoke;
+		fastrpc_buf_free(buf);
+		return err;
 	}
 
 	/* update the buffer to be able to deallocate the memory on the DSP */
@@ -1950,8 +1951,6 @@ static int fastrpc_req_mmap(struct fastr
 
 err_assign:
 	fastrpc_req_munmap_impl(fl, buf);
-err_invoke:
-	fastrpc_buf_free(buf);
 
 	return err;
 }


