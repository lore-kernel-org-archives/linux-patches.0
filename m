Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBF9408035;
	Fri,  4 Sep 2026 05:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500119; cv=none; b=Oh7j73Mg4N9kmnsr7kTWbslXGKo85xTjmNlXtvHOLEq6XyCK/iaQ+3PZGyNtYwy2eGslnk7U6XQKaeT6uvnZvbq7cWNTjAB409eC7e3/Wl6tp5qxZvb8es9goT24IkYVQIA5my8ScY6ZdaKoJMt5kyxycJ6hJUKGTJRf2Hc9T2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500119; c=relaxed/simple;
	bh=zaYDcEApVUvuiofvGXmh4ZM6EdYaYqg2lrOT1x9hBZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mK9D+2cGtlviT5C/5sFNylBPggEs545nfWeHwuvWPps4p39qKjZ6WsXgGla0d5vV/L+7aXaXa+LIvclx/E/3aVTNrGjMYaSOe/0AeiHAG9JTe/ButsYjqWzmaLANoJSZZcWbUnK4SHIaOb61v6J4jVcZu60t2NPgGTM3bcEyduk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aXYcSfww; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aXYcSfww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442121F00A3D;
	Fri,  4 Sep 2026 05:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500117;
	bh=a0bAPBWLkwugG1radwMGZPz4/XUErsOgUKv9hgfrcXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aXYcSfww+LvlH00iAAxhEsIBMTjQ+soM/nayfZL0v5rBnTwEQWOY2S0cjYnjY9zi6
	 41bfr5D8oGUzK4T4VFoCiDT9w3lQw9Mk3XPPTqsIpg/xcK9nTZJKgSTO9Q/a0Cz7qO
	 EfkbTmdCcujirlglPerem12qHbc+280gE4GJ7oaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.2 657/713] dm-pcache: bound the persisted tail-position offset
Date: Fri,  4 Sep 2026 07:00:25 +0200
Message-ID: <20260904045818.562038685@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit d1898576090a10d2ac2715218a652e78fb65a6b0 upstream.

cache_pos_decode() takes the persisted key_tail and dirty_tail seg_off from
the cache device and addresses within the segment with it. A seg_off at or
past the segment data_size, controllable by whoever supplies the device
(CAP_SYS_ADMIN), reads past the segment data.

Reject a decoded seg_off that is not below the segment data_size.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/cache.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -119,6 +119,10 @@ int cache_pos_decode(struct pcache_cache
 		return -EIO;
 
 	pos->cache_seg = &cache->segments[latest.cache_seg_id];
+
+	if (latest.seg_off >= pos->cache_seg->segment.data_size)
+		return -EIO;
+
 	pos->seg_off = latest.seg_off;
 	*seq = latest.header.seq;
 	*index = (latest_addr - pos_onmedia);


