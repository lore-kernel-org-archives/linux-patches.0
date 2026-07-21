Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B958A3C1400;
	Tue, 21 Jul 2026 22:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673520; cv=none; b=gziPTOocZvAvyfLrkZgAtJsl9Xv3WwsdZOAUZuUn9sPV4Az2K+ZpR0wv+gg+bK7mjU54nZG3LwfdAx/b2Z6xRfLionYt6sdRzdhbG+QvgUnwXJnVWFkeHqiu/EoTbeyLnQZNnMO53jHGZa3eJ9U6AtC7pGvEDPKYgHOCyIrQebY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673520; c=relaxed/simple;
	bh=kMp7vHTE3BJ02Va0Hrs0onDCpFlgeSNHdZGHC37mBN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcoRETsfmnK+ZI7CJN7m9gKnKnMrOJ3wVZXWTDQGhVaReA0bgNgyG1MKJ3hfPy1bJUdjpVOxG1UH/Gee9l0IsOcdyguJqUgjeuFQT6DD2jlia7KAETXh0THgarRqXrhb+ngKU+WGArOZ8njPi5T0b56I7xC8l9wc++TxDYBDeEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QR19jxLC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QR19jxLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2192E1F000E9;
	Tue, 21 Jul 2026 22:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673519;
	bh=24GFmxEZ66lVtO5Y91Y7Pvm8sWrbAkOiZjSAbHxYaG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QR19jxLCnB7NGBorm61013OZ1PeFJ3Mxbd3XEPxls07F2OIwSGvDmwp1wnnkyGPNG
	 ZwpwJRC0EVqaurQdI2W1vOkFRc2PxBaNteBbJcwv+F08by6fxNywRagZPNQC9rh6be
	 qo1BfweWsHm+0hA+UaoB7YTMWzDJm8B/Q8wtgQZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Tejun Heo <tj@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/699] sysfs: clamp show() return value in sysfs_kf_read()
Date: Tue, 21 Jul 2026 17:19:12 +0200
Message-ID: <20260721152400.052508482@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f51b2396830f4a..d3dd04d3997d2d 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -117,6 +117,10 @@ static ssize_t sysfs_kf_read(struct kernfs_open_file *of, char *buf,
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



