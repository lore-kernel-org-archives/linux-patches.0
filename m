Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DB6442110;
	Mon, 17 Aug 2026 14:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977459; cv=none; b=Zgmngjgk32mMX0fueVt2feTg/IhYDyNFzHYpzLNBdEkp/d1efrob0N+Dtp2OWWASq5TngpN8vX0xnU/WJLnXZqMHkTcPx+mVa8e24qMQN5HlFjwnH+FRvCc/Ovpysp8YK577pVBopMYsoUvRnzfOznNiPhwGpbnkKdLgLOHsBAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977459; c=relaxed/simple;
	bh=KLJ4Pxw+0o0UMKbuOpmvyALmHBm68Glop5XC5Wif7oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r8MrNWZNxyeJ0jFF5WDCKOJVz7wRDHFZHgxB3O0XkWB9bEfEbymG7nRaQNKpAeBwdke5CuYKcHDBcBiBDFND6iJ1IXf4jv3ADQW4yMV0+OsTFvx43le4mc93KcU2xQ6a0hbv/x2NtGoWonUTxBG1u/jR69ujVPYN0FwTz3C2pJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdUPF55c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdUPF55c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBA21F000E9;
	Mon, 17 Aug 2026 14:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977457;
	bh=tUlCeGFdPKFJEaeDCTqiplohFc3FYeJBL/yZnstq00c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NdUPF55cL+gZoedRqvd48T0oeVuZApKcycQJYkfJlvM+xLWKznfPbq83i4XM4R76V
	 bndKmvOt/rnwDao0mdHYU9kdwXOIB4P051oUMmhwfltM0qZnYL8FmOfFMnCHkqeJHW
	 kGz0UJBIr13ZtW2bXqek500m62svA5q0j707sXn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	Eduard Shishkin <edward6@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 336/456] s390/dasd: Fix potential NULL pointer dereference
Date: Mon, 17 Aug 2026 15:32:06 +0200
Message-ID: <20260817132552.756247478@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Höppner <hoeppner@linux.ibm.com>

commit 9973026f572db6b67570cadc30942f3014e41079 upstream.

dasd_release_space() checks the implementation of the is_ese()
discipline function before calling it to determine if a given device is
an ESE DASD.

The current usage of the logical AND operator will lead to a NULL
pointer dereference as the function is called even if the function
pointer is NULL.

Fix this by using the logical OR operator.

Fixes: 91dc4a197569 ("s390/dasd: Add new ioctl to release space")
Cc: stable@vger.kernel.org # v5.3+
Reported-by: Vasily Gorbik <gor@linux.ibm.com>
Acked-by: Eduard Shishkin <edward6@linux.ibm.com>
Reviewed-by: Stefan Haberland <sth@linux.ibm.com>
Signed-off-by: Jan Höppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://patch.msgid.link/20260727142840.567286-3-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -330,7 +330,7 @@ out_err:
 static int dasd_release_space(struct dasd_device *device,
 			      struct format_data_t *rdata)
 {
-	if (!device->discipline->is_ese && !device->discipline->is_ese(device))
+	if (!device->discipline->is_ese || !device->discipline->is_ese(device))
 		return -ENOTSUPP;
 	if (!device->discipline->release_space)
 		return -ENOTSUPP;


