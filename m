Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CEE4E3ECE;
	Fri,  9 Oct 2026 14:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557065; cv=none; b=o9/3ijxgX6V4a3Le+HQImINmB8Q96yKsruEFI9UxzHhLttkPxWKhdtDHGJFHB0ywkju9uNJ443RbBifHkwNW7Gw33StcudRXnhL+Cj8/O0ifP4PHe7RQ6HHMWUafUvEfvoQ31vXj2l5Qfk9pdu25RTWWYfZgP+1bijERApvpHW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557065; c=relaxed/simple;
	bh=GSun0pxZ0ghCXqo27l5JhH+STHNsX11P/hs9ueonufk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7yAbi9PD10SSBYv40Oov3eirCbCPkS8uO2UdUuD0A3bJeMYARwhcT9+1uGFJBZjcTnVBi1Jj6GrKRBT9WQVm3MjFv7smjufBBCG/ADTWeKCn+YOTrsfwaQS+DFS3C4evnhhA4fxJ0YazlxV1KlXlVxP2kaByvfmCSBCVABud2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqVfY/9h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqVfY/9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDF81F00893;
	Fri,  9 Oct 2026 14:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557064;
	bh=G6YVWtKTjagsB9KTBcklW+4tNx+Upob8Ov+sRl1OGzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nqVfY/9hXis9kQJf1qfKv1B+eVOgPh+WtFfR43dLVpJz8xdQcJCq/a2TSCB9J3yhB
	 0lmX+hvKnICcadR/SfPmeSid5YDUXflKHRAch0xH86HRc8fMqal9OhakPf5hOg7GYN
	 kzZXuA4kFTGzw1nsRDGNzjmOHug3FqUT7GXnjwYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.2 290/428] Bluetooth: btintel: fix buffer over-read in btintel_hw_error()
Date: Fri,  9 Oct 2026 16:10:27 +0200
Message-ID: <20261009140952.476889471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

commit 40eb4b18ad167b63644c27fa67a7400ba050379a upstream.

The "Exception info %s" print uses skb->data + 1, but the 12-byte
payload is not guaranteed to be NUL-terminated and can be read past
its end.

Bound the print with "%.*s" and skb->len - 1.

Fixes: 973bb97e5aee ("Bluetooth: btintel: Add generic function for handling hardware errors")
Cc: stable@vger.kernel.org
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -288,7 +288,8 @@ void btintel_hw_error(struct hci_dev *hd
 		goto unlock;
 	}
 
-	bt_dev_err(hdev, "Exception info %s", (char *)(skb->data + 1));
+	bt_dev_err(hdev, "Exception info %.*s", (int)(skb->len - 1),
+		   (char *)(skb->data + 1));
 
 	kfree_skb(skb);
 


