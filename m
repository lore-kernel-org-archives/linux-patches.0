Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AF126B097;
	Thu, 13 Feb 2025 15:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459511; cv=none; b=OBabUcMdnF3LIBuIOi8zb4k0y/Njp5ehFHqDsdJV+edqPXuz+JvsNpMoOxKJ3JSh3iBxT9cGmKrKM7TQwokOcXhdPLtrpDExJ/tHf9YpH154zTSLaWdxlXhSPxV6aGOiMVIJFVyv7O+06D40oShPCbxUDFtWZ6edv/RV87GBM4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459511; c=relaxed/simple;
	bh=P2EelS6ySvEeMrmtSXjxugEo1OJPmZi6vDoNgLWAWdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRUFd1hnuod/wt/f2H7saqV+MbYcsWeREFCBTTuwDN3A5mXDKGX7hI4mstKT364tbbCNNPGUtkENEzF8z/CScN6pmmPOHBbJGcDKKmR0WaAoT8FusrE6T+Hw5aeJk9I8uig/0DNDouf11cWEV3oXk7Y7pAkTDktC2jef7bUIK3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3/t1OPt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3/t1OPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C180C4CED1;
	Thu, 13 Feb 2025 15:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459510;
	bh=P2EelS6ySvEeMrmtSXjxugEo1OJPmZi6vDoNgLWAWdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w3/t1OPtWOw6uavYI07rXuymv3x/nDd333AKlzszMBJ+W7jIosa4fG+gnpxXORniu
	 oz6YUfcZ9j+S7AKICj1y2lvHusoFvtlv2uMXMWmmuFNONcbNOmrBVK2qum9GeY/zuk
	 /cF9PYMDvBubldqyh80LfIPU78efd/fLhsJk3rHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.13 287/443] pidfs: check for valid ioctl commands
Date: Thu, 13 Feb 2025 15:27:32 +0100
Message-ID: <20250213142451.686991438@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 8ce3528188207a2e1896cc3173fba6d99a59013a upstream.

Prior to doing any work, check whether the provided ioctl command is
supported by pidfs.

Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pidfs.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -190,6 +190,27 @@ static long pidfd_info(struct task_struc
 	return 0;
 }
 
+static bool pidfs_ioctl_valid(unsigned int cmd)
+{
+	switch (cmd) {
+	case FS_IOC_GETVERSION:
+	case PIDFD_GET_CGROUP_NAMESPACE:
+	case PIDFD_GET_INFO:
+	case PIDFD_GET_IPC_NAMESPACE:
+	case PIDFD_GET_MNT_NAMESPACE:
+	case PIDFD_GET_NET_NAMESPACE:
+	case PIDFD_GET_PID_FOR_CHILDREN_NAMESPACE:
+	case PIDFD_GET_TIME_NAMESPACE:
+	case PIDFD_GET_TIME_FOR_CHILDREN_NAMESPACE:
+	case PIDFD_GET_UTS_NAMESPACE:
+	case PIDFD_GET_USER_NAMESPACE:
+	case PIDFD_GET_PID_NAMESPACE:
+		return true;
+	}
+
+	return false;
+}
+
 static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct task_struct *task __free(put_task) = NULL;
@@ -198,6 +219,9 @@ static long pidfd_ioctl(struct file *fil
 	struct ns_common *ns_common = NULL;
 	struct pid_namespace *pid_ns;
 
+	if (!pidfs_ioctl_valid(cmd))
+		return -ENOIOCTLCMD;
+
 	task = get_pid_task(pid, PIDTYPE_PID);
 	if (!task)
 		return -ESRCH;


