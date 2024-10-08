Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2741DEFF6;
	Tue,  8 Oct 2024 13:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393991; cv=none; b=g7dBb3AdTHUuQ772ggc3XeWIc5zXdhICdFw08YORF0BCQ7uu0Q4P5q08GSPThF/X+AesaCXInmmFohmEEluRPOw91jBVh11ZaIy0K3Agtr/pzxb88yJj6U3oPUO6Qq6xZcP+5MqlYzhgGZiqi/oIwW75uZEctT6MJ/XimLnFzT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393991; c=relaxed/simple;
	bh=Uo2gqnv4ZxlEHTh3jICsAxZJkIooQ5bLe8ENvWIxnjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/Hk+COT4el74W8ERLEfp/iFlJQIO5WkxjHBoUpQW+G/gVB6QG1+pKYDkGNjN/UWYRfeYrY2R4z5sTGAG0QHjrO28myqSbkczCSsl+zqr+LvOj3EUNWN+DRck0GBPsSUjPeuZXeB910Eyyu7UYirRysI4kuzqnEtNw+LzyZLq3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGbHDSAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGbHDSAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20232C4CEC7;
	Tue,  8 Oct 2024 13:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393991;
	bh=Uo2gqnv4ZxlEHTh3jICsAxZJkIooQ5bLe8ENvWIxnjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hGbHDSAEutv/6DXi77DmpnBsHXoMyPGFBsfa8cbKhk8oeG2DRjrOcDQRlrzFwrK4K
	 SSgGB3nPQaQoviJq2ARXqJgNXmc/6eJ8Yc61xbbbyprDjeIPA6653IQFh7iqA8BhpD
	 p8CsmWCDQOacuWKG7hoJ5pjis0G8zPfJmBGAnYvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Kiran K <kiran.k@intel.com>
Subject: [PATCH 6.6 314/386] Bluetooth: hci_event: Align BR/EDR JUST_WORKS paring with LE
Date: Tue,  8 Oct 2024 14:09:19 +0200
Message-ID: <20241008115641.742006796@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
@@ -5324,19 +5324,16 @@ static void hci_user_confirm_request_evt
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


