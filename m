Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8238B1DE4CC;
	Tue,  8 Oct 2024 13:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392742; cv=none; b=pWFamNImH4NUofaCmaNkpJUXSTgypvvirXbS6Msz12bm0Uh2OUEPYMYky/Sr1IVA3ZPkceCi8OxkhIqdZc92q4LTHdKl+PQnN3R9GvJzbPg/IEEbhrD8UxjPHT6adsbfgAaWmLwhd+DVXUhTzNxVBV8k4oQ8u01vF1uVyGEx+g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392742; c=relaxed/simple;
	bh=gtNkcNBT7L4uEERw62mHqJqfeUP3SkiduSrBhrxsDrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2SY6EfdetoI/H3/pAiufiZRo6J6PcHHAUikvb3plllF19ornuhlZiv1snGcloSsEZWtwPGiEB15MeAxoBzkxS19cDHvDSjBlN1e1Jutqs0Cz9YfNbVNzyGhiFIgEj7iVtLKuDb/X2fOKCEEomAS0igVEtYdh3cmIC5/pEaf+H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LuxT9oMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LuxT9oMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E513FC4CEC7;
	Tue,  8 Oct 2024 13:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392742;
	bh=gtNkcNBT7L4uEERw62mHqJqfeUP3SkiduSrBhrxsDrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuxT9oMPWSCJSIB8gdFCsLIVMlsSmONlaSE9eZRWksIU0sUmKr1QhE7Fs3Ycitir9
	 5fwVO+QAFN2Ky2nivuK4z7jJtNJC0gyaOu5IhCb1KV3wyzt00ghhY6W/2NPOAiI8z8
	 0vFvQgWoJ3xPaol5Hvasaa5w40eTfkLhgB0xQuIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Kiran K <kiran.k@intel.com>
Subject: [PATCH 6.11 505/558] Bluetooth: hci_event: Align BR/EDR JUST_WORKS paring with LE
Date: Tue,  8 Oct 2024 14:08:55 +0200
Message-ID: <20241008115722.104266341@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


