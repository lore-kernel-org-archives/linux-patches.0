Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43804C97;
	Tue, 11 Nov 2025 00:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822240; cv=none; b=m1k4F3n+NN2rS5Y4h9igVfM6qwQyPDIt4yZ5O3Ko8tZeW5Y2fWHFR4YnwGy5ZqCqzXoOHTMTPsnoprFWKMO0hvoqJvKElY6wKld4xSx/HYx0g4EuFtGf4aBgN9xeYBJxpwc6T4APBFBRLgVFVMI7lvuuf+X8AUNEVad0+tHXuSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822240; c=relaxed/simple;
	bh=hyZGk0YPHWE5UnsKqwhRi0+fDhk3ptQBvA0pe9Vw19U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdgGbkYMWqKPS9dGnGt66IP18fv10N+vC/VmFMXU5ew3FtXNV7v3VbPs+EcWUCmGTNcAFyi52VlMhxv6P7wufDndPXMMX3NMPTaQbE9qX5KNFCui+BG4cMN3rrCMA8Pj1/xvjA5NC4gif+7njYi4+xPqntFkTS+wWJxdAh5+5qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUU1+Xny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUU1+Xny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF46C113D0;
	Tue, 11 Nov 2025 00:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822240;
	bh=hyZGk0YPHWE5UnsKqwhRi0+fDhk3ptQBvA0pe9Vw19U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xUU1+XnyQ1StpYLgib98y90VYhk4p7cr729m6SXC6MIuTtYqOIsILmkaohiaRZGCw
	 8lu+KPZL+TQz4HowYJvipUY29LH6aFfJ7edtLI1RDen+5FKORAWrhHH+D09VDRX4iK
	 09Yb+DnRkKOVh6yEqktkBwmcvIHwKLmmfFqHjCnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 064/849] Bluetooth: hci_conn: Fix connection cleanup with BIG with 2 or more BIS
Date: Tue, 11 Nov 2025 09:33:54 +0900
Message-ID: <20251111004537.979640286@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 857eb0fabc389be5159e0e17d84bc122614b5b98 ]

This fixes bis_cleanup not considering connections in BT_OPEN state
before attempting to remove the BIG causing the following error:

btproxy[20110]: < HCI Command: LE Terminate Broadcast Isochronous Group (0x08|0x006a) plen 2
        BIG Handle: 0x01
        Reason: Connection Terminated By Local Host (0x16)
> HCI Event: Command Status (0x0f) plen 4
      LE Terminate Broadcast Isochronous Group (0x08|0x006a) ncmd 1
        Status: Unknown Advertising Identifier (0x42)

Fixes: fa224d0c094a ("Bluetooth: ISO: Reassociate a socket with an active BIS")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index e524bb59bff23..63ae62fe20bbc 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -843,6 +843,13 @@ static void bis_cleanup(struct hci_conn *conn)
 		if (bis)
 			return;
 
+		bis = hci_conn_hash_lookup_big_state(hdev,
+						     conn->iso_qos.bcast.big,
+						     BT_OPEN,
+						     HCI_ROLE_MASTER);
+		if (bis)
+			return;
+
 		hci_le_terminate_big(hdev, conn);
 	} else {
 		hci_le_big_terminate(hdev, conn->iso_qos.bcast.big,
-- 
2.51.0



