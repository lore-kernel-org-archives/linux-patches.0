Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22EE1E487;
	Tue, 27 Aug 2024 14:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770759; cv=none; b=rJx+6FEfdTl3po/sd7f3FX9PGrJAnNAaO79MRtuEZqr7XcaXiVL5igem1okDEmww1fSVa4dvGP8V5hTRRRTHFizF7OzahLy1P7fUc/EwZBux4yvN/3AqzVmMNwljQJ8W0DrjaPSz3aZb8jDL+/JTH47mXNiN+/Ls9zJX9Tr5JZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770759; c=relaxed/simple;
	bh=MwprgtIIWcX9JmsHl0e1s+iEdkiXDrBvIo6xgshPaz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMmTmbS4rzu/Q7wHlXehOXScEeWuYE2zlnCScCsFm6bpGHUbRXqzmSFw4uTuZxd93x+EaPmT4JAL+Pe2B43GgRI5Y5kkChripZS+siWQyNacTxZzAejM8lutaiyMMoLQbe4OzBj1357cTtm4bEHgmIPTrWU9kY3p0mKeDqvke7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2aRs0Re; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2aRs0Re"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7225CC61044;
	Tue, 27 Aug 2024 14:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770758;
	bh=MwprgtIIWcX9JmsHl0e1s+iEdkiXDrBvIo6xgshPaz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2aRs0RefCgq4SRlcnTn4Cul0EXuJpliQI5u+UZSfW8H+ERkaoYGgw6EA5BKJO2Cn
	 yF174KVakWqrtDDogrMkjIXAMKjYEaSq+U5VmpvUq6dUzcUPWi78dR/JzghRSC60cl
	 6ugBmkZ6Bh09yD9JhsrM5r3w4YoQnDDuZVUVYl3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Yiwei Zhang <zhan4630@purdue.edu>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 294/341] Bluetooth: MGMT: Add error handling to pair_device()
Date: Tue, 27 Aug 2024 16:38:45 +0200
Message-ID: <20240827143854.581548881@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit 538fd3921afac97158d4177139a0ad39f056dbb2 upstream.

hci_conn_params_add() never checks for a NULL value and could lead to a NULL
pointer dereference causing a crash.

Fixed by adding error handling in the function.

Cc: Stable <stable@kernel.org>
Fixes: 5157b8a503fa ("Bluetooth: Fix initializing conn_params in scan phase")
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Reported-by: Yiwei Zhang <zhan4630@purdue.edu>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/mgmt.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3449,6 +3449,10 @@ static int pair_device(struct sock *sk,
 		 * will be kept and this function does nothing.
 		 */
 		p = hci_conn_params_add(hdev, &cp->addr.bdaddr, addr_type);
+		if (!p) {
+			err = -EIO;
+			goto unlock;
+		}
 
 		if (p->auto_connect == HCI_AUTO_CONN_EXPLICIT)
 			p->auto_connect = HCI_AUTO_CONN_DISABLED;


