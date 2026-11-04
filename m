Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831371;
	b=a11LCKoylenckGv4zbst6BXsXmFtu+GQ49AVNjQ14kzdy8A5uO38pCGroDgep3Bkt+XB
	 cvNS/2ZcR+R39eXMdTHpKCAC/HntEJHIKCbxuFSSRnOZs/1EoYHrsoT2sH+w/ZA9GNIOp
	 V08CJJ6rgX4naTlHO1BS3e59wQcJjsoY4zxGNHCROOP9dg49mbmdSoIqYXIZeUsLTQCPk
	 xZoSrwFW4eve9Wx+gwb9z6uJ/ADwqlENNwYeithlTFhOiYMcBxCZP5osWb5SAkwjZj0/2
	 soVP3NUUodHd9wUfdhWthmEHU5lvy9wdoCkwEGFsR0l+pYNfL2MxdQJqAkIhXIBw+XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SKSaalMXgvUvzi2M6rZ+SIWOIY1GqlVP7/7iqOoEPcA=;
	b=gwQsssZpvq7YcgQMNcyrXVWGQ6WLq08Pp3piZjLugWZnmzQAL/8aRkKCAhjxBCb0ETL1
	 50vxSmYtx3EFrO1v2H693unwA60100eKwSY5WrUR6xwcCwBv3lrYoR+ITpsopjKzKdbyC
	 7Eqn7K9G6YNGl+c3giu/hPoCJuHXpvwoz59bO5qCJ4dcqfc+okceMXMVd3iQqmFtY00xT
	 t9jyJ9A5/b6W/Wt8FSgaqtytAF1QKXx9EYpeMYx4C+qnL8lSAAa11/z4v8060nH/+qGhy
	 8WgleU1oraKTp6wFPs2T1ON+TOEAIbi9cZN1VTUReNZpWJoTMMI+mZoItHBn+7vCzTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gIMMT2oX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7B0606A334;
	Wed,  4 Nov 2026 22:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gIMMT2oX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B6F1F00919;
	Wed,  4 Nov 2026 22:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831370;
	bh=SKSaalMXgvUvzi2M6rZ+SIWOIY1GqlVP7/7iqOoEPcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gIMMT2oX8D7lQstivj6pK6nSCuWDXNMnwIRtQWRcAtcW6veOXkRXo9mgTYuQMZkKj
	 lCdrmeHwjSyNbxsdkWJPGyk31Bx8oNXmW3O6HForrwpYtAegtr+/3vXyoelaBBQlD4
	 jUaqg6KALBP127lHdrrh0ELW2U6TA+hswaIT1btc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko Bot <sashiko-bot@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.18 0663/1005] spmi: Fix potential use-after-free by grabbing of_node reference
Date: Wed,  4 Nov 2026 16:06:36 -0500
Message-ID: <20261104211102.245672541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

commit f7aa9de4f2b197cdd704cdc476901b68ee128433 upstream.

As noticed by Sashiko during a review run of an unrelated patch,
in of_spmi_register_devices(), for_each_available_child_of_node()
is used to loop through children, and to also assign a node to a
newly created SPMI child device.

Problem is that the refcount is dropped at every iteration so, in
the specific case of DT overlays, a use-after-free may occur when
an overlay is dynamically unloaded!

To resolve this, increase the of_node refcount when assigning (in
function of_spmi_register_devices) and release the reference in
spmi_device_remove().

Fixes: bc32bbd04011 ("spmi: Set fwnode for spmi devices")
Cc: stable@vger.kernel.org
Reported-by: Sashiko Bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260608100949.36309-1-angelogioacchino.delregno@collabora.com?part=2
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spmi/spmi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spmi/spmi.c
+++ b/drivers/spmi/spmi.c
@@ -24,6 +24,7 @@ static void spmi_dev_release(struct devi
 {
 	struct spmi_device *sdev = to_spmi_device(dev);
 
+	of_node_put(dev->of_node);
 	kfree(sdev);
 }
 
@@ -517,7 +518,7 @@ static void of_spmi_register_devices(str
 		if (!sdev)
 			continue;
 
-		device_set_node(&sdev->dev, of_fwnode_handle(node));
+		device_set_node(&sdev->dev, of_fwnode_handle(of_node_get(node)));
 		sdev->usid = (u8)reg[0];
 
 		err = spmi_device_add(sdev);


