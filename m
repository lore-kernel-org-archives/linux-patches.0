Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DA246A602;
	Tue, 21 Jul 2026 15:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648577; cv=none; b=qKbOYMAPlmTDbPbwy+pAkm/EenAlSuZO2GkOZ0L44Kvv4g20vv6UniGhlF/BslvU3xgCzhkKuQHEc4kFuAGt1gGDxcu1bdw8ugjCk/jhP4VVn5p+5YI08p2vf9xhzLh2c/qdUOn+I7eG1liV5hl7254PB7x7Bxmj7BfzQ7jaBnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648577; c=relaxed/simple;
	bh=WUYRSk318Q4M6Z84R2tVGiATRUaZf/+jbDza/FwsI08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9/uoMFIYk67+vNryoQCAxOEw32njnq4KMhH+mLR1xNXSLfn2GwMlx9SSGFEsdRFUVUYyMudHuqz93K7n22veoaVvcMqT8sGERu3fWjqr3O2IX4dnucUdmawpEKQNHoBapt3eHGDL5sH6HKsLNk679EuGlmPtIWnv8TMf6/DYlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ha+SMpsV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ha+SMpsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1051F00A3A;
	Tue, 21 Jul 2026 15:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648576;
	bh=JU0zcw5S0hY3xcw8d4wap9+OwYd3AS46ETPR5J2HHlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ha+SMpsVHF9uAr1b+I+w2wF0JyAL0HwmiCp6pteSnrs05sa3AFpH84YNjDxEMlLVD
	 NwCi27/uW0bz+YTZeX8mY4ElZ6i+hs9Dhx8t3onZqg2W8dTMIvltXn76/2NYuS1ppQ
	 4Pn75AZP12ouKJhjeUfAclZI3KXrDeFWTgw6BqEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Tejun Heo <tj@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0251/2077] sysfs: clamp show() return value in sysfs_kf_read()
Date: Tue, 21 Jul 2026 16:58:44 +0200
Message-ID: <20260721152558.600639453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5709cede1d7568..25b44fe171a329 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -120,6 +120,10 @@ static ssize_t sysfs_kf_read(struct kernfs_open_file *of, char *buf,
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



