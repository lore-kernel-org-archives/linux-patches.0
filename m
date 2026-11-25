Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624255;
	b=NJEB7nZ/Ajg0AXk6z66tOR1KzambG+cgNTk4Chq2MxNq+rurzzpOPs1buBAS0YNdhzdT
	 9LOoEb1eYk0fYwVHNStxIH3Nuh4ukJSJyE5eYryZZ8oeaZkGWaYQyqeUcpEhl8BhsF7TU
	 DuDiYVf+Hj9R1CxZvgPIA3TRyvMPtVUGZU64pTNIEP+K3C2QoAqfryONUT2+vXFE6e+8+
	 OgAqJSKd2XC+rsl3+zTo0LNhaU/VHvrNVdcMIitMPki7cgGvrs/wshEZQBPJFH5qsUCFd
	 KZEG/y98zU6ylU+ZgU3ouWNHCwRk5yy7DYOR8WYrngHn6Q+ZloIndq4ftmHtTPC0zmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xVH1KxEW8uBYI4NLJxn08WdX3zUPHqd4/guzv1EYSMY=;
	b=csUttx2zRAOrS2njz4W3N2jUWkUYy7tsUlc0HFtiv6wUiCzqjNLPAkYyPnx3vx4pCkmU
	 h31iIzxtRzrim5gvkiH3oV8op/N7MV3srYlO0PyE3GVaAmlO27msVezecQtdli0C3LwT+
	 EAlo8PzeWak3dLqDclDBWsHt/2MWPD62vFBwKt65BTD1t9NVfzMh+cb8ERXQsdyFh6xcs
	 w9+LSMdWq4hVKm2Dwm5443jpur02H2NKN6qUgBTnS7Q65nKE83VX2jpBpXXIAxMqbWML4
	 6xFQveqVXx+bcTECpl7BSmwcJ/sBUc0AJ4EvYeB8DBC8Wkbp6PvYjmrUOxzUluM9eNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YCDeO5Ay;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37B8606A332;
	Wed, 25 Nov 2026 16:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YCDeO5Ay
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5CC1F000C0;
	Wed, 25 Nov 2026 16:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624254;
	bh=xVH1KxEW8uBYI4NLJxn08WdX3zUPHqd4/guzv1EYSMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YCDeO5Ay1asFWWA0W+geJGdtqKmPxzP2irviNfvNPAQIvfNPoxBWPxkBXkzMObjWJ
	 Ln0gYmarZPEGJq08hlUKkmbIurFoQJQGJms+MpLzSJoiSdRL3gXJXmtArS0hjddLcZ
	 KV4S6iA0Ls/xnJe7n7buxAhWH6DoffN2u+1Dh2Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/816] ptp: unwind partially completed virtual clock creation
Date: Wed, 25 Nov 2026 15:27:06 +0100
Message-ID: <20261125143851.027010475@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit 3dea778260e3dddf30651a6913d87a42861346a2 ]

n_vclocks_store() publishes the new clock count only after every child
has been registered. If a later registration fails, it returns without
unregistering the children already created by that request. Those clocks
are left out of n_vclocks, and a subsequent request can overwrite their
index entries without removing them.

Unregister the newly created children in reverse order and clear their
index entries on failure. Leave the previously installed clocks and
their count unchanged. The n_vclocks mutex serializes this rollback with
other sysfs changes, and parent removal drains the store before walking
the children.

This was found by code inspection while adding initial PHC sample error
handling to virtual clock registration.

Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Link: https://patch.msgid.link/20261026-ptp-vclock-sampling-v6-2-e705612541f1@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_sysfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 998de4be08ebd..b07274b67294a 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -229,7 +229,7 @@ static ssize_t n_vclocks_store(struct device *dev,
 		for (i = 0; i < num - ptp->n_vclocks; i++) {
 			vclock = ptp_vclock_register(ptp);
 			if (!vclock)
-				goto out;
+				goto err_register;
 
 			*(ptp->vclock_index + ptp->n_vclocks + i) =
 				vclock->clock->index;
@@ -261,6 +261,12 @@ static ssize_t n_vclocks_store(struct device *dev,
 	mutex_unlock(&ptp->n_vclocks_mux);
 
 	return count;
+err_register:
+	num = i;
+	if (num)
+		device_for_each_child_reverse(dev, &num, unregister_vclock);
+	for (num = 0; num < i; num++)
+		ptp->vclock_index[ptp->n_vclocks + num] = -1;
 out:
 	mutex_unlock(&ptp->n_vclocks_mux);
 	return err;
-- 
2.53.0



