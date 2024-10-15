Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3151C07ED;
	Tue, 15 Oct 2024 13:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997905; cv=none; b=o9ln3z68zkPQpg/9DN8TlfCmrq63DN+fuiGqxtb+ibTfCfzEbkmgabnnnYFuOPRAtPlp9vb3UXDzntvowiVxL36DFtrrYoGtnlvPlAMAtT43L9XaClrOM0PkjLxGbjtQrL85HaaE4XjpQtUv4udlS32z+3atgnWoKckOfB5/YV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997905; c=relaxed/simple;
	bh=AiyV5Y4OXDQWhiuFSGWAdUVU82X7QplrMWHrkbR1PFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRUSqBuAp1/xTw00BIZXQpG/AvuxB7tfZDuRz0raEKN0YShFbhW3kr6kxXuzXk9rjBWnYX75tqYXQUBvigv89sx5UqwWXWpgjDwoo+ZhX32hEyOQHkbBl+w0auoFBUtWoqZlKXdGmT43zvqfvpek0hs3d80uF3kH16RXoEO9RT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmB9qpv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmB9qpv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BDFC4CEC6;
	Tue, 15 Oct 2024 13:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997905;
	bh=AiyV5Y4OXDQWhiuFSGWAdUVU82X7QplrMWHrkbR1PFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmB9qpv5rZVuxeMVpBo5psN+4Syufxq2sqIhziesj+1KIV4/15UzqPglp7nisuzjw
	 AvNpJz03g8ZYBm16yOMS5hlpMUNmj3HqHMqBREEs8DiXtzix6icb/2QB5OtGcF+9Of
	 i/jin7Tdt6wseC8b1Lw/lTt/KFxPcso9HxCdeqpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 322/518] ALSA: asihpi: Fix potential OOB array access
Date: Tue, 15 Oct 2024 14:43:46 +0200
Message-ID: <20241015123929.407760671@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7b986c7430a6bb68d523dac7bfc74cbd5b44ef96 ]

ASIHPI driver stores some values in the static array upon a response
from the driver, and its index depends on the firmware.  We shouldn't
trust it blindly.

This patch adds a sanity check of the array index to fit in the array
size.

Link: https://patch.msgid.link/20240808091454.30846-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/asihpi/hpimsgx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/asihpi/hpimsgx.c b/sound/pci/asihpi/hpimsgx.c
index f7427f8eb6303..761fc62f68f16 100644
--- a/sound/pci/asihpi/hpimsgx.c
+++ b/sound/pci/asihpi/hpimsgx.c
@@ -713,7 +713,7 @@ static u16 HPIMSGX__init(struct hpi_message *phm,
 		phr->error = HPI_ERROR_PROCESSING_MESSAGE;
 		return phr->error;
 	}
-	if (hr.error == 0) {
+	if (hr.error == 0 && hr.u.s.adapter_index < HPI_MAX_ADAPTERS) {
 		/* the adapter was created successfully
 		   save the mapping for future use */
 		hpi_entry_points[hr.u.s.adapter_index] = entry_point_func;
-- 
2.43.0



