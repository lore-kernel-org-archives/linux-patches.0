Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A14415445E;
	Tue, 23 Jan 2024 00:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969397; cv=none; b=H8UdrO1+9eufcOH+xB//H0DHUNAqcSU/F10YMMVTq2suPCnf0yjfAI6Ah303RnTxfhl1BIuK3YlPduP45S0DNbpcQIpdKDi2NCTdJO0wBlCklo64XOpmiT7RL35p6gQa2gyRhnnVGUVGLlrxODAbS0KLV3uuVVP8tx2xM/WPdLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969397; c=relaxed/simple;
	bh=fpfSuPRF9xMEUwV96O4LkJNwfJnOe2HplD3DbaCiTUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWEaEXjk751pS8arc9hg7oiCRQJ69HzrfpBLjYsGMMchpI3U+JbRVkBRtvif8KUn2+v2+7CZ7v0YEiKQ1ium0AgldMqOBi+LaAdQ+OueAgEOXTr53a7SYr6+XH4+baYZbttmxOhU5TtjY8Y9OWf2V41Jn9/2QlnQXPNMI/fjvD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rB0fZg0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rB0fZg0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4A2C43394;
	Tue, 23 Jan 2024 00:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969397;
	bh=fpfSuPRF9xMEUwV96O4LkJNwfJnOe2HplD3DbaCiTUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rB0fZg0BNSUYrejYr0cl5UxbDXs0on2+L2zRONvCkbfLGV1Ui4xNmnRiXpHNJ7vlT
	 bwgwRWqJQKdWLGNELG/wfmFICaTe/K/5oyTsXRHR5g+YojnW+svElXvgOJkw49QDYL
	 xVWcCsyZWk6rFfvzq7R4Ubgu+fqcOe2nOzxCyR98=
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
Subject: [PATCH 6.7 219/641] wifi: iwlwifi: fix out of bound copy_from_user
Date: Mon, 22 Jan 2024 15:52:03 -0800
Message-ID: <20240122235824.788395977@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 329c545f65fd..7737650e56cb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1815,7 +1815,7 @@ static ssize_t _iwl_dbgfs_link_sta_##name##_write(struct file *file,	\
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



