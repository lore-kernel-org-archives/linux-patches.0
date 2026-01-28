Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7CC30F52F;
	Wed, 28 Jan 2026 15:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615591; cv=none; b=a2UHZ9sJUaAdx4vefUXZ/NzmySFiZCWRXZRg5GPi4aRJjP912s58WlxLKY5L5ai1k6t+W7oIgtRKMZNkLZIf1or03eh4B7NptSqScw8s/NXgcDwMo06dWnibwWMtXGz9//FCRWZ6yvW3IHn4+Z6odixLoVu0SBo/JDWGm9qnwBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615591; c=relaxed/simple;
	bh=k8cXxeLTgrKjJvT9ZvnlwIZy7lYp7oXuv8gBRLmvksg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMYO6QMauRCFBCTVDkK08IOP+FkMlFBy3TJSasBf3do6oVyH6XGxPP59+ctNQJuzyHTc/QyjpDRZqmMN62/fPe3HjwpIr6GDmESB4ERPvzhV9kZMnXCsqjSA/qE/SgzYDFkl4Ijlw42woi/jh0hw5zH1+j3pZKvzhL8PDQ4B7/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gO7oaCPt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gO7oaCPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2BDC4CEF7;
	Wed, 28 Jan 2026 15:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615591;
	bh=k8cXxeLTgrKjJvT9ZvnlwIZy7lYp7oXuv8gBRLmvksg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gO7oaCPtG9ziKv5bHGnTwwiprbMO8HJ+MBr0WYYyVYPiv2P0yv+KndEuli4o4X1Vx
	 xYQmLmMwJkmd9VpE8NfSgXFmvOfO5FxCPzQBfdM0hO/Q3H5PzX+mMBTBqrXRpROktO
	 Od3pOXuZjYs3CDz7xmcUZbfEtWUe6KMuVSTJ1MWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 054/227] Revert "nfc/nci: Add the inconsistency check between the input data length and count"
Date: Wed, 28 Jan 2026 16:21:39 +0100
Message-ID: <20260128145346.286627591@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

commit f40ddcc0c0ca1a0122a7f4440b429f97d5832bdf upstream.

This reverts commit 068648aab72c9ba7b0597354ef4d81ffaac7b979.

NFC packets may have NUL-bytes. Checking for string length is not a correct
assumption here. As long as there is a check for the length copied from
copy_from_user, all should be fine.

The fix only prevented the syzbot reproducer from triggering the bug
because the packet is not enqueued anymore and the code that triggers the
bug is not exercised.

The fix even broke
testing/selftests/nci/nci_dev, making all tests there fail. After the
revert, 6 out of 8 tests pass.

Fixes: 068648aab72c ("nfc/nci: Add the inconsistency check between the input data length and count")
Cc: stable@vger.kernel.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://patch.msgid.link/20260113202458.449455-1-cascardo@igalia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/virtual_ncidev.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/nfc/virtual_ncidev.c
+++ b/drivers/nfc/virtual_ncidev.c
@@ -125,10 +125,6 @@ static ssize_t virtual_ncidev_write(stru
 		kfree_skb(skb);
 		return -EFAULT;
 	}
-	if (strnlen(skb->data, count) != count) {
-		kfree_skb(skb);
-		return -EINVAL;
-	}
 
 	nci_recv_frame(vdev->ndev, skb);
 	return count;


