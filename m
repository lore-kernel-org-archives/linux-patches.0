Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C307D3B83E0;
	Tue, 21 Jul 2026 20:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667406; cv=none; b=JY6SYZcPZvWTFr065XdnFnj6Gc42qlaC19GCHiS/wXF2E3n6e9H6hyUKAakMpNQ8jsMR6QbYhN6oTzMItiiiG7uQs6YVEnAPS8N25YOmejhp5Z1/dWqyWfoKMMNMddoN1vZqIsKu5bPTRyrv2LtplKSyKO1Wd2Sd4CnL3kf/cW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667406; c=relaxed/simple;
	bh=Fm3QRVJ+m/UA7KlfNFGQh6ieR/bAJKrh7UTqY54PNEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6YGVLhY0EOqBRDtTjjcSF4LWVp3zuxXCA616BLrCNNHee3im/a0rInw8BfSLl/sngp7fVZpzybQDq4oUY0Nwbxxf7TBPno7lPkgOMkROp4wLnGTlZ4lweZo3T+spBVT7gpNGg1hYzcko1hJsrxKN9Yjjp7Pyde3cUXkCT3wkuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpI5ty2R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpI5ty2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353141F00A3D;
	Tue, 21 Jul 2026 20:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667405;
	bh=TQrQGJDIYbUg5JHUjwEzgg0JG3gdOSaXRPjEqEZdwCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xpI5ty2RNWHqtMJQFVPdYmnb25Qsi9SvZGcnGr9hrGbPNby4FKy/hfnPQLN3j+AfG
	 LKCvhJyS1wMnIZB0f11LXoW4JWwgH8KhAx4+Hk6aW4CDLuO7dJETBnTRIAapi0D7Sk
	 S1/we8yUFuMFU5c2/nDM6eFhNYEQkmRd7NyFLKOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 1048/1266] dm-ioctl: fix a possible overflow in list_version_get_info
Date: Tue, 21 Jul 2026 17:24:45 +0200
Message-ID: <20260721152505.269672404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 76c6f845dc0c614304a6e6ee619b552f97cf24b3 upstream.

sizeof(tt->version) is 12 bytes, but the code writes 16 bytes into the
output buffer - info->vers->version[0], info->vers->version[1],
info->vers->version[2] and info->vers->next. This can cause buffer
overflow.

Fix this buffer overflow by replacing "sizeof(tt->version)" with
"sizeof(struct dm_target_versions)".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -683,7 +683,7 @@ static void list_version_get_info(struct
 	struct vers_iter *info = param;
 
 	/* Check space - it might have changed since the first iteration */
-	if ((char *)info->vers + sizeof(tt->version) + strlen(tt->name) + 1 > info->end) {
+	if ((char *)info->vers + sizeof(struct dm_target_versions) + strlen(tt->name) + 1 > info->end) {
 		info->flags = DM_BUFFER_FULL_FLAG;
 		return;
 	}


