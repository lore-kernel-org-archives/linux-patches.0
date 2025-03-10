Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC47230BED;
	Mon, 10 Mar 2025 17:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628022; cv=none; b=LEUryDxNA+BHQqlCuTpXb2n7xgMUFhGBTLbsDxUTzZr+M4XsnLRQRIsFS4Xym+MJnyBhdJs7MJPErzLBzkrDOwkwUEtMps1aYMEp9w5iywAYOWSHEs8LeRS9x/mbhh8GPOg7JOHHz87nB+0st/SfKhFhc8EQ7OssmFy0EimCK0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628022; c=relaxed/simple;
	bh=QqGkch5w4x199tVWu4Sju9C2w+vEocE7OF67GKO6NVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFi5pntWgnR18A3J1vxyodDm6Bt/O+PVgJdVXqY10sEoep7MJ1wzQIjfCMEd2wEP73Clye08UMwxwJhW+BZ05dHDX+Ls9JrNH9Srbgp8odxS0s368J7oP6Iv8k8CIFVHtni6AL0knZ05Wszp0bN5/yvgZ+dEqfCvRVxwQuzd/28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7UUtSYo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7UUtSYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B584CC4CEE5;
	Mon, 10 Mar 2025 17:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628022;
	bh=QqGkch5w4x199tVWu4Sju9C2w+vEocE7OF67GKO6NVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7UUtSYoRsx5sHazAryDCOQns4P7CXWAwwEZMoRggHxAEmcgnmv4iGlAnAJR+9zzb
	 xxp2IAZYB6pD3GLwoFFUbltyPyYgW8ZNStBhvrZlO6SSxbCjSW+TKu6WS/Q8jlIsaF
	 laYsfMdxnPokqWvLS6MaZ9W3A9BhX+o9w+dayhtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/145] wifi: iwlwifi: limit printed string from FW file
Date: Mon, 10 Mar 2025 18:05:53 +0100
Message-ID: <20250310170437.127784982@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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
index 47bea1855e8c8..42f7f95dac225 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1200,7 +1200,7 @@ static int iwl_parse_tlv_firmware(struct iwl_drv *drv,
 
 			if (tlv_len != sizeof(*fseq_ver))
 				goto invalid_tlv_len;
-			IWL_INFO(drv, "TLV_FW_FSEQ_VERSION: %s\n",
+			IWL_INFO(drv, "TLV_FW_FSEQ_VERSION: %.32s\n",
 				 fseq_ver->version);
 			}
 			break;
-- 
2.39.5



