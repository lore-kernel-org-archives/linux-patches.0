Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D5A1EF0AC;
	Tue,  3 Dec 2024 15:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241174; cv=none; b=r0lWq9l7XGDda80iA6jAZF/1uVpD0Vprt/ftkkw569lnVpBj0B/ZIW4+exSY5Dd67xTrajQIgIKgHXAbDWgjIY9lzE/lfv7oJXKiOLemHfiaqkbAVY6jfPVlVQfX/V+e1VFkA8Ze5mzDtU3mteGSui4qH5mnsXHKIVYxDE7kMSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241174; c=relaxed/simple;
	bh=A7ZY0AHz1OhaBFOw1iYU0uj8vqNl+bnOawQpL5WNM0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABZ6XQVC8EeRtVWHZ08hRAe9+AvT20vxyRao6osS+3NDuCPP0zzdtVRbQKK6KsqfIz+PllSUh/vL57ra1V269EWGpwk5j9kwwJX5mooZm8r/AE7lZ3UFGjdAJSh3w4oc8SV2Qk2vnUeoKT26xEbLW4fN4JOBlk+7/rAGsrK/SKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H38Sh8wu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H38Sh8wu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AABC4CECF;
	Tue,  3 Dec 2024 15:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241174;
	bh=A7ZY0AHz1OhaBFOw1iYU0uj8vqNl+bnOawQpL5WNM0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H38Sh8wuRzTiOJfrod/T4URw+OVRx8oozYBP/pPUYdLMSZhJWV11Ouma6LxdDazOZ
	 FxyRQ0p4sWUg7lzXAKr4k1gwXAjKoJQlTOToKT0+dHmyAiCVbYCyPsMofWuci8p8uO
	 NGRfBPYy9rGqPm5/UeiAP5pVEYGSbAwfHwPf2r6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 340/826] Bluetooth: btbcm: fix missing of_node_put() in btbcm_get_board_name()
Date: Tue,  3 Dec 2024 15:41:07 +0100
Message-ID: <20241203144757.024756397@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index eef00467905eb..a1153ada74d20 100644
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



