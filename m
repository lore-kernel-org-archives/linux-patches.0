Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0503403E3;
	Sat, 12 Sep 2026 13:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220033; cv=none; b=cA6Sy/H/jlCf7QH981Y9zE+0crXsfmLrQOhFFJSI7Y3FNxOaFBRYoNQcsy2U8Qo2vyTWS6eyeWmeQpjhq5Ymj0GvAgp2a8vfJcM5HTn0zSAaupf3bA2/YUz1Wy1T+kc9fv4k3c58YIWn7ixPWgDSyHGy+0iJVETpKzIAOCQ19bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220033; c=relaxed/simple;
	bh=+2ENGMFMM/atJuyj7CxO36nO9WsNEnCKZDVdaxaPmGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pB6K0xQpcLSyyEPFvoQICcyWM7hZGqGT4hJZkvhzf734jbWWZ+oTnObddXFswzmV/OAkRKjvuH9n8B/fGln/wqJzpGINy/ktvG55rHGp7tawYoIEcKgCV4MLrTOcGW+J7fjRMlALSdYPuh+O0GS6Xfc/EAGbjjKRkhbbVnaecAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvBzt8db; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvBzt8db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4469E1F000FF;
	Sat, 12 Sep 2026 13:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220032;
	bh=FKnSw5b8gAyhcBe0pAR0R+7bi511aS/JnR7VVPryyaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvBzt8dbYvQiRGO+ulp7Wrayo6k83cXxiJP3YQi7i3d5UoN0buVmPvQZo6KzBfn3r
	 cNC8tDyMM6ZKzeRj68NsF/TYGFNNK2GrxAuub0zV3917uCB01FS7yBrFpkua33kMQj
	 V76DzrcG4KFDipruph2GxbzqzFm9Wi6QeknYyrWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.6 0094/1424] ecryptfs: fix tag 11 packet exact-fit size check
Date: Sat, 12 Sep 2026 08:42:06 +0200
Message-ID: <20260912065609.411000487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -1576,7 +1576,7 @@ parse_tag_11_packet(unsigned char *data,
 	}
 	(*packet_size) += length_size;
 	(*tag_11_contents_size) = (body_size - 14);
-	if (unlikely((*packet_size) + body_size + 1 > max_packet_size)) {
+	if (unlikely((*packet_size) + body_size > max_packet_size)) {
 		printk(KERN_ERR "Packet size exceeds max\n");
 		rc = -EINVAL;
 		goto out;


