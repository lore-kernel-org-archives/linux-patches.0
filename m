Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EE0221DA5;
	Tue, 11 Mar 2025 15:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707363; cv=none; b=Egfm+XIL+c8ETIhADDgr7GKvAUGprN/a6cbcXE3Gt6xaQENKKxXhacwCgyKfXPiKX2YbgWs/EAvKQieEanMPe2hMxmuD7w1J1K24FcIAbIrZdAU3T4hiEwnQagze/AgqNIt+c2iDxxOWPDKylC+U7xqjjdF1KbSHjeUi69RJNvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707363; c=relaxed/simple;
	bh=oPeeY4XF0BGFqeFnHLWjA9pR7SfE6YIy57AQwME7GpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiXcVIgnANLtpDkzD6qz0Y9cwlFAlm9824vr2syXzk07ZVJnkIwjP4tjtD433hcAc1F5rIVC+ZF1D14GpJS2ob9kTbEfLlBjwYhG2j4YT7peFSGDD4nhRsN0JTpZgkqbvVtHzki5d/Gw1cEOASIGKPZpCj8y8ngwyvEpz+Q/DgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpNXvg/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpNXvg/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB8FC4CEE9;
	Tue, 11 Mar 2025 15:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707362;
	bh=oPeeY4XF0BGFqeFnHLWjA9pR7SfE6YIy57AQwME7GpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpNXvg/DB8G/e/jb7oZnJeW1csBWiFCPurCr/WEqDG3qf8NzeZkgI78ZrQNPxhVxu
	 JSfrjq2MGCvQ/CP72Mh7TWsMF1E5w97dfIBOuXky/IHhHt4fihw9Noux+JjA15eSjf
	 7HoHKOHokGx/zAzxROBzDzVpcnd/zXJRZk/QXkDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Zicheng Qu <quzicheng@huawei.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 346/462] acct: block access to kernel internal filesystems
Date: Tue, 11 Mar 2025 16:00:12 +0100
Message-ID: <20250311145812.030245014@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 890ed45bde808c422c3c27d3285fc45affa0f930 upstream.

There's no point in allowing anything kernel internal nor procfs or
sysfs.

Link: https://lore.kernel.org/r/20250127091811.3183623-1-quzicheng@huawei.com
Link: https://lore.kernel.org/r/20250211-work-acct-v1-2-1c16aecab8b3@kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reported-by: Zicheng Qu <quzicheng@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/acct.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -216,6 +216,20 @@ static int acct_on(struct filename *path
 		return -EACCES;
 	}
 
+	/* Exclude kernel kernel internal filesystems. */
+	if (file_inode(file)->i_sb->s_flags & (SB_NOUSER | SB_KERNMOUNT)) {
+		kfree(acct);
+		filp_close(file, NULL);
+		return -EINVAL;
+	}
+
+	/* Exclude procfs and sysfs. */
+	if (file_inode(file)->i_sb->s_iflags & SB_I_USERNS_VISIBLE) {
+		kfree(acct);
+		filp_close(file, NULL);
+		return -EINVAL;
+	}
+
 	if (!(file->f_mode & FMODE_CAN_WRITE)) {
 		kfree(acct);
 		filp_close(file, NULL);


