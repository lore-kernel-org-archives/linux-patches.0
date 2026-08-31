Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A8B4B1272;
	Mon, 31 Aug 2026 13:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184237; cv=none; b=fLrwVmvErr+bAIB+Hr/vMpCu/aVXZlUjj3om3/+2l2oskXwrUu6u1PKa3l6IF7gpRw+EWG14V45yoeU9OpRYml3gt8iDembjpfrZfAykzLd8WtKecUFytR5e4QEErWyqBxmjBmXGgHHYBj1/owaU/92aMQE7q2Hzf4ITaNTbI+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184237; c=relaxed/simple;
	bh=rj7hPseSq2O2yd9PKZADs0ypRlz1tHaw/VPwiUoL+1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+nxVZ/oasoMLTZpf04lODKyqhR/i793IIySnx0YmHFKv1Yl0KmS/qudksOvi2vy42BG8QpHIcBNK8xWYC3Xo8xMxJk1wEs4QUxDMFO+W/98H2Lf0OnJlTDr0CMI/jO3poBE+hb3GYpxOh4xABVIQzGSwCtrOVCZVigM4t4JSug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4V5Oo0D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4V5Oo0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCC41F00A3D;
	Mon, 31 Aug 2026 13:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184236;
	bh=Iv9kf7jn3K8Ck2lc2HZ6z/pFuOcDP+3CPLjgrZCAcWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4V5Oo0DVl6kKti5zjBwSvfWreehs28mTtvpdprvxrCYpY2B7kPA+6Im/XM1d5gil
	 vbtQ7aJXeGV4sOsnm3Q+G4XIi86g7CDWIi6Goh4EhegrKPzZOaBfXUcXCUFWqIIz5U
	 A/7WRaWp6kIQSYk7QrplaFb/5VNpiS/Bip4M7p80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianzhou Zhao <xnxc22xnxc22@qq.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 20/99] exfat: fix double free in delayed_free
Date: Mon, 31 Aug 2026 15:33:49 +0200
Message-ID: <20260831133400.901877133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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
2.53.0



