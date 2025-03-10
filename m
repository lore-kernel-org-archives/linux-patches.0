Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC85A231A24;
	Mon, 10 Mar 2025 17:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626807; cv=none; b=Y4RFPX3DZc5M6UjpYjMF/VDynS5f5oK2KXVDALLN3JzbJ+QSt/zh8uEKgJPtZwtnDAGeYC4KCmq1Z2KLEr2M2TuhkdRza3xd0hsvRW5ZrK1daUGCZQHRaMRySufKuyQijzIv/rkdw3e0ibV5MwOmtNe0szk9UE1arJ/z8MJPquw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626807; c=relaxed/simple;
	bh=DPOJay1pMmwmP/DlMk5NoZnhoqcLxWFFRIBPp3qUsNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZ0p/TXNJbhpFYpy6vM7okIFSuo1Nc/oyGZRWVWJaAtmPTeCkRjST0hf5gVCCUx/8Qo+myU3VJWsWuDMW2CWNcfT2Bjn5CCoLuVuyOAgbvXYNmS4AhkTBYws2Z9en1ZMEP69P9HgoQ+ZFUqKyrp7KJpxVpPgzaDCGUPba8Ysfw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVPp9cFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVPp9cFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F75C4CEE5;
	Mon, 10 Mar 2025 17:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626807;
	bh=DPOJay1pMmwmP/DlMk5NoZnhoqcLxWFFRIBPp3qUsNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVPp9cFkNk/zcY3XqDKHCNLIUnOO5uipNzDdwEIsVgfDiiEfg2r1OYWo4BDXXJ/5m
	 uD0HM7iPe0BBPteznMIeXhlRNu3Lr0iHylzo9koB1hn6p9liawiDp+5dJvsPUf71jA
	 sqjxn91m2mHuzgTe0oT4s4d+mDpStk1GnlrLWAjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessio Belle <alessio.belle@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 120/207] drm/imagination: Fix timestamps in firmware traces
Date: Mon, 10 Mar 2025 18:05:13 +0100
Message-ID: <20250310170452.578396693@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessio Belle <alessio.belle@imgtec.com>

[ Upstream commit 1d2eabb6616433ccaa13927811bdfa205e91ba60 ]

When firmware traces are enabled, the firmware dumps 48-bit timestamps
for each trace as two 32-bit values, highest 32 bits (of which only 16
useful) first.

The driver was reassembling them the other way round i.e. interpreting
the first value in memory as the lowest 32 bits, and the second value
as the highest 32 bits (then truncated to 16 bits).

Due to this, firmware trace dumps showed very large timestamps even for
traces recorded shortly after GPU boot. The timestamps in these dumps
would also sometimes jump backwards because of the truncation.

Example trace dumped after loading the powervr module and enabling
firmware traces, where each line is commented with the timestamp value
in hexadecimal to better show both issues:

[93540092739584] : Host Sync Partition marker: 1    // 0x551300000000
[28419798597632] : GPU units deinit                 // 0x19d900000000
[28548647616512] : GPU deinit                       // 0x19f700000000

Update logic to reassemble the timestamps halves in the correct order.

Fixes: cb56cd610866 ("drm/imagination: Add firmware trace to debugfs")
Signed-off-by: Alessio Belle <alessio.belle@imgtec.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250221-fix-fw-trace-timestamps-v1-1-dba4aeb030ca@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_fw_trace.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/imagination/pvr_fw_trace.c b/drivers/gpu/drm/imagination/pvr_fw_trace.c
index 73707daa4e52d..5dbb636d7d4ff 100644
--- a/drivers/gpu/drm/imagination/pvr_fw_trace.c
+++ b/drivers/gpu/drm/imagination/pvr_fw_trace.c
@@ -333,8 +333,8 @@ static int fw_trace_seq_show(struct seq_file *s, void *v)
 	if (sf_id == ROGUE_FW_SF_LAST)
 		return -EINVAL;
 
-	timestamp = read_fw_trace(trace_seq_data, 1) |
-		((u64)read_fw_trace(trace_seq_data, 2) << 32);
+	timestamp = ((u64)read_fw_trace(trace_seq_data, 1) << 32) |
+		read_fw_trace(trace_seq_data, 2);
 	timestamp = (timestamp & ~ROGUE_FWT_TIMESTAMP_TIME_CLRMSK) >>
 		ROGUE_FWT_TIMESTAMP_TIME_SHIFT;
 
-- 
2.39.5



