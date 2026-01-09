Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C930359FA0;
	Fri,  9 Jan 2026 12:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961222; cv=none; b=Moy9gqP/8iuw+ZKTKAmgkFT7pNvARaHUiNgtOA70IRnPfgAl8rSnJdbArHcGUX2awDVJJNNKbZ6fUpkWBwpkrkRkGA84DMlJKo4KEeKQydjHVohvRT5RQVBlcyfpQ4+9RNJc51s5tuaqIlYFtFQVfa2HPMlsxvfVP31B7ASVQDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961222; c=relaxed/simple;
	bh=+PZHv7hPA1kXIHJ1u0V7j+wQaFh8gDnQsFK4pomY1y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2+Ir5gBJGQj8+jrWyyg46e2p6F/sOB0ibw/UjVYuFYdk03Xh52JguDhZ+oizHhQNwIznPnKBOSHccRJAAn0bu8F2lxZzgNkiHdj1dZLAnQXBevX04LuV5NRNiWt1CAsTQ3o21awncFPYfGrlMRxy4n3iTYwj/HZdhvgNMF1tAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyQZP5Bn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyQZP5Bn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0F7C16AAE;
	Fri,  9 Jan 2026 12:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961222;
	bh=+PZHv7hPA1kXIHJ1u0V7j+wQaFh8gDnQsFK4pomY1y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyQZP5BnIno4qzu96tY66fjf5rfhSafU5fWkXYf3+KirZ2jhHC7OVk1j5zxKu5SuN
	 8klmsCXhs8KmzEx1uHU7xtyzGl7tWsSq7Y84Ax7wXXJRWbT20oxt47Y2hcdvfChSUj
	 v9Ys+JD2X6eMU3eAOjp6L2wO5K3saYRhXoH+CRXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 645/737] f2fs: use f2fs_err_ratelimited() to avoid redundant logs
Date: Fri,  9 Jan 2026 12:43:04 +0100
Message-ID: <20260109112158.278952847@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 0b8eb814e05885cde53c1d56ee012a029b8413e6 ]

Use f2fs_err_ratelimited() to instead f2fs_err() in
f2fs_record_stop_reason() and f2fs_record_errors() to
avoid redundant logs.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: ca8b201f2854 ("f2fs: fix to avoid potential deadlock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4054,7 +4054,9 @@ static void f2fs_record_stop_reason(stru
 
 	f2fs_up_write(&sbi->sb_lock);
 	if (err)
-		f2fs_err(sbi, "f2fs_commit_super fails to record err:%d", err);
+		f2fs_err_ratelimited(sbi,
+			"f2fs_commit_super fails to record stop_reason, err:%d",
+			err);
 }
 
 void f2fs_save_errors(struct f2fs_sb_info *sbi, unsigned char flag)
@@ -4097,8 +4099,9 @@ static void f2fs_record_errors(struct f2
 
 	err = f2fs_commit_super(sbi, false);
 	if (err)
-		f2fs_err(sbi, "f2fs_commit_super fails to record errors:%u, err:%d",
-								error, err);
+		f2fs_err_ratelimited(sbi,
+			"f2fs_commit_super fails to record errors:%u, err:%d",
+			error, err);
 out_unlock:
 	f2fs_up_write(&sbi->sb_lock);
 }


