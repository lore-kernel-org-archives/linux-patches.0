Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33741C6AB;
	Mon,  4 Mar 2024 21:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589342; cv=none; b=nhYrRC4+8BFS6JxYFuza9aDTc4XstCFouyzQScWSp5rUeKa6fE6qHT77pMTMskaz/9tJbzjdE9eqoSj1JgHznrfZL+thr58zSTVpalKj+gCGqi2Ys6esm7faB+ffMgghpJdAn9KKS5pmR6WS09EbECvQRlhMMzwKIN+nD1FBxb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589342; c=relaxed/simple;
	bh=Y/ZO1TICDmy920gfOWQCwvZRwmsRZ9LDhgPsjwoLPRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DbM7kB9DmsZ/+iywWU58pplvGBQqJGp2dCNvq0YomzxY51G7ueGsA9n5tjDXKuRgfv+EpN0LQ1huPwTX2HFziBAooWOwP+gu+ORDcT7S2W78y0GlIZYssRwpNCreYuFB2Vtko2rIsD2Q3cR3JIuBAXlzTad8jrLfPava2LFoyjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMV4iHZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMV4iHZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D63C433C7;
	Mon,  4 Mar 2024 21:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589342;
	bh=Y/ZO1TICDmy920gfOWQCwvZRwmsRZ9LDhgPsjwoLPRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMV4iHZG8dLpO0Y/pMzawV3uj7aTpRsfPxZPCTRJA7wzt0S+ZgVlFXd5dD0E0+aeZ
	 s1ITrhvg9lC+i9x5mtvljULsB9xFOlFRp4x//+WvIv41e1UtMDeQX9VbaB3iWJ/IlK
	 c6WvRIWg18WA19Xnwfio9ZxCTjnpMC7ikg1BzZJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 48/84] ALSA: firewire-lib: fix to check cycle continuity
Date: Mon,  4 Mar 2024 21:24:21 +0000
Message-ID: <20240304211543.958026645@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 77ce96543b03f437c6b45f286d8110db2b6622a3 upstream.

The local helper function to compare the given pair of cycle count
evaluates them. If the left value is less than the right value, the
function returns negative value.

If the safe cycle is less than the current cycle, it is the case of
cycle lost. However, it is not currently handled properly.

This commit fixes the bug.

Cc: <stable@vger.kernel.org>
Fixes: 705794c53b00 ("ALSA: firewire-lib: check cycle continuity")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20240218033026.72577-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/amdtp-stream.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/firewire/amdtp-stream.c
+++ b/sound/firewire/amdtp-stream.c
@@ -934,7 +934,7 @@ static int generate_device_pkt_descs(str
 				// to the reason.
 				unsigned int safe_cycle = increment_ohci_cycle_count(next_cycle,
 								IR_JUMBO_PAYLOAD_MAX_SKIP_CYCLES);
-				lost = (compare_ohci_cycle_count(safe_cycle, cycle) > 0);
+				lost = (compare_ohci_cycle_count(safe_cycle, cycle) < 0);
 			}
 			if (lost) {
 				dev_err(&s->unit->device, "Detect discontinuity of cycle: %d %d\n",


