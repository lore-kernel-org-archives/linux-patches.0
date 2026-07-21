Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6919470442;
	Tue, 21 Jul 2026 20:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664103; cv=none; b=jrcRehis8pFsZeXe7EjR+UDm9G5lBJdUORbbRVPtMQyTHTv1UoW804qrFRbKe/9QcW5zxcwFabxJ7se9UquUV73PVQeek5CZTD5Gkt96mBvBBZDvVfrv8/mxYqCbgTjQ4DUZlfD7Um61Yt0v1uBHdQwgmIiMs/aFyjg8UlmBrnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664103; c=relaxed/simple;
	bh=D9uBEZQUmSIGgUiB1Z/UWCAEJz1niHe+QYGkTBlz9do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEw4fohLpEuEpiIu81G1JqKib2+kmNQ9xwNeX7mbbbmgIt8Hrb3+Z5JB1Y1NGnuj+TJIPsl8VHDR6uB+Yg9Ifc1uRJFd/+Zc1Xdn5Ai4nmtiRV+zAvHg6jF5PIrX86MY32WgrYwi/oDFW/GimhfNqUR3yntWkomM7bmD5VZcCB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JaYxiBBg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JaYxiBBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77E81F000E9;
	Tue, 21 Jul 2026 20:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664101;
	bh=1O2QjcB8GmoP/CylTNd40bQ20LFstUnh7KqT1IC77N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JaYxiBBgOhH6QXBNBrBxtZl1DmQ23IrJW4bNv8HMQKoAUgbvw604OE1CS62EuOybZ
	 WzR/wADR0gKxozsfft/gUXr5J/Cs2EcqxDcEGNuGqymf1yFQOFiEDccTaOgVh3mZ2c
	 jLA47+O9pq87hqV7c06wreiTldyU1rMjaWEBTJ2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Breno Leitao <leitao@debian.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 1074/1276] fsl/fman: Free init resources on KeyGen failure in fman_init()
Date: Tue, 21 Jul 2026 17:25:17 +0200
Message-ID: <20260721152510.020498932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit d288efa2b94abc2e45a061fceb156b4f4e5b37be upstream.

fman_muram_alloc() allocates initialization resources before
initializing the KeyGen block. If keygen_init() fails, the
function returns -EINVAL directly and leaves those resources
allocated. Free the initialization resources before returning
from the KeyGen failure path.

Fixes: 7472f4f281d0 ("fsl/fman: enable FMan Keygen")
Cc: stable@kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260625004834.3394389-1-haoxiang_li2024@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fman/fman.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -1995,8 +1995,10 @@ static int fman_init(struct fman *fman)
 
 	/* Init KeyGen */
 	fman->keygen = keygen_init(fman->kg_regs);
-	if (!fman->keygen)
+	if (!fman->keygen) {
+		free_init_resources(fman);
 		return -EINVAL;
+	}
 
 	err = enable(fman, cfg);
 	if (err != 0)


