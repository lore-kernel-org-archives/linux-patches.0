Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183241DB13A;
	Sat, 12 Sep 2026 14:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224262; cv=none; b=DWvvm4nM6kUOorhx9J5YWEYNMroNOPyXGnrucO2bXarUDxETp8KPBURPEiJsg9BCK+xhOHDZqrOgp+G8Ev0Yd8WL3GMSe8Q7mjrBroq6PZXGlUyjxQi6wrGh9Ai22bY35++20nrqfqxuhFHG7AgUMCtyrP8PqEVeQR6hGs50nKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224262; c=relaxed/simple;
	bh=rxVp/SzwxyD6Pf7fRR9Nv4vsWufTmtDuK9wAvVYjeIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jP9odurEik/z8LIzQnJBwbS+A+9iKY+2Upxq0sEQ7lP8tMLKalxEK9f2zPXgSaSU9vxsJ8AahAqHuie9BbYHHdc2fxn1lYFHFBzFGA0QY5X6sEbUp4uMvOfB4BkJKRUKiO2aZzgIAulMPp4q5rpGs7BXdguKG96ajX0L/3gmm24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fE9PC+7x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fE9PC+7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685E81F000FF;
	Sat, 12 Sep 2026 14:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224261;
	bh=MC07acqUg3vgHYotEMs06W7nUt0PYBjW+7M1kxEZAvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fE9PC+7xeu6ERCl84WKY9lpbWzbWPHXVAJJCzbPV+xKw2SFZqB6ZDsQb7JJsdsVvX
	 qitZbqECwvb4VZBV/XDDTJUsVT7QqoytFAezj0bsboduR/38ZaN2MNSz7iQz3PNFVs
	 4LskyaneMT3CRCgh96vbs4ZScSDON9/k0qZXiUCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0905/1424] nilfs2: fix infinite loop in nilfs_clean_segments()
Date: Sat, 12 Sep 2026 08:55:37 +0200
Message-ID: <20260912065627.590492002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Crofts <joshua.crofts1@gmail.com>

[ Upstream commit ce5a5ad1a8330a2fcfdd9ec2ab341be739e89a18 ]

syzbot reported a hung task in nilfs_transaction_begin(). This occurs
because the cleaner ioctl falls into an infinite loop if
nilfs_segctor_construct() repeatedly returns -EROFS (e.g. the device
is remounted as read-only after an I/O error).

Currently in nilfs_clean_segments(), if err is non-zero, it logs the
error and sleeps but doesn't abort when it encounters a terminal error
like -EROFS. This causes the thread to loop forever.

Fix this by breaking out of the loop if nilfs_segctor_construct()
returns -EROFS. This matches the behaviour in
nilfs_segctor_write_out(), which also handles -EROFS.

Reported-by: syzbot+cae54346a70bbceeff2c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cae54346a70bbceeff2c
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Assisted-by: gemini:gemini-3.1-pro
Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/segment.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index b1730b1d88ba4..94458afcd5294 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2553,6 +2553,10 @@ int nilfs_clean_segments(struct super_block *sb, struct nilfs_argv *argv,
 			break;
 
 		nilfs_warn(sb, "error %d cleaning segments", err);
+
+		if (unlikely(err == -EROFS))
+			goto out_unlock;
+
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(sci->sc_interval);
 	}
-- 
2.53.0



