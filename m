Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC857BA34;
	Mon,  6 Jan 2025 15:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177792; cv=none; b=tQ9JceOwOiH6frzvQnvKrt/PwdYBJHiiqU5JRX7VVH2sUgrmyhrsDex49ajBJnuzqzlp/d0pS/Zj4qqf8aGtPc+SvfnPJgwPw9rywkUTxkXyrEK6uGUxPI6JdnDakDNNQua5UGlUX2nAJHg9Cdsf+RXe5RWh98rnZ+JwUbXQP4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177792; c=relaxed/simple;
	bh=Cj6vnfH/NVht5W2SNqSNQBhhCt4YQn2eRWHyf9o/DTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5HRVJgpOzRzQxpV0AbKeIpBjujUsS2qI0WTAZoDDIkV4ZZg/SjNiIJ8B6K8OWDxCBnI3tMgc3HnrlWNJcysOeAoY5+T+vjMx3BoYYyDigbTbJT/zqFhy7USGquJFuP8VEmGT2KgfxAcYrGnnPKAoaUeJWGu7Vfi5XKxiNWvTLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IwCxTovz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IwCxTovz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A30C4CED2;
	Mon,  6 Jan 2025 15:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177792;
	bh=Cj6vnfH/NVht5W2SNqSNQBhhCt4YQn2eRWHyf9o/DTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IwCxTovzmuVypaBhKB7TEaZsTUKDxzyhL/a0aRh/8mctrOALTfX2uMrX2Wm9b6747
	 rFE3GdhtboxOx4y7PDIAQRSHbOjTmBObeRhbqecLU5HBXOhmBboGsZqQ0/qcdEIuNx
	 Z6JJHKeQ5P3GzmKDyC5Ar0M3+DQcJBQMnsf7+a0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ff4aab278fa7e27e0f9e@syzkaller.appspotmail.com,
	Leo Stone <leocstone@gmail.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/156] nvmet: Dont overflow subsysnqn
Date: Mon,  6 Jan 2025 16:15:45 +0100
Message-ID: <20250106151143.961380497@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Stone <leocstone@gmail.com>

[ Upstream commit 4db3d750ac7e894278ef1cb1c53cc7d883060496 ]

nvmet_root_discovery_nqn_store treats the subsysnqn string like a fixed
size buffer, even though it is dynamically allocated to the size of the
string.

Create a new string with kstrndup instead of using the old buffer.

Reported-by: syzbot+ff4aab278fa7e27e0f9e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ff4aab278fa7e27e0f9e
Fixes: 95409e277d83 ("nvmet: implement unique discovery NQN")
Signed-off-by: Leo Stone <leocstone@gmail.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 685e89b35d33..cfbab198693b 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -2227,12 +2227,17 @@ static ssize_t nvmet_root_discovery_nqn_store(struct config_item *item,
 		const char *page, size_t count)
 {
 	struct list_head *entry;
+	char *old_nqn, *new_nqn;
 	size_t len;
 
 	len = strcspn(page, "\n");
 	if (!len || len > NVMF_NQN_FIELD_LEN - 1)
 		return -EINVAL;
 
+	new_nqn = kstrndup(page, len, GFP_KERNEL);
+	if (!new_nqn)
+		return -ENOMEM;
+
 	down_write(&nvmet_config_sem);
 	list_for_each(entry, &nvmet_subsystems_group.cg_children) {
 		struct config_item *item =
@@ -2241,13 +2246,15 @@ static ssize_t nvmet_root_discovery_nqn_store(struct config_item *item,
 		if (!strncmp(config_item_name(item), page, len)) {
 			pr_err("duplicate NQN %s\n", config_item_name(item));
 			up_write(&nvmet_config_sem);
+			kfree(new_nqn);
 			return -EINVAL;
 		}
 	}
-	memset(nvmet_disc_subsys->subsysnqn, 0, NVMF_NQN_FIELD_LEN);
-	memcpy(nvmet_disc_subsys->subsysnqn, page, len);
+	old_nqn = nvmet_disc_subsys->subsysnqn;
+	nvmet_disc_subsys->subsysnqn = new_nqn;
 	up_write(&nvmet_config_sem);
 
+	kfree(old_nqn);
 	return len;
 }
 
-- 
2.39.5



