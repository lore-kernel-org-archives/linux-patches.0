Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704429;
	b=A4NCMcP9Zk9FyJdpfFGz8sXB2Ro0dGaXJlHoxYA0qajhbzVEY7hNHxR41NAIgU6ilcSq
	 dGJwuus6FL4879vyg7nDBCguhVpG31m35Ev+iTbmTwvDhw98SvvU5ceSuP/NFGDDYoICi
	 Hq+m7iCPtr7lQpmChw74wjKIeG7tVCBT9Rx8JW6502HFY5N5Y0IP7yeGZ9MfnVebGtOt+
	 4ww5WLC8BYK3kIG1K3DUep4fJ2YnMzMfOxcx3Rl4qDVY55QTDM+Dw/GnGmtwdu99rQ6CZ
	 I1u5dIevoIJfD7JyX/jrYwAxq1XYEGKe+OvaWR+mpVJ4RJr82ceYyESEOaMdrlzwz4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rTfBBUZqRyehpNVQ/woU+t/D39X6ci8mjYHzyxp/1/A=;
	b=HERrcIv4b6mmWNpOMlTKTwlwge6v6flRMshH9TCdUhk0VL31DzoXVPZwyeQEhZAZ6ew3
	 s4ds22EyqMezBpicVQ/G30t2FATEP8u7xqMfly8hrmt+xhhp0hbU2bx7fg1qg4UBa77VU
	 WBZ1DKwKspf1yn1iqYlbYfTrpySd3VqH/3jzV3F6pRFgeGQRGIwQhpEViteCbli7Q9VoP
	 Dalyqc3I+V1dIJS/IifejKoVVyKQtvmybvZVf5tEECzaBQ08T7IwU2XfOpfBc1Ye/bdp/
	 k+Ri9rRVnG60VMWqhOJREiZvgxwN5d5+Bc6Fsz7J554k6/R0VM7Hk6VFR4ED882KQGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aF5t+bgO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1697A606A31C;
	Thu, 26 Nov 2026 14:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aF5t+bgO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7394B1F000C6;
	Thu, 26 Nov 2026 14:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704428;
	bh=rTfBBUZqRyehpNVQ/woU+t/D39X6ci8mjYHzyxp/1/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aF5t+bgOo6ZfqQ6X7thpK3y5Hv7xUyMkD6wFIC7dO/heztPytXvEghkq1KruzUJWw
	 mTtte6enmCGVaf7tmVkbqq+ImHp/cXxhOS6iEPwx+5mEvk9+vu2EoUcBmGMGikvTmp
	 PxnSEh3BO5aS/fXwB7nlYsOFn85wtt0mYxhAdjko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/265] include/linux/fs.h: add inode_lock_killable()
Date: Thu, 26 Nov 2026 15:37:05 +0100
Message-ID: <20261126143611.634490023@linuxfoundation.org>
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

[ Upstream commit d8c5507cd140d9471472ece673e70250b957c595 ]

Prepare for making inode operations killable while they're waiting for
the lock.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Link: https://lore.kernel.org/20250513150327.1373061-1-max.kellermann@ionos.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 7a5783cfac71 ("fs: reject negative offsets for SEEK_DATA and SEEK_HOLE in default_llseek()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fs.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5417515c41119..9abc697b208b7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -782,6 +782,11 @@ static inline void inode_lock(struct inode *inode)
 	down_write(&inode->i_rwsem);
 }
 
+static inline __must_check int inode_lock_killable(struct inode *inode)
+{
+	return down_write_killable(&inode->i_rwsem);
+}
+
 static inline void inode_unlock(struct inode *inode)
 {
 	up_write(&inode->i_rwsem);
@@ -792,6 +797,11 @@ static inline void inode_lock_shared(struct inode *inode)
 	down_read(&inode->i_rwsem);
 }
 
+static inline __must_check int inode_lock_shared_killable(struct inode *inode)
+{
+	return down_read_killable(&inode->i_rwsem);
+}
+
 static inline void inode_unlock_shared(struct inode *inode)
 {
 	up_read(&inode->i_rwsem);
-- 
2.53.0



