Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3241C07ED;
	Tue, 15 Oct 2024 13:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997950; cv=none; b=gA7Gdi83NOcW7bseop/2M8kTESZ0asvGqxU4dQVw9I7jIQgcqcy0POqAr1TsrKdVDeX+CgsidlFkSHAepcayhRT68ix6b9j/tbr8PDZv8FXW7UQfObpFjghaJQevAqZPPPjr1cRhJH9HBaPel7YjX+0cUx5HGoiNRxIdlM2gPCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997950; c=relaxed/simple;
	bh=CyViX1MPm/7dk2lAOiD2+WUb8reZKmWf0crkWF6cXgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYtW9VUS/MvESvJL+Lo2lcl0sm2RAc1nGqtpoUxyqdivhF6bY8pBtVbG8RV8BuNW8C95WYwARggYfEpa0Drq1+h/WRNomQf8PNQLpDCWDJ2XFZ1pONT17bFzNOhhU2y66he/chu9pqB4OFA5SQVcNuNVW1KZlEJf4DLQ548hTQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnTVM5aG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnTVM5aG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7BEC4CEC6;
	Tue, 15 Oct 2024 13:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997950;
	bh=CyViX1MPm/7dk2lAOiD2+WUb8reZKmWf0crkWF6cXgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnTVM5aGCkz8U52VljUgksLyhTx1joK8w8/wRLWVaTGsia9g8qXOTjR0GsYNZAZ/0
	 j1RaYm3oW8NmoG/XvsNRpVxcWjdp5h1vvHUfTAIV5evwOJ/VpYIVEbkIgDej1Psiim
	 WU3z/RPDHKz8lL4n8vGwcdQK3DBpXG9DblGrwmYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e38d703eeb410b17b473@syzkaller.appspotmail.com,
	Remington Brasga <rbrasga@uci.edu>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 334/518] jfs: UBSAN: shift-out-of-bounds in dbFindBits
Date: Tue, 15 Oct 2024 14:43:58 +0200
Message-ID: <20241015123929.865486619@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 801996da08a45..750853367d4ff 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -3084,7 +3084,7 @@ static int dbFindBits(u32 word, int l2nb)
 
 	/* scan the word for nb free bits at nb alignments.
 	 */
-	for (bitno = 0; mask != 0; bitno += nb, mask >>= nb) {
+	for (bitno = 0; mask != 0; bitno += nb, mask = (mask >> nb)) {
 		if ((mask & word) == mask)
 			break;
 	}
-- 
2.43.0



