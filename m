Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0CE375AC8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301700; cv=none; b=WnkhZGaiofIz7Pai23c7AtHQxVCpfpHJ9gdAAGRbfmFSE8Ws8S016SDKa0PF5HmopYea1bQ/G3o4HRy6XUFK1HV6AFx10a2w/Ihe04EGmNmop/EyEtOTW1JCKGvcJS8qakeFRTCsKA/8VqkWeJb8aD9mr0/JGa+hkshYrAK8b4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301700; c=relaxed/simple;
	bh=mI+wdgAwbsAkG4TZ0SztIQy85yl2XbqyWNpS7Vcdos0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqibwQGS/Vzab9bFuMFfinVm535IVRMNZZtqvZKFbhQR2QWjg6CegeIUG2cZsrX9hrm+lZ4tqd3lJ8K1h1NWs2oTMuJ5KglPsIUmqyZtIafj1PZ7J6VLztZEaOvMAJOLUzsFetBLc+S31kmav1bKD2pN5Cafrf3byRc5QmlVQp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N38WvLBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N38WvLBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF60C116D0;
	Sat, 28 Feb 2026 18:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301700;
	bh=mI+wdgAwbsAkG4TZ0SztIQy85yl2XbqyWNpS7Vcdos0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N38WvLBOtkJYhxY7MGNT0FZcQccIC1ZPZE0YE7R0esKKrE7Ep4LIWPlu5XymaTQtS
	 G9/u9ehEIa4lnU6ZTEX3dwJjz7kKBTaJy8Fz49s7iATQCpduZMBY/CFvh+WF8k2aKK
	 X69aPFIh8n8REIKxoChgh/Sg/t0frQE6f+8SJjVYn+90vchaD4dQQY3O5KrFHriMBt
	 +tUJ7p/pZ5qn6Vp9p8EgpOZ82j8wO5tkUVMLHdATf81wEOwq8rW6e8Dg+i6S1an5g1
	 CDWAEQq54mOkbQPOlAHpRtCkBOCUOpVtCDxnKFW2+59pwSNVPtPbtl2UE0ppq5xXSI
	 tMNTP3OQ5TIag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/385] EDAC/i5400: Fix snprintf() limit calculation in calculate_dimm_size()
Date: Sat, 28 Feb 2026 12:55:15 -0500
Message-ID: <20260228180011.1568201-93-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 72f12683611344853ab030fe7d19b23970ed2bd8 ]

The snprintf() can't really overflow because we're writing a max of 42
bytes to a PAGE_SIZE buffer.  But my static checker complains because
the limit calculation doesn't take the first 11 space characters that
we wrote into the buffer into consideration.  Fix this for the sake of
correctness even though it doesn't affect runtime.

Also delete an earlier "space -= n;" which was not used.

Fixes: 68d086f89b80 ("i5400_edac: improve debug messages to better represent the filled memory")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Link: https://patch.msgid.link/ccd06b91748e7ed8e33eeb2ff1e7b98700879304.1765290801.git.dan.carpenter@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i5400_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 49b4499269fb7..68afb3bb8e290 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -1025,13 +1025,13 @@ static void calculate_dimm_size(struct i5400_pvt *pvt)
 		space -= n;
 	}
 
-	space -= n;
 	edac_dbg(2, "%s\n", mem_buffer);
 	p = mem_buffer;
 	space = PAGE_SIZE;
 
 	n = snprintf(p, space, "           ");
 	p += n;
+	space -= n;
 	for (branch = 0; branch < MAX_BRANCHES; branch++) {
 		n = snprintf(p, space, "       branch %d       | ", branch);
 		p += n;
-- 
2.51.0

