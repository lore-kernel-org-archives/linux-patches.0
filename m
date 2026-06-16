Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C580478E34;
	Tue, 16 Jun 2026 16:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625616; cv=none; b=qggXbTl1Bx7tW4xJ7DmVdWhKJMW3wVTuilD/8tKK0FuwD1ebgHKkoWGyfqh9udk8F92gGP7vrUN4rOlhUW9pZ0TcuPF+wBLj1cVp6R2RYzSHLzwsqWG0RqTUn7Ieke1Tzzm9ZEzjERG/dWi3nm4yuKPakH45o++oMAyIHMOesOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625616; c=relaxed/simple;
	bh=c1AMncTBU9/5kCRgT8VmSft46jyu9SwcvKZ3P88p/oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHLmaRNYUO2fMQK8CET1IBgjt9Y6AkaR/UkkQJEtBm2/OQdm1NotR2N9DWGZhF/h4RpuQZLkQq6PaxsUDyzNIyRfo22VTQb9cEXQLP8AprioPeXukX0xEnU+LUpL/8uhEUZJ22uWECD3ux2UGaNnVVt5pldcBJua8IWO/K9SxaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h12K9M97; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h12K9M97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0174F1F000E9;
	Tue, 16 Jun 2026 16:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625613;
	bh=zPwsvtTqRkGzb9va4SCYy8Ff2t6KRe7dNhHdtIZobls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h12K9M97qZUQrm8pIla3Qk1thRbuj2EDYWx4JXiqJsdMb58Nnifdutt/FuUgAs5dc
	 MmKKLCW4jIAV+FkUGy39K5Gk17Feu4xuFKd45iYICLAno3kAlu8zhtG3SXpujz5HAD
	 Ekf5SfZ6Z+wmu48BH56UA2IgdR9MBNp/Q247x/PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lvc-project@linuxtesting.org,
	Georgiy Osokin <g.osokin@auroraos.dev>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 6.18 149/325] tee: shm: fix shm leak in register_shm_helper()
Date: Tue, 16 Jun 2026 20:29:05 +0530
Message-ID: <20260616145105.140312722@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgiy Osokin <g.osokin@auroraos.dev>

commit 26682f5efc276e3ad96d102019472bfbf03833b2 upstream.

register_shm_helper() allocates shm before calling
iov_iter_npages(). If iov_iter_npages() returns 0, the function
jumps to err_ctx_put and leaks shm.

This can be triggered by TEE_IOC_SHM_REGISTER with
struct tee_ioctl_shm_register_data where length is 0.

Jump to err_free_shm instead.

Fixes: 7bdee4157591 ("tee: Use iov_iter to better support shared buffer registration")
Cc: stable@vger.kernel.org
Cc: lvc-project@linuxtesting.org
Signed-off-by: Georgiy Osokin <g.osokin@auroraos.dev>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/tee_shm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -435,7 +435,7 @@ register_shm_helper(struct tee_context *
 	num_pages = iov_iter_npages(iter, INT_MAX);
 	if (!num_pages) {
 		ret = ERR_PTR(-ENOMEM);
-		goto err_ctx_put;
+		goto err_free_shm;
 	}
 
 	shm->pages = kcalloc(num_pages, sizeof(*shm->pages), GFP_KERNEL);


