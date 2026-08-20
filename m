Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA0737C92A;
	Thu, 20 Aug 2026 15:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238200; cv=none; b=F8cUyUwP3TW0/sYTy8LvMrcEXyUNVWMOmUihCoAIRvdAZx8k5AM0SCHvYNwxsdvHwwUWMIk7geA54PcC8nhNmBNOSg2PXL0KP7OJXG1b6JTGqXXWVYXAj1b/b+kznrqdD0C5eNBRuwJ3W3aU9q6Iw3uWEiQPxR5SHxRXUXeNiww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238200; c=relaxed/simple;
	bh=+JoEQXoYcqJLgpMudCzMQ0mJ5EsbIMwemOOGFtw0sJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNcnmt+xH+tX0OOlK4UkayS0PrkyjqXu1PZ95zlN9Ge8or5g9ZIKdc36s5+8ZzniwSwlzPm7yja40X77K9OJSR/JvTbQrp8OIkkIK943qprkgm9kHwKf7RkXTCglfj9tttfmEXkIFALxYhQ/WCsigGGsCw/pia4F2H26Tpngaa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hMKxOGL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hMKxOGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499061F00A3A;
	Thu, 20 Aug 2026 15:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238198;
	bh=AGpLGHzW4knJYvM62S+srI/U4/F9WSorqsKPFum9tKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hMKxOGLphAG/V9jE+VTKpKywkTgQbGNUmZNrFCJm6lS4e4CkBQqNrs4fnfVC6ljP
	 W1VIs9m0tgZbYjCSxB1dhCh/xxA0m+HrRz3yDw2vge6fAp1qP0LXCRoUqYbO8bEQ/8
	 AKKHvuzuxqnX7PIgNs0UuduShIYg+pJG8jgJwooE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 058/228] crypto: qce - fix error path in devm_qce_register_algs
Date: Thu, 20 Aug 2026 16:53:20 +0200
Message-ID: <20260820145246.237743935@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 9c75402286409f5e1a75e4a445555c84066f89db upstream.

If ops->register_algs() fails, the error path repeatedly calls the same
ops->unregister_algs() from the failed registration. Use the loop index
to unregister the previously registered algorithms instead.

Fixes: e80cf84b6087 ("crypto: qce - unregister previously registered algos in error path")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qce/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -59,7 +59,7 @@ static int devm_qce_register_algs(struct
 		ret = ops->register_algs(qce);
 		if (ret) {
 			for (j = i - 1; j >= 0; j--)
-				ops->unregister_algs(qce);
+				qce_ops[j]->unregister_algs(qce);
 			return ret;
 		}
 	}


