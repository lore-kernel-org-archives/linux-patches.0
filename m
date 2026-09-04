Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428BD415F29;
	Fri,  4 Sep 2026 06:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501733; cv=none; b=NL2HcGBiy0lqecfSQlUisRSDRn9AAblAsyE172TWwOR8i+7lzwI3gILXeQX6U6yr+Mu26bygpO98p1kZl2blx3pd7OGbJiWW3FQWZOrWohz8L433nkVBqdqbYgbX/34rA8E8uWh5pdLJrth5CUOA46wYkNeBhIv2yFPnHaL0QrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501733; c=relaxed/simple;
	bh=f2swh1BiXfW91FUevCIc3zR2O4ihP9AVHStp90Tff4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaTNkUFyejjXoy4DX9kTJ+Ro/5+bK0BpDhMapt3RKNU2sqJTzOFrIiSRF+f8G/cajgnRNYX75t1JdE/tX0GoCsEIgij9sR0FBY1ul+jF4ZFN8Po9WgedKSZk8vxD7hQa8V1eY1tXMEVhtWclkicVqk2SnM5dkP61tgIOU7Qwabg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXwhnuh2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXwhnuh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF4D1F00A3D;
	Fri,  4 Sep 2026 06:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501732;
	bh=pW3TX9kuadlNUhGfZqBJzmie6jrVWXxc2CvwtNME8Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QXwhnuh2Bo6WhegXOTLTUCYOpqs7D4wXygdc9lOznZHbuR5+juRou5Xn+6z4rQaDA
	 YTjXH0x06iuZxhRoZRzWaSvUVRN9b9upK7128T1tf2dy7eHHjT/9nFy88b+QF92veb
	 GdenCUSZVAN61SXJG3UTXPNzWqsHXAbrfd93T4rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 513/552] dm-pcache: fix implicit u8 truncation of gc_percent in message handler
Date: Fri,  4 Sep 2026 07:01:10 +0200
Message-ID: <20260904045802.265710041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Jianyun Gao <jianyungao89@gmail.com>

commit fb9e17287a4ea1cbbcedc77e6866978ecc2a7b55 upstream.

When setting gc_percent via message, kstrtoul parses the input into an
unsigned long, which is then implicitly truncated to u8 when passed to
pcache_cache_set_gc_percent(). For example, value 266 (0x10A) silently
truncates to 10 (0x0A), successfully bypassing the > 90 upper bound
check in pcache_cache_set_gc_percent(), and setting a different value
than the user intended.

Use kstrtou8 directly instead of kstrtoul, so that overflow values are
properly rejected.

Cc: stable@vger.kernel.org
Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/dm_pcache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-pcache/dm_pcache.c b/drivers/md/dm-pcache/dm_pcache.c
index d5cfd162c063..645fc27d82ba 100644
--- a/drivers/md/dm-pcache/dm_pcache.c
+++ b/drivers/md/dm-pcache/dm_pcache.c
@@ -439,13 +439,13 @@ static int dm_pcache_message(struct dm_target *ti, unsigned int argc,
 			     char **argv, char *result, unsigned int maxlen)
 {
 	struct dm_pcache *pcache = ti->private;
-	unsigned long val;
+	u8 val;
 
 	if (argc != 2)
 		goto err;
 
 	if (!strcasecmp(argv[0], "gc_percent")) {
-		if (kstrtoul(argv[1], 10, &val))
+		if (kstrtou8(argv[1], 10, &val))
 			goto err;
 
 		return pcache_cache_set_gc_percent(&pcache->cache, val);
-- 
2.55.0



