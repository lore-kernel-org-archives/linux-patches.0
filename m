Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CFA17F394;
	Sun,  1 Sep 2024 16:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207848; cv=none; b=QzOvt8Kg2Gr50b0zXex9v2/487w8EItt4C873tvRuSs7Hzed7YvvwR0ZnSL2fsxxKHOHq0aR5oYhYWEL71uKV78hw0PB4Cb10GKbGVI1BlflIhm0LIK6F+OMDSfZlnxOgu00jDrDlE8HVkpLEmg/hcA4iqYgrua5rNLeuo73Ztw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207848; c=relaxed/simple;
	bh=mvJo1Jqt7jp8k/aPLsa5QWYkeFauGeqM9rddAcKpYVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCCSEPF0CtTicbHBhx+c7d/oIM9SzTB3wYtRfjYnzAFYhrTHez5dTnuDb6wrdUsJ4eExCpCVkkkgc+yMQOvfQGepxgBL9pEzbh/ab08ICyx4BZJ2eRBg5AKTloisQ/B6umk7rXWJYF8AjBP3pXojaa9c2A82uI7U7D52ioa17LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRT5Qz85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRT5Qz85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD34AC4CEC3;
	Sun,  1 Sep 2024 16:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207848;
	bh=mvJo1Jqt7jp8k/aPLsa5QWYkeFauGeqM9rddAcKpYVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRT5Qz85mNkTEt5eF22xog9eCdPod5oCvw0BbSyrtGoAB/ROAnmm1pAeh58n2k45L
	 cA+vFdy4F00d/R+S0PF6EgyodkS76JERSeuWSiFM+GKObv8PpR3bVIdNM/trILBEHH
	 kFXcnTx2UfzhjIscct4Fh71a5984VBOzCEB0KYQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Yiwei Zhang <zhan4630@purdue.edu>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 4.19 64/98] Bluetooth: MGMT: Add error handling to pair_device()
Date: Sun,  1 Sep 2024 18:16:34 +0200
Message-ID: <20240901160806.113781723@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2913,6 +2913,10 @@ static int pair_device(struct sock *sk,
 		 * will be kept and this function does nothing.
 		 */
 		p = hci_conn_params_add(hdev, &cp->addr.bdaddr, addr_type);
+		if (!p) {
+			err = -EIO;
+			goto unlock;
+		}
 
 		if (p->auto_connect == HCI_AUTO_CONN_EXPLICIT)
 			p->auto_connect = HCI_AUTO_CONN_DISABLED;


