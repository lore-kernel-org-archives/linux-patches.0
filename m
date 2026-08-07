Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6A233C1AD;
	Fri,  7 Aug 2026 15:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115426; cv=none; b=ZGNSt5qUTskkbtdDO7pmALXB/TI9oFzl6i/4a63yVd2TOJTqMkb8SLw4WypelFMCI6RFshnhrqW3ssAuyPxKck3km50Ug9xjzzDyx6rmYb4sXTvVmwP7EEzJIicKzITYFW8iY3RtboiLlNn74fhbhZAJ9cF3D5Yx+oB2SSt/58I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115426; c=relaxed/simple;
	bh=o4Yypi59qRkqMZ9jS8mit9TnR+xikc2W/GH9+MOCLck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkPe95O1PJLz2F20/Rn3JTA8BBiwolH8exBf977VqSqudu1htkzO7s1qevsIF7Tbqu/YbO646T3FgdecRli2nyZhry6wGfJMSyUkOWvN0/XdRIPbsqLbtJ7CCyv0noMjLWAwas55Iwexyd3fUU46DtjwbYrXzH0hCsfN1mchsw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNMIJ0g7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNMIJ0g7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71341F000E9;
	Fri,  7 Aug 2026 15:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115425;
	bh=uqdCuDo6qfuSBfFlAcJD5mRGjiVS77fnNVItpdTd+as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sNMIJ0g75qeXuHTytb5qeLsE7j5PxknwIOkmABaZnXmqOjLO4Uk+Cv6pFoCexPj0k
	 1SjNkpxFZ1XdCclFNFKzFAgMX4NMfP1RT/o3zPHsk/J9JyqcYjYpIga8HNVgApRz7l
	 VDs8K9OXhu7OLE0Jh1xkqMg4Vx1cFwQJne6WF9kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 271/396] s390/qeth: Check CAP_NET_ADMIN for private ioctls
Date: Fri,  7 Aug 2026 16:37:11 +0200
Message-ID: <20260807143430.101334301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6528,6 +6528,9 @@ int qeth_siocdevprivate(struct net_devic
 	struct qeth_card *card = dev->ml_priv;
 	int rc = 0;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	switch (cmd) {
 	case SIOC_QETH_ADP_SET_SNMP_CONTROL:
 		rc = qeth_snmp_command(card, data);


