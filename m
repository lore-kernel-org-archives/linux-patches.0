Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2D217C;
	Sun,  1 Sep 2024 17:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210338; cv=none; b=QEPNEeVdrI6Oym1BfKgMd3Sb2KWNMwO+vhTlPtijelF7D8uEKgD03XpQpY3zCSPWxB6HRr02grSaF0oRJVLnQFccAt1hJeA5eQmED9u0YDBRV6B6x/uzALQQgUPpRr2ZA8JI1RFK1qO/RC3t1nYizLI6sNurRoNwgzbmI+To7bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210338; c=relaxed/simple;
	bh=YiykOJNJUH4/E2sVDPxKEACenpbnzmSrYrg5uDWbRM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFRcjZ11A0SOeQlTeq9ocQcH29UXobfzqmFpBzZsR6/I/TKOjzLGwp67sx5NztUUvFJHg71cIiEoLOL3EiVgavVASJxLSU7HKDls1tgYA7DvCkUyoEIMJeW/hQz9pV8eA7nXfoENf+DzMIwCZgy/Oz3JKxfbhhl0n2j1PNG6rGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zaYWMI3s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zaYWMI3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF575C4CEC3;
	Sun,  1 Sep 2024 17:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210338;
	bh=YiykOJNJUH4/E2sVDPxKEACenpbnzmSrYrg5uDWbRM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zaYWMI3skfPfXN/ov0z9pcQWmWUYFzFh90TzSNN08b9cKpVrOpi086Fhxp4Gq+/4e
	 VcKd8ifgOWO898pG1+OXVY7ZrbDB8vpNSsHElAzodRve+WHkU/eLIODqjK6fadmM9V
	 jcvocGfcSiqaon+xuT9zgQ3OG0o/Ou9kRycnLt3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Yiwei Zhang <zhan4630@purdue.edu>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 159/215] Bluetooth: MGMT: Add error handling to pair_device()
Date: Sun,  1 Sep 2024 18:17:51 +0200
Message-ID: <20240901160829.371687623@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2967,6 +2967,10 @@ static int pair_device(struct sock *sk,
 		 * will be kept and this function does nothing.
 		 */
 		p = hci_conn_params_add(hdev, &cp->addr.bdaddr, addr_type);
+		if (!p) {
+			err = -EIO;
+			goto unlock;
+		}
 
 		if (p->auto_connect == HCI_AUTO_CONN_EXPLICIT)
 			p->auto_connect = HCI_AUTO_CONN_DISABLED;


