Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F771C5793;
	Tue, 27 Aug 2024 15:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772335; cv=none; b=mzaEsDlvoxiWFFADhS5vAawUMCVroI9U1pi5+TrWHlrtu+rugNcStyJrgDgR+wPi5cFotzaEdRuhGOawPA4lk+bYzYgtHQWPQnTO3kHK0RTOPqUy+fwFEp+Ef3sTXIAXBTeRK5mkPqtKFX4MDFAtnEONoTusFCco/RN4W+mtRto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772335; c=relaxed/simple;
	bh=9uQeTeTrEqLFzh3+sW4TbiytWS5WNE70Z/f2eSpVXv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6TY9MT+0BhMBKMcq0RjKu2xtIhbIH1Rb8WZSI5q62gOUQ8DxN/lz3pRey0HicRgcqv+saJwHdWW2Bw1/da7hOSVY4L+y3RbUx1fBmTfGoDryYSY3/9oR19lTnhQdA+XHx4sgwpIRcIPr/VnDjxlZIUwmN6Y6YSx2q9MHusFJok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Eu9IDrJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Eu9IDrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8056CC61071;
	Tue, 27 Aug 2024 15:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772333;
	bh=9uQeTeTrEqLFzh3+sW4TbiytWS5WNE70Z/f2eSpVXv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Eu9IDrJgEp8PlyY+USNRxfX7RHS/cJbttsnarWtajS1bJV6xQ2wLCWnggVhxD/nx
	 Iklzsag6xwEaq9mmn9j9Iy/kAqnjT478vYJLVCN6MueAokffieuq0flkwSHZMABh+L
	 nSWa6zDQWyHW/Qc8B6pF9d1DQjQHYM2vyEyxTOt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 184/321] btrfs: send: handle unexpected data in header buffer in begin_cmd()
Date: Tue, 27 Aug 2024 16:38:12 +0200
Message-ID: <20240827143845.233759557@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ec3db315f5618..cfbd3ab679117 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -720,7 +720,12 @@ static int begin_cmd(struct send_ctx *sctx, int cmd)
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



