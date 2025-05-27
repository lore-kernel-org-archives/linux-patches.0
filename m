Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76F526F449;
	Tue, 27 May 2025 17:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366803; cv=none; b=WnmJXI/b2MKueTdKjpZa4VCAn4FBKR8dfr0VcmHfT5da6iZUgD4IBa2ttgd1l/yIW82v3jgQ/Ftu9x/VGwHcFkLWvRbn7/aLZOjlaSSQfqPr2ZMTYjjm2nMG67FtI9O56cCROHoF8OYX3BHh+Qlk6v6SVQDVf0AV0SbrPlQy5QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366803; c=relaxed/simple;
	bh=Q3lCQqnHSLIANwEXRUtRAS2HxuN7ZmollgSp/5TEIz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYNEIae1AIpaZvKqVF15bv8LWQAbEhfPg/qF1qnPSZLN3rjeIO3OAwLAmX178nFeLAXr2/MlX5mveP4vobRrv7/RwkpU3pkU7XWLHIlvhzHwSNHUs4XV/IwJ2jeda2oWItH6GlPUtCQ0DuVpJopELmfZ2btLB1cmdav31N6/xxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPahjFhi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPahjFhi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454ADC4CEE9;
	Tue, 27 May 2025 17:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366803;
	bh=Q3lCQqnHSLIANwEXRUtRAS2HxuN7ZmollgSp/5TEIz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPahjFhi1DoL/N5aOC1W/GoGDb/r3+WygRt61PE1b10j1gvi1+mLKi2Ka3w5WcooT
	 22qUfUDivlCekN/lv9AH1VvITTEqqqBMOesxOIUaST812pgLkZh0kgsuRzc0prbcsm
	 497TmSQbYXw55cb7US59qAnuMbrTeXPTi4uOgE/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 180/783] dm: restrict dm device size to 2^63-512 bytes
Date: Tue, 27 May 2025 18:19:37 +0200
Message-ID: <20250527162520.487886980@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 45fc728515c14f53f6205789de5bfd72a95af3b8 ]

The devices with size >= 2^63 bytes can't be used reliably by userspace
because the type off_t is a signed 64-bit integer.

Therefore, we limit the maximum size of a device mapper device to
2^63-512 bytes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index efc6ec25e0c5d..4752966fdb3f4 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -698,6 +698,10 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 		DMERR("%s: zero-length target", dm_device_name(t->md));
 		return -EINVAL;
 	}
+	if (start + len < start || start + len > LLONG_MAX >> SECTOR_SHIFT) {
+		DMERR("%s: too large device", dm_device_name(t->md));
+		return -EINVAL;
+	}
 
 	ti->type = dm_get_target_type(type);
 	if (!ti->type) {
-- 
2.39.5



