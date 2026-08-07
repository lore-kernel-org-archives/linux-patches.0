Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF50293458;
	Fri,  7 Aug 2026 14:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114290; cv=none; b=GEjsYlJi5uEvun4wyCkY5hl54+iPKbZ0LnQjPpJJccx2NKTNRARvjqTxhF7bDjWhGWNcibvLuNYgqj1j1NeGm+17QEep2vI9ojuNNr8VyYPgrn5Ohnj+43yo8ZmnRqhxPBYupK7iQv4tjL4/AXfdHM6WxtQP2fT87PFc4iGVdNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114290; c=relaxed/simple;
	bh=eRTupB7mq2GbfAMbD2BI5PEUtZ34F+hZGKyCNKjkdF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+FWWtLwrENUHwWdUncj5OQH1LdIle9uUd6iDkgoVS/ayNIhsPC2Pfw8PK8DqgsAXN3aivN3kg713YzX5h8KCVedWgI5DAYDslr7v3sjbszXoDrBJngBJnr7/A7tYmzRFW+/LNzX/Anzs48dY22WxGanBbfseHgxQfn0o9ffl8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILMYh7Tl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILMYh7Tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B601F000E9;
	Fri,  7 Aug 2026 14:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114289;
	bh=l5eRPytcq5l/J+MK3KcNLGG+CpftB1QNrV2tygmr2v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILMYh7Tl0rToUobfH3XMJwdKxcLim41rgEbxca8uPP+rEdsq7lovNbvJTkhdGXupA
	 nYMxoF1nBBoqzqu79yZ6LmVuj2bT1wyLzDjG16uB1uctV01yBlZm8K3+RmcXCs20gU
	 l5UguPO0Cq7Y+Ti5WLpxZGwM5Tsxi5QYf+MvhbwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 209/337] s390/qeth: Check CAP_NET_ADMIN for private ioctls
Date: Fri,  7 Aug 2026 16:36:52 +0200
Message-ID: <20260807143423.086622141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6526,6 +6526,9 @@ int qeth_siocdevprivate(struct net_devic
 	struct qeth_card *card = dev->ml_priv;
 	int rc = 0;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	switch (cmd) {
 	case SIOC_QETH_ADP_SET_SNMP_CONTROL:
 		rc = qeth_snmp_command(card, data);


