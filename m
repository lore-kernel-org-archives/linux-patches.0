Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11E233121F;
	Mon, 29 Dec 2025 16:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025127; cv=none; b=Yw1GLLKruzXw6VEU+ddziq/vJtudJruME2/LWq+ntejIzXczkhSVIMvzd/KCbPeTMhgIvu86zenoqMb4a73N8lkCOryfsuR3iS4QTGbFh003QwmH3mVlACeQ5xCUyguhUfHrbg8qIRwf2XaKxjkX5Y++grmlx6CBdgoqrx+bEBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025127; c=relaxed/simple;
	bh=BitvEpIXzuZ33C3BEe30umMZOEDHKVrjqPB2Yd7N6g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ou6RGlrcCh3AifNbRpgI/Lll8YEUkrfyCkCYo+PquBvjgaYC4Ogt+iy7V1/XTAlCIJFm63BqOUB/QIZa07r66KTmwDqhs1ojUF9zl0lS7V6QEmgD+ufslYMsbusSsa3svX/J+ykf9UQsHd9zClpoQ0XOJAHJsjqH4Eopacn9ou4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QuWZrsY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QuWZrsY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA6CC4CEF7;
	Mon, 29 Dec 2025 16:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025126;
	bh=BitvEpIXzuZ33C3BEe30umMZOEDHKVrjqPB2Yd7N6g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuWZrsY0fFuJTJMxjAakaZo/WG+QzHgDH4pQfu7NuaY4CIdrqv1k/PkSFJPEf9cRd
	 U+cR4OBKeEg5rZunmDigiuwivzNkH0W1OXqykpq0MiO9CjS/kj5HAzF++FuKtfi7Cy
	 csXdH8AuJwb2c3FkoeGIFezrW9+rrEYWBmgVdm04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 104/430] net: hns3: add VLAN id validation before using
Date: Mon, 29 Dec 2025 17:08:26 +0100
Message-ID: <20251229160728.196440666@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 6ef935e65902bfed53980ad2754b06a284ea8ac1 ]

Currently, the VLAN id may be used without validation when
receive a VLAN configuration mailbox from VF. The length of
vlan_del_fail_bmap is BITS_TO_LONGS(VLAN_N_VID). It may cause
out-of-bounds memory access once the VLAN id is bigger than
or equal to VLAN_N_VID.

Therefore, VLAN id needs to be checked to ensure it is within
the range of VLAN_N_VID.

Fixes: fe4144d47eef ("net: hns3: sync VLAN filter entries when kill VLAN ID failed")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251211023737.2327018-4-shaojijie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 782bb48c9f3d7..1b103d1154da9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -10562,6 +10562,9 @@ int hclge_set_vlan_filter(struct hnae3_handle *handle, __be16 proto,
 	bool writen_to_tbl = false;
 	int ret = 0;
 
+	if (vlan_id >= VLAN_N_VID)
+		return -EINVAL;
+
 	/* When device is resetting or reset failed, firmware is unable to
 	 * handle mailbox. Just record the vlan id, and remove it after
 	 * reset finished.
-- 
2.51.0



