Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCE61C8228;
	Tue, 27 Aug 2024 15:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772601; cv=none; b=febWQbFG0ZF7nJdHMyjTHV2gykdKLDW4/oBEPiMjnYD/bZrP6Rl6BFzeTnZyONxZZUlF3lW4RNQ9q79aJO330ojptcK2nmC8qkFFjIP/7jvmCcSic+4dT9hnoA3yw5T3eAASfriu1ZW1sXQSIWK1AH5zjhYCDGBd/TLVLUMM3lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772601; c=relaxed/simple;
	bh=5yVtnz92O3elg7uBIU/nU5bU0VIS381+KvaLqmIBXkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDQHYS/KN9O7CbEuV/8CFXPfRXNGwo4CxSGlcIcWCj/k/jVm/489iYkJ32cD8sEz75HsoiQGPqfbiKE+L+7jCCqnc5iL/ezhG4vafRIfBEx0yviLyyxrDnv877HuntKKgamxsYyF0BZVHlnUvTd0RhTWJOZWW0rU+njxoKn9eT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1YTCDsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1YTCDsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDAFC4AF15;
	Tue, 27 Aug 2024 15:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772600;
	bh=5yVtnz92O3elg7uBIU/nU5bU0VIS381+KvaLqmIBXkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1YTCDsbbxpCBxkeIrw50Ewan2hjYe1snpQf4dEiZnWbuzxC6tJou7+DPLKmmPuLK
	 DU7gPrIulBFp8U0L/H+8u0SnW/YEtgMRwzj7hQt8CeO03Cmq0cxWmjosHDjI7ot7eM
	 XZHkAg6N8m4oXlvP9YnUH6UgPSYW5d3r8mrXT1qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Yiwei Zhang <zhan4630@purdue.edu>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 263/321] Bluetooth: MGMT: Add error handling to pair_device()
Date: Tue, 27 Aug 2024 16:39:31 +0200
Message-ID: <20240827143848.259677980@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3524,6 +3524,10 @@ static int pair_device(struct sock *sk,
 		 * will be kept and this function does nothing.
 		 */
 		p = hci_conn_params_add(hdev, &cp->addr.bdaddr, addr_type);
+		if (!p) {
+			err = -EIO;
+			goto unlock;
+		}
 
 		if (p->auto_connect == HCI_AUTO_CONN_EXPLICIT)
 			p->auto_connect = HCI_AUTO_CONN_DISABLED;


