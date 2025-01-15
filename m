Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98BA1E98FF;
	Wed, 15 Jan 2025 10:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938523; cv=none; b=UiQn8EU1g4wuVzbwYVoPMiQnoJbEL1cyTQ3m5R97ZuCv0JDUfnloMFZ6uCB/N5ng6yz8mMLXG07o1duAGfyhZnUmNQhfJAXQP6MvIrXTZLEZRAwHnW21gmzhLAEDgc24rxkIYsRMBAId8SEkDwVXMVBzFr7hTJVG7aCOq4bMVXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938523; c=relaxed/simple;
	bh=ksAZHqL7RHrVT6yIrDUq0YeVIjFWM82BnerPUOJQcBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FG35xXOnJL5ybFVMO+0Q89VOkl2nFHhfBqA5mdW2ivnpUdukWmCFiIHN2e3PR5exTCGXZnS3SaONe8GDocX/gHCULdoi1TxsE8UO3lYC7wXbYp1vab3aCEu1PxlLoz8zZFsS7fuVfK5vFpAEo2bTQapnhM+yDKOwjLrDRbPYe40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNj73Ta2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNj73Ta2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196A3C4CEDF;
	Wed, 15 Jan 2025 10:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938523;
	bh=ksAZHqL7RHrVT6yIrDUq0YeVIjFWM82BnerPUOJQcBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNj73Ta2UfrhVVgHLmXFCN/Cc0lDlL7BsWI1q/+Exw0pZgvtGb5oORU3q0ponINYB
	 51G90RRBhavLlBsOkb0kV25Mtf1pQMa7wtsgnQ5g7MvFiV63YKRm/iQwoEkeAJeta6
	 gQDKjiFZnPI1oZTftzyKlsrMURpBvecMEMtQYmOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1de5a37cb85a2d536330@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/129] exfat: fix the infinite loop in __exfat_free_cluster()
Date: Wed, 15 Jan 2025 11:36:24 +0100
Message-ID: <20250115103554.737544123@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 56b870d9cc0d..428d862a1d2b 100644
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



