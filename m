Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B7D2571CE;
	Mon, 24 Feb 2025 14:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408429; cv=none; b=BdY67+x5aoh+ujG4+dlj7Ovmji+1C/LSHJObugO01x6YwrqTZw/f+I4gJS8BqTLY687zOEX3EVhMOHyR2aAjSs8XIPn2MUDQnDJPlz6e6XO/Pz0Zo6CbqSRwZLn6O1sPzr27/yhtjxoluTzVe8X8WwFqxPsXhWVovwcFDy4Sq68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408429; c=relaxed/simple;
	bh=kyfNt+I55n+nLHsPjOF16P9f/jAo3C7aKtLBeerS3Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6oTW3quVsiWjGuS9YBKIqzF63xJiqF/pR73q1kTkLHXqiZyDPrUt4xpXh4bDJ3dMpwb2UWqV5HLsP9cOlbS/hoPyA7bllha8RH4m7W6YR8cDAf9Q0AJ+5ov10veUKLfpMxScaQ+RZKp+gqYM12NTImAicb+4GqMIF+QKlt5V8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSQ5JSqf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSQ5JSqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77229C4CED6;
	Mon, 24 Feb 2025 14:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408428;
	bh=kyfNt+I55n+nLHsPjOF16P9f/jAo3C7aKtLBeerS3Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSQ5JSqfXCITDNEmEtfB622p7VW2tLLSZhxXnH03r4UzOu55ulz4IsTN7rfJCAVIR
	 B0PVgE26yrTwko5QKalOmapy2SnEEvViC7Qyy9e9kA77voLVFHzWYnLhceoSAgWoC/
	 M2UU3ypFJkeBWgvZWhx3xqy5I356Sa1Ejzn0IA4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/154] Input: serio - define serio_pause_rx guard to pause and resume serio ports
Date: Mon, 24 Feb 2025 15:33:42 +0100
Message-ID: <20250224142607.990277760@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 0e45a09a1da0872786885c505467aab8fb29b5b4 ]

serio_pause_rx() and serio_continue_rx() are usually used together to
temporarily stop receiving interrupts/data for a given serio port.
Define "serio_pause_rx" guard for this so that the port is always
resumed once critical section is over.

Example:

	scoped_guard(serio_pause_rx, elo->serio) {
		elo->expected_packet = toupper(packet[0]);
		init_completion(&elo->cmd_done);
	}

Link: https://lore.kernel.org/r/20240905041732.2034348-2-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: 08bd5b7c9a24 ("Input: synaptics - fix crash when enabling pass-through port")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/serio.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/serio.h b/include/linux/serio.h
index bf2191f253509..69a47674af653 100644
--- a/include/linux/serio.h
+++ b/include/linux/serio.h
@@ -6,6 +6,7 @@
 #define _SERIO_H
 
 
+#include <linux/cleanup.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
@@ -161,4 +162,6 @@ static inline void serio_continue_rx(struct serio *serio)
 	spin_unlock_irq(&serio->lock);
 }
 
+DEFINE_GUARD(serio_pause_rx, struct serio *, serio_pause_rx(_T), serio_continue_rx(_T))
+
 #endif
-- 
2.39.5



