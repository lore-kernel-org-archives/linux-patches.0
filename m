Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAF936826E;
	Wed, 30 Sep 2026 19:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796358; cv=none; b=E6s8LICOVqmiqj2wflU+lCjPRYFopi7zmHXPJ5SfZMMX6G2wd9FzrEBQaQ6gbH4FABBTbGFaZOExgZbbr1qj5nVsHep1gIdFTmeATjNqj9JIkwXB34jFqEDxLA/wFH+GBVqj/SiaYWtwDLPsAYnrNRUIZMswLUXNWg7M8C21Mk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796358; c=relaxed/simple;
	bh=qhV8Vjq/8Ya0lUkv5yHdNQamqkVCcIMgrrarQLCcSL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/S4TGqDZ2uD+u6dN1tDMnxdV23XEwu4Sc+NMPtHmoaQ8xeASLR03Az2YvbQcGpxKKmBia44u5CbwcXWPNnGK5IGztlAi6zAtI0/La9sX7Qea4M7LxcPK98/JGzzNQA5hI1EdAQJdWR0bkokhQkHmfyLOzgFAPEOfOYWtPkk2Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cVWs78um; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cVWs78um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A081F000FF;
	Wed, 30 Sep 2026 19:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796357;
	bh=PO6nUHSH48ZNSV+GAVadvIrE/VQlIoultTdmfKrVfRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cVWs78umPusNiBSFhxaGkaMFca1AEf8dup42JUABmEnKdffYrrNNOAij6pmnc4zIS
	 3jglKnWPVrq/0DumzLqZxC3SJap3gdEaeNXFIpLxofDms6Prgwt5fLrHqeqomiwH6q
	 JQXq5o4M8WqoYelw9tjcZ/JM8amP95unYv0pN7SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Ling <zhuling0805@qq.com>,
	Shawn Lin <shawn.lin@linux.dev>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.6 0884/1193] mmc: core: Fix OF node reference leak on card add failure
Date: Wed, 30 Sep 2026 17:26:08 +0200
Message-ID: <20260930152453.887421088@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Zhu Ling <zhuling0805@qq.com>

commit 08b54e16d547d5c1aa61bf7a3595bb1620975eeb upstream.

mmc_of_find_child_device() returns a device node with its reference count
incremented. mmc_add_card() stores the reference before calling
device_add(), while the card is marked present only after device_add()
succeeds.

If device_add() fails, the callers release the card through
mmc_remove_card(). However, mmc_remove_card() only drops the OF node
reference for a present card, leaking the reference on this error path.

Move of_node_put() outside the present-card conditional so the reference
is released for both registered cards and card-add failures.

Fixes: 25185f3f31c9 ("mmc: Add SDIO function devicetree subnode parsing")
Cc: stable@vger.kernel.org
Signed-off-by: Zhu Ling <zhuling0805@qq.com>
Reviewed-by: Shawn Lin <shawn.lin@linux.dev>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -397,8 +397,8 @@ void mmc_remove_card(struct mmc_card *ca
 				mmc_hostname(card->host), card->rca);
 		}
 		device_del(&card->dev);
-		of_node_put(card->dev.of_node);
 	}
+	of_node_put(card->dev.of_node);
 
 	if (host->cqe_enabled) {
 		host->cqe_ops->cqe_disable(host);


