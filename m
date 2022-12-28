Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E20F1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1727C433EF;
	Wed, 28 Dec 2022 15:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241810;
	bh=341Irjy7OAyENGO9M+wnz4E3V61UtC3nXWZORmmWKjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDrk3vV5EmMnuArafZchs0kd87h9jyCZzIqRXAhV5UBsX3m84loQGh1wmW4RfkO16
	 0Qqw1QbPtXXv4RS9U0lxiE9OL+p6ZoRr6NoCnSoqmSyGNrZhDpixwmI0heZSq0oDq0
	 DJ5uKeaSObCTo27DzGm7chO86TScVh8VyGXmkZqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Author: Randy Dunlap" <rdunlap@infradead.org>,
	syzbot+35b87c668935bb55e666@syzkaller.appspotmail.com,
	Shigeru Yoshida <syoshida@redhat.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 525/731] fs/ntfs3: Avoid UBSAN error on true_sectors_per_clst()
Date: Wed, 28 Dec 2022 15:40:32 +0100
Message-Id: <20221228144311.764599251@linuxfoundation.org>
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

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit caad9dd8792a2622737b7273cb34835fd9536cd2 ]

syzbot reported UBSAN error as below:

[   76.901829][ T6677] ================================================================================
[   76.903908][ T6677] UBSAN: shift-out-of-bounds in fs/ntfs3/super.c:675:13
[   76.905363][ T6677] shift exponent -247 is negative

This patch avoid this error.

Link: https://syzkaller.appspot.com/bug?id=b0299c09a14aababf0f1c862dd4ebc8ab9eb0179
Fixes: a3b774342fa7 (fs/ntfs3: validate BOOT sectors_per_clusters)
Cc: Author: Randy Dunlap <rdunlap@infradead.org>
Reported-by: syzbot+35b87c668935bb55e666@syzkaller.appspotmail.com
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index f3b88c7e35f7..39b09f32f4db 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -672,7 +672,7 @@ static u32 true_sectors_per_clst(const struct NTFS_BOOT *boot)
 	if (boot->sectors_per_clusters <= 0x80)
 		return boot->sectors_per_clusters;
 	if (boot->sectors_per_clusters >= 0xf4) /* limit shift to 2MB max */
-		return 1U << (0 - boot->sectors_per_clusters);
+		return 1U << -(s8)boot->sectors_per_clusters;
 	return -EINVAL;
 }
 
-- 
2.35.1



