Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD45E3B531D;
	Sat, 17 Oct 2026 17:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256758; cv=none; b=ZUuUFjSpsLFJ2SZhr6k1+4KDrSnNAkxBrWWQtlljlROCL4umpFN1U+i9upDAZn7lv8SFLoEYrx8S4vxoouOowP/H5GbpFOLA1XXTz/0V474ul7sCpfaNRiCBYjdIdQQdcn8hs/9bqvjBJJSX5C1sgIB9wSrxcqSEDP+oaInlhek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256758; c=relaxed/simple;
	bh=PaxFiMW4/KMSWRTPHZKKPyF8reemj9Torh5+a9kjL1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdYMTDPvZjTnHaPGZ1dgFLizx036a5PSyMAzuNRep5tU+Nr30yBjmTH0MIo5XK6l3fvOa1b1c/Hde1ymk0I+GF9v/UWkBT8ENdZYUTXXQYvL6J5KwbIYosPYkR/zncJ+uOWN8jPCrA8l2PP+nD8yiAQfp0MO0VzQL8TiW4LhN/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjkm/NYJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjkm/NYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AF01F000C4;
	Sat, 17 Oct 2026 17:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256757;
	bh=wAipyC0auOCHM/u16vepcHpsxz6e9zQK7KcBbz/40j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vjkm/NYJ7NXmD2p01H2uP+2ukjAV+a8OQH4JP6Q7YJ9e+/azrp31fDgUuMKR2Xy8l
	 gbOtGaq8RgDKIOWfVfCp8Cab741gkq0iC8OdRS4plvk4XU3fJtyCxCP7U3Xw1qBu8h
	 aKIJKURcBjYMAcXNz0zz6K94ebG3Z+zau9Y9UqhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 0300/1674] Bluetooth: btintel: fix buffer over-read in btintel_hw_error()
Date: Sat, 17 Oct 2026 17:42:52 +0200
Message-ID: <20261017160438.820964792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -265,7 +265,8 @@ void btintel_hw_error(struct hci_dev *hd
 		goto unlock;
 	}
 
-	bt_dev_err(hdev, "Exception info %s", (char *)(skb->data + 1));
+	bt_dev_err(hdev, "Exception info %.*s", (int)(skb->len - 1),
+		   (char *)(skb->data + 1));
 
 	kfree_skb(skb);
 


