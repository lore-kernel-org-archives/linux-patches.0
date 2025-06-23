Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167EC21D3DD;
	Mon, 23 Jun 2025 21:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714726; cv=none; b=I6BaNT+kcbsiB5HvUgBHfrRuMX0wFZZS2pQmIX98/ysKa9xmUmDiryQLSQnNzCBKpawS40dgU37Duit0thyT1fME3oWzJy5VBLafkQ7PHCwf7DBeukHjfxqTtibbrEf33zt48CQJjLoC3Zv73HrJxJ2UUn2mz0IahwaxE72u/xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714726; c=relaxed/simple;
	bh=+1Jb+dc8mYjzOZMU48BsCcDpje1kVknZ4ioB4hkWy/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGfQ6Ep0Ybo1e7s4bk4z+gp5u6zCcNbt7V773Ceb3+V7HR4rt6bALW70gn4Na86tygt1MVl/LpjKx7zC7ps2eC0iot0sTUsAdGQW3P1Ykhe02siI7j03C3mDC/D1fLHvicp+6w20WT1AUK1bG621uhSiCXaOudzLv4CkHG8N+GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxpByocN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxpByocN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20A0C4CEEA;
	Mon, 23 Jun 2025 21:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714726;
	bh=+1Jb+dc8mYjzOZMU48BsCcDpje1kVknZ4ioB4hkWy/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxpByocNC20C5ymYKYSxT3V1GOBKARLhoJniaRHe8VjNccBChKWLLdH77A6XrXrEs
	 gDXlf4ZDpRgocKeBzo7yoneYex+8wh9OJKiS85775dAFL1Au7anwmHsTNrAb9UDMdf
	 j+HMzBcWArcRJmuSEvW1rVStscWYbqgiU0/RsnYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianzhou Zhao <xnxc22xnxc22@qq.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 225/355] exfat: fix double free in delayed_free
Date: Mon, 23 Jun 2025 15:07:06 +0200
Message-ID: <20250623130633.508901622@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



