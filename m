Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCFE1DED4F;
	Wed,  6 Nov 2024 12:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896349; cv=none; b=VUAn+gcaIXiNfN6U5AFE7eHJfbqfjoHL2BA/dGVfhxVU5hH53smXWt6DJG1VduAySdJk5caK9bMgL0pLUs0HxbIpC8hD/Nv/JGzIcbKwrQ23lzIOQDx9UyZ9brX2m09XL0X/pXxrnx3Dmg4N/S61gmhx8MTbEk00fDIZk7d60rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896349; c=relaxed/simple;
	bh=1sbgPlohlBhrJdNL9IKhlj0rVbBurNy8KypT8lDIDWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xw67gXxAQe1iHGpn/KL9Y6tZ9Zgn0xbnY4u1eh3j8PSUO65ox2tw9WtCQ51ioo6nxDbJJ4kGIjlOLcKkEJ4Ce00O2mDU3iCoVAZiDhOo4RFPgK4/y3JkR3LD/YR/ECXGnuO/Ov0sdOniBBANX3/BvNXoMZZKmZnkGkBi70bYTBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQOCUcqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQOCUcqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183FAC4CECD;
	Wed,  6 Nov 2024 12:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896349;
	bh=1sbgPlohlBhrJdNL9IKhlj0rVbBurNy8KypT8lDIDWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQOCUcqvdVickyF4N5kJqqqiky2dfYnmOk8/y1N0PzVXCTW9pC0GCD+yehLJnH2NR
	 AO5gvjUL7X4WcOdKNFzCZphzPO2QK0hInBjYRBcEO9ngy3e/JN/F/tSIFRWkrL0YzI
	 gfXGYgwU3Tr5YsRJnEDCM7n+3fY76QmlOopRebE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Rohit Agarwal <rohiagar@chromium.org>,
	Brian Geffon <bgeffon@google.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 173/245] mei: use kvmalloc for read buffer
Date: Wed,  6 Nov 2024 13:03:46 +0100
Message-ID: <20241106120323.496244920@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit 4adf613e01bf99e1739f6ff3e162ad5b7d578d1a ]

Read buffer is allocated according to max message size, reported by
the firmware and may reach 64K in systems with pxp client.
Contiguous 64k allocation may fail under memory pressure.
Read buffer is used as in-driver message storage and not required
to be contiguous.
Use kvmalloc to allow kernel to allocate non-contiguous memory.

Fixes: 3030dc056459 ("mei: add wrapper for queuing control commands.")
Cc: stable <stable@kernel.org>
Reported-by: Rohit Agarwal <rohiagar@chromium.org>
Closes: https://lore.kernel.org/all/20240813084542.2921300-1-rohiagar@chromium.org/
Tested-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Acked-by: Tomas Winkler <tomasw@gmail.com>
Link: https://lore.kernel.org/r/20241015123157.2337026-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/client.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 9d090fa07516f..be011cef12e5d 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -321,7 +321,7 @@ void mei_io_cb_free(struct mei_cl_cb *cb)
 		return;
 
 	list_del(&cb->list);
-	kfree(cb->buf.data);
+	kvfree(cb->buf.data);
 	kfree(cb->ext_hdr);
 	kfree(cb);
 }
@@ -497,7 +497,7 @@ struct mei_cl_cb *mei_cl_alloc_cb(struct mei_cl *cl, size_t length,
 	if (length == 0)
 		return cb;
 
-	cb->buf.data = kmalloc(roundup(length, MEI_SLOT_SIZE), GFP_KERNEL);
+	cb->buf.data = kvmalloc(roundup(length, MEI_SLOT_SIZE), GFP_KERNEL);
 	if (!cb->buf.data) {
 		mei_io_cb_free(cb);
 		return NULL;
-- 
2.43.0



