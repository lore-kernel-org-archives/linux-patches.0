Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B44344D91;
	Tue, 13 Oct 2026 12:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895307; cv=none; b=dPlwXO1sBOJgVdu0lChN+aJozamve5m3MR1lVOQVCFBhYuucvOQWVL+nFQThQ21/P2XLA1kh71T3Bp6ZiBw2Ajm0C611+r8eo1RQX1kxW6F9MLDVjk/Pv0Yd5bO4W8DmynLi0utJh/z385UljIRrnfC+ltJy1o5XI86J2vPGLQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895307; c=relaxed/simple;
	bh=ayojqCKMEvJP7DCM70oDBt07Nz8DLVhliRNoRy+rL6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvt1bQdauVb+FaPz51QsdATHZ5yNv7CLCaj+dtyHk1Ju5jEFyUvdlCgKoKyWnS7FkNUraY06f3uyaN9eoYKSuM/X5R33qMtvb1sIEwlKmKDqBPaRCNHzMtfvFsB8dKCAwWf5glMa2xvx8yqH9M+orSaSMyyPq9dp+3x8Hpkj4T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6IX/Ud5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6IX/Ud5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE5B1F000FF;
	Tue, 13 Oct 2026 12:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895306;
	bh=vZ71lg/iT0dKw8PiRrfxBASwmUVEVRlaPfzqzT4Qb14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A6IX/Ud5d0EJ5MJR6bPEH0cN/f+bgajNuxQburm9UVGsEAQv3wZfDq727/GePD8EG
	 qG3u9Enj+Z4YkyI9nURTtoDLQJ7txcto/mtQ9XxXuk0qOcQOj/AjqjVAyofYuVq7aH
	 eFVALS3SaOWuSW14qjs31soOjm8hBy+soscVWG3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 186/497] Bluetooth: btintel: fix buffer over-read in btintel_hw_error()
Date: Tue, 13 Oct 2026 13:35:53 +0200
Message-ID: <20261013112912.303597863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -268,7 +268,8 @@ void btintel_hw_error(struct hci_dev *hd
 		goto unlock;
 	}
 
-	bt_dev_err(hdev, "Exception info %s", (char *)(skb->data + 1));
+	bt_dev_err(hdev, "Exception info %.*s", (int)(skb->len - 1),
+		   (char *)(skb->data + 1));
 
 	kfree_skb(skb);
 


