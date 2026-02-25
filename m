Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C013081D7;
	Wed, 25 Feb 2026 06:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002693; cv=none; b=rqjjytTMNSYaeL4epi2YSGmbh3p3SkQpgN7zH062u00B1Z5v5wziJxn7/IpIq/R/9kyRBrFftQM9odwlUA1JptkAG9aMUEmrsVVtiLwarKFsswBvHqHmNf1GEgSfBuu3iKG++r+D98XxTcGVabmn2IeaQVeTreADqFpYbHOTGmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002693; c=relaxed/simple;
	bh=qECuJFnGuNTKRxpqdj9FxUcfhcNsgIsm+Sdx9VJQqlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uq+jkYzYBGTPyLdtCGmdumyZZo2OI1CSlw9Kj7EyHf3+5DyFOtqfa02bxGTeRkHVXL1A3LZ1V9xeLJDT6gT+p1f2lHkh9xK79y/sCq0IuGI+zDOPzA5RL49nPQOUzzyktipquz9ni7fPglyQnw9pT3yBXTOtfeVJroolh55d4yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xuHVTezu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xuHVTezu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFE2C19425;
	Wed, 25 Feb 2026 06:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002693;
	bh=qECuJFnGuNTKRxpqdj9FxUcfhcNsgIsm+Sdx9VJQqlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xuHVTezuC32AyJ/kL5bTbaczbweLAQUkKUzorMuFtE8LBV4ACAfZ9PMl07youh2Xt
	 YBF3ak1F/2GLXzCnFxgYMcMHnZ6CzzKBqPkIczRKHPYouXFy9X7OPSmsFK4CWk4Hqv
	 MNTsjGVEbUZT2bhAfJNcyAIuQ9do98ODGaLhLViE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 487/641] pidfs: return -EREMOTE when PIDFD_GET_INFO is called on another ns
Date: Tue, 24 Feb 2026 17:23:33 -0800
Message-ID: <20260225012400.318315877@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index f4d7dac1b4494..34987fcdd9a87 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -321,7 +321,7 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
 	 * namespace hierarchy.
 	 */
 	if (!pid_in_current_pidns(pid))
-		return -ESRCH;
+		return -EREMOTE;
 
 	attr = READ_ONCE(pid->attr);
 	if (mask & PIDFD_INFO_EXIT) {
-- 
2.51.0



