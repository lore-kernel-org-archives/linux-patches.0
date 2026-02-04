Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6736441B367;
	Wed,  4 Feb 2026 14:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216964; cv=none; b=mcPzA4Tf+jW37qR5Qkl5GfkoUltuQ5LmOmwub3Y9rkTfuwVBhdpswSaLbwcFbF9fHwaxArkgK0f+tyeaPIiBSBQddm3+FVMosE+qxwTNKZc5MUzi5SlD9edS0GOli5zW2VCwMA/FAAnNKkdxtQzbMOc4NskAhCkXSX2x9TCongI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216964; c=relaxed/simple;
	bh=mrkTL9L4u7GM48q0HoCshJgXLLUYotWkmhcpnhSJpFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=py0bf5BYT2fbwHBGagxZvw7UN7l1xv6YDcuWxVbXWsC5Ms7mNvhDvVfGR8d4YRifB/NUbocjNmLuUzn4aXWcp2Wk7Gy0ZHWcwMQcc5OZiSs/heE5irPIzNFJVmRWLxUa5BIMK6OgYEpJAVXTgBs7wY3bbJP1NZIBfdX0sPykELY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSgTDIvs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSgTDIvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB55CC4CEF7;
	Wed,  4 Feb 2026 14:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216964;
	bh=mrkTL9L4u7GM48q0HoCshJgXLLUYotWkmhcpnhSJpFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSgTDIvsOqXdCMVcp0A2FUxn7DuFcbyuKKteszccLN4xxzJVOSLwyeb9K398GE4pR
	 o5eA1Q3JQ0tTVLTIofBvFy1JMFbM6OMdQKBtgUhzvomOtTpw5JU31dUQuoXQTAkSgb
	 yXrqArJmZvX2NAJUAGXgCIFKr7MvN8thqzXP6pBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 084/206] Revert "nfc/nci: Add the inconsistency check between the input data length and count"
Date: Wed,  4 Feb 2026 15:38:35 +0100
Message-ID: <20260204143901.236962166@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -121,10 +121,6 @@ static ssize_t virtual_ncidev_write(stru
 		kfree_skb(skb);
 		return -EFAULT;
 	}
-	if (strnlen(skb->data, count) != count) {
-		kfree_skb(skb);
-		return -EINVAL;
-	}
 
 	nci_recv_frame(ndev, skb);
 	return count;


