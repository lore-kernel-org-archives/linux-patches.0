Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABBA230D2B;
	Mon, 10 Mar 2025 17:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626980; cv=none; b=lgu1/dPfAbGbEpMZ0jo/XmGY2F51jKtGRr0SHEvQy7UsGO2ev9P/Fr8xvlEU+cf5xKvQMmPekjKFNegUIrbkWjLWyCFXyFIWmXCpdQyMPCo4BYAujXnrizYTsqZF479vUGYUb/+tFfC7HxAkhTzsbaNBU9XQHB7XSxHJvCZOELM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626980; c=relaxed/simple;
	bh=COgnYyJK431DT7jBl4MtZ/5nNwmswxiI3YrqhXnNyrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRzZY11AxCYItJBW36hr59aKWp3ngzcmUyxqe9i99/i8I71qimCtXNrWEZ3RKalxfVRRXEtloQDeFKMCtpFGxcfRSgZCwGwKnhsC+OA2N96dTpUS4nj2NIDpQMC91y4hxNf7cshB+oS/gGBUFlV6Gb8LndldioSOkdNI/7z2+vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ub8lY5P6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ub8lY5P6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1121FC4CEEB;
	Mon, 10 Mar 2025 17:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626980;
	bh=COgnYyJK431DT7jBl4MtZ/5nNwmswxiI3YrqhXnNyrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ub8lY5P6aqc3Y5Gvsu9LkIaZkVHjln2e8jtP0K6zZwsLmVaCwIq+fFcH3uANehBaK
	 DmhKYbBXYdoXs7yuhaDnSA/Zaib3l4YKxPK1KlYey/XqmajWqeF6ZzTkHr6np51ZV2
	 7hR3BzJbxvezR9xfK88Fyjw9Q6v+WO+aDePTDJVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 138/207] exfat: fix just enough dentries but allocate a new cluster to dir
Date: Mon, 10 Mar 2025 18:05:31 +0100
Message-ID: <20250310170453.284181671@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 6697f819a10b238ccf01998c3f203d65d8374696 ]

This commit fixes the condition for allocating cluster to parent
directory to avoid allocating new cluster to parent directory when
there are just enough empty directory entries at the end of the
parent directory.

Fixes: af02c72d0b62 ("exfat: convert exfat_find_empty_entry() to use dentry cache")
Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 099f806450721..9996ca61c85b7 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -237,7 +237,7 @@ static int exfat_search_empty_slot(struct super_block *sb,
 		dentry = 0;
 	}
 
-	while (dentry + num_entries < total_entries &&
+	while (dentry + num_entries <= total_entries &&
 	       clu.dir != EXFAT_EOF_CLUSTER) {
 		i = dentry & (dentries_per_clu - 1);
 
-- 
2.39.5



