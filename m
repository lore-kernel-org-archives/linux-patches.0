Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059996;
	b=KZTj/sFho+5nfh8hMkXRD01UAoFYX/4mUwIdN98SLaI8SEhKUeLotpd6zqPWp40K271R
	 k65HdRBlQMIoWkN8T3BANkVLUoqRZxy35ispj388nZz73DoeFFV4yniiboO1My/lkmChK
	 8qTZcdXvwf6r3yU3z8czSxi/MDiAUwUWlISBqs4QXWB2qXBYgDNesPapW4pzg13SbV8h1
	 5Nu3R2KxPhnvG/VQAqxA1AsFp3l72vqvjtQGqXUjUEOnjAwlphN0AiKECyybiGEcfjBuX
	 V7u7G1kxHBgZIiM9P+DoMCFh0RWAabfnDrPOEvh8nsHtZ2h/YjZA9aAe4BWn9tQzLaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HkR/Sz+GDeZryTIcugQlpPOukWThvrMdoLWOzOezBTg=;
	b=m4ONvvgCYgWV9Kn8gm+gBm/f+U9REbPD+AY6vrUZ3ezlPMPvu13AR2IIe2UftSmkYQYL
	 7tVRSWP6tYAmzuPPI+j1qxAhZWeG+kKNm1kIcZ4OYOnAV9Ct9HhoZfE9+pdbMZW5APC/u
	 zpP7nWhRRV3JF/AsvOCj2IKBzM7xE+qe2QPYjr/CyhOi5KTGOGoxXF515cdfwG9PJICpB
	 J9fxAtXavTZLbqp04AVSwwJvkP0OPhxENHEoFw+BeBOCV49RxiNSBc9aqjPB0mTtCVrp0
	 16OvjpZuaxNRkxTopqYEN5VI6DGK4Gw5d5kDdg9PTHOBDsYRZA4/999bpSXF2sdUTpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pSFn6cn0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59CE606A325;
	Thu, 19 Nov 2026 03:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pSFn6cn0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3455A1F000C4;
	Thu, 19 Nov 2026 03:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059996;
	bh=HkR/Sz+GDeZryTIcugQlpPOukWThvrMdoLWOzOezBTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pSFn6cn0ZJ05iLm7K2RuDLala0VcpkdBSnoV7VaiWYEduSjb3KVTdwIvVebNfSUcr
	 sUClHj+saPlRLDWR25q5Mv0AGu3Eh1EEZVkGFUBgVkrzopYc+XlHB4WH7DaV32jQkO
	 bEFYGI3nrghrHfr3zKIVSzIN/NlaJYQ5aMgCqUrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1041/1848] f2fs: fix to fetch ino via ino_of_node() under cache lock
Date: Wed, 18 Nov 2026 15:51:19 +0100
Message-ID: <20261118150000.919510186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit cd6d8b1891395b681f2060916a4b83880b765698 ]

In f2fs_writeback_node_caches(), it's better to fetch ino via ino_of_node()
under cache lock, otherwise, node cache content may become stale after cache
is unlocked due to racing w/ truncation.

Commit 493b9dc8b52c ("f2fs: cache: use node cache") fixes similar issue in
f2fs_flush_inline_data() introduced in commit 34c061ad85a2 ("f2fs: Avoid double
lock for cp_rwsem during checkpoint").

Cc: stable@kernel.org
Fixes: 2049d4fcb057 ("f2fs: avoid multiple node page writes due to inline_data")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: Adapted node-cache operations in f2fs_writeback_node_caches() to page operations in f2fs_sync_node_pages(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index fc1f0d3bf6ed7..b50ee5482cec5 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1958,9 +1958,11 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
 
 			/* flush inline_data */
 			if (is_inline_node(page)) {
+				nid_t ino = ino_of_node(page);
+
 				clear_inline_node(page);
 				unlock_page(page);
-				flush_inline_data(sbi, ino_of_node(page));
+				flush_inline_data(sbi, ino);
 				goto lock_node;
 			}
 
-- 
2.53.0



