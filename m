Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1367F1A314B;
	Wed, 19 Feb 2025 09:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957161; cv=none; b=IFG5HEtj+eDc+6bXwzNvN3pJ2K2h2Erp6XfA4AjvotRj2GcihYT5pLGVoWrAA7u0aRiya4Xb8kIQpsq02aTSYB7XvENQFq7Y9MaHavqRZaFF4vdEvLWVVwiBUBH5uKMr8IoCrSep9aS7nDFJAfrbOd549EFs28v9rN1Njk664oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957161; c=relaxed/simple;
	bh=e4LYy1W6x6uqUsxRoGQc2AtsAbfmCsscdaPo8jQeLhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1uxfq82BtYwN+1yPJL1g6t/prUJy1oUNIzZKDTtp5j0pshLfcDn/MiunfXNPpz8kFv1mauosiSUbbieE5TfQFMN3kCJfx3UXRROHMytwDtF3G65o3PbPFi06deM+Aju15ceaXeZQdlV27UZOM/Qh/eje/pKI7nk3AjuMIIKMug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xM+nwQvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xM+nwQvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B790C4CEE6;
	Wed, 19 Feb 2025 09:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957160;
	bh=e4LYy1W6x6uqUsxRoGQc2AtsAbfmCsscdaPo8jQeLhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xM+nwQvyTU5PpY7ijFXzaHBY1co9P1rWL5LwZhGe0IEQLLLBMSE7fnEt/3EUl0iIA
	 SzOnEpzn4SQKxBUbCpvXLKW0MLEX+RvP9Hen3GdqgVkDsZmOzLUxtNl6KLrBVO7RE1
	 p8Oa7OQNErkQSlv87anH6NG3S2zWl9w68yXjDCB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 430/578] NFC: nci: Add bounds checking in nci_hci_create_pipe()
Date: Wed, 19 Feb 2025 09:27:14 +0100
Message-ID: <20250219082709.929703710@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -540,6 +540,8 @@ static u8 nci_hci_create_pipe(struct nci
 
 	pr_debug("pipe created=%d\n", pipe);
 
+	if (pipe >= NCI_HCI_MAX_PIPES)
+		pipe = NCI_HCI_INVALID_PIPE;
 	return pipe;
 }
 


