Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7C21779B1;
	Tue,  8 Oct 2024 12:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390893; cv=none; b=qCrCsqZI5dQ8AACXogS0jBwwKfGZ/VApMTQPaSf5T/jyndRsC3qEzTOWD4Vx8godb24iYbeD3Pd5cYnNBMoXJPuO+Cg+3op62CksF3AXLCY6fbDlDufe6I1/no3fNkov5Sme3F1nWcmEHQpT+UF+nqA5Bu/+pgaJja2mqmnxtLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390893; c=relaxed/simple;
	bh=V81q+biJWP0F2OmHPptSWcGJCDlfa0V67R7zxHFWwMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdeFcYTvokhbcDKEc1/HcoEjSxjDTAjT5VeIiaIDvvJS9WAiRENwm/YcZtcTSl7fcvKhZCu3naVzXrMD2v8Nu9npEkrBPjkyJ0PCOp9xAfCIdJW0sEF1M3MEakKuWo/2mYKqFDIu4t9MSBxAeCt6QL6TXDQtWnYp/sVb8OQDYmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsrBnzkP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsrBnzkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F49C4CEC7;
	Tue,  8 Oct 2024 12:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390893;
	bh=V81q+biJWP0F2OmHPptSWcGJCDlfa0V67R7zxHFWwMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsrBnzkPzPxcv9LpwBgsjEncLDuO1BnL0tNFxzriUB+l3v3c5yuiakqWt+JgN+AO4
	 KZvoZSBZJLgpS7Hmkh2QtDJ3pCK3uTa55E8bszWzEDyo+xjcATKyTBUa1lfeyfbxwW
	 uJ+0jd9uaE9V2/7SRUZFbbB62Ljh4oepLLBSYYeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Kiran K <kiran.k@intel.com>
Subject: [PATCH 6.10 424/482] Bluetooth: hci_event: Align BR/EDR JUST_WORKS paring with LE
Date: Tue,  8 Oct 2024 14:08:07 +0200
Message-ID: <20241008115705.088668521@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit b25e11f978b63cb7857890edb3a698599cddb10e upstream.

This aligned BR/EDR JUST_WORKS method with LE which since 92516cd97fd4
("Bluetooth: Always request for user confirmation for Just Works")
always request user confirmation with confirm_hint set since the
likes of bluetoothd have dedicated policy around JUST_WORKS method
(e.g. main.conf:JustWorksRepairing).

CVE: CVE-2024-8805
Cc: stable@vger.kernel.org
Fixes: ba15a58b179e ("Bluetooth: Fix SSP acceptor just-works confirmation without MITM")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5325,19 +5325,16 @@ static void hci_user_confirm_request_evt
 		goto unlock;
 	}
 
-	/* If no side requires MITM protection; auto-accept */
+	/* If no side requires MITM protection; use JUST_CFM method */
 	if ((!loc_mitm || conn->remote_cap == HCI_IO_NO_INPUT_OUTPUT) &&
 	    (!rem_mitm || conn->io_capability == HCI_IO_NO_INPUT_OUTPUT)) {
 
-		/* If we're not the initiators request authorization to
-		 * proceed from user space (mgmt_user_confirm with
-		 * confirm_hint set to 1). The exception is if neither
-		 * side had MITM or if the local IO capability is
-		 * NoInputNoOutput, in which case we do auto-accept
+		/* If we're not the initiator of request authorization and the
+		 * local IO capability is not NoInputNoOutput, use JUST_WORKS
+		 * method (mgmt_user_confirm with confirm_hint set to 1).
 		 */
 		if (!test_bit(HCI_CONN_AUTH_PEND, &conn->flags) &&
-		    conn->io_capability != HCI_IO_NO_INPUT_OUTPUT &&
-		    (loc_mitm || rem_mitm)) {
+		    conn->io_capability != HCI_IO_NO_INPUT_OUTPUT) {
 			bt_dev_dbg(hdev, "Confirming auto-accept as acceptor");
 			confirm_hint = 1;
 			goto confirm;


