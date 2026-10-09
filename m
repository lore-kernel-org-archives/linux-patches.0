Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533064DEC34;
	Fri,  9 Oct 2026 14:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556437; cv=none; b=KjjCqar3RkkJHFlgjzPwTnUzpGf/RnHN8sErINVG8OQ96nn0/6sgBmIXqlY6QNOYgsbBqPZ2sr5e2P/PTPsR5+Fmy1pBREQBmAo6XAbs+YflSsDzl3eX6i6THD9zEB0b1bMfaTpw36zXoPYRC3t6aHbS8O6xoTHKoGOT2PsqpVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556437; c=relaxed/simple;
	bh=aPri4u0Q26QUNrIOSm+hfgxQIA3QOak9BUXYoOcIUHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlQb4HWyOF47PRvEjMKhStzUUYW94cnoM1DBrk3zpsBOfn9Og5yfbskTBesgMFASmip6VJHQ50AFK8nnTWk7BpjuJofE8a2X1S6yeYO4G6SEz4q/OjDBNSx3a6vPzJhpfsQGQnu49TsJxHSkvUzW5dFVyjKX8KH1Ir6lND97Kqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=snKbOErA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="snKbOErA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFAA1F000FF;
	Fri,  9 Oct 2026 14:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556436;
	bh=a6fqGtZryKydNHYHTTPXyR1UiyXpebWjCWNuMM/NfgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=snKbOErA3OIHmRmI28ULFe/sYAS9q/Jwua9JdG7M34ToBxhadImrFpLR6LgHmT/PV
	 qMAv3sjrhcGJ6uBhj0MNJn8VXVZL2hfUpyZFVlRhAllbtFkdxdpwyppsWnPn4RbTn2
	 f/5j3F28HIPpZQg4onSv66oWq5wfcFiHik4pdFRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 233/403] Bluetooth: btintel: fix buffer over-read in btintel_hw_error()
Date: Fri,  9 Oct 2026 16:09:54 +0200
Message-ID: <20261009140957.606445539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -274,7 +274,8 @@ void btintel_hw_error(struct hci_dev *hd
 		goto unlock;
 	}
 
-	bt_dev_err(hdev, "Exception info %s", (char *)(skb->data + 1));
+	bt_dev_err(hdev, "Exception info %.*s", (int)(skb->len - 1),
+		   (char *)(skb->data + 1));
 
 	kfree_skb(skb);
 


