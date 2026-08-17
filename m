Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61AD2E7BD6;
	Mon, 17 Aug 2026 15:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980044; cv=none; b=i4+u00v2J3KFqNRqwa1LETnBYf9JmteLCDbFY43iEv1MR27RvZArMpfMZzAvvxScSj9DtQOzcLQsQiPhlhS+ynBjdACXbePTHfjB+Y79/PKJJxYrzYOg1e7wnk7DCEHEOc1IiIjAkNn9NmEs/adn3KzjjiMuZmFvfnQfyI8n/t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980044; c=relaxed/simple;
	bh=watPJuvONptIgigM56le2WQ82oCmB1MGwYC8/VaIR20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdxeJ8Ue8g0T6ywsEUSZ9tZcGYBB1NZ1+nEh1GbnjubnmL3nlG6C/30YuMTqWTM4BQ2uIMEuWO805UrvmP7x6FE7OF6nAaTaMeXBwwH+lkWvlRQ9coqtnwb1UgWCG5IQAb8MKIy/TcjpqxXH7p046km3YUkgGwdAsXFOgA1K9Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0af/tgSk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0af/tgSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1161D1F000E9;
	Mon, 17 Aug 2026 15:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980042;
	bh=qjFmCXp3vAlAeXqC/5kraOu0SZIVtzglGsVcMXA6buE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0af/tgSkfPh/Lv6HOVfnyhN11Sts8EfqHmJKSd82HzQFhgZFgpvKrfWyCa97j2H5z
	 oJM/I4N8jZyDTyB1mnWKKqz+Z/0NQA8IVtZ1J8tE0EwHSNtfb82XZcJEMzFhwPFN0T
	 EQbMUaKRO1Q7lV44MZZyyrZuytSTb1HCeJioCUdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 435/609] s390/qeth: Check CAP_NET_ADMIN for private ioctls
Date: Mon, 17 Aug 2026 15:32:11 +0200
Message-ID: <20260817132558.635685204@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6524,6 +6524,9 @@ int qeth_siocdevprivate(struct net_devic
 	struct qeth_card *card = dev->ml_priv;
 	int rc = 0;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	switch (cmd) {
 	case SIOC_QETH_ADP_SET_SNMP_CONTROL:
 		rc = qeth_snmp_command(card, data);


