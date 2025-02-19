Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0E51C5F29;
	Wed, 19 Feb 2025 08:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953966; cv=none; b=K4xZWOZhrGawHG+wnqU4cCCImVssEsM6AFRmITFsvMwUaNm3PhXpY74gcjsUCKMQNFfHrPGFbkWnW3rz0n85dz/8yzSFxEUF2xPlM3tnc5mbYrrWfKpn8hlKzawVPPqIJNWM1NzdaUJs6iYQJtt15q+rm9ApPj/2sBr3s29y20Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953966; c=relaxed/simple;
	bh=Yas5vfjYkO2pEnbxtwjW/5mbs2+k1lpA8dIakCyJfLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9H/fEvuC32sJyUvlC14sq+FVuo7OhPzOeXifYItBBbR+oVmP36Vi7z/FzCmEy0bUvCG/MpKLMFK/if8MFUoXvTpIW5iacIdVH7IptBQZ31zKlsViUX8Lyfcw7jigNBFMSQVmLMBeVDDHo4xYz088Myi0C/vvb6rHqLaZMRIwVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHNo7Yda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHNo7Yda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909ABC4CED1;
	Wed, 19 Feb 2025 08:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953966;
	bh=Yas5vfjYkO2pEnbxtwjW/5mbs2+k1lpA8dIakCyJfLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHNo7YdaoHw7xcG9YbV6Q9XjsblqRYZK3O9rrjx0xIqlN4NCqP7gLUa05P4G/ksOP
	 3gNZMVLeXA2lr05v+ATg3GHybky07tayWiaBCKcnhYmsEq8iBjz+4YBybbZma+F5Y7
	 hjHfgZxEyQUjBWoO+pdL56nzqHM7H8KW9V3o7OfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 053/274] io_uring/uring_cmd: remove dead req_has_async_data() check
Date: Wed, 19 Feb 2025 09:25:07 +0100
Message-ID: <20250219082611.594951401@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 0edf1283a9d1419a2095b4fcdd95c11ac00a191c ]

Any uring_cmd always has async data allocated now, there's no reason to
check and clear a cached copy of the SQE.

Fixes: d10f19dff56e ("io_uring/uring_cmd: switch to always allocating async data")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/uring_cmd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 25cae9f5575be..f43adcc16cf65 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -74,9 +74,6 @@ bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 			continue;
 
 		if (cmd->flags & IORING_URING_CMD_CANCELABLE) {
-			/* ->sqe isn't available if no async data */
-			if (!req_has_async_data(req))
-				cmd->sqe = NULL;
 			file->f_op->uring_cmd(cmd, IO_URING_F_CANCEL |
 						   IO_URING_F_COMPLETE_DEFER);
 			ret = true;
-- 
2.39.5



