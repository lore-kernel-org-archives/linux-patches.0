Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A1B3E3DB4;
	Tue, 21 Jul 2026 17:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653898; cv=none; b=AcdlbCe+BIvsiCLfmI+InsS1RtdClN0xlOA+ITqt6SllLzUVcEA0qedFHwLGoeZl64jJvXEZVr7d8EVW7eDe5PEHbSjmQKi9wu2UtF/YXmxN0sOHsn7eCJYKOt/adOkRZ307QfUfOjutgAhTrzSwI3LXpFDH9mm5FkYzdjqWkGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653898; c=relaxed/simple;
	bh=7nCoDIffemYEIGbMWJLwZH1aTod0kp6sn2NAA/GYL9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNDmxjUy9Q5pCUb3xDLsRdx0PAihG1/oqZbiGfrrqUrKzSvL3vI+4Yxf2cDCvObf7zHBR5VB7RUDlM3cgROztSj/Eo4S/FvLlhLiHizcfGG/SBRM/xqPsrfNbkpmuvczNkip+gx72hq85xIHkotaUEylYrK63kV7TXRCXZXzTmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vY8Xjv0R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vY8Xjv0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844011F000E9;
	Tue, 21 Jul 2026 17:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653896;
	bh=b/qfNmCZwcJnyLvvohl11tfAOSeJmIXdvNpSUMITwTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vY8Xjv0R3O6sGi+9mBLmiOrgpxWpSj6zPq4mttWEnw0S/ifrI6yR5qVQA0I7WGf2e
	 wg0jhlIbS0iIJhvEi+2l+ixOgNjaMKhY8hDmiYFy+65DSA08+w8dX5DNoYot3A0jFm
	 FEiqDOPL/yvsYdrv6VMWGqTiIBuP/ZiKOktu9zl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Su Yue <glass.su@suse.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1500/2077] dm era: fix NULL pointer dereference in metadata_open()
Date: Tue, 21 Jul 2026 17:19:33 +0200
Message-ID: <20260721152628.167685608@linuxfoundation.org>
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

From: Cao Guanghui <caoguanghui@kylinos.cn>

[ Upstream commit 9ae672606c17891d90b282e3490b817620549599 ]

metadata_open() returns NULL when kzalloc_obj() fails, but the
caller era_ctr() only checks IS_ERR(md).  Since IS_ERR(NULL)
returns false, the NULL pointer is treated as a valid result
and later assigned to era->md, leading to a NULL pointer
dereference when the metadata is accessed.

Fix this by returning ERR_PTR(-ENOMEM) on allocation failure,
consistent with dm-cache-metadata.c, dm-thin-metadata.c, and
dm-clone-metadata.c which all use ERR_PTR(-ENOMEM) for the
same pattern.

Fixes: eec40579d848 ("dm: add era target")
Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
Reviewed-by: Su Yue <glass.su@suse.com>
Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-era-target.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 05285c04ff2cda..08ce96e8cf4f63 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -810,8 +810,10 @@ static struct era_metadata *metadata_open(struct block_device *bdev,
 	int r;
 	struct era_metadata *md = kzalloc_obj(*md);
 
-	if (!md)
-		return NULL;
+	if (!md) {
+		DMERR("could not allocate metadata struct");
+		return ERR_PTR(-ENOMEM);
+	}
 
 	md->bdev = bdev;
 	md->block_size = block_size;
-- 
2.53.0



