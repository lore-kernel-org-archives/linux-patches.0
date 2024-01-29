Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF73E159588;
	Mon, 29 Jan 2024 17:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548217; cv=none; b=uS+Y1E0hvTctTQoseUuz5lf6NsqdQMi0nrLtEWAe6sPRioEhkr2bLXJhzYVH6yN7u9z1hWLEgpDQld4d6hzNQE6eZIGO2mgGUy6hW5psA6sEVhslZ8gDpw0Cau7YNmxxTG2DnufyKCk8Z2swE5bQXtTOLkEeNJRnGEOwRnOMf1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548217; c=relaxed/simple;
	bh=3IgD35KFcDdIcXmmphasteCgmK+27yRUwO/gebQQZ9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiJGo2k7qdi+0qqk09ysXgoeEjKPfGUFyYe8XSETj+WTe59p8z7YWVUGe0GqrYV0VUvHJZ3GgyHBa4QSvEMY46MuFmKhDQm5T7cXPCbiCQFvU8+nY4APt+tFULIwaYEHT6F6fkUDlFtpku/hNyqCCYKyXOnSIeHq9EU5iXhNPIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xkyXjE4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xkyXjE4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960B6C43390;
	Mon, 29 Jan 2024 17:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548217;
	bh=3IgD35KFcDdIcXmmphasteCgmK+27yRUwO/gebQQZ9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkyXjE4YS8s8Vz7lmgb2R/Fv5kvzoxTcZtulKA7PZ0wDPfa8clkyzh2zH0sGvX+ku
	 VCTSyuf+Gzmh5s00xsK+KVthMlNCJXxcUBIChL0PPN3+7HWmRZxhdh4Y3ZlFu8ci7V
	 jX2TOrhL0OHD1c/HHGOwPVYy7yod4uqzO4oYPOoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna chaitanya chundru <quic_krichai@quicinc.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.1 024/185] bus: mhi: host: Add alignment check for event ring read pointer
Date: Mon, 29 Jan 2024 09:03:44 -0800
Message-ID: <20240129165959.376553999@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna chaitanya chundru <quic_krichai@quicinc.com>

commit eff9704f5332a13b08fbdbe0f84059c9e7051d5f upstream.

Though we do check the event ring read pointer by "is_valid_ring_ptr"
to make sure it is in the buffer range, but there is another risk the
pointer may be not aligned.  Since we are expecting event ring elements
are 128 bits(struct mhi_ring_element) aligned, an unaligned read pointer
could lead to multiple issues like DoS or ring buffer memory corruption.

So add a alignment check for event ring read pointer.

Fixes: ec32332df764 ("bus: mhi: core: Sanity check values from remote device before use")
cc: stable@vger.kernel.org
Signed-off-by: Krishna chaitanya chundru <quic_krichai@quicinc.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20231031-alignment_check-v2-1-1441db7c5efd@quicinc.com
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/bus/mhi/host/main.c
+++ b/drivers/bus/mhi/host/main.c
@@ -268,7 +268,8 @@ static void mhi_del_ring_element(struct
 
 static bool is_valid_ring_ptr(struct mhi_ring *ring, dma_addr_t addr)
 {
-	return addr >= ring->iommu_base && addr < ring->iommu_base + ring->len;
+	return addr >= ring->iommu_base && addr < ring->iommu_base + ring->len &&
+			!(addr & (sizeof(struct mhi_ring_element) - 1));
 }
 
 int mhi_destroy_device(struct device *dev, void *data)


