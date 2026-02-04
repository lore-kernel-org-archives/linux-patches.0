Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0181741C2ED;
	Wed,  4 Feb 2026 15:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217793; cv=none; b=SdLwQ9dsgNCqnleqDenaGooRXQ28Ve6PgzqhX6GbOaXi1DH5V8bVqAH8dzRTEjMEWHib0VXvYcgm6E1UcGmQISpyBBt2U/Y9SJWEqCumff3BTu4YLD7VJt7orkati5wbLMOKSiRoPkOCUlHA0uVWmZ5PY5pAwf9CTnAd49eC/ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217793; c=relaxed/simple;
	bh=QNKITXtv52Lof4M3NqfjR0+vta00bbkYPIKj3GX3BwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQfX+cXyD+mUg2lDmdKjolDgNFOKm01AAXIG5qiYQm5P+ozCdTNKjKpXEC+JZ73RHiMUrqTmgCLerUoDp80zhxUJKlYeLSgX70B4fcpXfTrriSQqp4szE/V2dhL7nAQKNB8ameg88Jz0vG0GLyZtTduNP7YWI6UCjdsjHuOkh/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lynb4GAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lynb4GAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B953C4CEF7;
	Wed,  4 Feb 2026 15:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217792;
	bh=QNKITXtv52Lof4M3NqfjR0+vta00bbkYPIKj3GX3BwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lynb4GAqZU+91CEQ5W00mXFM7HXmqQxDx8JHXfyATB/5gkUQOVPbVBiaXyAOg7HAW
	 Q4IaLDEmB/5JE/wSuLzs9gc+M8fBAd5DS513fE8rWGVAYh9KZBcKAzP9XVTx6b8xo9
	 L2tO/j8R1SW2wswvBjOZNxEkZtyqBmftwMLtbVBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 119/280] Revert "nfc/nci: Add the inconsistency check between the input data length and count"
Date: Wed,  4 Feb 2026 15:38:13 +0100
Message-ID: <20260204143913.921131194@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


