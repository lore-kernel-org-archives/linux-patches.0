Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18FF34DCD7;
	Fri, 21 Nov 2025 13:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732904; cv=none; b=c+N1Aw+Kt8Mm4YUYwdWImVcqmgEFqXUo4apcH/wEW1WFKUXkKdPwqB0SW/dkS3IQls4acbR0iIihIm8DkHb/V9SLWiI3YgCU3oUBdKe6XOnVR2PRpyCecUgP5tKrALMa6GQy78kVPAdPLYiJ5t/C5tRHvGYTc6zXuYHEjqotL5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732904; c=relaxed/simple;
	bh=B008eceXsqsJ6oorGoNi8PUQZWVAW7TZOFz/6yZMg10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9KjsbMRgAc8TBMiyXQ1gtVrMkDeI8ot0BK5vGZfnUSkPGjSKXDOhtz5RXRd/S8sB4QFlUIQJW4CCBgcFiTeQz9GfQ3kEbhbKkvvo+a1xrUOCPvj5lZPnC3tAb3bSTMCykyWrc5EYFYmXWHr++taBiVF4lQyUmvByXaatl9vle0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ri6rTz39; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ri6rTz39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20333C4CEF1;
	Fri, 21 Nov 2025 13:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732903;
	bh=B008eceXsqsJ6oorGoNi8PUQZWVAW7TZOFz/6yZMg10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ri6rTz39zlybBvxiGvatHYiOMFLtqqh4cH6YYpGeB7/tuN9cbjCoS04VTxC5PZFjg
	 hDFaU4c3OgwUNlxzMEsP85cu1/Ov4DxpPJ8zWl3GL0dALtImzNEaUJ/MZ5QzRC5diJ
	 /A2mDwMajfXx7jq2Rv0uFw29t/Qj1GYt76fOtI4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomer Tayar <tomer.tayar@intel.com>,
	Koby Elbaz <koby.elbaz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 276/529] accel/habanalabs: return ENOMEM if less than requested pages were pinned
Date: Fri, 21 Nov 2025 14:09:35 +0100
Message-ID: <20251121130240.851672075@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Tomer Tayar <tomer.tayar@intel.com>

[ Upstream commit 9f5067531c9b79318c4e48a933cb2694f53f3de2 ]

EFAULT is currently returned if less than requested user pages are
pinned. This value means a "bad address" which might be confusing to
the user, as the address of the given user memory is not necessarily
"bad".

Modify the return value to ENOMEM, as "out of memory" is more suitable
in this case.

Signed-off-by: Tomer Tayar <tomer.tayar@intel.com>
Reviewed-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/habanalabs/common/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/habanalabs/common/memory.c b/drivers/accel/habanalabs/common/memory.c
index 5b7d9a351133f..33a4246dd7358 100644
--- a/drivers/accel/habanalabs/common/memory.c
+++ b/drivers/accel/habanalabs/common/memory.c
@@ -2323,7 +2323,7 @@ static int get_user_memory(struct hl_device *hdev, u64 addr, u64 size,
 		if (rc < 0)
 			goto destroy_pages;
 		npages = rc;
-		rc = -EFAULT;
+		rc = -ENOMEM;
 		goto put_pages;
 	}
 	userptr->npages = npages;
-- 
2.51.0



