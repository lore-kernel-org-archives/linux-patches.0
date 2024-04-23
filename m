Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25FD14389F;
	Tue, 23 Apr 2024 21:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908646; cv=none; b=ikoZMNI6zxY9b6otrGmTXQbDTwKPwkQAWeUZpGlP2hgfuEqdv5nLqcXzot8K8edcPHyD3esg9+cPts0VGnA39n3edzWfsVwfSUXkqKzJPF5HFce7UR/RIiMaciO1XS+/tzQrBzazqBX5UZe9LP6/iZBWO7d5ieFZk/Xa86712k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908646; c=relaxed/simple;
	bh=/K2DL0OekGn9aYLps4o+hHt61AiYJxUC/dloe8S15q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7G09sxwe6khCF4ZwIZF/c2zqtIUnCMcKvu2VuTo/BceYjdkH4dU93YGnOMg9bDaZpqr8eFmaXAlhVhwiVStpKwgs3LyapKOiw7rVfSTi9hriy87SOeBKIbtN9WKpsGx5BuxH/HfefKDFAVw482XAIapXidqr2OphQnkBwhVtUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfuc0V6T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfuc0V6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8621CC3277B;
	Tue, 23 Apr 2024 21:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908646;
	bh=/K2DL0OekGn9aYLps4o+hHt61AiYJxUC/dloe8S15q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfuc0V6TlrT78AZSQdCweOwi60g4SBBNXO6liY2pr0o0o78aweniv2xCFN1GI7E7P
	 7NcenjTUBitms1ReVqTG7dSxSMP+ivDbMDPzy+G80FH5b2+MJUoTqiJHMLL8T7YqUF
	 thS4sReTjBcRnl2agLpX8LjToJIaDpmGVIpvIcY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Todd Kjos <tkjos@google.com>
Subject: [PATCH 6.6 105/158] binder: check offset alignment in binder_get_object()
Date: Tue, 23 Apr 2024 14:39:02 -0700
Message-ID: <20240423213859.166163131@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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


