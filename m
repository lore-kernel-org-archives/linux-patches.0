Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8B132E13F;
	Mon, 27 Oct 2025 19:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593107; cv=none; b=udrzmPXpJeD7pWznTrLzYwcfxbPnJ63xQG5gLDhxl89qwb1LFCSrvIzxaiQoW+MD0LhkqYO4R5UkZU/YxyL88k7mRfQRP7gfEqEFnS1I9qg5lXwCrhjX91iMa+5L1B9V/efvIWMarK2BMFebuakdqiGCouZuL4htQGfDKHSoAr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593107; c=relaxed/simple;
	bh=ohQrcnqq/6igKA1BOdtjY3qDZQpIQjwqBj+MnJFF4Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZ534Ja5ZE2KFm3uiU5B6jZe0ojroNKTQ0cyCJAIBrvtCWBGtcpWllL7Mi0k06i5JMRZ8/dIAfSxsjf00F+9uI5efncd6Fsd4eksfnL8VKT8JhBqNSortoA7WKeygvdgj+Mosf8ECyrxsNj50OK2HEC2BtZleO9BpZcb0Sod50Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/xHod+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/xHod+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54174C4CEF1;
	Mon, 27 Oct 2025 19:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593107;
	bh=ohQrcnqq/6igKA1BOdtjY3qDZQpIQjwqBj+MnJFF4Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/xHod+9byxhWx+JYvemTeKDvWTeCG/atTE2DQnileStfKczU+02PxytbrigIovGP
	 7KiXLZ6fVI7uFqaBfye5k+X3eXe/9Db1xG9dzaAE9x+CEoPC7xnYPaSFNpLAI6npV7
	 01Ak1klMx9fKm33IakSWCp28KIstZYYdkeXMNfws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 016/184] hfsplus: return EIO when type of hidden directory mismatch in hfsplus_fill_super()
Date: Mon, 27 Oct 2025 19:34:58 +0100
Message-ID: <20251027183515.373309106@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 9282bc905f0949fab8cf86c0f620ca988761254c ]

If Catalog File contains corrupted record for the case of
hidden directory's type, regard it as I/O error instead of
Invalid argument.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20250805165905.3390154-1-frank.li@vivo.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 2f215d1daf6d9..77ec048021a01 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -537,7 +537,7 @@ static int hfsplus_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (!hfs_brec_read(&fd, &entry, sizeof(entry))) {
 		hfs_find_exit(&fd);
 		if (entry.type != cpu_to_be16(HFSPLUS_FOLDER)) {
-			err = -EINVAL;
+			err = -EIO;
 			goto out_put_root;
 		}
 		inode = hfsplus_iget(sb, be32_to_cpu(entry.folder.id));
-- 
2.51.0



