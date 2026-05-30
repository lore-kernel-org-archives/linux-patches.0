Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AB52FDC5E;
	Sat, 30 May 2026 17:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161933; cv=none; b=rztD0n1PxwUBw0smES7apN7D1Ld/GktsQd47h5TCzlx0/rtZhvWGcTJSSrU092qdgaCzWJIoued4Up9g33dLV0JRLKShU0TwJwGtTKPX0oNeGt+8A1I1Z7RDKXEkh+TEsZU44LgICEXRRp4KrGKBZSigVQViXidEpzmc52/oKFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161933; c=relaxed/simple;
	bh=R3vvLJKe4ZEX/c73Bh520vR1lM3E9eWQr9PMrPXl31M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foYwLnqlGwXwSP6Qur4PVKLYVC77w79Flhi1gKRjsNDe8fjza4KFcs96xVlKdTa7xaWZMqr/qRWTYrkdXPSN5ZvWXQbpMekobNIxfm9N36K1cR6V2VBi3xhDuIioog5WQagRJ87DvH1gh7cu3ajKFNocyej5Y6FX/oGFi4vCsu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K11vyrgI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K11vyrgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A74D1F00893;
	Sat, 30 May 2026 17:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161932;
	bh=4yqiWc794ImEZxX/RRkNpCHq7RlAIWc0Qu5N2aAV90U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K11vyrgIM0pvSxgh7YtlmgPQc9X+nP10/5B812Fi8+9lqHa2xEY14Vt/UF7wQ4TWm
	 yxQAuvQqOZcYMT2XP60OnB5rDSACnWIUYB9baZiJBoo59CdUbwQuXBdfKOmCdbvmtk
	 rN9KmOk/IktTpp29BA3w0CZ/hqYPrD043gl2Oeso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 771/969] netconsole: propagate device name truncation in dev_name_store()
Date: Sat, 30 May 2026 18:04:55 +0200
Message-ID: <20260530160321.873190598@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f9bf2c9a3ae2a..d150287c01a7d 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -414,6 +414,13 @@ static ssize_t dev_name_store(struct config_item *item, const char *buf,
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
 
 	mutex_lock(&dynamic_netconsole_mutex);
 	if (nt->enabled) {
-- 
2.53.0



