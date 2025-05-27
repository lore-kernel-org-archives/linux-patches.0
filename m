Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E321742A9B;
	Tue, 27 May 2025 17:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368176; cv=none; b=iTAF27l5wb8FsuScoXI5l+B4ShW1eMJgUK+8L28lDn40WywHolTogQodXelmnuKivGxSaYYfCEWNLmJugVkoSCF5xgI9Xj6QhBu7lcBZWDKGHDHFOuak0uqG2csUazuQNjW2rfcNorBuYGwTdNqNTGqes7PUB7vmgfoysV2hAng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368176; c=relaxed/simple;
	bh=rqwhdFXj/Cpb1LMPtxfDia55+nvf6v0aesl51l2eRj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdzuA0F6DnsDukUDdwC8Lvq2KoH4TP9Bjn2jrTIqKGW1Rxm6HaBZq3FbdeGdlHfALU/4LHRRs+O3/jU16Df6rLeTLngbL3yNlvdYBqvWI7aySt9/EWd+flKndXxdSMWyirD9Cn69DhoKFp7EFArmyXYsPgpR8DlbUI7RDLz5OdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkL2E6cd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkL2E6cd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0ABDC4CEEA;
	Tue, 27 May 2025 17:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368175;
	bh=rqwhdFXj/Cpb1LMPtxfDia55+nvf6v0aesl51l2eRj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkL2E6cdXMQVWnwncTb/3xrqtG8pew1GC7U/AOJobPsUW+Nx2O3PabEZBa5UGSsgG
	 5DK95J9BtHxXl8dO9HWfASmRfsXEZAZoEbLeVLj2OQ7ZQNXhR4/vmHrkfxm4PCYarS
	 NyQpu9UF7XrrgGPxpZsZ8vMGKN8JbC4ekW0s43WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Harrison <John.C.Harrison@Intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 623/783] drm/xe/guc: Drop error messages about missing GuC logs
Date: Tue, 27 May 2025 18:27:00 +0200
Message-ID: <20250527162538.522597755@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit 174e9ce0daf6af791386e96e76e743eb59e8a401 ]

The GuC log snapshot code would complain loudly if there was no GuC
log to take a snapshot of or if the snapshot alloc failed. Originally,
this code was only called on demand when a user (or developer)
explicitly requested a dump of the log. Hence an error message was
useful.

However, it is now part of the general devcoredump file and is called
for any GPU hang. Most people don't care about GuC logs and GPU hangs
do not generally mean a kernel/GuC bug. More importantly, there are
valid situations where there is no GuC log, e.g. SRIOV VFs.

So drop the error message.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/3958
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250113194405.2033085-1-John.C.Harrison@Intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_log.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_log.c b/drivers/gpu/drm/xe/xe_guc_log.c
index 0ca3056d8bd3f..80514a446ba28 100644
--- a/drivers/gpu/drm/xe/xe_guc_log.c
+++ b/drivers/gpu/drm/xe/xe_guc_log.c
@@ -149,16 +149,12 @@ struct xe_guc_log_snapshot *xe_guc_log_snapshot_capture(struct xe_guc_log *log,
 	size_t remain;
 	int i;
 
-	if (!log->bo) {
-		xe_gt_err(gt, "GuC log buffer not allocated\n");
+	if (!log->bo)
 		return NULL;
-	}
 
 	snapshot = xe_guc_log_snapshot_alloc(log, atomic);
-	if (!snapshot) {
-		xe_gt_err(gt, "GuC log snapshot not allocated\n");
+	if (!snapshot)
 		return NULL;
-	}
 
 	remain = snapshot->size;
 	for (i = 0; i < snapshot->num_chunks; i++) {
-- 
2.39.5



