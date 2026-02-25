Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94097252917;
	Wed, 25 Feb 2026 01:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983970; cv=none; b=LhKHNyeEpvLuh/0Kza2RWWMrgKE3JLyvcuF7mY94CEDr9j/MmRotLqKL6ox4rWbOEK7MpM2rUBoLMCqWIcPRZ+hBVt6GR0kIB6pAzny/QDGrCLEKkbqygwTLJbv2PW6oRPgVzGu/Zcfdra1ZD53gzvRVeA6dEaRjvq7eELwwC3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983970; c=relaxed/simple;
	bh=t3OQ/isrwBZSQg2m3B6cJDOTlDM2fmiA38MKANVKB74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8gvHxWxMbJ2RKKLCBL1XmybOsoPz/eGxGjqNQdfcn6PY0c8GcH6K0Jx3uTNWFzYrUEflLKU873dRedOqB/71pVyPQ72j7dCv22qv52TWly2vADTGVAwI7CQKoENqsqmunOTenMk69sn5Fe9ZVUnxYmDCMwQ7CB4EyOkdfjU8dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8SjlS2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8SjlS2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4934AC116D0;
	Wed, 25 Feb 2026 01:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983970;
	bh=t3OQ/isrwBZSQg2m3B6cJDOTlDM2fmiA38MKANVKB74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8SjlS2P4YoFt/Huy+Z2WEY8XTtlQYCiOhwwpFipuaqmF9pYs1b5xarrr+2MXSYj6
	 oEmCjdBTaBQpbWuoaImhohSCCe9IWpJhZ2nM/vXXHuuHQ/D86A2anF18qZ2zqXisPn
	 Xr31uYW6TmXHL6S7QX5auNw302tJCJT5MBHmKopI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zishun Yi <zishun.yi.dev@gmail.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Min Ma <mamin506@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 225/641] accel/amdxdna: Fix memory leak in amdxdna_ubuf_map
Date: Tue, 24 Feb 2026 17:19:11 -0800
Message-ID: <20260225012354.363524251@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Zishun Yi <zishun.yi.dev@gmail.com>

[ Upstream commit 84dd57fb0359500092f1101409ca32091731490d ]

The amdxdna_ubuf_map() function allocates memory for sg and
internal sg table structures, but it fails to free them if subsequent
operations (sg_alloc_table_from_pages or dma_map_sgtable) fail.

Fixes: bd72d4acda10 ("accel/amdxdna: Support user space allocated buffer")
Signed-off-by: Zishun Yi <zishun.yi.dev@gmail.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Reviewed-by: Min Ma <mamin506@gmail.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260129171022.68578-1-zishun.yi.dev@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_ubuf.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_ubuf.c b/drivers/accel/amdxdna/amdxdna_ubuf.c
index 077b2261cf2a0..9e3b3b055caa8 100644
--- a/drivers/accel/amdxdna/amdxdna_ubuf.c
+++ b/drivers/accel/amdxdna/amdxdna_ubuf.c
@@ -34,15 +34,21 @@ static struct sg_table *amdxdna_ubuf_map(struct dma_buf_attachment *attach,
 	ret = sg_alloc_table_from_pages(sg, ubuf->pages, ubuf->nr_pages, 0,
 					ubuf->nr_pages << PAGE_SHIFT, GFP_KERNEL);
 	if (ret)
-		return ERR_PTR(ret);
+		goto err_free_sg;
 
 	if (ubuf->flags & AMDXDNA_UBUF_FLAG_MAP_DMA) {
 		ret = dma_map_sgtable(attach->dev, sg, direction, 0);
 		if (ret)
-			return ERR_PTR(ret);
+			goto err_free_table;
 	}
 
 	return sg;
+
+err_free_table:
+	sg_free_table(sg);
+err_free_sg:
+	kfree(sg);
+	return ERR_PTR(ret);
 }
 
 static void amdxdna_ubuf_unmap(struct dma_buf_attachment *attach,
-- 
2.51.0



