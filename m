Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B94A3815E3;
	Thu, 20 Aug 2026 17:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247144; cv=none; b=j8m+UNra0FQz2Rf3bE8WtweWXuMwLh1uoQJLZj0FbXKYrJx/jOE7r4dYRbCGDQJtMMyU2n4IxOoTxeRvLeEqRuQIU6wk451QbAoxig+tH1HzyKFlneqp+TYsuVmi5Xr5o12Ci5OxTRf5v9M+n7a7XGBjtDRHmzUjINrUZlmKYJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247144; c=relaxed/simple;
	bh=lUu2pvVFrAJp+82+QRGH9uy2z3wxHcqtp2MW5Q2QmX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5WVXYJL+6SmYLhuYbkpPDLZagn0L9x5wWRYEesvuJYIolzsXeqZc42HsE9iuXA5Z6pFXf3Me3GYC2/RZfQzcvpw9Nsrjrr2geACGPxycANzpvoye0vbL5hq2tsAQEOOCmBc0/2eJw+GYV7UJe/304qzYzfGwIBZn9SErq7Tmg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtS3BKkK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtS3BKkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697981F000E9;
	Thu, 20 Aug 2026 17:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247142;
	bh=z1p6uKqJl/WXMYOy/TTkuYzuu7Oix1SITRgmTQMbhLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JtS3BKkKQrowhIcIK8QjHay/KSgd5UeXEu3ycYw2F2AAVyRXPRcywaSdH07DW2IKg
	 0elDh7/XuyBHEitgDKejmL57UWLbQjbAjCQQL3X+NE/CWIF7ONnwS/lCeQjH1iOHjt
	 fGSK/GpU321rMHlTeSZSgCY1NsWWZ/nh/YK/8b74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 164/220] include/linux/fs.h: add inode_lock_killable()
Date: Thu, 20 Aug 2026 16:55:54 +0200
Message-ID: <20260820145228.406890704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit d8c5507cd140d9471472ece673e70250b957c595 ]

Prepare for making inode operations killable while they're waiting for
the lock.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Link: https://lore.kernel.org/20250513150327.1373061-1-max.kellermann@ionos.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: fa724e235cfd ("cifs: add fscache_resize_cookie() to cifs_setsize()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fs.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -848,6 +848,11 @@ static inline void inode_lock(struct ino
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
@@ -858,6 +863,11 @@ static inline void inode_lock_shared(str
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


