Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213682;
	b=jZVT6TeQADTaPsB1zZ+yJOJ5ZfCTZjrmTFueIkwlV/ZQsjSCnYn9dStB0ZuG8ePfbEfz
	 4OMFh9V0U5oRnCjgzSBGpGLZxAMseIg6j9i03NK0bd1flweXuKzLefVz+5iDnMLdFDuHI
	 YznXFYVV3XoUjKGXiawQ0yRbWDFl1UFmgapUUos1Hhg2n1sYWurJuIenV943qgFREzFE+
	 ShVSDiRihlr4Oz4GtqKyVdnO/7OcjDQmxJD7cAw/Ie6V2sCduIaICk5vcsU28cDNCNsr8
	 e2ib+jP3uxCHiUsRot1vqnzAjPR9aSvSsGHzO3IVKOkrATI+HUb+QMoBoWewF/6L4Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GbEbjAGGGEjiVrMnv0hlen8NRbh1LOL/JoWYr6ehEWo=;
	b=IMCJwUQduNWisoEwDgSQ3l/M9B6/PLkvAD5JOArrXRrDy7X15tjgCzv49AiD5cjde45J
	 hb5US51FO2uzrQNkg+CHkSk2JVW3Uv9OypIXPow55iz0kFBzIGycXWrXxiLBkGE6hxsDo
	 49JKh2E6Rn8qC3XKq75RXYkqWqMf/glKI/ubo7/Yz645jnqLzRAaOkEpWFRlVb7A171Cv
	 639To04JO9+rsaRfjnL5u+z7zbFXUYQDTaynm0BqAJ2PMP3QLd578XmkXguTmmZQk8NB7
	 zNHb96jrxK9OhdEqjvbRxVDHrI7BcrA5d39CZxemBOVqVahZOmuJfwddmhx+KGJtKzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CSeFs2pu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF3A606A33B;
	Wed, 28 Oct 2026 18:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CSeFs2pu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC851F031E1;
	Wed, 28 Oct 2026 18:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213682;
	bh=GbEbjAGGGEjiVrMnv0hlen8NRbh1LOL/JoWYr6ehEWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSeFs2pu7oUS+gMm/CIGvrRgDQ/p/GmpepUoXS7ehfaxDtdMj4zx1BSvl6cHS2RnS
	 78uHxhBYOtPvNH4Em5ZeByeYFO99M5wCHmvo90itWTsCLPXCpOB3skFWMwYblN3NQu
	 423TOORAxXwHJe4Ril7xbMIK/E49QEfxOTIH42NQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0593/1887] Bluetooth: hci_core: Fix possible buffer overflow
Date: Wed, 28 Oct 2026 17:44:49 +0100
Message-ID: <20261028170512.914123598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 81137162bfaa7278785b24c1fd2e9e74f082e8e4 ]

struct hci_dev_info has a fixed size name[8] field so in the event that
hdev->name is bigger than that strcpy would attempt to write past its
size, so this fixes this problem by switching to use strscpy.

Fixes: dcda165706b9 ("Bluetooth: hci_core: Fix build warnings")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index f79c84a9e0c05..20bf36e88bea3 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -877,7 +877,7 @@ int hci_get_dev_info(void __user *arg)
 	else
 		flags = hdev->flags;
 
-	strcpy(di.name, hdev->name);
+	strscpy(di.name, hdev->name, sizeof(di.name));
 	di.bdaddr   = hdev->bdaddr;
 	di.type     = (hdev->bus & 0x0f);
 	di.flags    = flags;
-- 
2.53.0



