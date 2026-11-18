Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020266;
	b=PA08EuhKKKK24OMkoQ/ueEUl30jAXB+jfGGp98hDsHJEC05Ba4EnUZ7EEq6trwyAa68U
	 B8XZ/RQTZ3I/2bG9j/n6iKOiuZdtjZbszIgGEmPoVnSVxB+DkNdGYyoOS5m+8EFFoo0Wg
	 X6tGfKsjxAocGD0ika/fWK7nDvkTDAS7Trp1cm+/0QkrPhVdwvrftqs+X1+076yETWqYi
	 sqw7ybRhaAcAlewhRhXlBw3X7aVFt6NDfwmgq+nUfwlDUTphay3rDqYvPyI6IjbQYyajh
	 mwUWE+PIro09TCILdXQC3X2PFloSgb8FBk1gOOHyA4belG3uKMPb8gVjfy/uz0KytTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b3L8Mm3lH+WltNzEheGekfy9GmOLI8ts6rnkXgy6dKU=;
	b=p2b0XmGGuAGQry+Qvg+UM+tgUwODivPi6QSQcUe7MX39dyy/AQprHRCuOU3wphhrVjUD
	 XwVs7bx6Ldd52ByEi6Y/ZtB8T/292CpQ/g1TTct1Ulj/yhYvp7btxuEj3J9eYZDLFvPCx
	 1R4OgdlAlDZeNMc/6jTuOUs6MPzIqUEN4gLSmDeQ2mE5lPoBAJGU4sz/1+9Sh0hspP8nR
	 9e+mumQXPcGQ85CFNa1WSn2TkZKGS/FlC0A+ByldCwTM7fpigU7Yc27CGy0T+mDhS5Tv2
	 r6F8iQT7jq3sIrxwCfScgO3QqYqOUyhkxbGJsAFWSBD501XQswcW/tAORa8BJPcQb5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0hcRmgvj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A623606A320;
	Wed, 18 Nov 2026 16:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0hcRmgvj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6F71F000C8;
	Wed, 18 Nov 2026 16:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020266;
	bh=b3L8Mm3lH+WltNzEheGekfy9GmOLI8ts6rnkXgy6dKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0hcRmgvj8Mn7u5bJ4fJ06Pg8ymqgCGswDXl/T+4nWjFAjedrF2Tx1avM6g93tmGJF
	 XGZ0NUWFK+VGr9m9hDBfcmT5xJnB9g7KHm0FAXdx7OmVmLtPd8E55JPDNScuFxZHDI
	 dr68mzbQEZPbPuvP8B+CFGi7dQ60m3w+YjBUWtZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1891/2651] Bluetooth: MGMT: Fix pending state of instances added without HCI traffic
Date: Wed, 18 Nov 2026 15:52:11 +0100
Message-ID: <20261118150354.959822867@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 5548fb51aa3cc24545029a286882d261a8e77d8a ]

When Add Advertising completes without HCI communication, e.g. when the
device is not powered or the instance is overridden by Global
Advertising, the instance is left marked as pending, so a subsequent
failure in add_adv_complete would remove it despite it having been
successfully added.

Fix this by clearing the pending state before completing the command.

Fixes: fffd38bca51c ("Bluetooth: mgmt/hci_core: multi-adv for add_advertising*()")
Assisted-by: OpenCode:claude-opus-5.5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index c669c80d74bfb..492b86f39bdf9 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -9160,6 +9160,12 @@ static int add_advertising(struct sock *sk, struct hci_dev *hdev,
 	if (!hdev_is_powered(hdev) ||
 	    adv_overridden_by_global(hdev, adv) ||
 	    !schedule_instance) {
+		/* Instance has been accepted so it shall no longer be
+		 * considered pending, otherwise a later failure in
+		 * add_adv_complete would remove it.
+		 */
+		adv->pending = false;
+
 		rp.instance = cp->instance;
 		err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_ADD_ADVERTISING,
 					MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
-- 
2.53.0



