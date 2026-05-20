Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B37C340A57;
	Wed, 20 May 2026 18:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301595; cv=none; b=Dd1dQJgwjoBkHT+IiA6EE6qy9NGAJmr8dpgK6E1S95qvK1lzW45Q+ggDNZcL/ZL7MvoraVNCP0ppqMh72O6LHFZp0mh88lVY4bJ5dXc7Q2z6bJREylH6E8W5Jm+AGQS7dCRPI93+IjdZKKOhS2046Bd0xLwukuHhmST7J2uPxtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301595; c=relaxed/simple;
	bh=35bmbzXbNGxzD1DuUyEEySeWoEZypWsDY3a1PviOROs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrjUFplo7tScnz2khjpmBLAwdynHUUdXIlG2jN42lthlIyt/XR4gAHzmKZvV1XAm1KlGGEIiAeLZyJCk5LK+h/Fo5fDXtP5bCjXDxsf36ZRfEy9zDKzbJUdO5AQDsa5+rW5TqkxGNfkYn5v6y+hav4KbdmZw6sMXiA849yfDdg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOULahxK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOULahxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22BF1F00893;
	Wed, 20 May 2026 18:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301594;
	bh=SagjWqh0seGzI1yk7C7VVQzgtpzDP2Wd9Vx2BF/9g9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IOULahxKjyz5dy6lLp3UCyfOmziwz1f2rIUHLCbj2a0R7GAZt22PBPYLGtEJTK6XS
	 D65RJrlffdZEx4ZxUziDTJPmxf4fJ0xiB92pomGcMU3byT8VcVlTpIUV+OwCG5Hml6
	 vIU5WzFC8CmZifmaOF205CDNScQ6Es8CNvfT6gMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 573/666] netconsole: propagate device name truncation in dev_name_store()
Date: Wed, 20 May 2026 18:23:04 +0200
Message-ID: <20260520162123.687815351@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4048d99b7c57d..60375bb814a1e 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -502,6 +502,13 @@ static ssize_t dev_name_store(struct config_item *item, const char *buf,
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



