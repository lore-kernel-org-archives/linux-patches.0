Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2392045B5;
	Tue,  8 Jul 2025 16:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993685; cv=none; b=ngbl3Bkt/Bih4RZAzdqIYky3rUtE1z11oAXjIu7FPP6g0cselLxeUcAPAWLYa4zvAr9espNtjghQrwT4v+Iy8Vz+Uv+29IXyWHPRvVRStdCdl7eMBYMuSxcy/th2vj2IOxEBH4l3qZhX0flO1Upj4KshMLj7CWlNcVXXL6/fysg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993685; c=relaxed/simple;
	bh=7910NeWAciKgBjExdsYF9CDCt1tq8WJMPTfANACrYr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sdYGcICepUUaJpVLMxwGgX7kSsF0shbsClAfh515x6V5OnyTnSGtBjeUSH181t3Tye13AaoycF5P2aO1WhbsUsx69usnX3tLdjj/d9qhIePn+oW2/CI1mvWMXQskoNQJtHgE7rtjYcq4UHXmPDNth5KgUUd9wK8SrM+LYX1v88U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LClbz7fP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LClbz7fP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A94CC4CEED;
	Tue,  8 Jul 2025 16:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993685;
	bh=7910NeWAciKgBjExdsYF9CDCt1tq8WJMPTfANACrYr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LClbz7fPoCcARjq1r904uk64ICDbzIPuL9II+otfj/N7fLonmP0n86MxdbLKbccDs
	 R3UN9u0oL/zUVOrEDS/LU+BeIaogX5ROgntAsdXTeQEjWwHvZGceowKuyt8eroE+cD
	 4mSVk/fc3rhhGyj/7tk+dpngE+a5d1yDiRK2BS1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.15 158/178] dma-buf: fix timeout handling in dma_resv_wait_timeout v2
Date: Tue,  8 Jul 2025 18:23:15 +0200
Message-ID: <20250708162240.618686315@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 2b95a7db6e0f75587bffddbb490399cbb87e4985 upstream.

Even the kerneldoc says that with a zero timeout the function should not
wait for anything, but still return 1 to indicate that the fences are
signaled now.

Unfortunately that isn't what was implemented, instead of only returning
1 we also waited for at least one jiffies.

Fix that by adjusting the handling to what the function is actually
documented to do.

v2: improve code readability

Reported-by: Marek Olšák <marek.olsak@amd.com>
Reported-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20250129105841.1806-1-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-resv.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -685,11 +685,13 @@ long dma_resv_wait_timeout(struct dma_re
 	dma_resv_iter_begin(&cursor, obj, usage);
 	dma_resv_for_each_fence_unlocked(&cursor, fence) {
 
-		ret = dma_fence_wait_timeout(fence, intr, ret);
-		if (ret <= 0) {
-			dma_resv_iter_end(&cursor);
-			return ret;
-		}
+		ret = dma_fence_wait_timeout(fence, intr, timeout);
+		if (ret <= 0)
+			break;
+
+		/* Even for zero timeout the return value is 1 */
+		if (timeout)
+			timeout = ret;
 	}
 	dma_resv_iter_end(&cursor);
 


