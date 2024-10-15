Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7905C1C57B1;
	Tue, 15 Oct 2024 12:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993684; cv=none; b=eLmtaSiM+CIF1lMIJ65pR5dTVscnWzPbCLULwlRIbfKHs/J9u28tMa3gNpeOMGvlizqBthx6KJTu/w9ABDeEGs2yTnweQJkzT79sFj/Lg6X7AZdM3JI0C+vjK2OKMwpZbKqjT7v8THFhmdkGxEn8lWuJ1Flg1ZH6WQ5e6+pShA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993684; c=relaxed/simple;
	bh=OAl0uJ8kQFow51AHFg5a4PbRMduY+2W/oqxknCKdzK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnBTAyBMc8Pkrd3GTnqQBKO+xIz+zM3jr/Mw5WwWTaPceY5Wj+4PH8l5qYei9F/2kOzLt9E6BiCKQiCxbw5owCe4IN+wBJ+svY02LhCtJW5Gx6ehFWt2UiDojHoNzxgkXre+Mo8NqUJz34i8yu8vuU4acPEmp4fxxIcZD/6pz5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyBdty+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyBdty+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E62C4CEC6;
	Tue, 15 Oct 2024 12:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993684;
	bh=OAl0uJ8kQFow51AHFg5a4PbRMduY+2W/oqxknCKdzK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PyBdty+1kaTNBWfg3O1yBhFj28yLoAbxqua4t/d5mcdmMrHSU/IkaxS6+qxD4ap+6
	 bKxXXE6rcfr4dPg0nF9dnr9wFo80r2uj66+47q/XdgmFMckeKb53JCXH9VT+Kk75VN
	 iNYvoC8YBpVFv1znZpHb6JTmTqwzURZT7wlgLnIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e38d703eeb410b17b473@syzkaller.appspotmail.com,
	Remington Brasga <rbrasga@uci.edu>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 453/691] jfs: UBSAN: shift-out-of-bounds in dbFindBits
Date: Tue, 15 Oct 2024 13:26:41 +0200
Message-ID: <20241015112458.326123553@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Remington Brasga <rbrasga@uci.edu>

[ Upstream commit b0b2fc815e514221f01384f39fbfbff65d897e1c ]

Fix issue with UBSAN throwing shift-out-of-bounds warning.

Reported-by: syzbot+e38d703eeb410b17b473@syzkaller.appspotmail.com
Signed-off-by: Remington Brasga <rbrasga@uci.edu>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 625457e94b30a..1eb28c4ccee54 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -3088,7 +3088,7 @@ static int dbFindBits(u32 word, int l2nb)
 
 	/* scan the word for nb free bits at nb alignments.
 	 */
-	for (bitno = 0; mask != 0; bitno += nb, mask >>= nb) {
+	for (bitno = 0; mask != 0; bitno += nb, mask = (mask >> nb)) {
 		if ((mask & word) == mask)
 			break;
 	}
-- 
2.43.0



