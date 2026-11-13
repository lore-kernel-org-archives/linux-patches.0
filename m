Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590718;
	b=aZGwFId5d3wVu/36xW8gwspB6sS/ITbIVU1uhz/3Dgf63ZUJS8Rf8V8FiAlF3JdL17Dp
	 RaP0srGFmr3Sb6ecNeTh707mq6r54Eex1vzbvqYRYafKySs0v/v5sKYk9WoEKC9yvpq1s
	 YA05R9X216BI0mxuDi5Q5QPPdg3XI2X6iJUnFVu4GnMwt5lyqrb8ljvhrg5JBuDZDVBgx
	 P/4xueoWQeXyg71Ew9fgTUYCgC+FRPi/6JNbgH7R3u8nS6UZ7H2rlZFnHsFz3w70pN2q6
	 elFxVBirjTUibmwVXCncjb+ilx6ePiJQnk28JObxUmSMUVtptyxsRqORuJ7GZa34NqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f266gsDDF/plXmo0V8XsMax73EYqH0BNjgAvFWJ01e0=;
	b=r3E96EcwyL8KSwYNumaDZZY7jBzw5AQLFQveKyKDDz2woXdkX/qfGfkryc8M0egqJkdt
	 3gzVE00D7gxcwF3OtcXX01FHydl00v00v64BJTfXm0fnhkViv1HkXU1SdIet+iOXLrruZ
	 PiQwihdYYtFFZG5wlSTAwlR7wcJ7aKIHfh93+kSkCDHNIcsuKUhF2WJYeLQ8bQdVMr7fw
	 sFaMqb5of90GGG8bT7Q8b6PawzcfYDEKDb7BqVwDHymTbEZY1GLYel6jdiOKT/v8UyoMz
	 ywpqSbTc8vNnhAseCVDK1uhRcSgjjOJ5fHf4C3rIn4GPYky4hlNiOlqfaZMWdAy2jPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bB9wnQ3v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BAA606B23A;
	Fri, 13 Nov 2026 17:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bB9wnQ3v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2218F1F000C4;
	Fri, 13 Nov 2026 17:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590718;
	bh=f266gsDDF/plXmo0V8XsMax73EYqH0BNjgAvFWJ01e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bB9wnQ3vudlyUNn0l2rTuXJ+MzEK9t5xgvcm3g2ni64CWUlJa5+A8a7fOwVQuLB7B
	 jnNzeaRTudq3xBafpVLSSkok4i2zqZh5rYHmq3oazcho2QqX6jkqBqpwcLfhtOHRgd
	 RepOFeJkles2wqqYzlkGS1VEyD6VBQWWZiTL6mrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 625/686] fs: assert on ->i_count in iput_final()
Date: Fri, 13 Nov 2026 10:52:38 -0500
Message-ID: <20261113153843.029959936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Guzik <mjguzik@gmail.com>

[ Upstream commit be97a4b63ca8c3ed8f5c3f5606a15a8379c78afb ]

Notably make sure the count is 0 after the return from ->drop_inode(),
provided we are going to drop.

Inspired by suspicious games played by f2fs.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 8ee09f597763 ("fs: rotate inodes whose page cache could not be dropped")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 24762fd1f2f77..acf09822535ed 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1875,6 +1875,7 @@ static void iput_final(struct inode *inode)
 	int drop;
 
 	WARN_ON(inode->i_state & I_NEW);
+	VFS_BUG_ON_INODE(atomic_read(&inode->i_count) != 0, inode);
 
 	if (op->drop_inode)
 		drop = op->drop_inode(inode);
@@ -1889,6 +1890,12 @@ static void iput_final(struct inode *inode)
 		return;
 	}
 
+	/*
+	 * Re-check ->i_count in case the ->drop_inode() hooks played games.
+	 * Note we only execute this if the verdict was to drop the inode.
+	 */
+	VFS_BUG_ON_INODE(atomic_read(&inode->i_count) != 0, inode);
+
 	state = inode->i_state;
 	if (!drop) {
 		WRITE_ONCE(inode->i_state, state | I_WILL_FREE);
-- 
2.53.0



