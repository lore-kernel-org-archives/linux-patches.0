Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAF813BC33;
	Thu, 11 Apr 2024 10:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832531; cv=none; b=CuDNxzX2qQTzuVnFLxtR/nfvaEr+BKh6//Z5o1PTAWeDGYgrJ453UTw6tiWBrDxtyijWfGXuekWcL+CM2wV3qYprC95q1ZqMAL4siJ+NdeRfX/XeoLsjc1NPGkD3DLIALaRH39J7CV+UBZ7lJfUcKT3tqgCcpZRX9axhqZs1Agk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832531; c=relaxed/simple;
	bh=tJ88D9vby0nBNV9eccUpYRJTm9kXP9NHajB/9hwuiUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8g0L+JmWIFacKNZ8O0joX8ymOhhy7ZfoEzc2z27elekV+mNk8ptIIceKyyO53QeD+VAoDNvPLBu0Agh+dMHPWAcrawlaZ+PQ7F/0wjLXfcfawaURestt1a43+tq9mUHYXsw6S/l2+h/6Q7mhmbi/+4T6p45GpvKeAUkjXYHJNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlI+8Erp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlI+8Erp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A40C433F1;
	Thu, 11 Apr 2024 10:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832531;
	bh=tJ88D9vby0nBNV9eccUpYRJTm9kXP9NHajB/9hwuiUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlI+8ErpwKM3eL1G+otaJxWpkMm5YffStzg4D2yGNMPMQcRn/au8wsMAsEr2VEH6s
	 eRWMzUkebpOxc0zxP9VpqqMpDBK/AYzb8ELSUNYbLdvehZX6LPpEAX1Lc1H73WU54i
	 2IQnnWFN7gdqJ2j1knqxDVoi36jBhVgI7uP66JjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 41/83] ext4: add a hint for block bitmap corrupt state in mb_groups
Date: Thu, 11 Apr 2024 11:57:13 +0200
Message-ID: <20240411095413.919800860@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 68ee261fb15457ecb17e3683cb4e6a4792ca5b71 ]

If one group is marked as block bitmap corrupted, its free blocks cannot
be used and its free count is also deducted from the global
sbi->s_freeclusters_counter. User might be confused about the absent
free space because we can't query the information about corrupted block
groups except unreliable error messages in syslog. So add a hint to show
block bitmap corrupted groups in mb_groups.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240119061154.1525781-1-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index bc0ca45a5d817..a843f964332c2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2905,7 +2905,10 @@ static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
 	for (i = 0; i <= 13; i++)
 		seq_printf(seq, " %-5u", i <= blocksize_bits + 1 ?
 				sg.info.bb_counters[i] : 0);
-	seq_puts(seq, " ]\n");
+	seq_puts(seq, " ]");
+	if (EXT4_MB_GRP_BBITMAP_CORRUPT(&sg.info))
+		seq_puts(seq, " Block bitmap corrupted!");
+	seq_puts(seq, "\n");
 
 	return 0;
 }
-- 
2.43.0



