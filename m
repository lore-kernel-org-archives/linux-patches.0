Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E3B248881;
	Wed, 25 Feb 2026 01:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983489; cv=none; b=EThNOQhS7gDVTf5WUA53Q6aeKItm6oK2iDIVmq5IEhCh50Tie+O9b9LcYUBcpKGvAqRBQilKcaXznk2dAKrnQ5AnjCcrlz71EVRoXNe3Si4RwpnVi0hEJr99NbHYIFNuHoncnSpu8LNaGIosPKKfWftDa03fJs2UpYBhVtGjoj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983489; c=relaxed/simple;
	bh=NAUHz7TH96JM/36eikIcl11uGPkjMXfZdhI+tPbszxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ibs2/UeESIZvct703hSB8oEayFDjnFDrpQVIPbzNFu7TlSWVINA4iIyaVVu2XZ7cE46Gq5m49loxarek5G/XzTVNmz/uNdo9FctfpCjPwH5JoCGv+DOqkp+0tVJqnW+UgevhkY27t0mvEtY7cvhzm22huilDsJky9G71muFKsYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztO0AE8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztO0AE8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA75C116D0;
	Wed, 25 Feb 2026 01:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983489;
	bh=NAUHz7TH96JM/36eikIcl11uGPkjMXfZdhI+tPbszxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ztO0AE8qvbG/ZquazB30anre3o94uFCH8exVo3m/w7XplLNdY8lYhdqebdo0Iy+Od
	 1Vy79z5I/4hhml8CR2XWU8fbCjYJlsiipCzG66kht3VOS7EAvJ48mQJQzxnKAphGnc
	 RFGLiIH3LYQPQfP+Gv1kuLxM0pAOCx2L0lQ6Dpoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 601/781] pidfs: return -EREMOTE when PIDFD_GET_INFO is called on another ns
Date: Tue, 24 Feb 2026 17:21:50 -0800
Message-ID: <20260225012414.537024630@linuxfoundation.org>
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

From: Luca Boccassi <luca.boccassi@gmail.com>

[ Upstream commit ab89060fbc92edd6e852bf0f533f29140afabe0e ]

Currently it is not possible to distinguish between the case where a
process has already exited and the case where a process is in a
different namespace, as both return -ESRCH.
glibc's pidfd_getpid() procfs-based implementation returns -EREMOTE
in the latter, so that distinguishing the two is possible, as the
fdinfo in procfs will list '0' as the PID in that case:

https://sourceware.org/git/?p=glibc.git;a=blob;f=sysdeps/unix/sysv/linux/pidfd_getpid.c;h=860829cf07da2267484299ccb02861822c0d07b4;hb=HEAD#l121

Change the error code so that the kernel also returns -EREMOTE in
that case.

Fixes: 7477d7dce48a ("pidfs: allow to retrieve exit information")

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
Link: https://patch.msgid.link/20260127225209.2293342-1-luca.boccassi@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pidfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 1e20e36e0ed55..d18c51513f6c5 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -329,7 +329,7 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 	 * namespace hierarchy.
 	 */
 	if (!pid_in_current_pidns(pid))
-		return -ESRCH;
+		return -EREMOTE;
 
 	attr = READ_ONCE(pid->attr);
 	if (mask & PIDFD_INFO_EXIT) {
-- 
2.51.0



