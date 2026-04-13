Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6437924E4A1;
	Mon, 13 Apr 2026 16:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098349; cv=none; b=HzsS0O8BPivx5rPgCLl5ZVRJmEamA/R1NiD0AAW0/UYF/5FObmIpftnmcHEGsQzrUw+Qu4t7UteCNcpAxOPAyNElxnIZr5KyDIJjBs/tYaT/B14BWMBuDDmU3qslYWh+TlJBU9UgOoyYl/8kYmSviktYhCT3CIOK3ADYD7kzQc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098349; c=relaxed/simple;
	bh=k+QVXL1KjFCvARB3kwk0lP3ZZBQK0sQHKATkqTwQXmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFGzh0WCVo90l6293b0u0sbPm2X7LP7GhZIg6Vr1IcF2YuE2uj8yh3m4YMOxMz/PriwWFB8tAOJFbPknzFQhoBIsX/jee/h7/TuhqDT04xwbdIUgrgC3xDVbaDYEKRae6pxLubCsoeg9qVxOlOH6Z7xLwAYuuT4cAt96aMTc9Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AllDHoV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AllDHoV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE83BC2BCAF;
	Mon, 13 Apr 2026 16:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098349;
	bh=k+QVXL1KjFCvARB3kwk0lP3ZZBQK0sQHKATkqTwQXmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AllDHoV2edm779Afn0MMc5swZDQ+i1x4yw4iQzwjHsHQA7iFJLWAhzILfdr0qIXDw
	 23VU5NKsCgDqaxTq5zHWlb3rTHW3JBUhmgEXO6ChnANwSCvTEin7s+2u3wbNwe0VGz
	 azgbEVAMhQjYY/NO63ZeA3VMe+46qhk6kHQvDY/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YunJe Shin <ioerts@kookmin.ac.kr>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	linux-nvme@lists.infradead.org,
	Cengiz Can <cengiz.can@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 473/570] nvmet-tcp: fix use-before-check of sg in bounds validation
Date: Mon, 13 Apr 2026 18:00:04 +0200
Message-ID: <20260413155848.182068742@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cengiz Can <cengiz.can@canonical.com>

The stable backport of commit 52a0a9854934 ("nvmet-tcp: add bounds
checks in nvmet_tcp_build_pdu_iovec") placed the bounds checks after
the iov_len calculation:

    while (length) {
        u32 iov_len = min_t(u32, length, sg->length - sg_offset);

        if (!sg_remaining) {    /* too late: sg already dereferenced */

In mainline, the checks come first because C99 allows mid-block variable
declarations. The stable backport moved the declaration to the top of the
loop to satisfy C89 declaration rules, but this ended up placing the
sg->length dereference before the sg_remaining and sg->length guards.

If sg_next() returns NULL at the end of the scatterlist, the next
iteration dereferences a NULL pointer in the iov_len calculation before
the sg_remaining check can prevent it.

Fix this by moving the iov_len declaration to function scope and
keeping the assignment after the bounds checks, matching the ordering
in mainline.

Fixes: 42afe8ed8ad2 ("nvmet-tcp: add bounds checks in nvmet_tcp_build_pdu_iovec")
Cc: stable@vger.kernel.org
Cc: YunJe Shin <ioerts@kookmin.ac.kr>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Keith Busch <kbusch@kernel.org>
Cc: linux-nvme@lists.infradead.org
Signed-off-by: Cengiz Can <cengiz.can@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 8f7984c53f3f2..c6cc1dfef92cf 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -312,7 +312,7 @@ static void nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 {
 	struct bio_vec *iov = cmd->iov;
 	struct scatterlist *sg;
-	u32 length, offset, sg_offset;
+	u32 length, offset, sg_offset, iov_len;
 	unsigned int sg_remaining;
 	int nr_pages;
 
@@ -329,8 +329,6 @@ static void nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 	sg_remaining = cmd->req.sg_cnt - cmd->sg_idx;
 
 	while (length) {
-		u32 iov_len = min_t(u32, length, sg->length - sg_offset);
-
 		if (!sg_remaining) {
 			nvmet_tcp_fatal_error(cmd->queue);
 			return;
@@ -340,6 +338,8 @@ static void nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 			return;
 		}
 
+		iov_len = min_t(u32, length, sg->length - sg_offset);
+
 		iov->bv_page = sg_page(sg);
 		iov->bv_len = iov_len;
 		iov->bv_offset = sg->offset + sg_offset;
-- 
2.53.0



