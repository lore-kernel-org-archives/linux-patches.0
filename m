Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51B247CC8B;
	Sat, 28 Feb 2026 17:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301368; cv=none; b=tbxNM+53KvwS+UWC41HML1RfdUsCSapAeb5pVCs1RaiEy371n+7yz69GybAkL7s70gADdza+VtQTOlDgqIgp6iZPa19vLUHKuBh9ffZ9tjguJ4pCZYliDpg0Oiu1Dt92l0oQlC1ewwlPxZGLoirGJNdAXakNyFlR6JXm/g71Sxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301368; c=relaxed/simple;
	bh=BmJESorZCNmwmXWKrpPOWGyF/Oq8LKKDxOzvYAgVGpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bg2YujyGL2m2KKGbjMaXZ+ioOg0J30F4fQtU/FmESQ/lf32Ow0tPMRhrXw4hksAjWqPkok+qpKlsn/JHK0AzrHKwaqkdqYl4h7Gw+fpADBfLMuixptG3+kDepK3XDX+NdfRa04nJT9UySgm4u9MgBsQ8f/ctskixcIyHby1Uoos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P4XrX9jc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4XrX9jc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09396C19424;
	Sat, 28 Feb 2026 17:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301367;
	bh=BmJESorZCNmwmXWKrpPOWGyF/Oq8LKKDxOzvYAgVGpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4XrX9jc3RHGqS5nk8Og6ELEr14G1t8eNm7ZD2XZ+u//s+RIC0QoThEpyUNYsoxVi
	 A3J1nWq76hzEkryqetX+LUBJi15DCBzWOab+YAWec0CcP1DJrtdHf8itt5iV6BCxXQ
	 lgS4AqQeoa6w6iUF1L/GThmlK7mYKL7Jqf/ra3CtR8MPWgjTDg9OxgKvYqKFl3DVhC
	 4wEWb68XWFP2Z8iX/7PEGGqoVFgHUx8FVEmTLUXf9nfJ6BTB4HHXSmjUq11SElEccA
	 iTkqPY9MSwyMPlacQTclwkajHQfXFTVHpXWHJrWFtcZBx7RfmTmh9Y8fmY9Sx6AMqo
	 ZuiOC+mPnUfSw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Joonwon Kang <joonwonkang@google.com>,
	stable@vger.kernel.org,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 556/752] mailbox: Prevent out-of-bounds access in fw_mbox_index_xlate()
Date: Sat, 28 Feb 2026 12:44:27 -0500
Message-ID: <20260228174750.1542406-556-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Joonwon Kang <joonwonkang@google.com>

[ Upstream commit fcd7f96c783626c07ee3ed75fa3739a8a2052310 ]

Although it is guided that `#mbox-cells` must be at least 1, there are
many instances of `#mbox-cells = <0>;` in the device tree. If that is
the case and the corresponding mailbox controller does not provide
`fw_xlate` and of_xlate` function pointers, `fw_mbox_index_xlate()` will
be used by default and out-of-bounds accesses could occur due to lack of
bounds check in that function.

Cc: stable@vger.kernel.org
Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 2acc6ec229a45..617ba505691d3 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -489,12 +489,10 @@ EXPORT_SYMBOL_GPL(mbox_free_channel);
 static struct mbox_chan *fw_mbox_index_xlate(struct mbox_controller *mbox,
 					     const struct fwnode_reference_args *sp)
 {
-	int ind = sp->args[0];
-
-	if (ind >= mbox->num_chans)
+	if (sp->nargs < 1 || sp->args[0] >= mbox->num_chans)
 		return ERR_PTR(-EINVAL);
 
-	return &mbox->chans[ind];
+	return &mbox->chans[sp->args[0]];
 }
 
 /**
-- 
2.51.0

