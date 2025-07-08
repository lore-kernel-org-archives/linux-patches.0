Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5706A1548C;
	Tue,  8 Jul 2025 16:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992221; cv=none; b=VJgU6p0+LUmtu2vE/8J6QUGCSTCggjbHTu8o5zW/uGnQeOJQfqigNWqOBeBiwmtaOpPZd9S1ZXfayEK8gFQ5hRKZ0Gxjecg8AihG8ucbfxCH8fGMn/+UKWi35ejVJJBBGazo0gv1WUv7zePFzcvCxqpXpw+kpoU4HiNKdfK87No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992221; c=relaxed/simple;
	bh=Vsd56XY36b8bcByMo/GUq0wtd68Fg20UpytZcpLNwOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDofLdPPzoQdaSbFoR7Ap03EAr4wVmF0/+VJBcXrYVNdh84aK0iT9eJ1mZ4iikUS358aYu722OnYozU+SNwO/vooH2K5++LqT2A+fLJa5x3MKai3SuycqlfYQbEBBlzWpBLbaBBLl0fwmPo4fkerB/4rptI3OZ7UniV70j8np3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+83FPSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+83FPSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F55C4CEED;
	Tue,  8 Jul 2025 16:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992221;
	bh=Vsd56XY36b8bcByMo/GUq0wtd68Fg20UpytZcpLNwOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+83FPSGANMfTZ1zvoL6RImkEOoIw0HvkX+O9vIjyTkpEF5tIWjl4R14UfQQT/8Ye
	 nQwD2vgpq/ryInK+KPFN/KxZgMhxIuleQHYIvDqysB+Oi9ZVAdfmzUfmOqfXQQMBVE
	 vWLHlWQZrQPqc8Zk5gzAkNV9NQk3L4EbwDJFm6/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 012/132] Bluetooth: MGMT: mesh_send: check instances prior disabling advertising
Date: Tue,  8 Jul 2025 18:22:03 +0200
Message-ID: <20250708162231.100623378@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Eggers <ceggers@arri.de>

commit f3cb5676e5c11c896ba647ee309a993e73531588 upstream.

The unconditional call of hci_disable_advertising_sync() in
mesh_send_done_sync() also disables other LE advertisings (non mesh
related).

I am not sure whether this call is required at all, but checking the
adv_instances list (like done at other places) seems to solve the
problem.

Fixes: b338d91703fa ("Bluetooth: Implement support for Mesh")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -1074,7 +1074,8 @@ static int mesh_send_done_sync(struct hc
 	struct mgmt_mesh_tx *mesh_tx;
 
 	hci_dev_clear_flag(hdev, HCI_MESH_SENDING);
-	hci_disable_advertising_sync(hdev);
+	if (list_empty(&hdev->adv_instances))
+		hci_disable_advertising_sync(hdev);
 	mesh_tx = mgmt_mesh_next(hdev, NULL);
 
 	if (mesh_tx)


