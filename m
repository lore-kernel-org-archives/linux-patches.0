Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F54C43C7D7;
	Thu, 30 Jul 2026 14:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422123; cv=none; b=IHZTpnT/yaSbDxhzSISxTFTEHxv4cF4uwyzaKy1yxHoWpcaLW6HJE6HhwOGw5Z9qqNpVj1M0i/MFbkV+pcsqqXIhqwIoVa2TLvSU+RxxReSq5WHSmnXLyef1Fq1iIOEnY9VNY7VzASz7Ayrqyj0DZjCdgBWaWokDJGsSE1lmsIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422123; c=relaxed/simple;
	bh=QIFw/5CUAJunmRgnJnZ7QURPW84FPH6H6f/w3RbvhFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kT/z/kUp+YpPj0Gjh0lVAnJQfUqWCa3IQbLXCfltoAAV7QaYIMJdzmL2FMvFpsCYtePyicIj/GowM9QtlFXiILrWnm8hHfL5aMZ/NqH+vmsigHm18GuLQY1J4od5RQbBT80wj/zSnfIHTK/dnPRnIX0j2oyQIhRoiehlEPVcGRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnB0v7bd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnB0v7bd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADAA1F00A3A;
	Thu, 30 Jul 2026 14:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422122;
	bh=7zHFMrNolIytlagAY4qiWU7OpgzFugxgpqDWwvxj5BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PnB0v7bdKrgXJORQSQKPFHAyFwYxBdaOgFcWee5gLgxT65xXR1aP15kJgEFuIa9QC
	 83MjrT5G12qe4uyOpAyNJutpGoMdft6q3FwufFI2q33zV9ojfE0O5cbWAQXOP4a53l
	 ZLB0wB1VZpS27q4wWk/rDJNc8grNvUkD6ycl/tM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 333/744] net: qrtr: restrict socket creation to the initial network namespace
Date: Thu, 30 Jul 2026 16:10:06 +0200
Message-ID: <20260730141451.362670223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

[ Upstream commit 3b536db8fb32da9e9c62f2bb45e2e319331f0426 ]

QRTR keeps its entire port and node state in module-global variables
that are not partitioned per network namespace: qrtr_local_nid is a
single global node id (always 1) and qrtr_ports is a single global
xarray. qrtr_port_lookup() and qrtr_local_enqueue() operate on that
global state with no network-namespace check, and qrtr_create() places
no restriction on the namespace a socket is created in.

As a result an unprivileged process that creates an AF_QIPCRTR socket
in a separate network namespace, e.g. via
unshare(CLONE_NEWUSER | CLONE_NEWNET), can send QRTR datagrams -
including control-plane messages such as QRTR_TYPE_NEW_SERVER - to QRTR
sockets owned by another namespace, and vice versa. The receiving
socket sees such a message as coming from node id 1, indistinguishable
from a legitimate local client, breaking the isolation that network
namespaces are expected to provide.

QRTR is a transport to global hardware endpoints (the modem and other
remote processors) and has no per-namespace semantics; its in-kernel
name service already creates its socket in init_net only. Confine the
socket family to the initial network namespace, as other
non-namespace-aware socket families do (see llc_ui_create() and the
ieee802154 socket code).

Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Link: https://patch.msgid.link/20260716154319.3297699-1-qwe.aldo@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/af_qrtr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index 2288159f5b1bba..7482a09adb54f9 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -1261,6 +1261,14 @@ static int qrtr_create(struct net *net, struct socket *sock,
 	if (sock->type != SOCK_DGRAM)
 		return -EPROTOTYPE;
 
+	/* QRTR keeps its port and node state in module-global variables that
+	 * are not partitioned per network namespace, and the in-kernel name
+	 * service only operates in init_net. Confine the family to init_net so
+	 * a socket in another namespace cannot reach the global control plane.
+	 */
+	if (!net_eq(net, &init_net))
+		return -EAFNOSUPPORT;
+
 	sk = sk_alloc(net, AF_QIPCRTR, GFP_KERNEL, &qrtr_proto, kern);
 	if (!sk)
 		return -ENOMEM;
-- 
2.53.0



