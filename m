Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF19370805;
	Thu, 13 Feb 2025 15:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460879; cv=none; b=eTv3owQ0hrDfmI4M/evUrgtCcvBiBYIt46qtm7na7EKPWc7w/DiMf2BFxFVRm33jH3bXrDsmx60WUL9joyT1keI++7TRvBLPkpijnhHOffMJeAelemtpeXd6Fvna1mcjQlh1CFkoVMAOZcAlhq7OjKhT0njqnSTdtz9IS5yR7io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460879; c=relaxed/simple;
	bh=iY0DRZaryUaX/Uf71siWhHtPlWHU3P9B/K8ylcwUr+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CE3gPgVe/4BxX8Q8pMzLeaBLZ38kqFm5DTN+A4MQrdjDklrg4mDvrFvbyIqKDtC+JY5WYkwZhUdZ1ngSm44yGcmeOxlQGa5oj3DztZ3MrVYGpi4hPMZbRpd+/o6mJ4QUmmuLqt6aHPW44by/W2xXHd+sAEQba1tLBEFnZd2UbtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsC9bS82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsC9bS82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9ADAC4CED1;
	Thu, 13 Feb 2025 15:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460878;
	bh=iY0DRZaryUaX/Uf71siWhHtPlWHU3P9B/K8ylcwUr+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsC9bS82R7u0h225KQlvRdMi7dXojOPuGKHYbpIum83mRRbb90ll3o8xLy7IftTQ4
	 ueWZVwMs4ymuj8QK4fIaA47APIrGSJW93it1igZ4ExNNrxGrt8xpsa8ThkWCY9mhhS
	 y4mtRtJ4zMX2ic9YsSx6ThKqJsV7arGUW6TaCDgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 237/273] NFC: nci: Add bounds checking in nci_hci_create_pipe()
Date: Thu, 13 Feb 2025 15:30:09 +0100
Message-ID: <20250213142416.799585427@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 110b43ef05342d5a11284cc8b21582b698b4ef1c upstream.

The "pipe" variable is a u8 which comes from the network.  If it's more
than 127, then it results in memory corruption in the caller,
nci_hci_connect_gate().

Cc: stable@vger.kernel.org
Fixes: a1b0b9415817 ("NFC: nci: Create pipe on specific gate in nci_hci_connect_gate")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/bcf5453b-7204-4297-9c20-4d8c7dacf586@stanley.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/nci/hci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -542,6 +542,8 @@ static u8 nci_hci_create_pipe(struct nci
 
 	pr_debug("pipe created=%d\n", pipe);
 
+	if (pipe >= NCI_HCI_MAX_PIPES)
+		pipe = NCI_HCI_INVALID_PIPE;
 	return pipe;
 }
 


