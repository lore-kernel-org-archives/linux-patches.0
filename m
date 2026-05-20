Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB933D6CB5;
	Wed, 20 May 2026 17:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296963; cv=none; b=Mrd5Epj4imj/B78GnKFTrmyvQ5ZwmyiOvIFqHQN0S5VrXC3rk+5r8+5rZ/ZnQvNzscAnYSl5q1RDyLZ6gpujs9DIHf+poq6pUfYpfhPpsa1vKFwCtvpyqbEPq+tCfNzWSI0AqFBtYEzfZ7aqORrmO5qC37uCEwFDMAAvK14eSHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296963; c=relaxed/simple;
	bh=VzDdJT7SeNmU14KcdcOWilQkEH3An2raC/nQEcvCH80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7JN7ZZ0JLWn5RVPm/2ipda78ZzWxlfjzrIWOFpOxmF0PVJXJz/j1ad7jKq7jFgA2Jw2DwQOe29TVIMpUfc+cIJ/wN/omCY0xjxdehVpW4zHkXq7ql8pQ14RZz7/mZi3ZvKd+1L9VWh2N+qY71mQ1j/V57hgSqBLVWHNA5GltuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXLAO8hD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXLAO8hD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF78E1F000E9;
	Wed, 20 May 2026 17:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296962;
	bh=kCJrJ+LhK9+5dSvckuqYMRSGUMEhEjLHpG/Ri6/AZGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YXLAO8hDSvGBEJIZGebj6YCm4no//k830NyBdSp7pMW9/JTttyRuR64aWrLvylt8Q
	 VaMUTgZqPMPPEZcqRReDSerTCIKcbZRzNI5AjuzoJmCj5lLRfVxxGdzd4gpPR0oFGV
	 ctmD/SMNmPDEFgLn93RatzFqrtDmq16ISiFfkXAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0996/1146] netconsole: propagate device name truncation in dev_name_store()
Date: Wed, 20 May 2026 18:20:46 +0200
Message-ID: <20260520162210.771830148@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 92ceb7bff62c2606f664c204750eca0b85d44112 ]

dev_name_store() calls strscpy(nt->np.dev_name, buf, IFNAMSIZ) without
checking the return value. If userspace writes an interface name longer
than IFNAMSIZ - 1, strscpy() silently truncates and returns -E2BIG, but
the function ignores it and reports a fully successful write back to
userspace.

If a real interface happens to match the truncated name, netconsole will
bind to the wrong device on the next enable, sending kernel logs and
panic output to an unintended network segment with no indication to
userspace that anything was rewritten.

Reject writes whose length cannot fit in nt->np.dev_name up front:

	if (count >= IFNAMSIZ)
		return -ENAMETOOLONG;

This is not a big deal of a problem, but, it is still the correct
approach.

Fixes: 0bcc1816188e57 ("[NET] netconsole: Support dynamic reconfiguration using configfs")
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260427-netconsole_ai_fixes-v2-3-59965f29d9cc@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netconsole.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 595e09bd1ccfc..b3b36e3ddd03d 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -817,6 +817,13 @@ static ssize_t dev_name_store(struct config_item *item, const char *buf,
 		size_t count)
 {
 	struct netconsole_target *nt = to_target(item);
+	size_t len = count;
+
+	/* Account for a trailing newline appended by tools like echo */
+	if (len && buf[len - 1] == '\n')
+		len--;
+	if (len >= IFNAMSIZ)
+		return -ENAMETOOLONG;
 
 	dynamic_netconsole_mutex_lock();
 	if (nt->state == STATE_ENABLED) {
-- 
2.53.0



