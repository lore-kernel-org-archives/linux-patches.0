Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2DC1C6AB;
	Mon,  4 Mar 2024 21:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588790; cv=none; b=jAlHaqlbLfn0/ZEK7bhs5ehoYdz7MfmtxkPY0DVyf4kW99rDd21soCcYeCQuCTCowYxPdCJJUVPHk+mKAXhqMDCX7nFyw9s0fgzltq2xxkaak+aWEf4fkIErK7Xr7wTjL3t85mN8miinITcU7rzyHcWxl3D1uHVJgkA8U4FFKEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588790; c=relaxed/simple;
	bh=57DxTgJzmRyyUblSpM+GWY86fQVE3mgG7pPqq/Xw3dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1hl3ZOGbZRhuQczZ+VBNDyUVHXuXjDOH6nIct6buFYG1AgdqvF1XkQrlTumSOJRBDQr9uBumZbtdb5AkahRM6qRwn4vOwfb69+qbu8tHK///ATzMdDXvxhBbBJ9GiTWPlSeK520JVe15fE0rQSR7zL+sPJeHgaxBJ8Qtk6nd+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4EXknaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4EXknaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845D0C433F1;
	Mon,  4 Mar 2024 21:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588789;
	bh=57DxTgJzmRyyUblSpM+GWY86fQVE3mgG7pPqq/Xw3dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4EXknaTT3QspNcfqgntIb+z9XvQ7cRzDtX33Ize+HxF3I381+zt1a/jMVejXnKfx
	 W9Hr7WqNVBzp0RMSCHcag/e4lZflD1kKMij6LvFfG+0n8ydEEMllaa24Lz0CpwSlyX
	 DN61K7jbLLltKHtCXNmD5yX8Rogh1cC3c4BBM+Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 073/215] ALSA: firewire-lib: fix to check cycle continuity
Date: Mon,  4 Mar 2024 21:22:16 +0000
Message-ID: <20240304211559.299733351@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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


