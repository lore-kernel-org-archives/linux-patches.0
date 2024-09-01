Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DF31C68C;
	Sun,  1 Sep 2024 16:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208980; cv=none; b=UjtFIwC5L5qa0LyHtPOuC6lvMSJIAIxt00XiHgfpj/lx2LA4zokzXduZrlQ6wSEkm7trz4BaM33e/kJUOf8NiTvQb3UuBzfzHBC/hPIvc/PEZmESbN5P4ktSsTh2oVJXwRHlghomC/xbU8P96T5pn7mLVo+wNNn6TCZCrxgrtWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208980; c=relaxed/simple;
	bh=9Iw9jWKoSJihDx6GE46E1/wVi0a1Ue8CKdg2D/OIWk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbRYFYEeBcoT53/d7d5yyVKZfs5ZYtFTHpKdR60jiS0ah5hC9yspwutXJwlHpc67VYm6vx+HXwTCrhVW6yNxdGnm7zwLNWYahYE4X10JAfl5oya+5AbcbZCwV05JFeD73lx8M7CjnfLuIpBFa9//Uy9ALFStyIUJOT9F6jopTHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7I+xSxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7I+xSxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4A3C4CEC3;
	Sun,  1 Sep 2024 16:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208980;
	bh=9Iw9jWKoSJihDx6GE46E1/wVi0a1Ue8CKdg2D/OIWk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7I+xSxQAs2PZ1PMD7znGLLcPLQA28GBsem+EqS+aXv8yD7pt6Ch1DRqaFgbi3ZHd
	 H7i0UinofybX33dVTOI51gvF8jkGkt2f6SOkvA6KjuheMshsXYNMvFTJX7VpFuGR38
	 aBBw8XT97lJ98G3vYVZPIod8gIJa4832hMK5cDaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Yiwei Zhang <zhan4630@purdue.edu>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.4 098/134] Bluetooth: MGMT: Add error handling to pair_device()
Date: Sun,  1 Sep 2024 18:17:24 +0200
Message-ID: <20240901160813.780537463@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2908,6 +2908,10 @@ static int pair_device(struct sock *sk,
 		 * will be kept and this function does nothing.
 		 */
 		p = hci_conn_params_add(hdev, &cp->addr.bdaddr, addr_type);
+		if (!p) {
+			err = -EIO;
+			goto unlock;
+		}
 
 		if (p->auto_connect == HCI_AUTO_CONN_EXPLICIT)
 			p->auto_connect = HCI_AUTO_CONN_DISABLED;


