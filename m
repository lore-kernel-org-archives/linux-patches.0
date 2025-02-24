Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE40190685;
	Mon, 24 Feb 2025 14:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408181; cv=none; b=PTpMzQfBS/9MctM5ly1yYR1XV9g9//983HK00yKF2k80+3X9v2Jqk8xFN9g6OWzoZhGAE93LVqeD/CiAMgx7nI3tnD8DGFo81hTzu6uvrasEasZN/tijoD66OPVLh1vkkjFJ7mbt+lO2YijuRJvJmcuj8W0S8xAwF1NdTvvE8uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408181; c=relaxed/simple;
	bh=TIyBwFU01+mJDOxxQlSxpKWoNlQ3LIpOAYJGJYHMQzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKGlR5ws9d0NRVY0CnozaHIAdWzsIxXMD7iBb53ORAIqPK2wb5fltNEuTLmm9m9IlM3Cv64HUvZZbeLgjdT7xYZ+Rb77HiIBSMTw3jQIpWfGkS06dlabaeeh/DO3Fa75MPTNoWm/GUCOlHJXIB6XzrHcOhoxEfe2ejpI9ZJhAVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SceBOqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SceBOqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2AAC4CED6;
	Mon, 24 Feb 2025 14:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408180;
	bh=TIyBwFU01+mJDOxxQlSxpKWoNlQ3LIpOAYJGJYHMQzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0SceBOqVieSnODMYgfv0J1HRi9AJK9BfkjDTQkR2zKsoBu6k/r8G3j1qBIMB1HahR
	 5TCXXZ4prPQ5wNwOq15uaBgfe0MD6lg0FPwGM6yf5PcqvWqE070uzgHkKBNxnsrdcm
	 ogDTij0Em+VaAs0TvSc/gqUuKfkACSbb6gF+mw84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Zicheng Qu <quzicheng@huawei.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 123/140] acct: block access to kernel internal filesystems
Date: Mon, 24 Feb 2025 15:35:22 +0100
Message-ID: <20250224142607.845520230@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -244,6 +244,20 @@ static int acct_on(struct filename *path
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


