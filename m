Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66C06313F;
	Tue, 23 Jan 2024 01:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975024; cv=none; b=jLuXkqmHD9nDMEyLyuQmPnN1kRKUys4xnr9gkKc3AIh9gwamE9ned3OzcSrwj4Hh8YNaoel5AJFr2KoojgBTmQw50KZ0BvqzS+rXZjkM9BABhJetGEwzbW2ydTzUJR/yQnHykXYFrfGz1zZwv5eyvnyNV9FXFty8hk1RDH2hmLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975024; c=relaxed/simple;
	bh=r61aYmHeE7ihlNAMhDk1gw/Ues/fxDSRuLKZ8MEDA4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZ1D4UTN7q7sG5Cf+INzB6RM7/nphnZiaGPFz74j6kdecBfQ88oIzXYYQJB3nhGZ7PF8joBWdxTSdybeRC6Gcz4NY0XAQQx2ukriNJs5gC2LJudq2ECRVNpBgHZ3mERIkHeLhLBsU2wPz+D0aThz7j9D1nmdHA5c0qQw3lHwy6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0zsFc/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0zsFc/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C00C433A6;
	Tue, 23 Jan 2024 01:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975024;
	bh=r61aYmHeE7ihlNAMhDk1gw/Ues/fxDSRuLKZ8MEDA4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0zsFc/P4/8NW2izsyVIXHYB8+HgZ77tVbA/KN0iiywFT1q2xu18E9HKul45/kfxy
	 UPCupN7RVW3vWpalF+ALFxgecsdtUiu+yJ7Wv4mqs41fYtO1S3JtAf9EuXY8iDtfK2
	 G1fAeWeks6ADuRqm3tHFNrybEcpWEW38CN4NDWeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 201/583] wifi: iwlwifi: fix out of bound copy_from_user
Date: Mon, 22 Jan 2024 15:54:12 -0800
Message-ID: <20240122235818.135692758@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

[ Upstream commit cb2dfacb197bed0241fbb4f84bd0995a47f4465e ]

The driver copies the userspace buffer into an internal NUL
byte terminated buffer. While doing so, it was reading beyond
the end of the userspace buffer, overwriting its own NUL
termination in the process.

Fix this by only copying the correct number of bytes.

Fixes: 3f244876ef73 ("wifi: iwlwifi: make debugfs entries link specific")
Signed-off-by: Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Reviewed-by: Gregory Greenman <gregory.greenman@intel.com>
Reviewed-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231219215605.e4913deb2ad4.Idcf6a7e909ff4b7801cd49c2f691f84a2f68eff9@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index cf27f106d4d5..7057421e513b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1673,7 +1673,7 @@ static ssize_t _iwl_dbgfs_link_sta_##name##_write(struct file *file,	\
 	char buf[buflen] = {};						\
 	size_t buf_size = min(count, sizeof(buf) -  1);			\
 									\
-	if (copy_from_user(buf, user_buf, sizeof(buf)))			\
+	if (copy_from_user(buf, user_buf, buf_size))			\
 		return -EFAULT;						\
 									\
 	return _iwl_dbgfs_link_sta_wrap_write(iwl_dbgfs_##name##_write,	\
-- 
2.43.0



