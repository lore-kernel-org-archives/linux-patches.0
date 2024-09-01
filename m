Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8C617E01C;
	Sun,  1 Sep 2024 16:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207655; cv=none; b=b+A9FZjoU8E/8txt8eyRghfg6kFVHDm79BupQ1B4Nif7Bi9RYxsorFqo7IjO0GJHEppYGUGAL0Hc9FT6YAoBvqmYRR0IaqwNplXmYXgpX7ZfcFpDEOxY5Nf5mQGimpu1FUiGagV+L7E93+YKGLOG0FQocHhKQoT60prOWlUwnR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207655; c=relaxed/simple;
	bh=HW8QBKasgQNc/x+cRK0PyLuaqPGaF/dyP0i1TgJLSjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPpn5vT+wZaH4Tj+aSbKx2xQ4r9xIAtZqE9NKtYmohOE6+WQiG7KshcNksaR6ATLab8UjQGEoRArapp7AxeXDTquG8ZG30HkwvWL92TaVNG1GFa3JpG8wYqmRFkd+yQ8oUBJrvb5mW892QLoZa6/sdzACZ1ZCmVp+2bBP5/1KUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsilJ7p2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsilJ7p2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0FCC4CEC3;
	Sun,  1 Sep 2024 16:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207654;
	bh=HW8QBKasgQNc/x+cRK0PyLuaqPGaF/dyP0i1TgJLSjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wsilJ7p2H/EQ4sIrhnUNWpW/ZzPOXutioFkF36Jpp+zNPBy5ZLhTzhZViaELH4Qe3
	 OPn0ltB06rYvpKENrQMO4Zl8XbCoKcKWlFJKFOAQRbyIgtD2apDtS1M/5zR6mW+lLv
	 ZdGZb1elAFK6fg3Oy8g1SmLln44ZohFdgN9stua8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/98] btrfs: send: handle unexpected data in header buffer in begin_cmd()
Date: Sun,  1 Sep 2024 18:16:08 +0200
Message-ID: <20240901160805.136316256@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index e3b6ca9176afe..2840abf2037b1 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -677,7 +677,12 @@ static int begin_cmd(struct send_ctx *sctx, int cmd)
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



