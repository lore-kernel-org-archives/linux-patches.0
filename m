Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A1022D794;
	Tue, 20 May 2025 14:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750714; cv=none; b=TuKdJtg7UaLn+1qDCcjBBO+ekxKAlQQuYOA2PRkdzuFOcPnvnox5qDyJZMcj4z/71oGTQFGpdZB/942R52U4cVgT3yO2STjb1n89TfkcrlCm4r3XNMl4jHfjTVcOnk2n1Pq16wf3mquRN//HkYLJtVMoPYHOsVCiqoiQFhIJrLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750714; c=relaxed/simple;
	bh=Fmm1CXzUjW5ENsCNP1Xqdl2cbx0WXFE3TUynv8/7SPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7zHQqdH8KirG/BfoBKdn8e2E8zKhV5ZOQiQ5qeBzryIiJExYRK/lrKp8fehpMnQeX7HsXiUGDQZJ9e7LQ0Hm2wvOJ1vw1hotG1t6nH1TP84O5QIfjvQ2/mL9OoT/VobHMcKBeXdpuL80W1iow5hany4PCU7fbaghBT1ikiGW8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GC7hd4iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GC7hd4iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BDDC4CEE9;
	Tue, 20 May 2025 14:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750714;
	bh=Fmm1CXzUjW5ENsCNP1Xqdl2cbx0WXFE3TUynv8/7SPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GC7hd4iyN+qz7m1kzP2AbOYrWNoz7LfV7z71wmdXvv9WpUwhFaE/eI4nVIVTuEkhx
	 cCzYx7KDglik7RpxEn9AmMZUZkrsa4fxzxd1PlAdfhkvETe7Q+qw4gCfkWiSuSZi+h
	 n95gS5higtHhOdj++otnjrJYKT1eWsGnP46AeHto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.14 097/145] hv_netvsc: Remove rmsg_pgcnt
Date: Tue, 20 May 2025 15:51:07 +0200
Message-ID: <20250520125814.366836552@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhklinux@outlook.com>

commit 5bbc644bbf4e97a05bc0cb052189004588ff8a09 upstream.

init_page_array() now always creates a single page buffer array entry
for the rndis message, even if the rndis message crosses a page
boundary. As such, the number of page buffer array entries used for
the rndis message must no longer be tracked -- it is always just 1.
Remove the rmsg_pgcnt field and use "1" where the value is needed.

Cc: <stable@vger.kernel.org> # 6.1.x
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Link: https://patch.msgid.link/20250513000604.1396-5-mhklinux@outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/hyperv_net.h |    1 -
 drivers/net/hyperv/netvsc.c     |    7 +++----
 drivers/net/hyperv/netvsc_drv.c |    1 -
 3 files changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -158,7 +158,6 @@ struct hv_netvsc_packet {
 	u8 cp_partial; /* partial copy into send buffer */
 
 	u8 rmsg_size; /* RNDIS header and PPI size */
-	u8 rmsg_pgcnt; /* page count of RNDIS header and PPI */
 	u8 page_buf_cnt;
 
 	u16 q_idx;
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -953,8 +953,7 @@ static void netvsc_copy_to_send_buf(stru
 		     + pend_size;
 	int i;
 	u32 padding = 0;
-	u32 page_count = packet->cp_partial ? packet->rmsg_pgcnt :
-		packet->page_buf_cnt;
+	u32 page_count = packet->cp_partial ? 1 : packet->page_buf_cnt;
 	u32 remain;
 
 	/* Add padding */
@@ -1137,7 +1136,7 @@ static inline int netvsc_send_pkt(
 		u32 desc_size;
 
 		if (packet->cp_partial)
-			pb += packet->rmsg_pgcnt;
+			pb++;
 
 		ret = netvsc_dma_map(ndev_ctx->device_ctx, packet, pb);
 		if (ret) {
@@ -1299,7 +1298,7 @@ int netvsc_send(struct net_device *ndev,
 		packet->send_buf_index = section_index;
 
 		if (packet->cp_partial) {
-			packet->page_buf_cnt -= packet->rmsg_pgcnt;
+			packet->page_buf_cnt--;
 			packet->total_data_buflen = msd_len + packet->rmsg_size;
 		} else {
 			packet->page_buf_cnt = 0;
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -342,7 +342,6 @@ static u32 init_page_array(void *hdr, u3
 	pb[0].len = len;
 	pb[0].pfn = virt_to_hvpfn(hdr);
 	packet->rmsg_size = len;
-	packet->rmsg_pgcnt = 1;
 
 	pb[1].offset = offset_in_hvpage(skb->data);
 	pb[1].len = skb_headlen(skb);


