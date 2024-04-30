Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C04D12CD9B;
	Tue, 30 Apr 2024 11:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476107; cv=none; b=eBNU9Kr5Okc7O6mKxaPbxRvu6H6yL3veEd/4XQamx9Ra8VVeI8P5t5A5PjthtveyoOl98L7CwKVNNozH6ZwR5Q5B7TjjsLe5lX0e+eD+Lywit2Ee+Zwj0R8XxDu5GT7cY6Q+1UUZBaY5bKHPeU9j8VNyE9z9E922YK+69jjrffI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476107; c=relaxed/simple;
	bh=oz6ser+dyxGHqDySihttlTPqytHo0IXtP6DoxnOhako=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NV7pJY46961Mg3ld802mD/Nwe0ekgEF7qCDnWhdLcHXYM6hBdV9sQ1btntBSQcXZJyp+ZWV68bDWOXn08Piy81MqUzCUv/6MJC23CifOk5DYKv+MM65vBcdf/74XINF12WKac5LuNapN9RTKM/P9fseV048wLygKIEnFh+JtqQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHsBqdnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHsBqdnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFF8C2BBFC;
	Tue, 30 Apr 2024 11:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476107;
	bh=oz6ser+dyxGHqDySihttlTPqytHo0IXtP6DoxnOhako=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHsBqdnLPn4Jti9gcg2LDfDhS8SRF5x7ALSsyl9XDhMS+PcH79gbWFB4kZ2pSLBT+
	 7s/QADTwXMIhIPU/OgGNrtW94hHsuSgUoSJoonNtzduAQ6SnO2Vb9XntfM6UNWTiu2
	 YH3fHbkZ6Hq91id6Lm5Rr1Fx/2+j7VnyqEBgFqNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.4 035/107] binder: check offset alignment in binder_get_object()
Date: Tue, 30 Apr 2024 12:39:55 +0200
Message-ID: <20240430103045.696095126@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2047,8 +2047,10 @@ static size_t binder_get_object(struct b
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


