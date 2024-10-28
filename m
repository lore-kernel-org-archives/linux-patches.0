Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0CF18DF8B;
	Mon, 28 Oct 2024 06:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096850; cv=none; b=rkfySvxRLlxu4uLEyVb29uX3kPyuNGYKVCRK7FQFIhxudpWrgtggqNrS5ECi1huE5ROsutGx+wkGcAflZIU1hWRZu5yBlWOg3+GoK2Eiz0EO06O56QRZTwjXBLtx/5itIERAoDSrMdL6gCqhOPvkYTZFBUkT7wfqDWEOdTMrk14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096850; c=relaxed/simple;
	bh=Z1iJAxZXJ6ijQD1KpnDHjkGf1nr5SiaWS62VL5uR8Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cc3W3jRe+nZzH2ATwPsdHJe6mYTqqJfpw1RqrR7tv6XiDnFoMCu+/8whdZi+RRLZ+9RwZM+pFtRb08KmyohGwhBlRVss5MIkcNXxbpcyEI0a/wr9JtjJz8ATKX5WKoAqsOXQcYjsibyPS6WtuPF5UgwkXLjVBOKEgJxIxRW8M2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUhzVxmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUhzVxmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32448C4CEC3;
	Mon, 28 Oct 2024 06:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096849;
	bh=Z1iJAxZXJ6ijQD1KpnDHjkGf1nr5SiaWS62VL5uR8Ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YUhzVxmqFFwBLuNq0B4seLmi9VUPEvkT/PKPYvszyqN/r6OqmwyI/ynuZQaeBD9Gl
	 tnaCzNEk3WqTwa2G8xEhXUI8W9ecDUp/dIcDUYbMNXAtD593H8a578yVxkHhEuZqsc
	 7hMmAO2IqOZI3jDzUgDveYhZKNroA+D23oRcYnv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/80] drm/msm: Avoid NULL dereference in msm_disp_state_print_regs()
Date: Mon, 28 Oct 2024 07:24:54 +0100
Message-ID: <20241028062253.019032131@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 293f53263266bc4340d777268ab4328a97f041fa ]

If the allocation in msm_disp_state_dump_regs() failed then
`block->state` can be NULL. The msm_disp_state_print_regs() function
_does_ have code to try to handle it with:

  if (*reg)
    dump_addr = *reg;

...but since "dump_addr" is initialized to NULL the above is actually
a noop. The code then goes on to dereference `dump_addr`.

Make the function print "Registers not stored" when it sees a NULL to
solve this. Since we're touching the code, fix
msm_disp_state_print_regs() not to pointlessly take a double-pointer
and properly mark the pointer as `const`.

Fixes: 98659487b845 ("drm/msm: add support to take dpu snapshot")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/619657/
Link: https://lore.kernel.org/r/20241014093605.1.Ia1217cecec9ef09eb3c6d125360cc6c8574b0e73@changeid
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c b/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
index 8746ceae8fca9..06f2f5a5e267e 100644
--- a/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
+++ b/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
@@ -46,20 +46,21 @@ static void msm_disp_state_dump_regs(u32 **reg, u32 aligned_len, void __iomem *b
 	}
 }
 
-static void msm_disp_state_print_regs(u32 **reg, u32 len, void __iomem *base_addr,
-		struct drm_printer *p)
+static void msm_disp_state_print_regs(const u32 *dump_addr, u32 len,
+		void __iomem *base_addr, struct drm_printer *p)
 {
 	int i;
-	u32 *dump_addr = NULL;
 	void __iomem *addr;
 	u32 num_rows;
 
+	if (!dump_addr) {
+		drm_printf(p, "Registers not stored\n");
+		return;
+	}
+
 	addr = base_addr;
 	num_rows = len / REG_DUMP_ALIGN;
 
-	if (*reg)
-		dump_addr = *reg;
-
 	for (i = 0; i < num_rows; i++) {
 		drm_printf(p, "0x%lx : %08x %08x %08x %08x\n",
 				(unsigned long)(addr - base_addr),
@@ -86,7 +87,7 @@ void msm_disp_state_print(struct msm_disp_state *state, struct drm_printer *p)
 
 	list_for_each_entry_safe(block, tmp, &state->blocks, node) {
 		drm_printf(p, "====================%s================\n", block->name);
-		msm_disp_state_print_regs(&block->state, block->size, block->base_addr, p);
+		msm_disp_state_print_regs(block->state, block->size, block->base_addr, p);
 	}
 
 	drm_printf(p, "===================dpu drm state================\n");
-- 
2.43.0



