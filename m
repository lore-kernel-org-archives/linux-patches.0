Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1E81C68C;
	Sun,  1 Sep 2024 16:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208951; cv=none; b=TTVRFnuvJA/xImXUEsQuf7h15MAywyJm2qdLPDp1qOIkssYFDJZTNvEJfRdhPxAGNmZK/nuNzOYEaGk0VINw5woLbngDoFCOriDkmlvykx/TEoYTcKzxo/K7UfU2mQBQHoSIF7Iq7CrPFNrbtxlHmxamsQ6ZJIu9W3EvrVNFoko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208951; c=relaxed/simple;
	bh=G34I3/sLgoQVAS87JX6xG34XbL8W7/q4GLsB9z+acAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diBn3dWBT4bWwh4pJ1L6AWhkSbWOHGu8nksGnGd4XB3KtNeALozsf/R3AoUGTE9O1daHuoIF4Hrpv3+4O7QEbPIRGr+/An+IUCrzNScxL5ex5O+BIljib+SiTtHkd5EikDAHWeFzZ8ZIArNfNJ+ufkd9jB2Fn11lvvOngP3kpis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYZ/dFi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYZ/dFi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50A0C4CEC3;
	Sun,  1 Sep 2024 16:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208951;
	bh=G34I3/sLgoQVAS87JX6xG34XbL8W7/q4GLsB9z+acAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYZ/dFi6IXQjGWByK/VY+Ver+wATLgqaQANnRP2X57tqcsW3ePB0TKQhZMmcZLG+S
	 lWL+BmT83TwPLalj2jzI2tqZEsfM+11ZtErftZB82vd2cYHdQGx0ihryYWP9gxl6AL
	 9svllSXV7RKaAeTkvBAfMfwGEY4NQM8LHH70+sso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/134] btrfs: send: handle unexpected data in header buffer in begin_cmd()
Date: Sun,  1 Sep 2024 18:16:44 +0200
Message-ID: <20240901160812.288773353@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit e80e3f732cf53c64b0d811e1581470d67f6c3228 ]

Change BUG_ON to a proper error handling in the unlikely case of seeing
data when the command is started. This is supposed to be reset when the
command is finished (send_cmd, send_encoded_extent).

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 576c027909f8a..e1063ef3dece5 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -692,7 +692,12 @@ static int begin_cmd(struct send_ctx *sctx, int cmd)
 	if (WARN_ON(!sctx->send_buf))
 		return -EINVAL;
 
-	BUG_ON(sctx->send_size);
+	if (unlikely(sctx->send_size != 0)) {
+		btrfs_err(sctx->send_root->fs_info,
+			  "send: command header buffer not empty cmd %d offset %llu",
+			  cmd, sctx->send_off);
+		return -EINVAL;
+	}
 
 	sctx->send_size += sizeof(*hdr);
 	hdr = (struct btrfs_cmd_header *)sctx->send_buf;
-- 
2.43.0



