Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791BF143C6C;
	Tue, 23 Apr 2024 21:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908804; cv=none; b=Mqx8uNlAfoWzBBLT/TGHeBImxxbswqVuMA/2t/YzNXS2PhF6gAC8Wk7fUAWUkuVbfL/1k5JbYhQfXsDBxOXj7TJqvkUweoMsfqvwhVuXJQx5hfxGzbPORgTlv85+AZIGhMn9Rnpwnm7I3IwfmGH8zDLf+OyrEyP/uu0PMdeWy3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908804; c=relaxed/simple;
	bh=zDAGMxqjTqsZX+Z7vmLBD2iaq0eeQqm1V+uhqUE6G8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHldWZOlV2Ayn3Sa20xxb3Y3u760ql+bMTu4Loyta5BVCFysv/Tg7oGoI6Ra8wUPH+Of8mqFvMdIIdM8XcpvkffJhAyPo9rjC/iPpqwv57Ub5G6ELRbHfQpXGGd9oXnRcgw+bGJNwc1LXKyGwfXthfd0EtN089ibQUG2fcAXqaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kc3Jp7xm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kc3Jp7xm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F123C116B1;
	Tue, 23 Apr 2024 21:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908804;
	bh=zDAGMxqjTqsZX+Z7vmLBD2iaq0eeQqm1V+uhqUE6G8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kc3Jp7xmSnsjKj/9Hhqf8Cmx5WK+uarnpG1NQb5MqxSM5s5U6ubJv5Az8aBJV6umX
	 q8yWeofcp5UgsUJEo3hXBiSUPE25We3TadFXpf2kea6kLtMcmaH4ZKQ7ae9P91kGjg
	 sKrkwJeBob7+ZMe204udBIQTG6h/aDj00Yawm5vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>,
	Todd Kjos <tkjos@google.com>
Subject: [PATCH 5.15 63/71] binder: check offset alignment in binder_get_object()
Date: Tue, 23 Apr 2024 14:40:16 -0700
Message-ID: <20240423213846.361540851@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1678,8 +1678,10 @@ static size_t binder_get_object(struct b
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


