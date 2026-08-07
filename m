Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9422D12ED;
	Fri,  7 Aug 2026 15:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116221; cv=none; b=N5TrybMQPAzgC0NRln0tzkEHO9iKVdxUepCJvBQMnE9Y6Ymv3NEB81t4iKr6fHuTOtsIXZ+pQJbC72lFccFJev6BY2orAQhT9bkbf3UMKbT8DDdnWvic8FK4pwXTMUPUdnXcKWhExoFddgW+OhuIuWWfTJIs0Uh5LXkCXchMB1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116221; c=relaxed/simple;
	bh=4oVJ9d/lUyHKM9pe/u1qUMcYEfdTOv+OrgEQ23vw4Ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3SHd7Z/c+lQtuplD6u3gC+1UqsuJgTmrj5Tzg/tLR/kaeGNd6gDmcQ4Ee59u2gqsebwCTe05gk6AieIbvtqgJbjlTC6yGej/5yXc9h8BSVfReZdVPZMYZI1NYDb2H7oakB2+RobFc5eloImZcKbq0I/Xx3YNem6MS7kEsIzdlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LiTiEGNH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LiTiEGNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033C01F000E9;
	Fri,  7 Aug 2026 15:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116220;
	bh=n6wOYBS7hEFVa1PoZZ0+F2C4NS0gQDYTYsNTS4hT5pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LiTiEGNHIngwcBv3nC912hxv3PQ2H5OQoAIVw1gEzgdcKTLKHmxglU6tRmQn+wFCG
	 fU9nbskZObK8Gw1/6xbYaXUXaH9hqHluWdorjJ9Qw3NfAbyt2WhVuOKkNI3txJpe4G
	 AT3odkVyIjFbwNy9G63+rNh+QVSPXjqZ6v0w0gPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 153/261] s390/qeth: Check CAP_NET_ADMIN for private ioctls
Date: Fri,  7 Aug 2026 16:38:30 +0200
Message-ID: <20260807143418.666851558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


