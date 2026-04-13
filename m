Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B4C299929;
	Mon, 13 Apr 2026 17:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099615; cv=none; b=DVevhm4oZPXC1eCoBJ8CSe39r4oJvo0RjmaLK5a8+M7X+/BoDOsxZi77r5ZrP87thLrTp9Ed9IDX4QCUiCR3mXpiD4FBq4JmRv+qgq/k3UUEcut6pWGyUMPnI7ADGjVbSAyuETMz99igXAoNNWmdemGxfIW/3PsZb94rMu9B0gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099615; c=relaxed/simple;
	bh=ZWntAkkj+FDQR+Wh+BTq5BACdUov9m/5CpM5nrE0wOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcLIezU27aqhl8fnon26QqmqbnMTdezvUFc1WGnvtS6eDh2ryiLrEMJYGaRTti1PtLDrzy+BcDcggiM5y+ner+Xo4ki8BH1MfOhBvvscv/cN8Gogv5zq8eOQGFVeRVSNCWMwsIMsYzELC8en06tdor4/83inQYRPPoiRIcW8Lm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ei2CfFet; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ei2CfFet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14B0C2BCAF;
	Mon, 13 Apr 2026 17:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099615;
	bh=ZWntAkkj+FDQR+Wh+BTq5BACdUov9m/5CpM5nrE0wOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ei2CfFetzMDdYZLezjtaK/fs3jUYp73cQj9l3iL/rh6oLIdoLc+qdOnrtOWl4/OPN
	 r/koPj3RxpdBskppyS5Py1hl2YsVHx8t/kLP0olNONCZv2/EEJ7XHnT9kj1SKdZEha
	 FbT/EAinJewmeSzmuNJLD7h+gAWYAeTpDxbOOTc8=
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
Subject: [PATCH 5.10 408/491] nvmet-tcp: fix use-before-check of sg in bounds validation
Date: Mon, 13 Apr 2026 18:00:53 +0200
Message-ID: <20260413155834.306257066@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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

Fixes: 043b4307a99f ("nvmet-tcp: add bounds checks in nvmet_tcp_build_pdu_iovec")
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
index 5d8e57e5fdb18..6db9dcdbb3c34 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -300,7 +300,7 @@ static void nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 {
 	struct bio_vec *iov = cmd->iov;
 	struct scatterlist *sg;
-	u32 length, offset, sg_offset;
+	u32 length, offset, sg_offset, iov_len;
 	unsigned int sg_remaining;
 	int nr_pages;
 
@@ -317,8 +317,6 @@ static void nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 	sg_remaining = cmd->req.sg_cnt - cmd->sg_idx;
 
 	while (length) {
-		u32 iov_len = min_t(u32, length, sg->length - sg_offset);
-
 		if (!sg_remaining) {
 			nvmet_tcp_fatal_error(cmd->queue);
 			return;
@@ -328,6 +326,8 @@ static void nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 			return;
 		}
 
+		iov_len = min_t(u32, length, sg->length - sg_offset);
+
 		iov->bv_page = sg_page(sg);
 		iov->bv_len = iov_len;
 		iov->bv_offset = sg->offset + sg_offset;
-- 
2.53.0



