Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C625417C;
	Sun,  1 Sep 2024 17:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210103; cv=none; b=Vma7XCxv8b+X07HcUV6YMfxX9pQYoZB6+Asrti4hiOsKoBN2VGxiz4RnY76mExpZA+1gk0vzm+t371n+DGZH5k5/dvfufe6GE5/fcC8sBvlgDPWtA4EK740h4O6TjGpRxJtHs3cEZJXMsDBgirUWUAFexc7WKg09exNG0h2oBP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210103; c=relaxed/simple;
	bh=SsCIuGjM0qQ87CNI3JVqLGTdSYRE2jh4FIBwqRLw7p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4kc2WYV34Cd9MNNiZAB9+7P3lEiQiJ9OZt+Ps3zjTrfkMDwuxnlh1R2e2UBMAFAaYwpMLZJ7SlPh2rgJc7t3RVDZ+tknJvtIqORX2OgXhV2ZGlD2sJXqw7eMAjjiiTz+oLh1nOrxpEoEPDCnj9Jnet/WwwPrmUzNNRidTKrt/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyUjG3No; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyUjG3No"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE6EC4CEC3;
	Sun,  1 Sep 2024 17:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210103;
	bh=SsCIuGjM0qQ87CNI3JVqLGTdSYRE2jh4FIBwqRLw7p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyUjG3No9QNAG75EzRhVHuo6PGqfDGpW+pxTyaRnzU0ajoT8u0gf0nhZ02GsgObAn
	 FOFrZke0UuAkJ9WuMmZ5j6VmHdrSUE4/p0T4zXj87ZTr0E59IpN+86LEHIHpMe85Z4
	 8ouDiQo+tgXXjemf187NwHcW3FA6v28/JOt2VKxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/215] btrfs: send: handle unexpected data in header buffer in begin_cmd()
Date: Sun,  1 Sep 2024 18:16:41 +0200
Message-ID: <20240901160826.717650748@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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
index c2842e892e4ed..27a33dfa93212 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -695,7 +695,12 @@ static int begin_cmd(struct send_ctx *sctx, int cmd)
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



