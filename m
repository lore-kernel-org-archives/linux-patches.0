Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023CC381E97;
	Fri,  7 Aug 2026 14:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114293; cv=none; b=CgdzuSq5rD++I+PhRPeC75HyifJ3oFXPHhDvY6Fpy3XPh1H0KH85tmHKQy+jAGS2NMZ8DHlbQ+bNdQJ6B1cPNdGQYxi/fSH9byPFs+quDpVpG9VN+XOsqRyYWs/ju7L9p9rdefu0yeKI+4Vu3oUyq4WpaV70ZwZcXSB0lrmM/Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114293; c=relaxed/simple;
	bh=KLpFMBB2b70ome6ys5gKJUtiuMgKzSPPW+fhDbXBFSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kC8tFEXzDOTdR8k9Zhsje2BaBPWxSlho6eUTHH5dujGtB4iWFCJTS16/dHyJ7caw4lxd+cL33pHuWSbLldIGMZ705w2NYQ6t3AzZdE8F5YKDEG6E9ChgY0GD1BupRv0R7TFcB3rACQyyVy3mZmJmFiI3NWlvXEyjqkraxCZlpWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Di7UB6Kx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Di7UB6Kx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0BB1F000E9;
	Fri,  7 Aug 2026 14:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114291;
	bh=I+gZToq8RArACze9quNF/OC7x/VIkIgVDPnPikCsxKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Di7UB6KxLsj+/hUe3qNXBGLnuEDwaUDAHvK8hM6Zxk+DQNc0SKzvKJervzv+efhFh
	 wC85byuWN+GFg6SBhSZtAVzgR53z0LrfxgysnLZLblHnwjpuXxHm7EkANl16hI27lj
	 Ls+s5V7739ygRTOEnWEDh+jZ/wtpH3cqbEP5ONNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	Eduard Shishkin <edward6@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 210/337] s390/dasd: Fix potential NULL pointer dereference
Date: Fri,  7 Aug 2026 16:36:53 +0200
Message-ID: <20260807143423.107919287@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -324,7 +324,7 @@ out_err:
 static int dasd_release_space(struct dasd_device *device,
 			      struct format_data_t *rdata)
 {
-	if (!device->discipline->is_ese && !device->discipline->is_ese(device))
+	if (!device->discipline->is_ese || !device->discipline->is_ese(device))
 		return -ENOTSUPP;
 	if (!device->discipline->release_space)
 		return -ENOTSUPP;


