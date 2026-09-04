Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44C4417BCA;
	Fri,  4 Sep 2026 06:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502310; cv=none; b=iCKOUngh7+SVYezu1CqA5H6qTdgb4YTBIlnEddkqc5uRDmBtx6X0Uo5gGVQ2UJoZWLRz4mDqntHzquk1XKG0rpxaowoRO9csUutuCU9YU/IKFxD4Rw5vL/dtwPB5a5ToyAsOeCxDLkgPHJn+GlYyEUYrxGtVeLGkkfBh7JWbA8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502310; c=relaxed/simple;
	bh=XiImJEgMM1hQpHYxGowr975Fpc621kvs+fJRQWVlyho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETu0PHDHiB8nIIaEXPGSoggo1bJcxdRWXjo4HLzvYvemEd8js9gawqVBClViwmePnfzP52BqgUYdMB8ncxxc/20beMJhaRCvD1s6qNkcJeZgPp8Xifq4ztEfmXA2wlQhSaG2PfOZk7PNkh6lWb/1BMg3vR0VaXiUn7xxqdlr/9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzjKyQV7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzjKyQV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EA21F00A3D;
	Fri,  4 Sep 2026 06:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502308;
	bh=aURLiiKymU/T04XdLg7Sjl1GknKY06u7Il/t7xHf1Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzjKyQV7sZ75oRFXH9GssTg0ubQBrM42Z6qjb+fgRxqNArxNbXzCsMp69lCSygHwH
	 nXhBpfvZ7rNtEZKhlA5RYLIgvCtQTJ3pHA8hhXKMVCH5bYHFQJpk1lM0WNpgKK2Wkf
	 O8dgDjqo++yDkQVrqikf7yvo2t8WY4RMxFBFx6O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.12 135/403] ecryptfs: fix tag 11 packet exact-fit size check
Date: Fri,  4 Sep 2026 06:58:58 +0200
Message-ID: <20260904045737.911071852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


