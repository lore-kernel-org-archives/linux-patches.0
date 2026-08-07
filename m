Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4064C38D3ED;
	Fri,  7 Aug 2026 15:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117496; cv=none; b=NRWWP8qEvx1LbidBxKcuDRetkNlDUM/WXEsSSMKimC6/qsUffbUk4DhVGWmS1+JS60Byn6nT+c+nnJwp3j81Q7dC1FaBK1Z1SFUKs8ZtLaLKprDduHQzhfAzGVO3B1sA8Hl9QzJ1rTGdvAKPedfssO/5H4SAp/KZgnmQkCuMcUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117496; c=relaxed/simple;
	bh=4wKANM4YaBBJBs+TcW/VTJJFhaa3nH0ZkNoib9fc1Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUuJYy2YI291K/CHWWIQauLLnsgp+3yAXRaPSM8Py5tXRwxoZ+jUBiQvOs7AwnSH2RRKXBIxOTZeGw/to3J++wTO8XqmIVTlsKEA2tMaiAkN5ZOcOO2A0gGMXwgeCXWOytDcgehHgKq4XOIz/Yodna6D8RWAqJKQH2ZCvtsDwK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNEmhaST; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNEmhaST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E2F1F000E9;
	Fri,  7 Aug 2026 15:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117495;
	bh=BbmG79pFaMQV2sWbGvInjEa4AvCLs5wxPufkTWndvt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TNEmhaSTOJ7DBS9wF9zFB1tMvp32+bP/3qFGDSMGk3xJFxXkg/OME7ledktKCtgWJ
	 PR88WioyVCUNt3ycrOSetYzj1ecHHmJMhiOW5oNB6Q3NUUbNNRirMFrhNVDVJTE9ef
	 TbE9QNMYkbFkuh+iJwrYOOT9sdzgHteJJ/x+0zWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 338/438] s390/qeth: Check CAP_NET_ADMIN for private ioctls
Date: Fri,  7 Aug 2026 16:38:54 +0200
Message-ID: <20260807143435.177892859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aswin Karuvally <aswin@linux.ibm.com>

commit d211028bac1bd0fff0026bfa2a8328e5b78cd0e6 upstream.

Gate the SIOCDEVPRIVATE ioctl commands SIOC_QETH_ADP_SET_SNMP_CONTROL,
SIOC_QETH_GET_CARD_TYPE and SIOC_QETH_QUERY_OAT with CAP_NET_ADMIN
capable check to ensure unprivileged users cannot invoke them.

Fixes: 18787eeebd71 ("qeth: use ndo_siocdevprivate")
Cc: stable@vger.kernel.org
Suggested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Aswin Karuvally <aswin@linux.ibm.com>
Link: https://patch.msgid.link/20260723140050.762991-1-aswin@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/net/qeth_core_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6525,6 +6525,9 @@ int qeth_siocdevprivate(struct net_devic
 	struct qeth_card *card = dev->ml_priv;
 	int rc = 0;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	switch (cmd) {
 	case SIOC_QETH_ADP_SET_SNMP_CONTROL:
 		rc = qeth_snmp_command(card, data);


