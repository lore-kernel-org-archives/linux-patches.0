Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA69318C03D;
	Mon, 28 Oct 2024 06:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097236; cv=none; b=Bk5VtUqbRp5vM+tvr3N75A6K4YMdfxkdWX083v7QqAPpjGIeql0bO5SCLyC87IS2vDoEPJpiDmzZ6fXmpu/GG6aKBbKD4Kf3VLBO8bVO/nOk7E1PDkPBYgNvssilbntGyRx8S9QNKBlYUvkMGoXpyTyxMcfxXg/jQM/xuu/0wXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097236; c=relaxed/simple;
	bh=x0KqzL+V/M8oBEIaDtn6ZepLIrRLF3o7wRxHYiBK1vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4AFlwhoWHLjl5+IIWUU261HlPkN1kbIDtzAYc8ki0EFx+t6itaDbDn/voJUtOHdi1zSv55RyF2eEVhV4BU/EdjC9YSn5d5JpctljEhAckYoz4mD36h0ZuM3pCu8cbtn0h6m5218sEOXVSi1tz7lOVBvBls6n579Z8OrACBnL+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ie21xRup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ie21xRup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87776C4CEC7;
	Mon, 28 Oct 2024 06:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097235;
	bh=x0KqzL+V/M8oBEIaDtn6ZepLIrRLF3o7wRxHYiBK1vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ie21xRuphD8o6I0NTvAbJOE3TtOqOa8B6d4EUyKfGARI+v/dEevU08a9g43Ph76Y6
	 t5J9HCeRtWqblWtOv6TUmK2GWF+1xTSn0zFxAklSAa7XzsVgkFhA5C4/VoWHi86t+V
	 W2BHVQWUERY6w6QH0wPZTx6DY0JsxtbLEa1JHdP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/137] drm/msm: Avoid NULL dereference in msm_disp_state_print_regs()
Date: Mon, 28 Oct 2024 07:24:22 +0100
Message-ID: <20241028062259.422801686@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index add72bbc28b17..bb149281d31fa 100644
--- a/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
+++ b/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
@@ -48,20 +48,21 @@ static void msm_disp_state_dump_regs(u32 **reg, u32 aligned_len, void __iomem *b
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
@@ -89,7 +90,7 @@ void msm_disp_state_print(struct msm_disp_state *state, struct drm_printer *p)
 
 	list_for_each_entry_safe(block, tmp, &state->blocks, node) {
 		drm_printf(p, "====================%s================\n", block->name);
-		msm_disp_state_print_regs(&block->state, block->size, block->base_addr, p);
+		msm_disp_state_print_regs(block->state, block->size, block->base_addr, p);
 	}
 
 	drm_printf(p, "===================dpu drm state================\n");
-- 
2.43.0



