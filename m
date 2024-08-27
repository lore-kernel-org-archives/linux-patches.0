Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8841C57AB;
	Tue, 27 Aug 2024 14:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770416; cv=none; b=NZ/dn6x4PaRzDrWXvl24hygC7HyQr5atU4EwVWfB08GCJIDjw+nRE7ysWOvyR+avWag47Ce2rFkQrQuWihoxS4clQj20xnbBuBX4iaUR4Um7saMvSudEiLM7l7yewn9ssdhdJlI5JMTao/Dyffi4XvljN3CMuy//7efn2KL65PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770416; c=relaxed/simple;
	bh=XwGLZjdQuxemyWXvXX05wPL0Fh8nALhw+FY6hNxAjN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCnqmbBLY4M01aiLONwPNueJyandVyP4qxz6ccV6nvWlHukQVCh87Q8RmThR6AL6E7Cp8pf3T6HF5c5MOKYSl77UfbnzSpwUWsNDhQ+FiqLwdIV/lxJzk5x6C6+GpNVcrcslX8QVjcNvk8CMIzTLW3rCSM5K/h08qKjtBohKPQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DquZhzR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DquZhzR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF37C6105B;
	Tue, 27 Aug 2024 14:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770416;
	bh=XwGLZjdQuxemyWXvXX05wPL0Fh8nALhw+FY6hNxAjN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DquZhzR9Lk2GJPuOqXHBqXqXvQ8Vcox8BDJMoPSgi0IHO2elGAq2aS0it3TUF7RK3
	 sCwMZRd92dMkXro6/EecMRcNIRE6Er/5QY045t+3yP58Z1DZjkL5vguGo/nrdCdG0b
	 p64o5yqocnVWVly8fUjuhUFLZHRzAFLz1R6fhR0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/341] btrfs: send: handle unexpected inode in header process_recorded_refs()
Date: Tue, 27 Aug 2024 16:37:02 +0200
Message-ID: <20240827143850.681987401@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit 5d2288711ccc483feca73151c46ee835bda17839 ]

Change BUG_ON to proper error handling when an unexpected inode number
is encountered. As the comment says this should never happen.

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index b153f6a96fc8c..9da3c72eb6153 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4195,7 +4195,13 @@ static int process_recorded_refs(struct send_ctx *sctx, int *pending_move)
 	 * This should never happen as the root dir always has the same ref
 	 * which is always '..'
 	 */
-	BUG_ON(sctx->cur_ino <= BTRFS_FIRST_FREE_OBJECTID);
+	if (unlikely(sctx->cur_ino <= BTRFS_FIRST_FREE_OBJECTID)) {
+		btrfs_err(fs_info,
+			  "send: unexpected inode %llu in process_recorded_refs()",
+			  sctx->cur_ino);
+		ret = -EINVAL;
+		goto out;
+	}
 
 	valid_path = fs_path_alloc();
 	if (!valid_path) {
-- 
2.43.0



