Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AEB23373C;
	Mon, 10 Mar 2025 17:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627572; cv=none; b=I7Ev3Ri8+InycvuGSGB94eNi7yrLABaN5wnJRe6slJpKIKgR2lCBcZ8gRO7I7iJei+PcPsEMuJj1pka4hm7603Rexul2o2b6xI7B4dxvNRkrAvMWRpiWW+nS8rElGmWqeaeAwTA8momTSmpApyMGfsJjCR3RwoOG1qsokfFAFeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627572; c=relaxed/simple;
	bh=gxKz7+Fkc8BkjdermLYwU4Vw4ZX7vj8A1zu7MbKCyqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZOU6SxM/NSMsXj/EFt3zON13UH+AzGY6rgQe2YoqqcMKj+xFeQtnQOjm01aU/1pVS0DGa8YRMEhUtt9jXAGsdhjXffEUpUC2jeD8tomEmScLnwETGNiBHI5n5h8Am5OpSnxOatTJ8ETGbYV7MkWsNKiBZric6wbZdquLro0kIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgJOESZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgJOESZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF82C4CEE5;
	Mon, 10 Mar 2025 17:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627572;
	bh=gxKz7+Fkc8BkjdermLYwU4Vw4ZX7vj8A1zu7MbKCyqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgJOESZsepJia/soH/diAlroESzqZ0Y7Omw6eNIRWgrRo9+mCbExuSP4U3q04ZApC
	 /aLkHI4zk6A2vM9mmnXklC9rDI65/BBg3W9qsVEoH+jPIjltuICTRaEq72q793Ibwq
	 KaYvENh1Zt4DEqoP9eZTgs+bWNpm99JzSIscKHV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessio Belle <alessio.belle@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 174/269] drm/imagination: Fix timestamps in firmware traces
Date: Mon, 10 Mar 2025 18:05:27 +0100
Message-ID: <20250310170504.649837008@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



