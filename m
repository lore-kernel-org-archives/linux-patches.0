Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7301B24A078;
	Tue, 21 Jul 2026 21:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668814; cv=none; b=XpmqbCF0gXLo6D7+g6DRARv6qBUuk/1D+BybiIpXAqLoBO5L5H4Omh0AGitCuMIsGhBWnFB5/OCv+YD0sySFWTIwNiN7cszXhb7Z6vYOuj4kxbOa8AccJqUpcs9Yt4Fs9SwJw1VykYbEP+aAS5aFa+F2r/4uT3F93LAA5be/U9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668814; c=relaxed/simple;
	bh=GZiH+2AMVnnnFZq6PtVEsOIxLggAwvHTFo2AdUx4AyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhhtVOnrhL+0Um6e9rfxk53j8yOcHIGt3wZWJ6b3Bh4cnNu10MF9t+yUWQNXlHXKKEYiFFgpMkS8az3U3vD31fm6yltuXkvhGG7Qvy+LnGgR9n/c8ncNwMNLAjtSmdXWl7xGqERmsY9PMhkD8RIuDM+tXEVwPOgga8Wy7IM2rvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1V+vglv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1V+vglv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA3D1F000E9;
	Tue, 21 Jul 2026 21:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668813;
	bh=3G1XGIECMQzRXbAjy6U7EIGT6LhS9wN79CFmDbUom3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1V+vglvjDG+EEMEZGEgu8DAv6CLzuMD9+kMwABnrh2kCiddzKWftu2d2XgZN2qf9
	 iD33Cb4SnOwTda0jONlJaBYypsiE5UFkoBQz8psg1Y9jPcjspyfcVeimvdV+w5pprz
	 dJiE/g1+3aurCxJc7Y0vDcG9rt4P1/obzIy+S14c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Tejun Heo <tj@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0317/1067] sysfs: clamp show() return value in sysfs_kf_read()
Date: Tue, 21 Jul 2026 17:15:18 +0200
Message-ID: <20260721152431.683162356@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 454257f6d124a92342dcbb7710c03dd6ef96c731 ]

sysfs_kf_seq_show() defends against buggy show() callbacks that return
larger than PAGE_SIZE by clamping the value and printing a warning.
sysfs_kf_read(), the prealloc variant, has no such defense.

The only current in-tree user of __ATTR_PREALLOC is drivers/md/md.c,
whose show() callbacks are well-behaved, so this is hardening against
future drivers doing foolish things and out-of-tree code doing even more
foolish things.

Cc: NeilBrown <neil@brown.name>
Cc: Tejun Heo <tj@kernel.org>
Fixes: 2b75869bba67 ("sysfs/kernfs: allow attributes to request write buffer be pre-allocated.")
Assisted-by: gregkh_clanker_t1000
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/2026052000-drove-unicycle-d61b@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/sysfs/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index f21e73d107249d..833dd3f5a3f20c 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -114,6 +114,10 @@ static ssize_t sysfs_kf_read(struct kernfs_open_file *of, char *buf,
 	len = ops->show(kobj, of->kn->priv, buf);
 	if (len < 0)
 		return len;
+	if (len >= (ssize_t)PAGE_SIZE) {
+		printk("fill_read_buffer: %pS returned bad count\n", ops->show);
+		len = PAGE_SIZE - 1;
+	}
 	if (pos) {
 		if (len <= pos)
 			return 0;
-- 
2.53.0



