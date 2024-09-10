Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7762946444;
	Tue, 10 Sep 2024 10:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964612; cv=none; b=eyrbNtOPA9bN/hIWLHj8g2bTlzkWUnjznvHKKW27EQqt4oNM0AiJpyhiWWQ4WlpkOBeLfokmr2o8DcMBDOXLl6Fka/FN0wLTyAVClTPaTWACyFXZC0rG0EigIPeHgZy5mJ+NuIGRSLVyqo6w+qbJrZRCCaeFxIuI31njgRDstiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964612; c=relaxed/simple;
	bh=94Q2JhbVwxF9qCjaCnfM5YLKkQhuufqPKQxdyQoj4/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNrUZlpxLR9qIwlEvkHxL/kjmst3D/4Bv3p3MnONUrWPi6h68K6unZgDqUlZJmX1rBSmsPaCY9boFI+wnUAJ+f7aUWJSRZ/fe/AZIvd5B3fQmNnbHvPKkVCDpHva34+XzJ6dD0rTL0GW/nas8p9QvMnuhMK7g85GE4AUhmqhbOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcM6z1A5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcM6z1A5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E7DC4CEC3;
	Tue, 10 Sep 2024 10:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964612;
	bh=94Q2JhbVwxF9qCjaCnfM5YLKkQhuufqPKQxdyQoj4/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcM6z1A58Da9wFnORIHeeWMA3NvpB8vlCuWBisX9P4uoVHnjTCiDWYdvKKFC0vqgk
	 crE5ldGQMJtU9rLZB7+QcKSim2W996Lp/9na2olRgFjxbVW/eeE45bRRvkRjiTw/on
	 gch01VE8BG25UsGmaXOCgOZdQUo3IB6wkWF3tcOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sukrut Bellary <sukrut.bellary@linux.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 214/269] misc: fastrpc: Fix double free of buf in error path
Date: Tue, 10 Sep 2024 11:33:21 +0200
Message-ID: <20240910092615.632233411@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


