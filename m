Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066731487C6;
	Tue, 25 Jun 2024 09:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309069; cv=none; b=OOLYylvMO4tYfI4dddCLwKgXZVktPf05vQGcne6uPYrAA0Cwc+rgBVTDF2T86QUfRScCrTMiPMqBT0c4HcxWSv4O/I+Cw6QpeCTMHCrnnnQDe0Qk3dW5KZi6ZDU2qRqjMtnC354DIPI7E6ytW8B8K5mB/PjGCX331+F5DZUgrYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309069; c=relaxed/simple;
	bh=wg3RIaXy88+Du8Zbv4f/eDzPbykz/ChyAYkhlhXidwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=juzyh/DY3smIDqfdfNH/Mzqv8pID9yKg3HewrOk8yKddNxWmb6ADC26o/vp9lUWtSzM/7QiMeozXmZ9HPG7YsQ6c2RUezb7ra1chd3iCsqVcnGtamRN7jsK+zaMLi8j/TBrlpk7YIzRhqyGkusWudh1cgwoCkUHw/K7vNBh1hwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkWI6+iY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkWI6+iY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817A5C32781;
	Tue, 25 Jun 2024 09:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309068;
	bh=wg3RIaXy88+Du8Zbv4f/eDzPbykz/ChyAYkhlhXidwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkWI6+iYklnaESgVUmu/Q1ij4cvnQD+UFo03wX1+GmjWISgTfhWz/uSPrVikhsm0L
	 zkKOk133aGbIxyBlg71TUZQaPs04HG3lZM/sCGfV1B97OLMLzECoXqw6DD+LPIDOLC
	 PpzaOERRQocLb5Hz7NeEZd5v4PNDxaQdRENLjAKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Light=20Hsieh=20 ?= <Light.Hsieh@mediatek.com>,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/192] f2fs: dont set RO when shutting down f2fs
Date: Tue, 25 Jun 2024 11:32:05 +0200
Message-ID: <20240625085539.206090107@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 3bdb7f161697e2d5123b89fe1778ef17a44858e7 ]

Shutdown does not check the error of thaw_super due to readonly, which
causes a deadlock like below.

f2fs_ioc_shutdown(F2FS_GOING_DOWN_FULLSYNC)        issue_discard_thread
 - bdev_freeze
  - freeze_super
 - f2fs_stop_checkpoint()
  - f2fs_handle_critical_error                     - sb_start_write
    - set RO                                         - waiting
 - bdev_thaw
  - thaw_super_locked
    - return -EINVAL, if sb_rdonly()
 - f2fs_stop_discard_thread
  -> wait for kthread_stop(discard_thread);

Reported-by: "Light Hsieh (謝明燈)" <Light.Hsieh@mediatek.com>
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 43424ca4f26c5..ce50d2253dd80 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4107,9 +4107,15 @@ void f2fs_handle_critical_error(struct f2fs_sb_info *sbi, unsigned char reason,
 	if (shutdown)
 		set_sbi_flag(sbi, SBI_IS_SHUTDOWN);
 
-	/* continue filesystem operators if errors=continue */
-	if (continue_fs || f2fs_readonly(sb))
+	/*
+	 * Continue filesystem operators if errors=continue. Should not set
+	 * RO by shutdown, since RO bypasses thaw_super which can hang the
+	 * system.
+	 */
+	if (continue_fs || f2fs_readonly(sb) || shutdown) {
+		f2fs_warn(sbi, "Stopped filesystem due to reason: %d", reason);
 		return;
+	}
 
 	f2fs_warn(sbi, "Remounting filesystem read-only");
 	/*
-- 
2.43.0



