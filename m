Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FA5231A4D;
	Mon, 10 Mar 2025 17:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626633; cv=none; b=JI2gAW7nRDWLfVXm71le7pfgr5//yQ54aFEOmJssz6c4vE5rIYie79VMWuhGVnF1moPlzg7HpHb6Z33+S+SnlCKPBnp1bB4b1qxzn2bBdY5ZUjDspegOnYAeMt123/FcXfsQPrK2SFTsy27Cd1EFOThjvWt4dg4sfbFKRxu1+Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626633; c=relaxed/simple;
	bh=iMRYvEVxtSu0WgPTW0KHzy/q95UwmT7l36Ni7SO4Ab8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXLbeT1x5uFMcS2lyTF8foMAGkTVOtmow99ZDISDmgOunHjCEVSe3qOGhKqdLsWEJql1X3Asr+p4IuKkpmRoUi386ugWaZsLVHrse3oSC58GVxXjV5FXFoEOZI64ZoKNBGk9v0NTsfWZeBV+zESDGCNcZBr/LCMc9SK54JtaYJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yESj9SDT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yESj9SDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212B4C4CEE5;
	Mon, 10 Mar 2025 17:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626633;
	bh=iMRYvEVxtSu0WgPTW0KHzy/q95UwmT7l36Ni7SO4Ab8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yESj9SDTrPDBHfACbyFSm9WkuRA4qEqTYXgdBmHpuftFRybqtHN0BhlPubgGwPtI9
	 YmGXUFSFdJWOCKLSxn26ZcY+rSoCBcMPzikbRu26f+LezFUuMkd7J4fgRafKpvzh8D
	 OEm3FLMKvfrCprGkDOFpDhxg4hsadZN5RJMrcwY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.13 059/207] Bluetooth: Add check for mgmt_alloc_skb() in mgmt_device_connected()
Date: Mon, 10 Mar 2025 18:04:12 +0100
Message-ID: <20250310170450.118059581@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit d8df010f72b8a32aaea393e36121738bb53ed905 upstream.

Add check for the return value of mgmt_alloc_skb() in
mgmt_device_connected() to prevent null pointer dereference.

Fixes: e96741437ef0 ("Bluetooth: mgmt: Make use of mgmt_send_event_skb in MGMT_EV_DEVICE_CONNECTED")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9791,6 +9791,9 @@ void mgmt_device_connected(struct hci_de
 				     sizeof(*ev) + (name ? eir_precalc_len(name_len) : 0) +
 				     eir_precalc_len(sizeof(conn->dev_class)));
 
+	if (!skb)
+		return;
+
 	ev = skb_put(skb, sizeof(*ev));
 	bacpy(&ev->addr.bdaddr, &conn->dst);
 	ev->addr.type = link_to_bdaddr(conn->type, conn->dst_type);


