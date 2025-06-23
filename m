Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A9B220686;
	Mon, 23 Jun 2025 21:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715734; cv=none; b=d7keOz7Dked7W6AI9pu3/FngkkijY+zleMFbeaPNyv3DXFVhQBZBNGmKixWknvtveLlvP4XHRv3uLQkyjWU5gJmbcawxj6FvTk/+i33huDMivCBoIQjOM6BJ9W6nhJyC8LaSjF/PZcbQjcEgSzD4L/5liBYFn351wDJv09y4k80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715734; c=relaxed/simple;
	bh=sFwoE58H7Xc1+bgGM81akl5Swk6XOiAE9H4bjEBhZ8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HI0nMkX6Bh7xvhsawMmJwaBwO1juAcGddzcn7eRp9Fy6kR+UhB9HimnvoTQWz1U8b8+djWf/hlq/kfLeAM4v+l9wiUAI7p3kzGLXh0Lp+X06wxTk98eRgOK5lrZeZ6WUnntyO2g1UB+1nvK+hwsvJH+p/gMnr+FqTtY3cpm7FdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hScxGwE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hScxGwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CFCC4CEEA;
	Mon, 23 Jun 2025 21:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715734;
	bh=sFwoE58H7Xc1+bgGM81akl5Swk6XOiAE9H4bjEBhZ8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2hScxGwEFXK5ii+HjJRTjbUhm8QBwcN4Ihj1BMmQ5R+ILakoKuPIxJ9Xc5eBHlDU8
	 bmlCGLKYLkvPNwpgd+YQ8jC7R746c9IkJUT1QX9FRutpUXYVTAznz4yg2rLW+8cI0t
	 VoXCxq7gHj4Oc1nU142FmX1avvjr3baEOHwbpm04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianzhou Zhao <xnxc22xnxc22@qq.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 275/411] exfat: fix double free in delayed_free
Date: Mon, 23 Jun 2025 15:06:59 +0200
Message-ID: <20250623130640.576712566@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 314d5407a1be5..a75d5fb2404c7 100644
--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -804,4 +804,5 @@ int exfat_create_upcase_table(struct super_block *sb)
 void exfat_free_upcase_table(struct exfat_sb_info *sbi)
 {
 	kvfree(sbi->vol_utbl);
+	sbi->vol_utbl = NULL;
 }
-- 
2.39.5



