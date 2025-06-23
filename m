Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C29424679C;
	Mon, 23 Jun 2025 13:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685608; cv=none; b=bNKQspeOYwhjyfYwFGLwkExRCnRox0CWp8VpRPB4XsamR/7hWcJLGm2uW+MhyNrWQpUkA4GfPuWOzwioyWxnX+P1FIBQluMm7zCk0iVTPHU8lHcCk5rXW6GP3nS4YeyuvujFWv8VCUaEC0Fovvht00+StxgVIA4tdcLyitNef2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685608; c=relaxed/simple;
	bh=DND0M6G1JS1/R+rhKdM25mTxoBs7cqI0ABdmS1LcmDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FB7Xj2QQiNmgWmvExvj9876aMQn6kwNpxZzFzHvtoZ2Da77y8QUyTF/8c0Pw+djiXQZqKyz8NxEF4MqyebbbWZEDHgJ0w1TLr4Nr3BDjy5aNABKYz+REAafNO+2aU8LIEtN7C2U0s7OqPicZMRKhHKzbDdcPzsnbLIyQWHYH2NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STMjzRNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STMjzRNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F43CC4CEEA;
	Mon, 23 Jun 2025 13:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685608;
	bh=DND0M6G1JS1/R+rhKdM25mTxoBs7cqI0ABdmS1LcmDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STMjzRNV5z8paum3RaBBYhhnIyymp+7ZgTdwleX5pjK+ST/k00P8A1fKDQ51MRliu
	 qseXhElD4nUViiY54ouECX6HGjOkQy7EiMDQxpMHwXnuDSzlMVdzsqje0oEn23/r5i
	 4XFCOIyJ9fTwkzUgJvfrG3d1fEUm2fANIBs8Ki/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianzhou Zhao <xnxc22xnxc22@qq.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 247/592] exfat: fix double free in delayed_free
Date: Mon, 23 Jun 2025 15:03:25 +0200
Message-ID: <20250623130706.168825156@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 1f3d9724e16d62c7d42c67d6613b8512f2887c22 ]

The double free could happen in the following path.

exfat_create_upcase_table()
        exfat_create_upcase_table() : return error
        exfat_free_upcase_table() : free ->vol_utbl
        exfat_load_default_upcase_table : return error
     exfat_kill_sb()
           delayed_free()
                  exfat_free_upcase_table() <--------- double free
This patch set ->vol_util as NULL after freeing it.

Reported-by: Jianzhou Zhao <xnxc22xnxc22@qq.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/nls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/exfat/nls.c b/fs/exfat/nls.c
index d47896a895965..1729bf42eb516 100644
--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -801,4 +801,5 @@ int exfat_create_upcase_table(struct super_block *sb)
 void exfat_free_upcase_table(struct exfat_sb_info *sbi)
 {
 	kvfree(sbi->vol_utbl);
+	sbi->vol_utbl = NULL;
 }
-- 
2.39.5



