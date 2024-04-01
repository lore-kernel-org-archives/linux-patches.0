Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6E81CA8F;
	Mon,  1 Apr 2024 16:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988733; cv=none; b=WxOA8lTKZDJAbBnG+FoTJMCDtHBsJnkOPdSfENcBDC0um0EV4bVEzYMGv8/UNf6IN1MSW1byrqc7lK71L5aIe5dCBNFhU3TjwyrGcmJHxROXBQv6Xb/RIdQuz2FpGMXCJVPS/tSgO2fqsorUjgF7OkujeDglyzFKcVlMuvCq19Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988733; c=relaxed/simple;
	bh=CnsYTna+yJ6BP3jbnWue+F7cwYPMI0IMcS4AtmDZLSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxCqWVN5x8FnW6g3LfvSV5SCGFFEI29wxZyicoSw3ADU2E+DGtZwceS42JKItAQQ6r5EPG1Nbdb2gXHcNhdRPotKZmTRNW2R1wLWlCYoLaEO32r7yC/bdL/4vf+TWDgYQo6sTv6w9Z24f4Tw8knZTy45d3OpvcVPKgWeuC5meyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9ytDhJg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9ytDhJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E586C433C7;
	Mon,  1 Apr 2024 16:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988733;
	bh=CnsYTna+yJ6BP3jbnWue+F7cwYPMI0IMcS4AtmDZLSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9ytDhJgZxNmUQW37U16yn/TCIwST5pzlCtaX3pX0iFiUKAflBMYMeYslkGLEIwn3
	 r1yxiVL+qIdqpLDfPCBEhXIi1eNf1U25Trrtsn33W9UvnGkR9AJViYUTuDC7H51dLz
	 5r96mQbKV18fpROyob7OVkPemaVD8h/Da49HMIoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <nico@fluxnic.net>,
	stable <stable@kernel.org>
Subject: [PATCH 6.7 273/432] vt: fix unicode buffer corruption when deleting characters
Date: Mon,  1 Apr 2024 17:44:20 +0200
Message-ID: <20240401152601.317738949@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Pitre <nico@fluxnic.net>

commit 1581dafaf0d34bc9c428a794a22110d7046d186d upstream.

This is the same issue that was fixed for the VGA text buffer in commit
39cdb68c64d8 ("vt: fix memory overlapping when deleting chars in the
buffer"). The cure is also the same i.e. replace memcpy() with memmove()
due to the overlaping buffers.

Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
Fixes: 81732c3b2fed ("tty vt: Fix line garbage in virtual console on command line edition")
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/sn184on2-3p0q-0qrq-0218-895349s4753o@syhkavp.arg
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -381,7 +381,7 @@ static void vc_uniscr_delete(struct vc_d
 		u32 *ln = vc->vc_uni_lines[vc->state.y];
 		unsigned int x = vc->state.x, cols = vc->vc_cols;
 
-		memcpy(&ln[x], &ln[x + nr], (cols - x - nr) * sizeof(*ln));
+		memmove(&ln[x], &ln[x + nr], (cols - x - nr) * sizeof(*ln));
 		memset32(&ln[cols - nr], ' ', nr);
 	}
 }


