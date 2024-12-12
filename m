Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4A5222D7B;
	Thu, 12 Dec 2024 17:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023526; cv=none; b=DmtXXpr+qbrnBkGo/HqPjC2xvZqHHlTUaRtnzFvfz2sQtT7XsYiGvIkV71KLSdNFOC1F2nPNwFwsEc33E6eT0OQgKVPN+VuSSbLnD6lhgfEKFlruwWHSYXPp7tswafzbAzFtOaHO//7dv0bQJ95NPsFig9+4nI5N6ePlFgtcuKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023526; c=relaxed/simple;
	bh=j06c0CXn4qKpq26d0G6BxJVY2pNvTUUv6+3pJdMeCN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfLGcpdY1Ya8fY+Qpgg0bUMb4qBuX3DdX3tyvRUyxins1c8I5CEuOL1bxnmNMKMlP2CH0mbMkAC/GYt1eShw1qFmNRaBz17RKuXFS2Oos1WASrX0qDwQslrFc5AYd2dRGs/C1XtDlFTT9kjkUoqzaFfi8pm7gO6bqUTcDIvaTkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ky6+WehY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ky6+WehY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E142C4CED0;
	Thu, 12 Dec 2024 17:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023526;
	bh=j06c0CXn4qKpq26d0G6BxJVY2pNvTUUv6+3pJdMeCN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ky6+WehYIj/WMPDGVEme3BKvChWWT3AtsYz7d7dgHMwCt7/ZqkHwOns3uQx7bFYHc
	 BIPXChjSuz3WzrCd1C6+WLWU2rQZ2RIAgjSJ5lPnNC5DyBub7KJYLwf6W7eAxPPtqI
	 +FuJobryG1jThm2XbJhsCajwrBPoeSMAaEhyfAgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ameer Hamza <amhamza.mgc@gmail.com>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.15 563/565] media: venus: vdec: fixed possible memory leak issue
Date: Thu, 12 Dec 2024 16:02:38 +0100
Message-ID: <20241212144334.129182069@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ameer Hamza <amhamza.mgc@gmail.com>

commit 8403fdd775858a7bf04868d43daea0acbe49ddfc upstream.

The venus_helper_alloc_dpb_bufs() implementation allows an early return
on an error path when checking the id from ida_alloc_min() which would
not release the earlier buffer allocation.

Move the direct kfree() from the error checking of dma_alloc_attrs() to
the common fail path to ensure that allocations are released on all
error paths in this function.

Addresses-Coverity: 1494120 ("Resource leak")

cc: stable@vger.kernel.org # 5.16+
Fixes: 40d87aafee29 ("media: venus: vdec: decoded picture buffer handling during reconfig sequence")
Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -189,7 +189,6 @@ int venus_helper_alloc_dpb_bufs(struct v
 		buf->va = dma_alloc_attrs(dev, buf->size, &buf->da, GFP_KERNEL,
 					  buf->attrs);
 		if (!buf->va) {
-			kfree(buf);
 			ret = -ENOMEM;
 			goto fail;
 		}
@@ -209,6 +208,7 @@ int venus_helper_alloc_dpb_bufs(struct v
 	return 0;
 
 fail:
+	kfree(buf);
 	venus_helper_free_dpb_bufs(inst);
 	return ret;
 }


