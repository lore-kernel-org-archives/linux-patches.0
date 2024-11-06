Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601731DFE27;
	Wed,  6 Nov 2024 13:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899198; cv=none; b=qa9oRUfTJtlqe052hcda1RwTHcXf8wvo4AxmdvCgZ7DBZPxJnv9ySOGd8ps0H4RY9Ah50Nk5Wa98MJqS4sQufE+ytXVuipOH7PIPRfZsEv/UoDR4aLCtc6nwFDwEvE9zENc2blK1Kyjavy6cyx2j3V7lugWLyCySzHM1EVSRozs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899198; c=relaxed/simple;
	bh=Y05lbFBQSAf6IsuK9YH3BkooBMudVEPMTT3nUisBbCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLA8gBYP2/UAB6h23kSAPgUOGgXrxNuCc8OQFdtWqkHIVx0vWq72bcwPP+7caM3Z8FKkEfvD/gpd8sr2Toemqg7XqXcLhmxUhgwk5wy/9d3bOGtennB7plSL6g6uj/JWrI/T33d9YwcxolAR04xa67g2UnauYLvADImwkDASKHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGh2FWto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGh2FWto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E82C4CECD;
	Wed,  6 Nov 2024 13:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899198;
	bh=Y05lbFBQSAf6IsuK9YH3BkooBMudVEPMTT3nUisBbCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGh2FWtoD7iARH4UlCArrU1HvrkW+GHuU+K/9pvwN2Dbrcb8utXH8i2ehswlEGoXZ
	 VykhU4VimIeIbD6Dvg1UMv6fHQ/6YVkxbR0yHO9OtEurf8auGdcIYs4dI/ZZDRUdLa
	 91RWlbog1fGs8Vjvl3tjbS8H+/BYd6JGMmG/Ew0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bc7ca0ae4591cb2550f9@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 32/73] fs/ntfs3: Fix possible deadlock in mi_read
Date: Wed,  6 Nov 2024 13:05:36 +0100
Message-ID: <20241106120300.922974694@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 03b097099eef255fbf85ea6a786ae3c91b11f041 ]

Mutex lock with another subclass used in ni_lock_dir().

Reported-by: syzbot+bc7ca0ae4591cb2550f9@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index bff1934e044e5..c1bce9d656cff 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -79,7 +79,7 @@ static struct dentry *ntfs_lookup(struct inode *dir, struct dentry *dentry,
 		if (err < 0)
 			inode = ERR_PTR(err);
 		else {
-			ni_lock(ni);
+			ni_lock_dir(ni);
 			inode = dir_search_u(dir, uni, NULL);
 			ni_unlock(ni);
 		}
-- 
2.43.0



