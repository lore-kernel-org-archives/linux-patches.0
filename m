Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24154330B06;
	Fri, 17 Oct 2025 15:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715887; cv=none; b=Kyd5yT2tQ7O/bZ4o18Lkbp5+89apDKAVheB+cO/e2MQi41BMau4qzYg+RKuV97eVF+U6OReoVp6ajhIiWg+p08CNC397kQY39LY0LRU4joQNwEVFueuytB3/QGnXwRlVccxat3wx9KG2ABHWXmV0wm1WCrzz3oJVTG9tYpf6NXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715887; c=relaxed/simple;
	bh=cRn/XJtBRONhVpNuCSmrWdcA1WdD3752fv0UhD62Y0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BA72dIZzblUxHgxdZlAzkDTUn69gu/ipavtYnCOVP7U76lhAVWD2OhN/gl39xhSnGo6FjkgexgJy1S48H4BICUQwJnmoZkejXCDtf1IGgnOP6n59tBvp4+EI04eT+nLYM6UUlUEVWXrVp5JqcYON1eh4Pe40Ga/tOiSGZsZylac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5GQVEvh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5GQVEvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C753C113D0;
	Fri, 17 Oct 2025 15:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715886;
	bh=cRn/XJtBRONhVpNuCSmrWdcA1WdD3752fv0UhD62Y0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5GQVEvhKimWdj+H9rrcySssjE7gM8wUrkLh/U03F5sdiBPea7vKLDgQNumwNTm57
	 Y5rMsN1+aRA1qYfIzdVO9rySaOfR04R1nGJ8MPpnb2NZlB2Eo7lAxJ9Nn1vQRQluc9
	 hiwzByjvrGdjMlEUA1GI1VLW/ccoxGkW9z3W7u28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 370/371] pidfs: validate extensible ioctls
Date: Fri, 17 Oct 2025 16:55:45 +0200
Message-ID: <20251017145215.470365390@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 3c17001b21b9f168c957ced9384abe969019b609 ]

Validate extensible ioctls stricter than we do now.

Reviewed-by: Aleksa Sarai <cyphar@cyphar.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pidfs.c         |  2 +-
 include/linux/fs.h | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 108e7527f837f..2c9c7636253af 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -440,7 +440,7 @@ static bool pidfs_ioctl_valid(unsigned int cmd)
 		 * erronously mistook the file descriptor for a pidfd.
 		 * This is not perfect but will catch most cases.
 		 */
-		return (_IOC_TYPE(cmd) == _IOC_TYPE(PIDFD_GET_INFO));
+		return extensible_ioctl_valid(cmd, PIDFD_GET_INFO, PIDFD_INFO_SIZE_VER0);
 	}
 
 	return false;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 74f2bfc519263..ed02715261036 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -4025,4 +4025,18 @@ static inline bool vfs_empty_path(int dfd, const char __user *path)
 
 int generic_atomic_write_valid(struct kiocb *iocb, struct iov_iter *iter);
 
+static inline bool extensible_ioctl_valid(unsigned int cmd_a,
+					  unsigned int cmd_b, size_t min_size)
+{
+	if (_IOC_DIR(cmd_a) != _IOC_DIR(cmd_b))
+		return false;
+	if (_IOC_TYPE(cmd_a) != _IOC_TYPE(cmd_b))
+		return false;
+	if (_IOC_NR(cmd_a) != _IOC_NR(cmd_b))
+		return false;
+	if (_IOC_SIZE(cmd_a) < min_size)
+		return false;
+	return true;
+}
+
 #endif /* _LINUX_FS_H */
-- 
2.51.0



