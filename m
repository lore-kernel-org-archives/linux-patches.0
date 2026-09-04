Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270783A7F4C;
	Fri,  4 Sep 2026 05:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499144; cv=none; b=pYZWaus/VPmIDvWUzu+M0KvWPr8szhBAoQxpkX3aripeS2EQ1hYm3zghBbx+SX0tgY2qXZ2aAbhbIi6WvnABq0+3TLyitiLT4yRXePQf22yl9+YVVFbPLbgZR58DZRx/63qCEXqvH7WXZwoCb9Yr7O+l+hhfLpNwyv8jnrxWpfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499144; c=relaxed/simple;
	bh=R2IZsV7kR7LynraDQlcjsTCd2bgMa3VVWhMiTLpLgbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbuUTjBLaPdXSzqvUZ8ZZKYRBIS5i+NDQ7/9K9iHvoVeW1CKULTo9cmlKl/8Zjcv7RbfONAboTixIcJ4swBuUgqKloVF+7iHsc2LLyyWSmWv6Z5+lH69XeLxjExVquk1isJiUnhuA7uVL/xmJmkhZAlF1Mau9FqDDZS9/lar7c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vayk7Ex2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vayk7Ex2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810D91F00A3D;
	Fri,  4 Sep 2026 05:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499143;
	bh=JHCbjukHnQYX3Mh1giwD0qkmcGEkNzOjSrUR27UNjLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vayk7Ex2O3+8RdAV2G7iBBtoFFRp1E4amdv5lapMp0U6+3DNFPiUxwfvw2Z6OI9e3
	 dW0thH4nHetjxydSlSUKdrUGb7RHy2JKmL987OnscJZCGs0YJONxsNrGYa6jxvsaV9
	 DuucpkB1teuDRQ3/HjEkHGG+s10zM7Uth0CWqf+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 7.2 270/713] ecryptfs: fix tag 11 packet exact-fit size check
Date: Fri,  4 Sep 2026 06:53:58 +0200
Message-ID: <20260904045809.889890217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

commit 8b2ec0f56f55477f547d332526c9ae2a8fabc0a5 upstream.

parse_tag_11_packet() rejects a packet when the already-consumed tag and
length bytes plus the packet body exceed the caller supplied maximum
packet size.  The check currently adds one extra byte, even though
*packet_size already includes the tag byte before the length is parsed.

Remove the extra byte so a tag 11 packet that exactly fits the available
buffer is accepted while oversized packets are still rejected.

Fixes: 237fead61998 ("[PATCH] ecryptfs: fs/Makefile and fs/Kconfig")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/keystore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1537,7 +1537,7 @@ parse_tag_11_packet(unsigned char *data,
 	}
 	(*packet_size) += length_size;
 	(*tag_11_contents_size) = (body_size - 14);
-	if (unlikely((*packet_size) + body_size + 1 > max_packet_size)) {
+	if (unlikely((*packet_size) + body_size > max_packet_size)) {
 		printk(KERN_ERR "Packet size exceeds max\n");
 		rc = -EINVAL;
 		goto out;


