Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F87C251795;
	Wed, 25 Feb 2026 01:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982812; cv=none; b=aQ0C12y8ZNMcW97VUladGxC6/g5JOlGGwFCfCtFea1ZHr7r/K/I76PZ43jktreDMRcI1eK5JuWbJp0YqMRsbHzgLMOi70z6qJ6H1Z6iwGY3mH7pje4rbpo3EsZN4YpiWS9zg4ERGbrVVcQ3YPgnkvczY43VxPIwjV/LpS71D8p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982812; c=relaxed/simple;
	bh=5VFJjOYyBdKuxGRUTvHYUcv9oFCe2XjyuKj6jMkYo9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHdGNkHSQe7Cg30xKjzw6/SVl9O9oNrZEPfuDNHaGPLInn4mlvN2QKivTpTAXmttaKI2Ktbh/EoNtTF4DD8cs8MfQrYSEelsiTNRMBX/yDfDuVOfS/hmNoxEhhA+oyl0k447KUth5HGCFsR4WVdMxO10v3DhAqJdyj5aIsK0lPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=byvc+Gqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="byvc+Gqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E14C116D0;
	Wed, 25 Feb 2026 01:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982812;
	bh=5VFJjOYyBdKuxGRUTvHYUcv9oFCe2XjyuKj6jMkYo9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byvc+Gqy6xipvbn09VPdgidG9DQTCZshWC2XDmh3oHVi9z76E3Lb0dXtMpqoTVUqD
	 9k3IjzKuYbcjrR5kKNC3fGlXOl6AQBlO0rnqpBmv2zF3HwWK7xRzAK2obJ8Oiu4fzR
	 LCs87uium9fCMI14ua0Yv99d+SzjjbtdK0usbt7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 010/781] device_cgroup: remove branch hint after code refactor
Date: Tue, 24 Feb 2026 17:11:59 -0800
Message-ID: <20260225012359.954820805@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 6784f274722559c0cdaaa418bc8b7b1d61c314f9 ]

commit 4ef4ac360101 ("device_cgroup: avoid access to ->i_rdev in the
common case in devcgroup_inode_permission()") reordered the checks in
devcgroup_inode_permission() to check the inode mode before checking
i_rdev, for better cache behavior.

However, the likely() annotation on the i_rdev check was not updated
to reflect the new code flow. Originally, when i_rdev was checked
first, likely(!inode->i_rdev) made sense because most inodes were(?)
regular files/directories, thus i_rdev == 0.

After the reorder, by the time we reach the i_rdev check, we have
already confirmed the inode IS a block or character device. Block and
character special files are precisely defined by having a device number
(i_rdev), so !inode->i_rdev is now the rare edge case, not the common
case.

Branch profiling confirmed this is 100% mispredicted:

  correct incorrect  %    Function                      File              Line
  ------- ---------  -    --------                      ----              ----
        0   2631904 100   devcgroup_inode_permission    device_cgroup.h   24

Remove likely() to avoid giving the wrong hint to the CPU.

Fixes: 4ef4ac360101 ("device_cgroup: avoid access to ->i_rdev in the common case in devcgroup_inode_permission()")
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260107-likely_device-v1-1-0c55f83a7e47@debian.org
Reviewed-by: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/device_cgroup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/device_cgroup.h b/include/linux/device_cgroup.h
index 0864773a57e8f..822085bc2d202 100644
--- a/include/linux/device_cgroup.h
+++ b/include/linux/device_cgroup.h
@@ -21,7 +21,7 @@ static inline int devcgroup_inode_permission(struct inode *inode, int mask)
 	if (likely(!S_ISBLK(inode->i_mode) && !S_ISCHR(inode->i_mode)))
 		return 0;
 
-	if (likely(!inode->i_rdev))
+	if (!inode->i_rdev)
 		return 0;
 
 	if (S_ISBLK(inode->i_mode))
-- 
2.51.0



