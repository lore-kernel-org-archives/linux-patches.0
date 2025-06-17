Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3862C2DFF3D;
	Tue, 17 Jun 2025 15:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175983; cv=none; b=bNn/HA8nv4yk8VI3ib+gQtyPZp1F7IOiDeWSWGzt97lUjKXmEWMK8O37JrolDuVUJs2sPMj/GHadEtgiFbjZWrAVI5+bKqslHbLrrMHtmQ7hJvMbIIzqtsosQeyqU1N3OAqoVqpMXCH/+n6EnvBo4cbN/j/iGegld7nTA2YrQn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175983; c=relaxed/simple;
	bh=/hbD7ry40RU7O3g3by5L2x3XWrUFmJ3z+pCR/BX6H98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTCmRm1b5PLwh4glOPHtQXzTe/kv93ZL6vyBCdkyJeBjb7880S6a98XLHjkceNsf2HuOvTdnhUazVqprP39CubNzzTa4wSUYTa1IdXhbNfdmhmJ6ghL4WzSPK5ShSJDAL8r7QnMN68OExU9ZFQQ8o/tLOvT82TqyGqz/iTltcEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEviTx3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEviTx3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E153C4CEF1;
	Tue, 17 Jun 2025 15:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175983;
	bh=/hbD7ry40RU7O3g3by5L2x3XWrUFmJ3z+pCR/BX6H98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEviTx3mnGw4dvw5OgbpVOV9qd0Huyh9DDg5IHphUh2pfeVeBJDQDnoUWr5S5zoSK
	 UXcPJHp9KJpTy6+qjSjqp8SJMyMKZEb0AhKyjLGzTuaXV40g6sRo0Q9hnT/0qyR+s9
	 2qmsopwEZCCXNbY6AqVHdfBXzJWZGnVtObY+HeFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 232/356] thunderbolt: Fix a logic error in wake on connect
Date: Tue, 17 Jun 2025 17:25:47 +0200
Message-ID: <20250617152347.533077158@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 1a760d10ded372d113a0410c42be246315bbc2ff ]

commit a5cfc9d65879c ("thunderbolt: Add wake on connect/disconnect
on USB4 ports") introduced a sysfs file to control wake up policy
for a given USB4 port that defaulted to disabled.

However when testing commit 4bfeea6ec1c02 ("thunderbolt: Use wake
on connect and disconnect over suspend") I found that it was working
even without making changes to the power/wakeup file (which defaults
to disabled). This is because of a logic error doing a bitwise or
of the wake-on-connect flag with device_may_wakeup() which should
have been a logical AND.

Adjust the logic so that policy is only applied when wakeup is
actually enabled.

Fixes: a5cfc9d65879c ("thunderbolt: Add wake on connect/disconnect on USB4 ports")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/usb4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index 8db9bd32f4738..e445516290f91 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -442,10 +442,10 @@ int usb4_switch_set_wake(struct tb_switch *sw, unsigned int flags)
 			bool configured = val & PORT_CS_19_PC;
 			usb4 = port->usb4;
 
-			if (((flags & TB_WAKE_ON_CONNECT) |
+			if (((flags & TB_WAKE_ON_CONNECT) &&
 			      device_may_wakeup(&usb4->dev)) && !configured)
 				val |= PORT_CS_19_WOC;
-			if (((flags & TB_WAKE_ON_DISCONNECT) |
+			if (((flags & TB_WAKE_ON_DISCONNECT) &&
 			      device_may_wakeup(&usb4->dev)) && configured)
 				val |= PORT_CS_19_WOD;
 			if ((flags & TB_WAKE_ON_USB4) && configured)
-- 
2.39.5



