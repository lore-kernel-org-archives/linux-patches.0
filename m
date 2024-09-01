Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8276225D9;
	Sun,  1 Sep 2024 17:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210058; cv=none; b=M0eGQQvMaAln4DePyVfnocIyRX9Mb44GOPpORePEfhaX+/oNhPqoNXXeeTCoRD7pEEjLUIS74zdBzd9JJwKtLj6q6gaQoTsNTuVJ8ZsZkSCWfzjrDPxXySyHw3EcnPvosC4EajD390z/js3eRghOGcVA6G1Lq+mundbY9AorXvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210058; c=relaxed/simple;
	bh=ubEJy5byjTHiaKAFuU6M+aOSgFVvWzbiiRk+lMifAwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjSrQVakiy5vG6jOgW7J1phFbxyW/2a/k4UAmijZEvDTvaqjLyUpBDSIvXxSLywI4CAOodbTYdqYlQsMxb9LCCFy8CnWiX97K3RsGD7py6BqWRoiNNKc2VQRsxj1Hh/rfXtPsFt09oTf0llim85ji7xAwKpk0TAGA/76uQvaP1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbEOUEZN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbEOUEZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2131DC4CEC3;
	Sun,  1 Sep 2024 17:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210058;
	bh=ubEJy5byjTHiaKAFuU6M+aOSgFVvWzbiiRk+lMifAwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZbEOUEZNHvEbk7htzdBei20vH/L52XfaY0OZMyDdqyTOM1pCbbKUM+RpT4Wl2xiQH
	 e3hEYfkqM1u4d6OIkwoCbY72/d6Rq/yUV1MpYHXHpXgzdb78F18uE1v5EI4obFpNBu
	 uwZu8AC85TZ8cQ5UQYjWueol8Jb0O4A1W67zESZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/215] ext4: do not trim the group with corrupted block bitmap
Date: Sun,  1 Sep 2024 18:16:20 +0200
Message-ID: <20240901160825.923930491@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 172202152a125955367393956acf5f4ffd092e0d ]

Otherwise operating on an incorrupted block bitmap can lead to all sorts
of unknown problems.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240104142040.2835097-3-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 630a5e5a380e2..a48c9cc5aa6e8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6496,6 +6496,9 @@ __releases(ext4_group_lock_ptr(sb, e4b->bd_group))
 	bool set_trimmed = false;
 	void *bitmap;
 
+	if (unlikely(EXT4_MB_GRP_BBITMAP_CORRUPT(e4b->bd_info)))
+		return 0;
+
 	last = ext4_last_grp_cluster(sb, e4b->bd_group);
 	bitmap = e4b->bd_bitmap;
 	if (start == 0 && max >= last)
-- 
2.43.0



