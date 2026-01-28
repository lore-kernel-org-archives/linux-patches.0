Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C822D239B;
	Wed, 28 Jan 2026 15:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614502; cv=none; b=oSJcjc9qLBOuPcEdpw+QlqgEZM4MR1Fv+DtNaLRhekyrnlhrSGRZRQmneGm9hwZ0HrKqm2YNsxGMOBWGp/ZG3gK4+We+BSCYcyxuub6jtf9J2wSFcSEHNuZgU1RSGbEM3tQzeYPup7CQmn7YOn/LFFb6NOfzJuzq0fjpw/pIdXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614502; c=relaxed/simple;
	bh=TGyIofuGB1YoTI+BTVialEZeJHRnQz9KWYm8q6AkP1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBlAwqgFZ6Idxc7jGz4txN6F+0aaVxJfirIkskLJh0reM9/DJE7voonRb3BOdasjCIX4BuJRKcj8Y0L5lShzIySBGGnLpOgwHazuaxdCcbF+CB8/M86Xv61e1MKa1pk6cW9zGw3X0g7MYzM9N/HlmZxAXj+3NWTOzritXDrRuaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3nM7oKu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3nM7oKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F3AC4CEF1;
	Wed, 28 Jan 2026 15:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614502;
	bh=TGyIofuGB1YoTI+BTVialEZeJHRnQz9KWYm8q6AkP1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3nM7oKufCqOvKnWyrhJslDKvdpN5hxSHW5lHrfrWh8TuOIuExegQifunbBWya0w2
	 60E1TGA+aFm/N470p7aH0pamR9NkgdlLWNrdhukbuYLJi0FaIeKRBEXUV6iS1Yx0/f
	 nmLb+k268FXG5G/VRJhryLEkyelFM5V9aSobr3sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 139/254] Revert "nfc/nci: Add the inconsistency check between the input data length and count"
Date: Wed, 28 Jan 2026 16:21:55 +0100
Message-ID: <20260128145349.819199427@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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


