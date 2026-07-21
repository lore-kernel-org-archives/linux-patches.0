Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E11246EC99;
	Tue, 21 Jul 2026 18:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658292; cv=none; b=P6DCFPcodqaegHhTO9nqPf/ClqV5VzN+EVI8PKYRSNA/ztXTJyq0ONdNaN8szvGiKM+jULTuU8gBkzHBbcPeSYhXEZg8FdRy4jz7DumytVqNvOeqkp1IevkrgiYjkSLa9JC9ks0scLVn9Ihu1+sQ5yVSF/8jHWVaoTXaLBi+100=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658292; c=relaxed/simple;
	bh=KvJfTE1HSrSbdUrGybEwTcmTO0LLhFs0YyxeQipkanA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiM8zW1TtgdyGma9oOffzIqetbqUHBAJlB3iJFZv4jB59suPGk1hCKizYSrtYSg97PkIYLyrmUA/UYZMwKEr9/EDZUteDYVQXx4vj7JvoqBzIxhcKg0IM1aHvoWvx8wmKhHVpVh2GqaipjMI7pB+KpVK5JxEo8zNMcPrhsSolCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ShQdjL1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ShQdjL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCCD1F000E9;
	Tue, 21 Jul 2026 18:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658290;
	bh=kilyrZ/fQcnHj5ZbbBCXd442vk1cLxgPSUHw4o0P6WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ShQdjL14R+xcyHKrWCF0nKhuVoXQ+gd15Esy+rfn9NVWtmxCQ1rfNKST67letTGf
	 0VtI4ypBbL0U8tnfmaGyMsT+DbEL+xI7D6aiTlPrC63by3R6MMxQe3z2qcn0AwdEV6
	 sqfJqEF1olD2nLQXMnK/9RWeLyVDZn9e8h2RTvBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Su Yue <glass.su@suse.com>,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1088/1611] dm era: fix NULL pointer dereference in metadata_open()
Date: Tue, 21 Jul 2026 17:20:04 +0200
Message-ID: <20260721152539.884806181@linuxfoundation.org>
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
index 9c84e9d13eca6d..5cc71dbc7e039c 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -810,8 +810,10 @@ static struct era_metadata *metadata_open(struct block_device *bdev,
 	int r;
 	struct era_metadata *md = kzalloc(sizeof(*md), GFP_KERNEL);
 
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



