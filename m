Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A336D3B19B9;
	Sat, 17 Oct 2026 17:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256503; cv=none; b=qSFKRi593B1HXvUzsP6yNcjkjt4gk8AN5om5qTjay4vDJD5Jbv5/Udi82DonK1UD+NZWGg2NP1lUQVta/z/KIvejDIGmdDSrf/3zVIWN44I+Rp5Gus0/f4tHTjfYLdeD8qUf1bYpMdxVW/zw5uirjU5P2eaj7qT5yDudXMP+wko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256503; c=relaxed/simple;
	bh=tlSDodJUlTHz9N/yA89Gu878YceUkIg/5CEAPkuaDlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhPlhSzoSxYYbZgKLKb4TsOtJCXfV4beNWm6feFpc6WmIBTF9LoLRflHHsEleSsfCme1UckpDnlP6pNIa2n7H2gALRriuHFQP/Mgu8K5BBrDbyzmO2a5LiO0O+Ilz2MFbpVHuPR+7K0Ugp6jjiVqrglapgWtvGuud6kPI61Xu88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nIJ5lu6u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nIJ5lu6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B537F1F000C4;
	Sat, 17 Oct 2026 17:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256502;
	bh=iDW1PmXulX1X2/SxTuv5YE1HFnV1wANyh9vLjRxoi38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nIJ5lu6u8oZXQMBDidmufoq0CCbLxX6joOQg3rcL0tDGaFxzECbn1G8LtFV7XDSHz
	 GrIVvHzySy5PD4qw0MPOfWT8wHLsnQfpnJltLuSdVbOBSjVtjJOykAnPn0m5t23quq
	 +LzxB75DFum+BVA+pDslU+vO7fBfvkOfU364tbMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0204/1674] Bluetooth: hci_core: free the HCI ID if naming fails
Date: Sat, 17 Oct 2026 17:41:16 +0200
Message-ID: <20261017160436.386259670@linuxfoundation.org>
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

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit d1ac915fb4184faad1b62148be50f317de7c24b5 ]

hci_register_dev() allocates an ID before calling dev_set_name().
If naming fails, it returns without releasing that ID. The device has
not been registered and hdev->id has not been assigned, so the normal
unregister path cannot release it.

Free the allocated ID before returning the naming error.

Fixes: dcda165706b9 ("Bluetooth: hci_core: Fix build warnings")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Assisted-by: LLM
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Reported-by: Changyul Lee <lcy8047@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index efc23bed5b9fe..5556bed18c9f6 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2587,8 +2587,10 @@ int hci_register_dev(struct hci_dev *hdev)
 		return id;
 
 	error = dev_set_name(&hdev->dev, "hci%u", id);
-	if (error)
+	if (error) {
+		ida_free(&hci_index_ida, id);
 		return error;
+	}
 
 	hdev->name = dev_name(&hdev->dev);
 	hdev->id = id;
-- 
2.53.0



