Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3512C34DCE3;
	Wed,  3 Dec 2025 16:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778849; cv=none; b=ZQ00corABo5BBhbYaDRB81WdMUKLAio3QPIhfx7ivE/4STvU0dl9aB/IHpC8n5x4x51mkST9xPH4Ug0z3AkyPfjGRSboTGrYACfrG4FM4B3kN/ENpcEfQsdQahB2k5Vg99LA0mRpvlc7yu03GZBj1+CUFaJpGgiGcfIeYg0YeuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778849; c=relaxed/simple;
	bh=RW6gaBI06MQgGVsDnBI2urjT+p1yUwTrB11k8qJ/1Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVN8xEgzlQ8pL+tAkPZunzCMaZQb8230YONCiXszOl0oSfoYXK4tynQsxGUUDXhZhye4HLMrP0dH6GXV4Rm/9+Wsk2Vyi1KUfX/47UHxY3VKgjD0Nh6Xy7nwDgkSfQ9CKfeqr6HWSkPaw76Rm+7SjZfLLefuhgOkhGaGi/gYYh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QamP34b2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QamP34b2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BE0C4CEF5;
	Wed,  3 Dec 2025 16:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778848;
	bh=RW6gaBI06MQgGVsDnBI2urjT+p1yUwTrB11k8qJ/1Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QamP34b2K5uL8HQyjNPHI/ESS1A7GJLb28i07KK90c7oDmsUijH1ozVB0q6OJiR5q
	 G2Kc7SI9yc3ClC6hybblJWjXKG2h1Luv15AaX5QMx7ZxJhvHkQPHH1pnf71RENKxX+
	 Cvi04UdPFOyj5RLeTIHON/26rhgnNgYAt1fxXmN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Mahmoud Adam <mngyadam@amazon.de>
Subject: [PATCH 6.1 079/568] direct_write_fallback(): on error revert the ->ki_pos update from buffered write
Date: Wed,  3 Dec 2025 16:21:21 +0100
Message-ID: <20251203152443.613315251@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

commit 8287474aa5ffb41df52552c4ae4748e791d2faf2 upstream.

If we fail filemap_write_and_wait_range() on the range the buffered write went
into, we only report the "number of bytes which we direct-written", to quote
the comment in there.  Which is fine, but buffered write has already advanced
iocb->ki_pos, so we need to roll that back.  Otherwise we end up with e.g.
write(2) advancing position by more than the amount it reports having written.

Fixes: 182c25e9c157 "filemap: update ki_pos in generic_perform_write"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Message-Id: <20230827214518.GU3390869@ZenIV>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/libfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1615,6 +1615,7 @@ ssize_t direct_write_fallback(struct kio
 		 * We don't know how much we wrote, so just return the number of
 		 * bytes which were direct-written
 		 */
+		iocb->ki_pos -= buffered_written;
 		if (direct_written)
 			return direct_written;
 		return err;


