Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B773D3314;
	Thu, 16 Jul 2026 13:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209072; cv=none; b=YZipGlOU/ydjclwB8cKpHY18YiWZRttcXKrOYqrxdEo2adCR5gmvnH1bWkSerCw8ZJD8yiYeWrp1HxibAA5asmTrkgxi36V8QPjJ5BDqd+uew7/5zXfyydg63yJzdHhXJ+ibePn8r1EOMd7YEP7zKiHIbvuBITJPYN7GpfOX1Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209072; c=relaxed/simple;
	bh=HO526jwrifr0ETYypHaNWiLbYoTbtdOzdMTylaWEuLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8HIMhnrwunmTkNUtKBlq2EOXM+nQrua3THjjBF6bb8GGtK7btm+yasaVDVN0IMFDr0R4pjGVDiCHwkrCJ6XId864mpa2RqjYRovdmXyuLs24cLYuJVgyX+7wEvVsQxIYHljag5fhluHUAjTK+aNMxObrNbsm4qGpf9q+nHfTYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ms5cbuAB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ms5cbuAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB331F000E9;
	Thu, 16 Jul 2026 13:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209071;
	bh=rrMMJFqwldmq5IiIKLbs8LjYLLtXb3yuPgXzgbxSxRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ms5cbuABteGXyHRId42T9dKQrYK0EPn3mcyOh3lVOznS1Yii1HA0lEUb8Oyos5ubj
	 SMLzjM1Svuud+wO3Qntj2VIzkiObaJ65se3vIHGsUuawFHpiNqAHNYqnWSuWjLGdH/
	 EGMyRy8pF0v+ZbcKu6kQP266F6hkY4nFKuEwzEuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 046/518] iio: backend: fix uninitialized data in debugfs
Date: Thu, 16 Jul 2026 15:25:14 +0200
Message-ID: <20260716133048.792196396@linuxfoundation.org>
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

commit a6e8b14a4897d0b6df9744f33d0a30e6b92368eb upstream.

If the *ppos value is non-zero then simple_write_to_buffer() will not
initialize the start of the buf[] buffer.  Non-zero ppos values aren't
going to work at all.  Check for that at the start of the function and
return -ENOSPC.

Fixes: cdf01e0809a4 ("iio: backend: add debugFs interface")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-backend.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/industrialio-backend.c
+++ b/drivers/iio/industrialio-backend.c
@@ -156,7 +156,7 @@ static ssize_t iio_backend_debugfs_write
 	ssize_t rc;
 	int ret;
 
-	if (count >= sizeof(buf))
+	if (*ppos != 0 || count >= sizeof(buf))
 		return -ENOSPC;
 
 	rc = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, userbuf, count);


