Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CAD1A072D;
	Tue, 27 Aug 2024 14:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770204; cv=none; b=B7U0hl3EGQNwf2E/A3Pi7YH/Ywt/eipZpqgaCvkDQykI/2hsVoBDNaspKN+hp6tTzOKscrwVUYlTSBLqmNO4Uyw4sk4rcco0BDe/XSG9beIYR2Hh465bL+cyOFvQ1oeD7j8sfX60pqguOIfVe3TNpLEt1i/mNXpeADlLK3PvhZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770204; c=relaxed/simple;
	bh=ZO86yeuV8FHPBdGdb2Glq41NOPt2V0Eif4hcb+k/n5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7YsapeU3aBIv24zkUQdnGTZ2um8gFoPkMXUdIbtXGy+skkROJFH2J8OuhfIQfakykDMwLVuGXZ9tdUIkzFC44ZdtTUC8kQZGrNvFSjfDRmQFBSFbzp584rnYj34m3m49L+0x8PCXxYqSYD4wp4kqOGQANosREK6rtp6wCM6XFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsTEYJoy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsTEYJoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F140C4DDEB;
	Tue, 27 Aug 2024 14:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770204;
	bh=ZO86yeuV8FHPBdGdb2Glq41NOPt2V0Eif4hcb+k/n5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsTEYJoyA7IVStc722/DKkmF9bsvbxO8QW7yn6rkvQrxLBYEvQCez+kGAByf2oJej
	 0Caq1y1hJdLWvDqBZcl/SegrGdNK3cI1XOtGI0NQGRZ3Hf6SKEDiE7EX2tEsyEmYx2
	 zn50hMu2iq7zqbPtTS7gSOm0yxeVs0ibd1oVX3tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	farah kassabri <fkassabri@habana.ai>,
	Oded Gabbay <ogabbay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/341] accel/habanalabs: fix bug in timestamp interrupt handling
Date: Tue, 27 Aug 2024 16:35:48 +0200
Message-ID: <20240827143847.865844688@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: farah kassabri <fkassabri@habana.ai>

[ Upstream commit 0165994c215f321e2d055368f89b424756e340eb ]

There is a potential race between user thread seeking to re-use
a timestamp record with new interrupt id, while this record is still
in the middle of interrupt handling and it is about to be freed.
Imagine the driver set the record in_use to 0 and only then fill the
free_node information. This might lead to unpleasant scenario where
the new registration thread detects the record as free to use, and
change the cq buff address. That will cause the free_node to get
the wrong buffer address to put refcount to.

Signed-off-by: farah kassabri <fkassabri@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/habanalabs/common/irq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/accel/habanalabs/common/irq.c b/drivers/accel/habanalabs/common/irq.c
index b1010d206c2ef..813315cea4a7b 100644
--- a/drivers/accel/habanalabs/common/irq.c
+++ b/drivers/accel/habanalabs/common/irq.c
@@ -271,6 +271,9 @@ static int handle_registration_node(struct hl_device *hdev, struct hl_user_pendi
 	free_node->cq_cb = pend->ts_reg_info.cq_cb;
 	list_add(&free_node->free_objects_node, *free_list);
 
+	/* Mark TS record as free */
+	pend->ts_reg_info.in_use = false;
+
 	return 0;
 }
 
-- 
2.43.0



