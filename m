Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613DA469851;
	Tue, 25 Aug 2026 13:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666072; cv=none; b=JiwspWa+138kuQjt053kqpK//erDldBSbRNMR4aOYByEOqpmEniQtR4P6Y27NrJcLVrYeM8jHRcv8lbTss3+PAHD2AG+1oKcYWJfS6vDd4P+Yyymp7emX3TSOKR3reYzWfU43Slyb2y5ksK7knPWvvP6XrhFVWV8pHEIA2UUtZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666072; c=relaxed/simple;
	bh=uWcrCS7ssFE2E1AMcMm1JSFTwCJRVmJ2gr262aR1UgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsDIP+SSE5sxaDfKk5dlNHZMJU0avQInH23cWD+xGZdwAd2q91ifu8UUm8eKUqMSrRoyI+JY3lWF90KPPbP3MSAPceoiYhjLwn4GGl/DUMTxDLd9T7mpNgCQr8ittWwzymRJPvmVJGOSEkhkX8BF5/cFZt9HS+C3wJ2v0tAlwTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4tFxlPR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4tFxlPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B657D1F000E9;
	Tue, 25 Aug 2026 13:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666071;
	bh=KvQo0x+TCQUaYJqJgROn38cdWExpfj7En/+COIFMUws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B4tFxlPRsE1DeJrd065lB9bmkRa6Izeg1o3epgkFaXAC4oSwvZAoTFiDXf4pJnewK
	 8uvqqmixK89/g1vQ6n0wiBncNYFKsDDnSpc5p1c9CSDElvQNKVbq2EUPjXaF4i7MtP
	 tZpb6TqYtzWVcaDtIQNhor46Bd7HnhATmJHI/4pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sukrut Bellary <sukrut.bellary@linux.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 74/79] misc: fastrpc: Fix double free of buf in error path
Date: Tue, 25 Aug 2026 15:26:54 +0200
Message-ID: <20260825132544.571748244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1774,7 +1774,8 @@ static int fastrpc_req_mmap(struct fastr
 				      &args[0]);
 	if (err) {
 		dev_err(dev, "mmap error (len 0x%08llx)\n", buf->size);
-		goto err_invoke;
+		fastrpc_buf_free(buf);
+		return err;
 	}
 
 	/* update the buffer to be able to deallocate the memory on the DSP */
@@ -1799,8 +1800,6 @@ static int fastrpc_req_mmap(struct fastr
 
 err_assign:
 	fastrpc_req_munmap_impl(fl, buf);
-err_invoke:
-	fastrpc_buf_free(buf);
 
 	return err;
 }


