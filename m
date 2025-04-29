Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FC57E110;
	Tue, 29 Apr 2025 17:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946049; cv=none; b=UfeWVLaF69qs5HSGGItihUMIuQiApKNws7VaxzdB/rus7jqJz8WDnfy0yYUxfgS4kblJo4IqZ25Us9aJXz1J1YBdCxNG/XuIKjuFNLhw/IrqthaSxpL6Ud4GsvHyrhtX/DAcXFRoerrpTwM8GpA1oN0pA08FKCkLpPftnnXGo8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946049; c=relaxed/simple;
	bh=/6rOnYQi2arvoof/ZGVyIovrh0bGIw6TzszU06SRTVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7NWvVCj4rfAJkKURDtADFIys3Qmsc/BWfygf8qwQ4S1LWnJHlOhbKWKM+8hd7ST+ZsInXK5siBp4LoU3kJvOVgz/RLZrWcv+ov0Zt10yCcr5no6QHoFBLFfTS83uglJkJFKcFMdX7C4IPnCbyJ2GZEBQrCmeTu8I/65fXad2WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lN2y7YGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lN2y7YGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D733AC4CEE3;
	Tue, 29 Apr 2025 17:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946049;
	bh=/6rOnYQi2arvoof/ZGVyIovrh0bGIw6TzszU06SRTVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lN2y7YGJVH1iXpyx2LTOZl7ZRg2f2r6q+K9yk9mym7K/1xszR0lvflpXzTtml+lA+
	 eqisyPSPzEt4m6a7NGRD8C00P82X9CrFDVxi6bzCr1bq3ejyJue3uR8wbXCSoJmfx3
	 HGra1P/1WclUv+jUENkCfHJfO9mSRxqpYTd8meKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Johannes Thumshirn <jth@kernel.org>
Subject: [PATCH 6.14 137/311] mcb: fix a double free bug in chameleon_parse_gdd()
Date: Tue, 29 Apr 2025 18:39:34 +0200
Message-ID: <20250429161126.650064248@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 7c7f1bfdb2249f854a736d9b79778c7e5a29a150 upstream.

In chameleon_parse_gdd(), if mcb_device_register() fails, 'mdev'
would be released in mcb_device_register() via put_device().
Thus, goto 'err' label and free 'mdev' again causes a double free.
Just return if mcb_device_register() fails.

Fixes: 3764e82e5150 ("drivers: Introduce MEN Chameleon Bus")
Cc: stable <stable@kernel.org>
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Johannes Thumshirn <jth@kernel.org>
Link: https://lore.kernel.org/r/6201d09e2975ae5789879f79a6de4c38de9edd4a.1741596225.git.jth@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mcb/mcb-parse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mcb/mcb-parse.c
+++ b/drivers/mcb/mcb-parse.c
@@ -96,7 +96,7 @@ static int chameleon_parse_gdd(struct mc
 
 	ret = mcb_device_register(bus, mdev);
 	if (ret < 0)
-		goto err;
+		return ret;
 
 	return 0;
 


