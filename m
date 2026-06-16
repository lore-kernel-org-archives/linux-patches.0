Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C407247B425;
	Tue, 16 Jun 2026 17:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631193; cv=none; b=uikzDzcOOtAR5zR9R8WFTTsrGv64cPhONw3DfbnZ0gyE4+AA8ykCfrudHTVz4rd/r/NDBcr57drjxuTKWVcRpA+R06+2kc3oZ0/UTWA7QTXdMKVTnwiOWLAJEbobOytEXl8in6ngzkoK61T2ItI48zSz10J0Fkhkc3+1uFzNAQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631193; c=relaxed/simple;
	bh=HCBejHZfA8VEvV5aEwQyP+SLFAiqFGwla0BSRJQCWKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Apnj6Qoa69RQ9+OBgjzkE2tcgQKG+FuEtF/yyeRYlTRq//Yhpy7nA0EcOYwSjKp+QgWhMr1yO4tuyWqk1poWNfc6PpgUEeHzcJ17OpzW8amBQpTubZiR0jrxDiyYjz4Uu7fRk3E7klznotoyo+jgAEqFgyoQc6UqzkHOPvenK7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xwsbPrQM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xwsbPrQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99F01F000E9;
	Tue, 16 Jun 2026 17:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631192;
	bh=4YCrzIHn12pryU4ST9iHloZ37PYEVrqunUpvgpg68Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xwsbPrQMYmw37X5eZRHj7I4d3RgtzJ6G27BA5/3bjEbcUoWfCGzcPWHBnrFE7gJ1T
	 0N4/JqAyHyvRFxzviHmcyWbAEdkB1Yr2h6VjZggZ/Ew7LRDN5DxwpMpQB4+fY8W/qq
	 c74rzl9htvqUDeSFcURKXnw+KDuAQOdW//m0rcBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.1 141/522] counter: Fix refcount leak in counter_alloc() error path
Date: Tue, 16 Jun 2026 20:24:48 +0530
Message-ID: <20260616145132.686979893@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit d9eeb0ea0d2de658663bfaa9c26eccdd8fd64440 upstream.

After device_initialize(), the lifetime of the embedded struct device
is expected to be managed through the device core reference counting.

In counter_alloc(), if dev_set_name() fails after device_initialize(),
the error path removes the chrdev, frees the ID, and frees the backing
allocation directly instead of releasing the device reference with
put_device(). This bypasses the normal device lifetime rules and may
leave the reference count of the embedded struct device unbalanced,
resulting in a refcount leak.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fix this by using put_device() in the dev_set_name() failure path and
let counter_device_release() handle the final cleanup.

Fixes: 4da08477ea1f ("counter: Set counter device name")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://lore.kernel.org/r/20260413134604.2861772-1-lgs201920130244@gmail.com
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/counter-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/counter/counter-core.c
+++ b/drivers/counter/counter-core.c
@@ -123,7 +123,8 @@ struct counter_device *counter_alloc(siz
 
 err_dev_set_name:
 
-	counter_chrdev_remove(counter);
+	put_device(dev);
+	return NULL;
 err_chrdev_add:
 
 	ida_free(&counter_ida, dev->id);


