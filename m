Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55484248BAC;
	Wed, 15 Jan 2025 10:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937873; cv=none; b=T6mNLtI7jDxAA2P53qVQ6r+2t+7M5NjzzlJutZ+ZTMJ4xN5KKRKWvTWc+BmxFyCKvseTAh6emNh/5l34ToyTbUKuiaxpdj6FsnlMTp9x2pzfBUFgQpFKR4GjJH6XA3LRJnNSuEf4CgJ0UaVY/SRcvgfQ12nEa+KFXfvIdP098Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937873; c=relaxed/simple;
	bh=iqXm5OVQbaezFDccwb9isJXSxnhTCTDVem34jKnxyjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+wFiSHCZzbgkpqX8qWlwHatIIthu0qJqHtEjcoMKu7LRMnbbauea+Sl5dBMEIWu+R/3JayLU3GgXr70A7y3Ek5vFfyTVy3HAN/czxwhjnCx9k4vVdwWoW1v6Yf5UmC4DDaCp5pSyxtulPYh6PsYozUIKyqkXGvTmYlUBP+qCqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoAAuiM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoAAuiM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74E5C4CEDF;
	Wed, 15 Jan 2025 10:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937873;
	bh=iqXm5OVQbaezFDccwb9isJXSxnhTCTDVem34jKnxyjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoAAuiM46NNdLacK4NsKnwHtQ6u17C52uEeUYzLIOVmgsCd/8oO2ghsI0l/jzHtBz
	 lwbgRY+7hI411bvLcDSnfJLb1RYG9RIaxJoDgzrObqh/CuuyxV2G426zX+kGU0U+tS
	 V2gMT4duayCw5CRqbNWYb4MuCuoiOTKpnqc2nB/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1de5a37cb85a2d536330@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/189] exfat: fix the infinite loop in __exfat_free_cluster()
Date: Wed, 15 Jan 2025 11:35:13 +0100
Message-ID: <20250115103607.049578215@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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
index 773c320d68f3..9e5492ac409b 100644
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



