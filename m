Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6441F8905;
	Tue,  3 Dec 2024 15:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238675; cv=none; b=ZPVcqME7mFAmsJe/Jpr3XVAYBAa/yfGlrAdlG6Xv5s8dn1acErDZHkmpabhiQjiE2a73GsygyHq7K+u35s1nHPD8SSrk8TqZ3JLlDycRpzKyGQZ69MngoDzkq6V9EVmS80Fd0mA8DDRgwPu5Nw4vjdqeKT1Y/CwwunZ/ik0TvOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238675; c=relaxed/simple;
	bh=32AErDVJg+uTHdtb/vDPXp+EbMTO49iSPqZ7YT2hAbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBr4KxwEy6E8ZmsHAYkQhfij2kZsCFxNvZ5RcKTOt/IqMK/4rdzH1ocflNNRAz8OM+27P9+raeuxWPOOrogCjyzaQPmh0SNKKMwwtSKwQ35yn8MNt4HsXP/UAhbOpzDwUMhKulKjm8ap6U6SNUO/CD0ff/9DC15DFQTLx0ML110=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mhoj9N5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mhoj9N5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45800C4CECF;
	Tue,  3 Dec 2024 15:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238675;
	bh=32AErDVJg+uTHdtb/vDPXp+EbMTO49iSPqZ7YT2hAbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mhoj9N5p9Hb9gXoVb04AT1ch9+h2yl/Vhd9h4GoVL8IiNoHfisjUlQbrBwXBCKBBf
	 kf5DvGykf3+x0l454A/cgxVzUXcG/VHV8lrEVx/1y9EZjVTMxxq0mE5sBPn5gWJZm/
	 vDpTkFj4lPKkgucXx4BrO+19/NKjSYKc0A/1Q5yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 359/817] Bluetooth: btbcm: fix missing of_node_put() in btbcm_get_board_name()
Date: Tue,  3 Dec 2024 15:38:51 +0100
Message-ID: <20241203144009.845983725@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit e42eec0f182ac0605e658145f6fe3b6a7c256c45 ]

of_find_node_by_path() returns a pointer to a device_node with its
refcount incremented, and a call to of_node_put() is required to
decrement the refcount again and avoid leaking the resource.

If 'of_property_read_string_index(root, "compatible", 0, &tmp)' fails,
the function returns without calling of_node_put(root) before doing so.

The automatic cleanup attribute can be used by means of the __free()
macro to automatically call of_node_put() when the variable goes out of
scope, fixing the issue and also accounting for new error paths.

Fixes: 63fac3343b99 ("Bluetooth: btbcm: Support per-board firmware variants")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btbcm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btbcm.c b/drivers/bluetooth/btbcm.c
index f9a7c790d7e2e..723db989d9cec 100644
--- a/drivers/bluetooth/btbcm.c
+++ b/drivers/bluetooth/btbcm.c
@@ -541,11 +541,10 @@ static const struct bcm_subver_table bcm_usb_subver_table[] = {
 static const char *btbcm_get_board_name(struct device *dev)
 {
 #ifdef CONFIG_OF
-	struct device_node *root;
+	struct device_node *root __free(device_node) = of_find_node_by_path("/");
 	char *board_type;
 	const char *tmp;
 
-	root = of_find_node_by_path("/");
 	if (!root)
 		return NULL;
 
@@ -555,7 +554,6 @@ static const char *btbcm_get_board_name(struct device *dev)
 	/* get rid of any '/' in the compatible string */
 	board_type = devm_kstrdup(dev, tmp, GFP_KERNEL);
 	strreplace(board_type, '/', '-');
-	of_node_put(root);
 
 	return board_type;
 #else
-- 
2.43.0



