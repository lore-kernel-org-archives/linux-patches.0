Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A544428EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D72FC433EF;
	Mon,  2 Jan 2023 11:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658927;
	bh=RkxLZ62SkT2nkSHzCdxMHLC2+CuVdCg78Uv/39ImUDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3tLFRxpa7rgy7MYyyy225TarJIQ2sNbP95vdx9dQFHU4o4OWtt4eIBH/VorJjv7+
	 xmKGFte1plxRNNUiT+w99DdtmOnw0+QX8YzSk4aRJ9vSflRH3sVb4abOhQGekML80y
	 RXuJB0wVabtdseqbA3zOP4SXds/+NuRkCTOwCaEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzot <syzbot+fa4648a5446460b7b963@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 35/74] fs/ntfs3: Use __GFP_NOWARN allocation at wnd_init()
Date: Mon,  2 Jan 2023 12:22:08 +0100
Message-Id: <20230102110553.583846890@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 0d0f659bf713662fabed973f9996b8f23c59ca51 ]

syzbot is reporting too large allocation at wnd_init() [1], for a crafted
filesystem can become wnd->nwnd close to UINT_MAX. Add __GFP_NOWARN in
order to avoid too large allocation warning, than exhausting memory by
using kvcalloc().

Link: https://syzkaller.appspot.com/bug?extid=fa4648a5446460b7b963 [1]
Reported-by: syzot <syzbot+fa4648a5446460b7b963@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/bitmap.c b/fs/ntfs3/bitmap.c
index 087282cb130b..bb29bc1782fb 100644
--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -661,7 +661,7 @@ int wnd_init(struct wnd_bitmap *wnd, struct super_block *sb, size_t nbits)
 	if (!wnd->bits_last)
 		wnd->bits_last = wbits;
 
-	wnd->free_bits = kcalloc(wnd->nwnd, sizeof(u16), GFP_NOFS);
+	wnd->free_bits = kcalloc(wnd->nwnd, sizeof(u16), GFP_NOFS | __GFP_NOWARN);
 	if (!wnd->free_bits)
 		return -ENOMEM;
 
-- 
2.35.1



