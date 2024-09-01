Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAB01DFD1;
	Sun,  1 Sep 2024 16:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209635; cv=none; b=DCBJndmQYduMmbOVXLyBmwqfQQWCum/kuBff50Gs/ja+BmiV27PprLmkhHtc60/MPEuHS22j4CTxo8+ijF05Qs5M7k52ccJMr3w7AA7l20wlxbesAkquQgyKDKd7JlOw8Fflp85ctLUY8KZPyCSdVR4C1XTivCVjNZiIKHRJLHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209635; c=relaxed/simple;
	bh=MinyPCOWysreGpc1qXkm6YwrwNBPiDb3oPUTMTfAKP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzDbA8ZvXHGnl0B1w9glXl4H0KtMKR35hZ0SQ4QGU/lo428nQm49e0tg/tKxOYqh8nTeEDjVtow1df8jI8KfZ1KnOeeN1fR55tQNSFM8DgxGhv2uHa8CN+b4V6DZabiD3mRqk9t+KHM9B4uKFNXoBc4HwBzCojG//l2GtGCiV1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4YlUDqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4YlUDqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C8FC4CEC3;
	Sun,  1 Sep 2024 16:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209634;
	bh=MinyPCOWysreGpc1qXkm6YwrwNBPiDb3oPUTMTfAKP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4YlUDqpqyp2kG5ywo/GETNm4d8hzL8oNR6ia5SQ3bbgt3EiU3z7Erx7rjxu/xWYv
	 PKluik1HYow9xrTRyVbGBAlYyxpCUfWKcNnqRKLOwnBKp16WFKZARx/U/fk5Ky4oin
	 SK/rK0DihcAcPifEL6Lb/IB3TKJ6Jav8z/xIKfOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/151] btrfs: send: handle unexpected data in header buffer in begin_cmd()
Date: Sun,  1 Sep 2024 18:17:06 +0200
Message-ID: <20240901160816.600950547@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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
index a5ed01d49f069..a9e72f42e91e0 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -685,7 +685,12 @@ static int begin_cmd(struct send_ctx *sctx, int cmd)
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



