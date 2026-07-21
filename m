Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D570F471271;
	Tue, 21 Jul 2026 18:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659105; cv=none; b=uoABeeHk6g0PPQrn5wp3TAhu2S6sscb3NVC3jM7cyD7uiMR0hSOG9jwzJeZwVIyWbfyuhJvGfGLXpZGWBBQZ8o1lHGVMyXI6M4fyJGDIFMJIlMdVh2a/tmEzeXEDTBkqCDE64B6ARUctCp+IQ9n4O4MU75bT4AChuu0YF93ppJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659105; c=relaxed/simple;
	bh=6RaButsybyFy1VMYs+5GtsnH+lBkkxrGHyBGojboiVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOPf0WR3K+ddFP49TK5BhSpLss+3joQzxDfkjfY3xGycPk+ikEASsFRy8lWop064s/serAHLbOpR9mBi2iDgNREjF1mTiHBMXT/y5+mRbu96VhR5vQyCDilhLvBPu+xMAdyX2qI8jEuwHscZAZclknRr10Q2xlyv7HFy6mP/gy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vES4pcgT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vES4pcgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCB31F00A3F;
	Tue, 21 Jul 2026 18:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659104;
	bh=rjl0ilT9NmT6v+Lrdy3ib2/HC5ig4tN2vv04cXfvznA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vES4pcgTwha2cQX0Gpe1EcWmweD5LZzBw2kTfM6TPS5bjhxRDio2srr/AsMDH9poT
	 GELjSQEYroPoEGgKFD8xw+jZ2ajJJYiPtD9R1kYEvROQb3+CrBrcoDWQUwmwDQuQ4y
	 1ZCf3H2RalPYr6CXbiJI4sV18ABuvBF2zVm0X7Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Zheng Gu <cengku@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 1351/1611] dm-pcache: reject option groups without values
Date: Tue, 21 Jul 2026 17:24:27 +0200
Message-ID: <20260721152545.845134611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Moelius <sam.moelius@trailofbits.com>

commit d9c631e3fbd44246a2be781d26cfacbb9b8ec127 upstream.

The pcache target parses optional arguments as name/value pairs.  A
table that advertises one optional argument and supplies only a
recognized option name, for example "cache_mode", reaches
parse_cache_opts() with argc == 1.  The parser consumes the name,
decrements argc to zero, then calls dm_shift_arg() again for the value.
dm_shift_arg() returns NULL when no arguments remain, and the following
strcmp() dereferences that NULL pointer.

Check that each recognized option has a value before consuming it.  This
keeps valid "cache_mode writeback" and "data_crc true/false" tables
unchanged while making malformed tables fail during target construction
with a precise missing-value error.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Reviewed-by:  Zheng Gu <cengku@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/dm_pcache.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-pcache/dm_pcache.c b/drivers/md/dm-pcache/dm_pcache.c
index 81c795c0400e..d5cfd162c063 100644
--- a/drivers/md/dm-pcache/dm_pcache.c
+++ b/drivers/md/dm-pcache/dm_pcache.c
@@ -168,6 +168,10 @@ static int parse_cache_opts(struct dm_pcache *pcache, struct dm_arg_set *as,
 		argc--;
 
 		if (!strcmp(arg, "cache_mode")) {
+			if (!argc) {
+				*error = "Missing value for cache_mode";
+				return -EINVAL;
+			}
 			arg = dm_shift_arg(as);
 			if (!strcmp(arg, "writeback")) {
 				opts->cache_mode = PCACHE_CACHE_MODE_WRITEBACK;
@@ -177,6 +181,10 @@ static int parse_cache_opts(struct dm_pcache *pcache, struct dm_arg_set *as,
 			}
 			argc--;
 		} else if (!strcmp(arg, "data_crc")) {
+			if (!argc) {
+				*error = "Missing value for data_crc";
+				return -EINVAL;
+			}
 			arg = dm_shift_arg(as);
 			if (!strcmp(arg, "true")) {
 				opts->data_crc = true;
-- 
2.55.0



