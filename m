Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BADA7464;
	Tue, 30 Apr 2024 11:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474836; cv=none; b=VcGh9yLHWB3c57WkkFdTHxHFHC9LJnhT8n7VrqesrzaDcWLy9NJdB9w8IYlzWc0j+iESy0FFAv6n/gtdwcXJjQBEMOap1tjkk6yPXQFx9x3w8D4jVbBF5+0QCdhL5m/ZyUSjoZzYA4HQGxpQlWxE98I/sCO+YN0Bi4FpSGXpT64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474836; c=relaxed/simple;
	bh=2G0H4LbhCwV2kDlpr9mm3Fzq9nsTrmvCAkGQwVQY++k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfNsrPJgpC9+ocj6xst1Y8xoDgRbsuxo1xdACieiXL5WKKejK0km0wgArTzdx2gePN3Jiz89Gl1fZlPnt/bS5rKHeiPxz/y3GHPyrdIjzgsHdVyTvyvRkFEbuKbxMyYuj2alKRgVWnFhKPyoeTvkS5cv6x2Jc7suY79uLsy+/7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmSdzsbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmSdzsbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02996C2BBFC;
	Tue, 30 Apr 2024 11:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474836;
	bh=2G0H4LbhCwV2kDlpr9mm3Fzq9nsTrmvCAkGQwVQY++k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmSdzsbf9oPtRXHyBrB57aZEmPratKWCArfd/VjLxEAr+/xE0HwTeYKKUVrQgAWm5
	 Fb9ytt6Fx0eX+CGUNu4sgmGGiECgPUhhP94Kpu3w3PGyWAqtL7fm8pZ1NEVhCSFIqX
	 Mbzxu34iU6XVAVEq66+XNJHtNqvXqZn/6Z8Rqcr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.10 051/138] binder: check offset alignment in binder_get_object()
Date: Tue, 30 Apr 2024 12:38:56 +0200
Message-ID: <20240430103050.930848932@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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
@@ -2042,8 +2042,10 @@ static size_t binder_get_object(struct b
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


