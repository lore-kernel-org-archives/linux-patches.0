Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F807144D3E;
	Tue, 23 Apr 2024 21:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908511; cv=none; b=GFHJs7MXLtCfTLcfDtbCZ8DVRrjTr8El2Xc1Q539VgrKkMpqkFok9tiM1zWBU4mW+fQN96/tpKZySRZcTHUuGl33pyy46zpotISKuoSEls1KLHGgM63wHOvAKbyfj3n4F5+TDXEIAAyEE5RIpnu2Z6X6DBq/b0kgfdDcPdE6hUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908511; c=relaxed/simple;
	bh=v72/BvHTJI+uiXBuQBpBDo04YVGC7j27LBq84+vGczo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEU9WPnd/DdHj2uC48EPjoIFE3dWURtPf0yYfc7otAHNeK3bP4gNXMz2ooahR0kC0LqWTkEllwSiAE1iAWEW8U7UQfNGOq7AK3Xut8VRYoAyegoWD+vPs7wR8NKjmLMV9k8mrZF+JTcWtHptdbEGaKxL2H4vEYxyRxuoMuCRkns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4sdsqox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4sdsqox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA45C116B1;
	Tue, 23 Apr 2024 21:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908511;
	bh=v72/BvHTJI+uiXBuQBpBDo04YVGC7j27LBq84+vGczo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4sdsqoxlVURkJQsoTrKtog5JIBDqfz3vKX9Lz1v4aCsQA5PdNzqPrRMZTubF6GHt
	 tufClYZj7PcYLGtTBcXeu9T6X5DOGFz1EIoLMjYuGYA+Org4B9V5jCDA0yPFmrJXrb
	 SFcsMd4tT4uBhwwyW/NjZD2Nu7khnHRAfM9102Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Todd Kjos <tkjos@google.com>
Subject: [PATCH 6.8 096/158] binder: check offset alignment in binder_get_object()
Date: Tue, 23 Apr 2024 14:38:38 -0700
Message-ID: <20240423213859.072329948@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

commit aaef73821a3b0194a01bd23ca77774f704a04d40 upstream.

Commit 6d98eb95b450 ("binder: avoid potential data leakage when copying
txn") introduced changes to how binder objects are copied. In doing so,
it unintentionally removed an offset alignment check done through calls
to binder_alloc_copy_from_buffer() -> check_buffer().

These calls were replaced in binder_get_object() with copy_from_user(),
so now an explicit offset alignment check is needed here. This avoids
later complications when unwinding the objects gets harder.

It is worth noting this check existed prior to commit 7a67a39320df
("binder: add function to copy binder object from buffer"), likely
removed due to redundancy at the time.

Fixes: 6d98eb95b450 ("binder: avoid potential data leakage when copying txn")
Cc: stable@vger.kernel.org
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Acked-by: Todd Kjos <tkjos@google.com>
Link: https://lore.kernel.org/r/20240330190115.1877819-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -1708,8 +1708,10 @@ static size_t binder_get_object(struct b
 	size_t object_size = 0;
 
 	read_size = min_t(size_t, sizeof(*object), buffer->data_size - offset);
-	if (offset > buffer->data_size || read_size < sizeof(*hdr))
+	if (offset > buffer->data_size || read_size < sizeof(*hdr) ||
+	    !IS_ALIGNED(offset, sizeof(u32)))
 		return 0;
+
 	if (u) {
 		if (copy_from_user(object, u + offset, read_size))
 			return 0;


