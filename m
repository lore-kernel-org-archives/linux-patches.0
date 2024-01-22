Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E47612DDAA;
	Tue, 23 Jan 2024 01:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971707; cv=none; b=CgFotmyXaW/pmsM8U9JuUKEhcYmnAB3566j/y0eVpd9jr3Gn2TdG0Si6WOXhra7ASCJj7UJG0ctIQq3zDgbSls/TD8iNFmztn4ZSMUQytaFnGK16dGUZjCirARoUTOrlNrQe4Nkp3+vw8bAjYJRT4vaDUSnA+Vw7o7GB/eF/ZRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971707; c=relaxed/simple;
	bh=hGp7eyFscusuLwGSpVM0qH8ciEtoPbBQF+iFe6Ij/Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGvtBHQcvjIH9tmxfEBlpPkoZmoWZrmsfFc1JazjCWiu01e21VpwiPtMvns+w0Qw/rUgnSlwkpsTsI216hTZarvsVOQvZ+cGfH7NUpUOSPylhsVb+tzXN1x/e+OenKNWUPQoVO5JzGkwBOtwiI7isbWFLnTaJQxvcK+Hv/jyB5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GA+HuP9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GA+HuP9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0456C433C7;
	Tue, 23 Jan 2024 01:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971707;
	bh=hGp7eyFscusuLwGSpVM0qH8ciEtoPbBQF+iFe6Ij/Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GA+HuP9eYK+yG0MYCwi+5ZOWQOTomBfW3IhgwU8Kiwp5+Efg2E0GGFADLZV2BXNFH
	 Iop9c7cJ35bJLaHe88wOBCpIqmr2keBdESRkqkXqK99Hu4BmEFVOXr62rkfDRiY9X7
	 UbI9OyORzGKgzVrsFLpP/6CKlaFuDm5eGbJpeAYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.10 198/286] binder: fix async space check for 0-sized buffers
Date: Mon, 22 Jan 2024 15:58:24 -0800
Message-ID: <20240122235739.741638894@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit 3091c21d3e9322428691ce0b7a0cfa9c0b239eeb upstream.

Move the padding of 0-sized buffers to an earlier stage to account for
this round up during the alloc->free_async_space check.

Fixes: 74310e06be4d ("android: binder: Move buffer out of area shared with user space")
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://lore.kernel.org/r/20231201172212.1813387-5-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder_alloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -415,6 +415,10 @@ static struct binder_buffer *binder_allo
 				alloc->pid, extra_buffers_size);
 		return ERR_PTR(-EINVAL);
 	}
+
+	/* Pad 0-size buffers so they get assigned unique addresses */
+	size = max(size, sizeof(void *));
+
 	if (is_async &&
 	    alloc->free_async_space < size + sizeof(struct binder_buffer)) {
 		binder_alloc_debug(BINDER_DEBUG_BUFFER_ALLOC,
@@ -423,9 +427,6 @@ static struct binder_buffer *binder_allo
 		return ERR_PTR(-ENOSPC);
 	}
 
-	/* Pad 0-size buffers so they get assigned unique addresses */
-	size = max(size, sizeof(void *));
-
 	while (n) {
 		buffer = rb_entry(n, struct binder_buffer, rb_node);
 		BUG_ON(!buffer->free);


