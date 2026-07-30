Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BE72E9EC7;
	Thu, 30 Jul 2026 14:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421740; cv=none; b=n/EpOuW8C76XINf1b+I7PDSi3sIdpYWBwCAmZFYF62QA1P4HiIuv70+ntbdR60OMTRDwHwrnxrc8KWV58gve6ViQ0twXYEI8UcwdgN/q3v1zgveynTn3lEQYd9JF+Y8KyFyWD97oitR68kCfMTSSgTxxWz/PwLLGgPIVA2ZHnWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421740; c=relaxed/simple;
	bh=jAUJog20iOmk8CvibWR8HXB11GUYpKRQPt1G1SDOAEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCTF3qIZwHmvwnqdC5AhCFMy0gYUSSH6SQU+0uxqskH95/gDTgUgO6NzOdmLMHEjdGqy+tYvUem4ez2DSr+BxgIZMcBny0wXdCZ92hLs2K1rwm2/Tgj3SWs+t0qEJECu6Kmzvi5WKeiXbosvTDRiT8HCUtVw1NIN49vuNoA2pgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pxZWPoW7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pxZWPoW7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDB91F000E9;
	Thu, 30 Jul 2026 14:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421739;
	bh=s+iCWdQPPRCFEkoGoFeuKUlOoTOL/v2YlIMemmZbGxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pxZWPoW7A6QW3DGZWlHr5bcfPjnru35M0dwUvpDCSo+cVSPasgksX8tOPvpLsaBzx
	 J427iSB6En2BF5JyOFLEUUFtnU9jXlcxJXqHSC0lpfBUWjn58zoailv0TsWF8x1LBv
	 iNKJdlvrv2/jm/UrZOKPTfE8etAELUu59zc6TyuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 204/744] arm_mpam: guard MBWU state before adding it to garbage
Date: Thu, 30 Jul 2026 16:07:57 +0200
Message-ID: <20260730141448.616520999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 977f52909c624210178a1247fab0b02b110c1106 ]

__destroy_component_cfg() adds each RIS mbwu_state object to the MPAM
garbage list when destroying component configuration.

However, mbwu_state is allocated per RIS and only for RISes with MBWU
monitors. A component can therefore have comp->cfg allocated while some
RISes still have ris->mbwu_state set to NULL.

Passing a NULL mbwu_state to add_to_garbage() dereferences the NULL
pointer inside the macro.

Skip RISes that do not have an mbwu_state object before adding them to
the garbage list.

Fixes: 41e8a14950e1 ("arm_mpam: Track bandwidth counter state for power management")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_devices.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 18ae935e8d51a5..43dfce57fae1c1 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -2595,8 +2595,10 @@ static void __destroy_component_cfg(struct mpam_component *comp)
 		msc = vmsc->msc;
 
 		if (mpam_mon_sel_lock(msc)) {
-			list_for_each_entry(ris, &vmsc->ris, vmsc_list)
-				add_to_garbage(ris->mbwu_state);
+			list_for_each_entry(ris, &vmsc->ris, vmsc_list) {
+				if (ris->mbwu_state)
+					add_to_garbage(ris->mbwu_state);
+			}
 			mpam_mon_sel_unlock(msc);
 		}
 	}
-- 
2.53.0



