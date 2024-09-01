Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C241DFD1;
	Sun,  1 Sep 2024 16:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209664; cv=none; b=RDO53R1d5bBSug0A4eBVEQiCrnKgxzDQ8q8phfQebhbhLITKwqV12qeF6oSXgrsnN1ZipYD0w9b3ywpOL82zqKJ6bkRuOdfR8QnibSLvgNbo4XNaB5IuwGZgs9C0+v1YavYqzd+XKlzDU09IqI/rDWKnH4oDc6Cbl9wz6rBAsls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209664; c=relaxed/simple;
	bh=B/294zeeXfWlXjzocPGKaQVvOVDKRLVKEREPatCtY/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgYVPdo7BVOBwHUD/nh55QxJ4nEHduAECaWHncPYE8zqGrGnWuud6W2YXJIDnpPdHg+YxGDWYMstFELtBKrU45AsurChdtg6+iMeEu+sQywapKzomqg49YKOxnamOit4iLk+0wNqNGsn0i/03jpgLtpqw5If+xWqCckZSHyeaMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+s4gKmk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+s4gKmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28DAC4CEC3;
	Sun,  1 Sep 2024 16:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209664;
	bh=B/294zeeXfWlXjzocPGKaQVvOVDKRLVKEREPatCtY/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+s4gKmkUtahFEKWwoCBYQc17QhyKWtaUpUakT25wtUq5B0gyPSJsQ09ghlDJBEmr
	 oIlW3RMURoFbevOz87/ssdI9y0lwu3BNPD1wiFjPbMr+dnek0+772GARPHfQ6gs/Yq
	 mVFk76V08hzRCHD6tfFdqFdwKTJy4lfp6KVUo3o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Yiwei Zhang <zhan4630@purdue.edu>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 107/151] Bluetooth: MGMT: Add error handling to pair_device()
Date: Sun,  1 Sep 2024 18:17:47 +0200
Message-ID: <20240901160818.135299469@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2962,6 +2962,10 @@ static int pair_device(struct sock *sk,
 		 * will be kept and this function does nothing.
 		 */
 		p = hci_conn_params_add(hdev, &cp->addr.bdaddr, addr_type);
+		if (!p) {
+			err = -EIO;
+			goto unlock;
+		}
 
 		if (p->auto_connect == HCI_AUTO_CONN_EXPLICIT)
 			p->auto_connect = HCI_AUTO_CONN_DISABLED;


