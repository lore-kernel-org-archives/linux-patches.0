Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D552E0B45;
	Tue,  8 Jul 2025 16:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992600; cv=none; b=nN/KFo6QRlLKr6tV12raqWQRIXlXhhLtfqJs7x+rYEkjvYp6/GO1JUp4Mq/BFuEwf57uEhnLmlKD5CKvBAuC3FVz44WnVy0EDxN10KvcwGI1yqk6eGXczsNiMFcVgzuDd0/L9jeALU7dWofQPAGqTJnaJDGyE3BWdyWN753fWZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992600; c=relaxed/simple;
	bh=Z4DDZrow9eRUZb+6Wh3IOORYW3fhIuct2/QJ3PIJPL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxOgx/QDPwgu8bjRswjr7G6uJzn1clZ5QRzijiHIhVUAIkdaXettN62ouuNmucYqzhZpdwmSjpGtuX61rAxR0OKhEHd3aqwIm5hBzbHpeCpVpt2iHj1TcYCXRMyfqQ9fICpbn7zoIp5aYxpxMnIMYNC55YnAI4VNnp0GPR5JEqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBbyE+WJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBbyE+WJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C06C4CEED;
	Tue,  8 Jul 2025 16:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992600;
	bh=Z4DDZrow9eRUZb+6Wh3IOORYW3fhIuct2/QJ3PIJPL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBbyE+WJwfhFRf8SyVH5TMJMlbEdErqBu+Mnh76PwZy3qSaBNrEWnWCnCKPIaF+AY
	 zi1mzcogTOSfOJypJxuovXGMfrn7C2Ic0+kJEoHPA4IHw/ePC3ZNxuoB7VuPUC2BCu
	 lk3/2a7q5rCWjBTOn9jqYVigUH9z4aXE8JwQw68Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 017/232] Bluetooth: MGMT: mesh_send: check instances prior disabling advertising
Date: Tue,  8 Jul 2025 18:20:13 +0200
Message-ID: <20250708162241.885123097@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1073,7 +1073,8 @@ static int mesh_send_done_sync(struct hc
 	struct mgmt_mesh_tx *mesh_tx;
 
 	hci_dev_clear_flag(hdev, HCI_MESH_SENDING);
-	hci_disable_advertising_sync(hdev);
+	if (list_empty(&hdev->adv_instances))
+		hci_disable_advertising_sync(hdev);
 	mesh_tx = mgmt_mesh_next(hdev, NULL);
 
 	if (mesh_tx)


