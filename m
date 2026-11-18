Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019459;
	b=vcOczVJQTms3NuVH9EsvTCBNcSaxMXqwCt5cfDDI8lOP2+oP/7fWxZuH2mvEt19Xsx3/
	 FUn7RyH+bY8VXS/18j6lE3TdvGmmsReWFs04VTzTQ0zceEBlNZSnijicF/glpU4YxMBo8
	 YBTjz4KBS0vbHgc0cr4b3zLB4IeGYy2rfgYXxitsGIvMXteFrU780R5sG/FNIFbOlqwG/
	 DZ5FVx6GYOHHF6J75aatZXLG5Ol4yc2PZIRFHz1mXKqqINa00jc+XoZLK2frtnFd1JGCp
	 zdRDiK8VCnxcBXTmp43qm5j7CjbUNGf53c2kX/7DbhkhMucnJHKa4uKlwbGeTqUe+4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CSI1pPqXGhYJuJHigZk8otc7fAwFxsWvrFFglD5B4rs=;
	b=Flr0Wmpl88MPOrEoqSTVB6cQHL2VpPX85SdE87iNlCiFb/VL6vc9FbUhMo7MiRiSFeFX
	 hFKhi23Be5oG6p/TiNLpih4M6+Pk1HlipmpdZs/OmKYqgXsAIYuaTYPWvTIF1jE9cYyOr
	 cwUMkpf8iPBE20PRokgWbtwpwkCHxzOAT563RGM80jpK5FQ11vUhRqOPfjD0Jpc+rDSK6
	 NXuIWKqJ1yHErKHdqlb3rqQHYX7p4Vk98Mqeap7Nr0dDIlaMhoGT+7xe5GmXoIqqLALT1
	 sp0qPEgJQE5tE3L5MMIpUeH5q4AronvyjecTCPK45e4B8432wqs5bZhLaWirp8UnYsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WWIJPkxe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AED1606B560;
	Wed, 18 Nov 2026 16:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WWIJPkxe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237E61F000C4;
	Wed, 18 Nov 2026 16:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019458;
	bh=CSI1pPqXGhYJuJHigZk8otc7fAwFxsWvrFFglD5B4rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWIJPkxecj2EL4jlW6kcYNEFA7eT7oiuKtIiHbDZtzgaH31xTw6PyYYhmaNsEoLJ+
	 QG6a2ATa18T6VnJunIkpw3Q3Nzijxj2Gqcd/dV3dceJn72/BEAB5QdN97byJpVYI81
	 XqysYdzCK54cSusrsABdOYDuUzIJMSmy/L38B56w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1602/2651] xhci: dbc: lock the minor IDR on registration failure
Date: Wed, 18 Nov 2026 15:47:22 +0100
Message-ID: <20261118150345.520859957@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit 47f4e983b5de7616fb11d5f537fc9a605387d136 ]

dbc_tty_minors is protected by dbc_tty_minors_lock when entries are
allocated and during normal device removal. The registration error path
removes an entry without taking that lock. Different DbC instances have
separate event work items, so this removal can race with an IDR update
for another instance.

Take the same mutex around the error-path removal.

Fixes: e1ec140f273e ("xhci: dbgtty: use IDR to support several dbc instances.")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Assisted-by: LLM
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20261009151624.618967-6-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-dbgtty.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-dbgtty.c b/drivers/usb/host/xhci-dbgtty.c
index 3d51e8d82659d..2249cc16800cc 100644
--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -535,7 +535,9 @@ static int xhci_dbc_tty_register_device(struct xhci_dbc *dbc)
 err_free_fifo:
 	kfifo_free(&port->port.xmit_fifo);
 err_exit_port:
+	mutex_lock(&dbc_tty_minors_lock);
 	idr_remove(&dbc_tty_minors, port->minor);
+	mutex_unlock(&dbc_tty_minors_lock);
 err_idr:
 	xhci_dbc_tty_exit_port(port);
 
-- 
2.53.0



