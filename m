Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA56142AF87;
	Mon, 17 Aug 2026 14:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977456; cv=none; b=X5jWREdmBjn1lm09/3tzWfxS6UrcQuJrsTTJUT+IhBQCse+CA/99tr6w9hLc/Sw24Xj4WJsdkljh2/bvSOjQSvDzAvZoKn1pivd7O4Y5xn+ePjyzhxsW5xp0hUgoAFXtCbx7Y0bMb+DrUxjDDvD64jw6riLnj66UMcnzlv8BgGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977456; c=relaxed/simple;
	bh=yN0BLMwhz9/Phr2vjunSnpW0D/bkB8E3QfteTMJstxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcwcJrc/ez1KKG70FQMpItQgwV5/QFlpwLl68LbjXb15rjCPmkR79FAEyq0WD9opDhNi3va+YmOjKsd/WZXLMZZkx+annZVIkkzzi+brB4l7rjoMEYIAWAFOFzcgppkxTNENymv9/sQCQdXK7sA5oU+H4CqOanJi1jQSR4Jmx4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N420a/OB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N420a/OB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC9A1F00ACA;
	Mon, 17 Aug 2026 14:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977454;
	bh=C2LDrsO9qf56tyMMbbj59nry/G30KMxETpvsgSIfhAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N420a/OBRJxnan+032cGG/bnjaTXPmZLHK697TUSQ0p0A0Ryy2GGXE28u7ahd6Ghi
	 qjnbHCjt2T7/BoRMupz2OnaYwHsdoXZP/p+qq6GTDDpwIFXGudvlzsvGGxK15JjfjX
	 XsIbdN2baARFQYtIcFt65BjSJ38JQaAoBykVb5KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 335/456] s390/qeth: Check CAP_NET_ADMIN for private ioctls
Date: Mon, 17 Aug 2026 15:32:05 +0200
Message-ID: <20260817132552.721432712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6609,6 +6609,9 @@ int qeth_siocdevprivate(struct net_devic
 	struct qeth_card *card = dev->ml_priv;
 	int rc = 0;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	switch (cmd) {
 	case SIOC_QETH_ADP_SET_SNMP_CONTROL:
 		rc = qeth_snmp_command(card, data);


