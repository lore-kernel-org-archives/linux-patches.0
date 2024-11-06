Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD5A1EF93B;
	Wed,  6 Nov 2024 13:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898536; cv=none; b=qhE1zEtK8x3TsP5elvayCGC7CbpqdRrA0wYqXdSckuX34pcxESN8m5XEBrJI5aokMqTjk7KessgZ8Fuakjb1tOojJDCWSdrQ+gFbMDSsNV8dD0saJ19NIuO98B8WelY80jsTM0cONwGmWEC6HC6ndcJcoAWM5f1RHpDQWcIgjm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898536; c=relaxed/simple;
	bh=K0Y2TmZsN4d1H6m5vCBZ7hL0rLmiDVGqAQHOINLOYWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWG4uif2W4X8BPjxz3xOnw1xNN5AqyvMKKvOIPWcoqxkpA/ocRxkmiyVpbP8/EWjV5wPy4vkIZ5GSAsJCSpj7PTKrDcZyf6qvk4g/ouDGFZeSMbDUJBzMG7+DoeP2PKkNmVU+9x2ZXVM+DXAlmxvLua7ET3/OmAsMYX+mLApvwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlIxew49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlIxew49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB755C4CED3;
	Wed,  6 Nov 2024 13:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898536;
	bh=K0Y2TmZsN4d1H6m5vCBZ7hL0rLmiDVGqAQHOINLOYWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlIxew4997f9ALx9zV2LwCsfm3s9EWhCuLZB7BFrPQ9xfqzY+12XhfkfELTXBi8tn
	 T1G8SpqnMdTfOI0RKlWzoBDhRrwo8n6bnwJ9UZK/g1juw8Al5Lo3EYa6esw2VSvzlr
	 hUxq2dJFkxlYrJdJ18NS2pDh+QYfcyyFT5FHuWsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Mikhail Ukhin <mish.uxin2012@yandex.ru>,
	Artem Sadovnikov <ancowi69@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 234/462] ext4: fix i_data_sem unlock order in ext4_ind_migrate()
Date: Wed,  6 Nov 2024 13:02:07 +0100
Message-ID: <20241106120337.302608839@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Sadovnikov <ancowi69@gmail.com>

[ Upstream commit cc749e61c011c255d81b192a822db650c68b313f ]

Fuzzing reports a possible deadlock in jbd2_log_wait_commit.

This issue is triggered when an EXT4_IOC_MIGRATE ioctl is set to require
synchronous updates because the file descriptor is opened with O_SYNC.
This can lead to the jbd2_journal_stop() function calling
jbd2_might_wait_for_commit(), potentially causing a deadlock if the
EXT4_IOC_MIGRATE call races with a write(2) system call.

This problem only arises when CONFIG_PROVE_LOCKING is enabled. In this
case, the jbd2_might_wait_for_commit macro locks jbd2_handle in the
jbd2_journal_stop function while i_data_sem is locked. This triggers
lockdep because the jbd2_journal_start function might also lock the same
jbd2_handle simultaneously.

Found by Linux Verification Center (linuxtesting.org) with syzkaller.

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Co-developed-by: Mikhail Ukhin <mish.uxin2012@yandex.ru>
Signed-off-by: Mikhail Ukhin <mish.uxin2012@yandex.ru>
Signed-off-by: Artem Sadovnikov <ancowi69@gmail.com>
Rule: add
Link: https://lore.kernel.org/stable/20240404095000.5872-1-mish.uxin2012%40yandex.ru
Link: https://patch.msgid.link/20240829152210.2754-1-ancowi69@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index dbba3c3a2f064..ebee8c94b5fe6 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -678,8 +678,8 @@ int ext4_ind_migrate(struct inode *inode)
 		ei->i_data[i] = cpu_to_le32(blk++);
 	ext4_mark_inode_dirty(handle, inode);
 errout:
-	ext4_journal_stop(handle);
 	up_write(&EXT4_I(inode)->i_data_sem);
+	ext4_journal_stop(handle);
 out_unlock:
 	percpu_up_write(&sbi->s_writepages_rwsem);
 	return ret;
-- 
2.43.0



