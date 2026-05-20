Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A130D400E0E;
	Wed, 20 May 2026 18:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302839; cv=none; b=RXmE3gAf9HVwQXHqZuONMh9wMpo9Gmw/QjZXg9Nx1PX6VsIyb3nedMbFdJ5JAs9vx7tgW1YZV+uwUOjQPtB2eTJGGFuiQisW6rLpC7EePww6vQrDeHmLncsiXy5n1sHmtklYGuBa8IAgF02nX0auHfvbPGhIF8ZYUmIx3qKXIp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302839; c=relaxed/simple;
	bh=6dlPH9MioAO+uphQE8FAY90CneWtEWAtEJpc/X9io4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHuZgxNzrXTSL/wGSGvGMyuQJXl4WBd68zGCHPXeA6LN0p8TGtLoqKzEBRE32YTWk1U9sfh30BHnvdfT2I7Co2qGpK82QDFKHj0dEF3ijuxrv2gpozwZrB3tThP21ckBpbylzUDL35h7kUs+X58mqjeV80Pks2PvZ4gZ6Sum3RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNb7NCMF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNb7NCMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1111F000E9;
	Wed, 20 May 2026 18:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302838;
	bh=Hm8dPmmWWtuPpMSUBYb1KQ25XAewV9ucF1SlgcD3b7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tNb7NCMFp3vkqPDe1RTPoPw2sDva6NW4NkCR+bjM2V7gzZqAx1pIDJyjxy1SuZ8XQ
	 tQ5fisqP6XvugAQxz3u0Ia2UDcqa4CoKvDiiqNcIQk5tf81mO9DXNpZI0JfDdK84ef
	 avFRzU4S8YgcRduJwX9Uvq8p/Qiu17dN4HM9/Gac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 418/508] netconsole: propagate device name truncation in dev_name_store()
Date: Wed, 20 May 2026 18:24:01 +0200
Message-ID: <20260520162107.663803973@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2045872de5328..f58643bdafc5c 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -476,6 +476,13 @@ static ssize_t dev_name_store(struct config_item *item, const char *buf,
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



