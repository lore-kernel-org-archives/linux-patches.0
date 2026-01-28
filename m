Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09841E1DFC;
	Wed, 28 Jan 2026 15:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615085; cv=none; b=qzCVK8E5Qc190S0lUN+4191arB1H5B8OLVq2iexRwIS1nFFc9yZxB6mppvrvqleHiMhU2B6hyUIe57xj29lsmWONCXpMKJ50mIKj37GbPtz30k4tcqtdHDzjnL9G5NFqiMcDTTnxaqq5E8hCDtC97xo3NvCG1h6iE0cOahS5gSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615085; c=relaxed/simple;
	bh=CzMoGqclZOeEPrNBRWJ2c4pU0rxhc45XRk7AMDDgPvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDQwpMDKb7dqOJ6RiZf4F/egKMyn/2MxiyNVCCV11oDKK6eYfZOKZ2I8+dI/bifwQ29lrWodOHWlp5tFlyjWJaBhiSRHLr+9YgJaU3s2mnc6omRMlQymjKNM7DZpKmLYYq2ZK1t1MDPl9YDh1B530i+5GsEwj5HAjigzziSSJEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tfjq8Cp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tfjq8Cp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A47C4CEF1;
	Wed, 28 Jan 2026 15:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615085;
	bh=CzMoGqclZOeEPrNBRWJ2c4pU0rxhc45XRk7AMDDgPvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tfjq8Cp31YpCeBA+0vYt2cTW/f4VwCN+cF5SfzKbOndF5cgCCpnJGl1XV7NSdxWoP
	 G2pi0LzHK5lFcu8VP3HkpM3zTmmpjnJ8EZgofEWBaZkitl7XJ8xU4g6mB6dTTvM+gY
	 4m9AccXOLz+gwQTlEYnOvMzIVdsmWkmcHvFDOMgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 047/169] Revert "nfc/nci: Add the inconsistency check between the input data length and count"
Date: Wed, 28 Jan 2026 16:22:10 +0100
Message-ID: <20260128145335.710801455@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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


