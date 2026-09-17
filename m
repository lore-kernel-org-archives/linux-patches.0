Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84EC52F288;
	Thu, 17 Sep 2026 17:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664896; cv=none; b=CZiAm6WL3l5SU0JMoWQ0S/fbrkqBBDZeBVcgW0QKF6rIc0uNc0XsDX48mws93qMF7IHWtRVIWAtBg6v/3l0k86vR9DLIOz91GPU4sx9/RoicpzH0OtX56gndMydeEvCpsGcDVKB+iz35PZN6gn+E7pAIUxtsAnqoDAMgcSnEcz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664896; c=relaxed/simple;
	bh=IBl8I9jtZ41VWyzkh4u3YC/jg1dcdtXQNb+83qum40k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2V0L5KiMOk3QDNaLrdvFyA+6+KVGk+7xiGD5fqqGyfpZwDk5jbdqX0Q6dWyOT0zV/eJxka2jqyzkIdkPrKfuiXfKj0SJWem+OUd7mtrWhc8k6CI9dVtkTdc9vFVcXwIj1I1hkM808MPYFCamozRu3DNaqhq1GwLJYXQsdXagc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1GB2LwSH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1GB2LwSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034691F000FF;
	Thu, 17 Sep 2026 17:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664894;
	bh=9RSfz1TJFROVe8VkRVXdq26OGvqLGhi/tLo8p1LxVvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1GB2LwSHuEdc/z/C8FgUiib/cO4uRrIU/pNh5x3uPQpT9Ay6YbCAeIeN+5db16DIP
	 5cjwSbos5OCDAgv+s8GIZty2yvN5f/Pp9gZoNx6AEYe1wdF+9UZJnhC1QP3X84w4IQ
	 EO7BWZlFdT4oWN38zcTt7x/goXoJFfHvZGu2Z6fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0525/1250] smb/client: flush dirty data before punching a hole
Date: Thu, 17 Sep 2026 16:05:20 +0100
Message-ID: <20260917151606.176161823@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit d7d2adcd022baade5cab65ca492ce63421ce3a6e ]

Punching a hole after a large buffered write may leave the range
reported as data. Reproduce it with:

  xfs_io -f \
    -c "pwrite -b 3m -S 0x61 0 3m" \
    -c "fpunch 1m 1m" \
    -c "seek -h 0" \
    -c "seek -d 1m" \
    /mnt/test/repro

Punching 1 MiB at offset 1 MiB should produce:

  0          1 MiB       2 MiB       3 MiB
  |  DATA    |   HOLE    |   DATA    | EOF

Instead, the entire file is reported as data. SEEK_HOLE(0) returns EOF,
and SEEK_DATA(1M) returns 1M.

This happens because a dirty folio spanning the punched range can be
written back after the punch and refill the hole.

Fix this by flushing and waiting for dirty data in the punched range
before invalidating the page cache and issuing FSCTL_SET_ZERO_DATA.

The xfstests generic/539 pass against Samba/ksmbd with this change.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1af1789bec5a5..9f42e5427557b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3456,6 +3456,15 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 		goto out;
 
 	filemap_invalidate_lock(inode->i_mapping);
+	/*
+	 * Flush dirty data first, otherwise a dirty folio spanning the punched
+	 * range may be written back after the ioctl and refill the hole.
+	 */
+	rc = filemap_write_and_wait_range(inode->i_mapping, offset,
+					  offset + len - 1);
+	if (rc < 0)
+		goto unlock;
+
 	/*
 	 * We implement the punch hole through ioctl, so we need remove the page
 	 * caches first, otherwise the data may be inconsistent with the server.
-- 
2.53.0



