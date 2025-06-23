Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9EF223DEF;
	Mon, 23 Jun 2025 22:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716698; cv=none; b=U8u4fZZQ2r7lzD/F9KyRDxvrL5POshZxapi2LKw7qDW3DCC3yOhO7spaKYmnw1Uy2G66xLAbqeKuwm7iVFQ0TLbGcf+NpeB794Kuat8jPEfT5wB4CHWuBR16gdye/REOxNWDY6vAwd9lZhn2uY4/A2X9jndhx+HK2E723n5Sb/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716698; c=relaxed/simple;
	bh=cZ11O8rNtqIOXWkPIIVZ9iMaEEdqyjkIUq5WJD64Noc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lN4lH3zdw0CKUcpAcBGSwqqt5Wen5bOPqwla8dQSHcwVACzLyKD18fG6fLKgRiOMGe3dyS8PFsh0nux4JQwFsIetyuVPMWfJiWoj9i5PU46pT4/YHskw3brUCrKo8ISb9pFggbra3f3tIeYrwk8wj3/6tCJzay39/QlyyCTTCpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pchB3wRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pchB3wRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26554C4CEEA;
	Mon, 23 Jun 2025 22:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716698;
	bh=cZ11O8rNtqIOXWkPIIVZ9iMaEEdqyjkIUq5WJD64Noc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pchB3wRj6lcs05RFbH8HdMcP0Kj9ZbROn5ltWft8SQuCpk4ae8nTQLzSKD1vNigtM
	 hLZhzvptl+DsSEQwGirxtAOA6oKw2knjIl92urSBut17ZXZ2cR6/qtl+BUoD5dkOGp
	 SOjMK01/O20OH1RmntiwLyXX7Ubfx7gNdfW2cmQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.15 351/411] udmabuf: use sgtable-based scatterlist wrappers
Date: Mon, 23 Jun 2025 15:08:15 +0200
Message-ID: <20250623130642.482394913@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit afe382843717d44b24ef5014d57dcbaab75a4052 upstream.

Use common wrappers operating directly on the struct sg_table objects to
fix incorrect use of scatterlists sync calls. dma_sync_sg_for_*()
functions have to be called with the number of elements originally passed
to dma_map_sg_*() function, not the one returned in sgtable's nents.

Fixes: 1ffe09590121 ("udmabuf: fix dma-buf cpu access")
CC: stable@vger.kernel.org
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20250507160913.2084079-3-m.szyprowski@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/udmabuf.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -133,8 +133,7 @@ static int begin_cpu_udmabuf(struct dma_
 			ubuf->sg = NULL;
 		}
 	} else {
-		dma_sync_sg_for_cpu(dev, ubuf->sg->sgl, ubuf->sg->nents,
-				    direction);
+		dma_sync_sgtable_for_cpu(dev, ubuf->sg, direction);
 	}
 
 	return ret;
@@ -149,7 +148,7 @@ static int end_cpu_udmabuf(struct dma_bu
 	if (!ubuf->sg)
 		return -EINVAL;
 
-	dma_sync_sg_for_device(dev, ubuf->sg->sgl, ubuf->sg->nents, direction);
+	dma_sync_sgtable_for_device(dev, ubuf->sg, direction);
 	return 0;
 }
 


