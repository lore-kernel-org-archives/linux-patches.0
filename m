Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5306248BCE;
	Wed, 15 Jan 2025 10:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937538; cv=none; b=FlxQanUwzw7q1VqRzh+ts+8xRdpCrYHk4ETV88sbb6TDTZmQ6jVm4AKCuLId5Ax4HOTQhERkTTFq9O9/j82EtlUe5pfLEUZTN/cPZiqkonKPX/1wz77qERk4l/+E9wpqXT2SCKfhOuGRlhnHCAHuhGOy2Sgtcg1oo8dmTcxXxDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937538; c=relaxed/simple;
	bh=9CiB1H0CK72ZlTOLbBcHe73h8VTPgA0Y3pqBDAS0HnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWRrVMnn0b5dUDa8NZDdMoAr6/F8DVquJMlL4JXLWLOUPK5r+UbIQ1IoD/9spx9WQxcyQ2RrYWxb+tVdkOoCK8SWQDJvRrWqzyQzWzSqKGjDVcy76cG7/HgRgzMas0TVxeb+8DjH4uoWE2VKA3zqrMbt2OLwfxUIQc0JbzkYoAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ET8YAEzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ET8YAEzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641F6C4CEE2;
	Wed, 15 Jan 2025 10:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937538;
	bh=9CiB1H0CK72ZlTOLbBcHe73h8VTPgA0Y3pqBDAS0HnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ET8YAEzI+PwMQHrtv8pUfHpgaQY2Hs2IXB3qNhYnsHzNtZmCscQdo9IT3ojjl0yvX
	 acBHMoMqzGoLjBhmUJvC4w3+So4+inuhAs2ojJku537gxwSeA4rMIbUNK1Q5LXPRHm
	 QkdH9irtAums/wBRL6tZVa6ouUBtw1hZMkMXLhGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1de5a37cb85a2d536330@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 10/92] exfat: fix the infinite loop in __exfat_free_cluster()
Date: Wed, 15 Jan 2025 11:36:28 +0100
Message-ID: <20250115103547.943648051@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit a5324b3a488d883aa2d42f72260054e87d0940a0 ]

In __exfat_free_cluster(), the cluster chain is traversed until the
EOF cluster. If the cluster chain includes a loop due to file system
corruption, the EOF cluster cannot be traversed, resulting in an
infinite loop.

This commit uses the total number of clusters to prevent this infinite
loop.

Reported-by: syzbot+1de5a37cb85a2d536330@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1de5a37cb85a2d536330
Tested-by: syzbot+1de5a37cb85a2d536330@syzkaller.appspotmail.com
Fixes: 31023864e67a ("exfat: add fat entry operations")
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/fatent.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index 41ae4cce1f42..fe007ae2f23c 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -216,6 +216,16 @@ static int __exfat_free_cluster(struct inode *inode, struct exfat_chain *p_chain
 
 			if (err)
 				goto dec_used_clus;
+
+			if (num_clusters >= sbi->num_clusters - EXFAT_FIRST_CLUSTER) {
+				/*
+				 * The cluster chain includes a loop, scan the
+				 * bitmap to get the number of used clusters.
+				 */
+				exfat_count_used_clusters(sb, &sbi->used_clusters);
+
+				return 0;
+			}
 		} while (clu != EXFAT_EOF_CLUSTER);
 	}
 
-- 
2.39.5



