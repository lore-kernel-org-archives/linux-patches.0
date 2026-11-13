Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585649;
	b=p6eKJCDQMG/lHRzbdIwk/2eOYZKkaoV9EdKM4/fcrqfAs9ntWftff/95yBfH4AQv2PZ8
	 ETS+6hOgB+u9KoNxLTS3L75b0flVBGZIQJZ2UAEWhwCT0oim6iZj7//6bcDjkhYMrXaDk
	 rzqIL8kif7QsjluSKsZAtdX1ULi4UtonXrV7KaCqnYVUdCYFfRpOzS8yvvTntg+iKLKlW
	 jWOUWBPROtyXnSSaa9/HUqKqa7FFC0HJN5yMZj2STjEiTTk7isYkbnUwWQK949xbRp9UD
	 p+mybsn8LHZtm6E1pRbC11ZVo+ETJo5T78QKgDMGzQOYYfpULYcBKa/lkGzKCJIvwqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b05LvgMPDCt9vrkZVr1RNkbJDARgwBYIhTxt5lQztCc=;
	b=A9d6oNxObzmZbyJ8uwEORNw89FvEFuE/KBYpk700VfMZAXL0WdqgqdnXv29cTYa7nPOQ
	 noETYDwnAyiLH1uw37lJglAf5F0pRYgEIgh99tvODbrYAtFBzH/ocbDK8iOxbFBYGZd82
	 8rNq1b9Qxb9Lv+UzVAC5V3vKS/bWhE9unHSZEkBfdFOY5TxfnswVOv5RMvEEfkIg/fyWn
	 psJkhVqUinwef5seC/XXZCtKbiK6CP57+HcFpyInBnxhvPefb3T9CTAZH7DOqyHUPzgrv
	 M2BJcN1Tl657CvXLi/xdGIQiSL7P0ErzP9HMO7iJcpEURXyewfKnXgxrAUMKMm/34zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FV5xtPGs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6701B606B2CF;
	Fri, 13 Nov 2026 16:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FV5xtPGs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BC61F000C4;
	Fri, 13 Nov 2026 16:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585649;
	bh=b05LvgMPDCt9vrkZVr1RNkbJDARgwBYIhTxt5lQztCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FV5xtPGs5mUIjjp2YwLo3zARrGf1bNZ4MD0BLbDo4ez7bitkWcuhBFaVSOdX0A9x2
	 ovEgePOq4zN53TGmVqJDPf8dunhpyrVbrREDU2CVX95+CL3Sl9TKgTmFMrl+MG3xZ9
	 3VML2+l8opcj/CEF+WoxpK9i87mUVr2bHK5E1mis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubham Antil <shubham@octane.security>,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 265/507] vhost-scsi: zero misaligned I/O bounce pages
Date: Fri, 13 Nov 2026 10:49:29 -0500
Message-ID: <20261113153803.586346400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shubham Antil <shubham@octane.security>

[ Upstream commit 01c3a5fa6d641c93c7cef4fb25c5f12938316e18 ]

The misaligned I/O fallback copies the full bounce scatterlist to the
request buffer during completion.  If a data-in command transfers less
than requested, part of a newly allocated bounce page can remain unwritten.

Allocate bounce pages with __GFP_ZERO so all bytes copied during completion
have a defined value.  This path is already the slow fallback for
misaligned I/O, so the added initialization cost is acceptable.

Found during an LLM-assisted source audit and validated with a QEMU/KVM
vhost-scsi target using misaligned data-in commands.

Fixes: 5ced58bfa132 ("vhost-scsi: Fix alignment handling with windows")
Cc: stable@vger.kernel.org
Assisted-by: LLM (OpenAI Codex, gpt-5.6-sol)
Signed-off-by: Shubham Antil <shubham@octane.security>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261020105503.75904-1-shubham@octane.security>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 4f8c0260bc9e7..ddc9bea190ded 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -937,7 +937,12 @@ vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
 	}
 
 	for_each_sgtable_sg(sg_table, sg, i) {
-		page = alloc_page(GFP_KERNEL);
+		/*
+		 * Completion copies the full bounce buffer, including bytes the
+		 * target did not write. This is already the slow fallback for
+		 * misaligned I/O, so zeroing is acceptable here.
+		 */
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (!page) {
 			ret = -ENOMEM;
 			goto err;
-- 
2.53.0



