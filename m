Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A50E1CF5C6;
	Wed,  7 May 2025 18:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644208; cv=none; b=SnTJb6gYsSIh3lvkrcGGSTBveoXrQ6Sa972HZEv5GDH8dH6NHDy4nfycs4ZY1lfbKJ1BZ1zYg2PRByrN3JxZpsWq/sc4QSduhWcQcLdoLSXjyuldDQFBHx1oYzkm4ddNokAPMcuMmY8C0FjpAVB6GtgILJA+7qkUtV2FiXSMxVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644208; c=relaxed/simple;
	bh=wzBIWoru3KETX3qKua7/D7bXTvc4HCwYdSp4KqYMYl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8jMOWX6gC7QLEwdwjayRpR435JR+olfxpQfHVeFX/73/l4xvEarAfk1aEWSHf7I0m459IC1qcK+vJRCusUydV7NORN4EoCRBdRxq2jPmybc5N4/PkNn3fSB+B8nDudMpo4q1d4r4pEfZZrMCmX7dOBpyYZ62Ah0wuL8/teV7D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNTem74k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNTem74k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2766C4CEE2;
	Wed,  7 May 2025 18:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644208;
	bh=wzBIWoru3KETX3qKua7/D7bXTvc4HCwYdSp4KqYMYl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNTem74kH9fQDziWRhA/9ipSOddjYbMi5ApHcDbV0kZ4hJcZy7veeUhPJEGj8YCRk
	 QeuWEW1Uw4rUy10vtpthm5Ip/unE/4HffgyL74BhFCfHLsw5/kUnnA7ph5yGbuAO3b
	 puVnHq24LZpVhABpmm+Os6BPFVqiGwao7ni2Fu2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.14 154/183] ublk: add helper of ublk_need_map_io()
Date: Wed,  7 May 2025 20:39:59 +0200
Message-ID: <20250507183831.101596870@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 1d781c0de08c0b35948ad4aaf609a4cc9995d9f6 ]

ublk_need_map_io() is more readable.

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250327095123.179113-5-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -594,6 +594,11 @@ static inline bool ublk_support_user_cop
 	return ubq->flags & UBLK_F_USER_COPY;
 }
 
+static inline bool ublk_need_map_io(const struct ublk_queue *ubq)
+{
+	return !ublk_support_user_copy(ubq);
+}
+
 static inline bool ublk_need_req_ref(const struct ublk_queue *ubq)
 {
 	/*
@@ -921,7 +926,7 @@ static int ublk_map_io(const struct ublk
 {
 	const unsigned int rq_bytes = blk_rq_bytes(req);
 
-	if (ublk_support_user_copy(ubq))
+	if (!ublk_need_map_io(ubq))
 		return rq_bytes;
 
 	/*
@@ -945,7 +950,7 @@ static int ublk_unmap_io(const struct ub
 {
 	const unsigned int rq_bytes = blk_rq_bytes(req);
 
-	if (ublk_support_user_copy(ubq))
+	if (!ublk_need_map_io(ubq))
 		return rq_bytes;
 
 	if (ublk_need_unmap_req(req)) {
@@ -1914,7 +1919,7 @@ static int __ublk_ch_uring_cmd(struct io
 		if (io->flags & UBLK_IO_FLAG_OWNED_BY_SRV)
 			goto out;
 
-		if (!ublk_support_user_copy(ubq)) {
+		if (ublk_need_map_io(ubq)) {
 			/*
 			 * FETCH_RQ has to provide IO buffer if NEED GET
 			 * DATA is not enabled
@@ -1936,7 +1941,7 @@ static int __ublk_ch_uring_cmd(struct io
 		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
 			goto out;
 
-		if (!ublk_support_user_copy(ubq)) {
+		if (ublk_need_map_io(ubq)) {
 			/*
 			 * COMMIT_AND_FETCH_REQ has to provide IO buffer if
 			 * NEED GET DATA is not enabled or it is Read IO.


