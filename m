Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0F32F7ADE;
	Mon, 27 Oct 2025 18:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590800; cv=none; b=etAzvqXZOAwQyO1I5h+34bnKxTBnSHxVeDz5aGCoaqn7uCP8jRjVp9Nz73zyurBio8BJIiLphfMKvO/4p6dDaldJbc4wzuWV+fYhk1n4yGxE7JPFEKIQtygZ2AQGYoaktG6RwLosWQ+fvEpIE3OZd6fYG4B1grMVORvt7CahG1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590800; c=relaxed/simple;
	bh=WUBm6Yr0RumIqvtnFmj4i+QnKZ3kkML/wITdG0MtNqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKiQB5DkooSc7/s+PE4yw6+quWf1WNbZvscYw36dT9yf5oLvKd+nkwRh8wCKbr5Oh+OgGjwQHqzZzUs2a4QKwvXuNty7uAo0FThI3XDx54tNW6nYBVSBxtWapcuk05D0EYg824mzfaE+k0uZWS+w6GjBUnHwGIljOygrRdc84qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8WrnmjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8WrnmjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B43CC4CEF1;
	Mon, 27 Oct 2025 18:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590799;
	bh=WUBm6Yr0RumIqvtnFmj4i+QnKZ3kkML/wITdG0MtNqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8WrnmjLS8ZKflD2iGDvPi2P9LZhw5JGgOT/R8fx+XkQ9Dyq4K4RmpgzAV5JGNv2S
	 kH8TkY48kK0T45ZdnbmpjSGvz7QmmExImAAP4T5aBt6VnxgItEgc3yD7z5nbvXN/jI
	 I0dlRYC6aRQ0ZrBWvYbtb9rxUXL2VoNQ6FayBhtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 180/224] hfsplus: return EIO when type of hidden directory mismatch in hfsplus_fill_super()
Date: Mon, 27 Oct 2025 19:35:26 +0100
Message-ID: <20251027183513.682443018@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d744fde416804..db68ed59b4b21 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -539,7 +539,7 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
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



