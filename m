Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA502FC4E;
	Fri, 24 Nov 2023 18:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2LWPHH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EF5C433C9;
	Fri, 24 Nov 2023 18:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850882;
	bh=2iEVDouW3ACwyzv5rPogKeCZHumARSgfMvXenM0BGJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2LWPHH6v6y5aABjEHvGsJRtEj4mOL2mB4bOKEvty9gDQGPIvMCOLURvLRzsBlPC6
	 8ZDGoLsjgi7dvGx9/SUJvDh0DJT7j7fwcrnbpwo/n87aFj8Rt3w7AYK1lS+wrtXxay
	 kCW71wc3hxrxwNW0GQzEOniHYLTEC/Yo+noI8Szg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.5 227/491] media: venus: hfi: add checks to perform sanity on queue pointers
Date: Fri, 24 Nov 2023 17:47:43 +0000
Message-ID: <20231124172031.381504469@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikash Garodia <quic_vgarodia@quicinc.com>

commit 5e538fce33589da6d7cb2de1445b84d3a8a692f7 upstream.

Read and write pointers are used to track the packet index in the memory
shared between video driver and firmware. There is a possibility of OOB
access if the read or write pointer goes beyond the queue memory size.
Add checks for the read and write pointer to avoid OOB access.

Cc: stable@vger.kernel.org
Fixes: d96d3f30c0f2 ("[media] media: venus: hfi: add Venus HFI files")
Signed-off-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -205,6 +205,11 @@ static int venus_write_queue(struct venu
 
 	new_wr_idx = wr_idx + dwords;
 	wr_ptr = (u32 *)(queue->qmem.kva + (wr_idx << 2));
+
+	if (wr_ptr < (u32 *)queue->qmem.kva ||
+	    wr_ptr > (u32 *)(queue->qmem.kva + queue->qmem.size - sizeof(*wr_ptr)))
+		return -EINVAL;
+
 	if (new_wr_idx < qsize) {
 		memcpy(wr_ptr, packet, dwords << 2);
 	} else {
@@ -272,6 +277,11 @@ static int venus_read_queue(struct venus
 	}
 
 	rd_ptr = (u32 *)(queue->qmem.kva + (rd_idx << 2));
+
+	if (rd_ptr < (u32 *)queue->qmem.kva ||
+	    rd_ptr > (u32 *)(queue->qmem.kva + queue->qmem.size - sizeof(*rd_ptr)))
+		return -EINVAL;
+
 	dwords = *rd_ptr >> 2;
 	if (!dwords)
 		return -EINVAL;


