Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704460;
	b=1Hzhsoee7lxClnU3BKb2lu06JuNwL7ZIlU7wOpyWrk91rY/tnpxnglfi/r6HOymKrGrT
	 1nGLZBTNtGXAIARP5u9kanzycwVxS19PR6YREdOIEUYvpVG820VTE+K9v770G6tJq/qsn
	 ZVmoYCi7RqEKhZ29sLJT5rrzFJKffaoMqnb4XBTWpGppHVljEZ8PNZJ46F0MmxBWRwTQ2
	 vkUREqLnTNAWv8se2CfpJaAaaDCpG0xffgjhZsE/wFOPrauSCtjYOBWH3FXZxzT+D6Gp9
	 zowLflp9DaPLg9TFZw/7Czdffb3zmA7f0kqEBK1B8JiARLuN5/Mgz1SCPLQMBJiNNvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vwNjNn7RrhRVyR/Ha6HGCAjAeaTQtm71JqYxeoE/sfw=;
	b=SYaBcNfbPQaj877iLEcVb5dUK6l9ONIGxUhFkZDDRG/dSUHI5U0DupuIhAodvGXRiEaP
	 XvOp9trexJp/9A0/W4kN8xLWI5yxqDhpMaKVBBMWE/Z7XT4zXWf5bH12KZ5bJeZjDGua1
	 xDw8qqQlhwzvmMD50ddIbQ7cl/2NYuBJtqTEkXImtFj6AeVib+bJQ8Rkh5OrThmTd7pdL
	 78e89xNPMWSVmLOEl1qw02x+0oNiWYkGldAuAoyOWSWBRdLNk5uWYlZw4wLgL7ZYJHE9f
	 45fzk6SSsdL2WEsyei5fR5Xpokr8vnH+rsMi/0xFIovGkDbwzEgN1PozB1WaYcWc5pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EE1UuVKz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD5A606A31C;
	Thu, 26 Nov 2026 14:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EE1UuVKz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5071F000D0;
	Thu, 26 Nov 2026 14:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704460;
	bh=vwNjNn7RrhRVyR/Ha6HGCAjAeaTQtm71JqYxeoE/sfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EE1UuVKz8VJ+NQgsvzChsk/+JEvtytH/4NDwWem/6jXXpdU9IbvVtOih1EbozGiMe
	 F9z6oxZudfVXHi7qDttKK8jsxr09LGkIVNJTnlIxuR3V//GVkB33sBX19K/QJuuydc
	 C1Xz6VcrRQ77mqmPZfX+06NEN/vpVodlkXu4VjQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/265] fs/read_write: make default_llseek() killable
Date: Thu, 26 Nov 2026 15:37:06 +0100
Message-ID: <20261126143611.692084212@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 2e1a8fbff51bb9bdf0fe9c6602855e308efcfcdb ]

Allows killing processes that are waiting for the inode lock.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Link: https://lore.kernel.org/20250513150327.1373061-4-max.kellermann@ionos.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 7a5783cfac71 ("fs: reject negative offsets for SEEK_DATA and SEEK_HOLE in default_llseek()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/read_write.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 1e02faeb652b5..1a450f569e80f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -238,7 +238,9 @@ loff_t default_llseek(struct file *file, loff_t offset, int whence)
 	struct inode *inode = file_inode(file);
 	loff_t retval;
 
-	inode_lock(inode);
+	retval = inode_lock_killable(inode);
+	if (retval)
+		return retval;
 	switch (whence) {
 		case SEEK_END:
 			offset += i_size_read(inode);
-- 
2.53.0



