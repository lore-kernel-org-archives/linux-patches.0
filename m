Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7065C233148;
	Mon, 10 Mar 2025 17:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626694; cv=none; b=SK0uQdJatrnXck/2fFDp9A8hz9qHEZ5XFjL+aD/0naaRuS2qzGCAfHB3KmdXKWbTSV5MmmGIc7Dj+szDy/rq8/xzfK7nUXXhnsFhWlJvd+P0kwnsVGD4k1Cmw8sK0lVa3mD3rYtBTAaWfGlLfQ8TUdPH7W1fhADmImtUbzs6lpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626694; c=relaxed/simple;
	bh=Rcrz7qixOlxB3dFDQuQPJ8ibScD6QNVnox6TOHZ/8EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzMdJrPyNtck3WmDl5Vz18ABdqIlgjgro7W40I8J5+AXTfaMU8mD5AMOOoTbp8FFJJymG6XleJ+ovE0h5OJZlq4BfMThHiP4urN1H+FnWEx79OP5REMmDxcexCkVJ3ihz50R7S/KHSasmQyzGwwyCclyBAekA23b1Exe+TTmE50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWZgjkFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWZgjkFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECB3C4CEE5;
	Mon, 10 Mar 2025 17:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626694;
	bh=Rcrz7qixOlxB3dFDQuQPJ8ibScD6QNVnox6TOHZ/8EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWZgjkFNYcfjkXisBkowYYG35Edtb+WWTy1a5LWsQqXAX7R0wE2afUP3Obo+v8qLy
	 9T+rGYTHR8QCnxKbj4CXVbmvEDhcERM9G5iPs7DTaavs8nZarYnTiRFXcQi3rD2dTD
	 B0cEJm32LPd+xnUjSDUF0QggMLhLiNfQTt0yzMJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 081/207] wifi: iwlwifi: fw: avoid using an uninitialized variable
Date: Mon, 10 Mar 2025 18:04:34 +0100
Message-ID: <20250310170450.979773646@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 3f8aa0b8a53df2247a84eaf3b3aa38b6ef86cb1c ]

iwl_fwrt_read_err_table can return true also when it failed to read
the memory. In this case, err_id argument is not initialized,
but the callers are still using it.

Simply initialize it to 0. If the error table was read successfully it'll
be overridden.

Fixes: 43e0b2ada519 ("wifi: iwlwifi: fw: add an error table status getter")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20250209143303.37cdbba4eb56.I95fe9bd95303b8179f946766558a9f15f4fe254c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dump.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dump.c b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
index 8e0c85a1240d7..c7b261c8ec969 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dump.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
@@ -540,6 +540,9 @@ bool iwl_fwrt_read_err_table(struct iwl_trans *trans, u32 base, u32 *err_id)
 	} err_info = {};
 	int ret;
 
+	if (err_id)
+		*err_id = 0;
+
 	if (!base)
 		return false;
 
-- 
2.39.5



