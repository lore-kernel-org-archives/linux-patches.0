Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C2E1C3BEB;
	Tue, 11 Mar 2025 15:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706246; cv=none; b=kTAbqJtLu3bJthP1fYVa+FStwZY3IJOOYiDMMHAViTKI9K/fRoGN7wH2/WuLref8ju+APQi4zQc9Xk/lJ4ZQD2sSxb0AYzBHk03a+L2UzPQlNHt6daZ4mJCAADtqmxVRF5Powjrs4ITKHFoGceRKD7t13wk7OSsn5BuuI6eWVWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706246; c=relaxed/simple;
	bh=lpbFobZpTzG3ayUlLo6Fzy6tIGZw+7bHFb6RwS73fh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHN2Dgb7VHAplmEoXzCsZNxPLcIMBEFbgsv39fMKeVU6L5RjG8wFqD5j5nDiMLtYdkC1W4t2Vq4k6zvjSe6c9MKqTq+VnlXZY4HdDnZwAlEWHAKTONn6aFBLXAM7J5+uAg8rje2duqRxoynLAZ0OQQQnFnZrlE9QS36p0Mqx004=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1e0m9F3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1e0m9F3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE00C4CEF6;
	Tue, 11 Mar 2025 15:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706246;
	bh=lpbFobZpTzG3ayUlLo6Fzy6tIGZw+7bHFb6RwS73fh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1e0m9F3GQJgUJJJ7CNEJoMzCOBmpfZgyDF6OZ+VYNvF05wM/DmcD9KTaGEtnvPsw
	 DzE+YLMd2SCw62b6nYutHrt7al7MiGOerT3zuYNJIDKu4FUw5T8IChqBm4ZoO9f0dr
	 eIsb+DtsA/S8t1F4OvXi8VYQqxMb8GiDOh5eGJUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 293/328] wifi: iwlwifi: limit printed string from FW file
Date: Tue, 11 Mar 2025 16:01:03 +0100
Message-ID: <20250311145726.554208068@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e0dc2c1bef722cbf16ae557690861e5f91208129 ]

There's no guarantee here that the file is always with a
NUL-termination, so reading the string may read beyond the
end of the TLV. If that's the last TLV in the file, it can
perhaps even read beyond the end of the file buffer.

Fix that by limiting the print format to the size of the
buffer we have.

Fixes: aee1b6385e29 ("iwlwifi: support fseq tlv and print fseq version")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250209143303.cb5f9d0c2f5d.Idec695d53c6c2234aade306f7647b576c7e3d928@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 9e63230da1ec0..03de1ca54c948 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1113,7 +1113,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 
 			if (tlv_len != sizeof(*fseq_ver))
 				goto invalid_tlv_len;
-			IWL_INFO(drv, "TLV_FW_FSEQ_VERSION: %s\n",
+			IWL_INFO(drv, "TLV_FW_FSEQ_VERSION: %.32s\n",
 				 fseq_ver->version);
 			}
 			break;
-- 
2.39.5



