Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5902F83A2;
	Tue,  6 Jan 2026 17:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721357; cv=none; b=CkNvtNqr3rrVfhNsza8y31lu55/y01jaGw4WEAYAb6vgdhUpMjUcdDI7t+7YusvMR3U6BEwEseU7Emi/RNahmHYiGg2gamqbjjgA4/6YKRLEzR9zsqanClppYxRm16lyOpXlWYHp5R5Od7p5X99VX2ckQ+hfGTXXzrZR3bZ8ue0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721357; c=relaxed/simple;
	bh=KQ02eY+RLFz2DSultkds+L7HxM6p+WzWeeIVBda4/PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNkmFbdeAQqEA730syAJNQ/ByTcGiaQK3PyEmVNXIigw+mz+i2xXGnnkmVWakG+Q3A9H/WuwdS46IYixUJNil5PxFfVxK1lslOJ6n4VdZtFCyQuBfDvz/kfrjMdrSrgxZM4jIn9w9Lbjq7/Wa15a6qx2gcv992JuB0u6DTLHZX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vdj60hqb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vdj60hqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A65C116C6;
	Tue,  6 Jan 2026 17:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721357;
	bh=KQ02eY+RLFz2DSultkds+L7HxM6p+WzWeeIVBda4/PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vdj60hqbmOuWluTT8ItO15PdXly/aeW0cvAGPxoQjykdgeNDYvktqqrsvkGSUrP5e
	 IyXUe+vFL19twR985/U8twE7AlM+9vyhZVXfOoFT3V1qgdwBLsyjr6JryfAIqjLjMu
	 IENexlF9LtntF1AHOvdSoga8XNyXd7/N2SdyVXy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Feng <songfeng@oppo.com>,
	Yongpeng Yang <yangyongpeng1@oppo.com>,
	Sheng Yong <shengyong@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 512/567] f2fs: clear SBI_POR_DOING before initing inmem curseg
Date: Tue,  6 Jan 2026 18:04:54 +0100
Message-ID: <20260106170510.316681873@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sheng Yong <shengyong@oppo.com>

[ Upstream commit f88c7904b5c7e35ab8037e2a59e10d80adf6fd7e ]

SBI_POR_DOING can be cleared after recovery is completed, so that
changes made before recovery can be persistent, and subsequent
errors can be recorded into cp/sb.

Signed-off-by: Song Feng <songfeng@oppo.com>
Signed-off-by: Yongpeng Yang <yangyongpeng1@oppo.com>
Signed-off-by: Sheng Yong <shengyong@oppo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: be112e7449a6 ("f2fs: fix to propagate error from f2fs_enable_checkpoint()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4804,13 +4804,13 @@ reset_checkpoint:
 	if (err)
 		goto free_meta;
 
+	/* f2fs_recover_fsync_data() cleared this already */
+	clear_sbi_flag(sbi, SBI_POR_DOING);
+
 	err = f2fs_init_inmem_curseg(sbi);
 	if (err)
 		goto sync_free_meta;
 
-	/* f2fs_recover_fsync_data() cleared this already */
-	clear_sbi_flag(sbi, SBI_POR_DOING);
-
 	if (test_opt(sbi, DISABLE_CHECKPOINT)) {
 		err = f2fs_disable_checkpoint(sbi);
 		if (err)


