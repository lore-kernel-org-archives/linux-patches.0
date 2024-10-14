Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C823419E802;
	Mon, 14 Oct 2024 14:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916618; cv=none; b=heKJsNriJ1d5Rvs5l55ihB7P0VJSDp4u8eBsoZgPG5JLswudPXxmHB6ncnldeqjo2Ru7tmEU59y5dJuUrSvNvODCYsSqb7UB2VM/cEavGjxAY3mlN4VN8NcfCsj0EoRU9M4Gc7jxx8YZzw/aYpc34FUcVcvd4dO/UH/PxvbohcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916618; c=relaxed/simple;
	bh=IJCNeWeY3rQq8gxrPwbSA9NnNlyZSHrmS8LjCP9xhcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsIrufVIYhMj9eMONhKyqkSqHwGJzmLja5DsAV680k/aU7A4O7zVeAnlKNx5LP48riaDLZU8Tuo+Q21vdM6322Phv9cThT0uo7ZFirw2NKtu0mjPY94ocrJx6F9xyfdzjCgv7SlfezdYwtRw/8lVpM1ylsZzqxjMI2VkOVr2k4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEIjmvnJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEIjmvnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3831FC4CEC3;
	Mon, 14 Oct 2024 14:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916618;
	bh=IJCNeWeY3rQq8gxrPwbSA9NnNlyZSHrmS8LjCP9xhcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEIjmvnJ/DxBV55rh2IQUzWpHI7H3Qf0si/+XXiUKKOXJaWw6o2tr2uCqu3wd4C5b
	 lRUE9MSVhU0V38HJxC+IDhX/GGvLzP4LPt36xYCE6JfTcEqBaZhvaRXIkzMgX23FT4
	 v0PVXXNKKUHeEWbW7s8I9Jh95StgoGSjCGw57Dsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/213] bus: mhi: ep: Introduce async read/write callbacks
Date: Mon, 14 Oct 2024 16:18:44 +0200
Message-ID: <20241014141043.695972341@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 8b786ed8fb089e347af21d13ba5677325fcd4cd8 ]

These callbacks can be implemented by the controller drivers to perform
async read/write operation that increases the throughput.

For aiding the async operation, a completion callback is also introduced.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Stable-dep-of: c7d0b2db5bc5 ("bus: mhi: ep: Do not allocate memory for MHI objects from DMA zone")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mhi_ep.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/mhi_ep.h b/include/linux/mhi_ep.h
index b96b543bf2f65..14c6e8d3f5736 100644
--- a/include/linux/mhi_ep.h
+++ b/include/linux/mhi_ep.h
@@ -54,11 +54,16 @@ struct mhi_ep_db_info {
  * @dev_addr: Address of the buffer in endpoint
  * @host_addr: Address of the bufffer in host
  * @size: Size of the buffer
+ * @cb: Callback to be executed by controller drivers after transfer completion (async)
+ * @cb_buf: Opaque buffer to be passed to the callback
  */
 struct mhi_ep_buf_info {
 	void *dev_addr;
 	u64 host_addr;
 	size_t size;
+
+	void (*cb)(struct mhi_ep_buf_info *buf_info);
+	void *cb_buf;
 };
 
 /**
@@ -96,6 +101,8 @@ struct mhi_ep_buf_info {
  * @unmap_free: CB function to unmap and free the allocated memory in endpoint for storing host context
  * @read_sync: CB function for reading from host memory synchronously
  * @write_sync: CB function for writing to host memory synchronously
+ * @read_async: CB function for reading from host memory asynchronously
+ * @write_async: CB function for writing to host memory asynchronously
  * @mhi_state: MHI Endpoint state
  * @max_chan: Maximum channels supported by the endpoint controller
  * @mru: MRU (Maximum Receive Unit) value of the endpoint controller
@@ -151,6 +158,8 @@ struct mhi_ep_cntrl {
 			   void __iomem *virt, size_t size);
 	int (*read_sync)(struct mhi_ep_cntrl *mhi_cntrl, struct mhi_ep_buf_info *buf_info);
 	int (*write_sync)(struct mhi_ep_cntrl *mhi_cntrl, struct mhi_ep_buf_info *buf_info);
+	int (*read_async)(struct mhi_ep_cntrl *mhi_cntrl, struct mhi_ep_buf_info *buf_info);
+	int (*write_async)(struct mhi_ep_cntrl *mhi_cntrl, struct mhi_ep_buf_info *buf_info);
 
 	enum mhi_state mhi_state;
 
-- 
2.43.0



