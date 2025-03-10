Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E827231CB0;
	Mon, 10 Mar 2025 18:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629609; cv=none; b=X50TUjHvZLfFZ7h6IFtrpbkj0my+HtU/e7tidVeo97fY2UmdBNls3fDXZCXai0EBoyhUIp11E1UPqzXg3QVbKB2bf4jfuOPgxIMVK//UjqM7BAiMKrnKg9/LDQvn440JwsRvFeXVJl7U9qtGgV5Wucg74Lo2e5uuKOTETUhVXrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629609; c=relaxed/simple;
	bh=nYKoN8VOakXha/SxwaoWGjpQEJyXnF/bgaduaaMRZTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUp9a3muah453GeZdT6gLj1lM/u3IWrJjrPmRp5zYIsMwrT7a7uG7z5AwQlOLMY8ZUI1x0fe6CwExoPIMuxRp6Bj6JTc95TzKaPDT0B+52K1TdbYDFiT6wwtSjRQNmfwbnHW0M/odHH+yahzkKcCv+p4Vs7VkBAfiaHfDJZCKH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GiQOiv6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GiQOiv6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA94DC4CEE5;
	Mon, 10 Mar 2025 18:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629609;
	bh=nYKoN8VOakXha/SxwaoWGjpQEJyXnF/bgaduaaMRZTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GiQOiv6BjfvPPWCFHDTNyIWpyayBeL79kdtVUxtRchXpA0boIgW+RwHz5lIFhJICG
	 MT2J5/Xa2zAXwUwi2frm2AspgC/cbpfNh0EeVqTADrycYGt4D6cb0nARvqXd09DQUI
	 HyZCA190Efw5RdH5BsN4W/B99MN09d4Tfz5Yxwno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 322/620] NFC: nci: Add bounds checking in nci_hci_create_pipe()
Date: Mon, 10 Mar 2025 18:02:48 +0100
Message-ID: <20250310170558.319209839@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


