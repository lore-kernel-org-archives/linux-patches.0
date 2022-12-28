Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACC21863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F60C433D2;
	Wed, 28 Dec 2022 14:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239116;
	bh=D5WXWKAMh/U/o3bUFjMYFK//R6cloyVnmOzBd63zD0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQWymdqm6q8Ae26rnB5KE8c1wKQ5C4Kwpnbty6RkN1O5duxpTuUbjZoS/kI6zxOP3
	 yYoSLX2DGjA8mZnWXzqbyFzngj6sQvYBfDAtTYCl20ii0bK4AbsAA6gzVuqKYmT9Rb
	 EDjkZiaVaeUSQpC/Sl6zJ+fEDosSyPcnmKefVI3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/731] fs: sysv: Fix sysv_nblocks() returns wrong value
Date: Wed, 28 Dec 2022 15:34:01 +0100
Message-Id: <20221228144300.434198992@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit e0c49bd2b4d3cd1751491eb2d940bce968ac65e9 ]

sysv_nblocks() returns 'blocks' rather than 'res', which only counting
the number of triple-indirect blocks and causing sysv_getattr() gets a
wrong result.

[AV: this is actually a sysv counterpart of minixfs fix -
0fcd426de9d0 "[PATCH] minix block usage counting fix" in
historical tree; mea culpa, should've thought to check
fs/sysv back then...]

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/sysv/itree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/sysv/itree.c b/fs/sysv/itree.c
index 749385015a8d..5a59d56a2038 100644
--- a/fs/sysv/itree.c
+++ b/fs/sysv/itree.c
@@ -438,7 +438,7 @@ static unsigned sysv_nblocks(struct super_block *s, loff_t size)
 		res += blocks;
 		direct = 1;
 	}
-	return blocks;
+	return res;
 }
 
 int sysv_getattr(struct user_namespace *mnt_userns, const struct path *path,
-- 
2.35.1



