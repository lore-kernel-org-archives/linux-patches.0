Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358A01754B;
	Tue,  8 Jul 2025 16:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993287; cv=none; b=FM/giEvzFuQKZWF2hJdyyQOOVcK1ZkiDC1xpqmy4UNCL5jdsf/w8jFEeVQJ9PQELkZ2MuNvh+8J6a3ZSCZ/Y1fpz3CF1QcGz2zJTZFJSYoIdcBkREuU4Eu0tqVwqy7m/3awzDC88SmaJfRMppJNDTQlxY7kF1B/Uc9N9dA77R/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993287; c=relaxed/simple;
	bh=BpA0vFAAufnuUnk9J906FRSr8JSlMtlp765eEY/mpMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bqq8ay9/asP2RwdFSpnhYoe2TvKcnub+rsXTFsEgUWMKepORinM0uqjNrMVu8qHifIFpB9hWhLauZegAQ6xgC/dnfMX7UI4oHSIkKj+rgp2tosQQjSkr1yuqA5xQCTTufSn7JIZo0rRKQGGsPOCf7vMaBLz5KdQgkIaR+REmUD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPuWU8/j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPuWU8/j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F76C4CEF0;
	Tue,  8 Jul 2025 16:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993287;
	bh=BpA0vFAAufnuUnk9J906FRSr8JSlMtlp765eEY/mpMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPuWU8/jDVpRXdnXDyKr1hCvvAT7i//IqkSh/2sXmuhkHo4bDtggzorIGY8HHGcDQ
	 zDWuUysIszoJdCjXRpgIpNZ0pie8W6wIcqwfCF6b6wQGtp/fuNb7qo2mxFjBZTMpOB
	 uLfNCnfhiYtD5EJo6TZP6th9sTzluuL6qCg+aPhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.15 023/178] Bluetooth: MGMT: mesh_send: check instances prior disabling advertising
Date: Tue,  8 Jul 2025 18:21:00 +0200
Message-ID: <20250708162237.154036821@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1080,7 +1080,8 @@ static int mesh_send_done_sync(struct hc
 	struct mgmt_mesh_tx *mesh_tx;
 
 	hci_dev_clear_flag(hdev, HCI_MESH_SENDING);
-	hci_disable_advertising_sync(hdev);
+	if (list_empty(&hdev->adv_instances))
+		hci_disable_advertising_sync(hdev);
 	mesh_tx = mgmt_mesh_next(hdev, NULL);
 
 	if (mesh_tx)


