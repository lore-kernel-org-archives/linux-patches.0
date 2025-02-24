Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B2D1519A5;
	Mon, 24 Feb 2025 14:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407899; cv=none; b=PkUxQg6D/lcx1NSS8NpydEe7wj5RDjx7rh+TnTt1PGQaisBvgQch0wm2Efli48z/UDU3xExFRDbG61pI6hV+hauQ/bPPqaiA9lFA8261gSPwxDPyLVep4xHKihXtBaG5tR59B6oj2D5nyQN9oRNy2XFzNgTgARXqoPvGhahmtQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407899; c=relaxed/simple;
	bh=VDQF1hQPXIfAuTc9+mDbCcP0IDm3HxwXs3RJ3ppMlZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUTQEMXr1ccTIwBzgUgEUWJNVoeJemL1wmyxNbI0ydjFxU9BIl/sL0XJ5QSaS1QerzPdPWnUjRxH9nqcB+8RD6MdPz5nkyDhZpB3m4AWG08cnZVJi1Hvki317yIx+wT4bwPv5uaTRSURsdhQ/s51a/gQUAeqclRoV8GoXEaMw90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgE5QF07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgE5QF07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9E0C4CED6;
	Mon, 24 Feb 2025 14:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407899;
	bh=VDQF1hQPXIfAuTc9+mDbCcP0IDm3HxwXs3RJ3ppMlZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgE5QF07BqOU+7pdLCP6oVsh00kM6AvG5dcoE5IaES+6EFEjiKnSgA0Y/3mfFvccB
	 2npL46vnSLSPpadVk4FFpn+dTuSG++u44J/24JQqoZQikLwcFkuy5nNFvlh2+nV/Zv
	 gCiSvEMmZTh3GYdailks24Z4j+80nZvlOz5Bf79w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/140] Input: serio - define serio_pause_rx guard to pause and resume serio ports
Date: Mon, 24 Feb 2025 15:34:01 +0100
Message-ID: <20250224142604.663429434@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6c27d413da921..e105ff2ee651a 100644
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



