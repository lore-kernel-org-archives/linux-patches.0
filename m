Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7D1FBF0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F41C433EF;
	Mon, 15 May 2023 16:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169654;
	bh=M3v98ZhcJTfpmPI1aYheNzTgw8RV+l7Q8rQJILWMNCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ckrz8HLryPjseqeqySbTIQ6QEag2Ro6XpTdLD4vVuWYZTqXeYKDnLYierI7kKNzxo
	 Ztaf3cMBJeArk1NYwzQUmBO6AhE5jkYV1S1wpugnsleOcV1ySl2zqrwzRGC1neYHL4
	 B+XGciyCEFcTQogi6AG+oZx8cqdwUcq1JMXx/EAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.3 128/246] btrfs: zoned: fix wrong use of bitops API in btrfs_ensure_empty_zones
Date: Mon, 15 May 2023 18:25:40 +0200
Message-Id: <20230515161726.403229053@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 631003e2333c12cc1b52df06a707365b7363a159 upstream.

find_next_bit and find_next_zero_bit take @size as the second parameter and
@offset as the third parameter. They are specified opposite in
btrfs_ensure_empty_zones(). Thanks to the later loop, it never failed to
detect the empty zones. Fix them and (maybe) return the result a bit
faster.

Note: the naming is a bit confusing, size has two meanings here, bitmap
and our range size.

Fixes: 1cd6121f2a38 ("btrfs: zoned: implement zoned chunk allocator")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zoned.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -1168,12 +1168,12 @@ int btrfs_ensure_empty_zones(struct btrf
 		return -ERANGE;
 
 	/* All the zones are conventional */
-	if (find_next_bit(zinfo->seq_zones, begin, end) == end)
+	if (find_next_bit(zinfo->seq_zones, end, begin) == end)
 		return 0;
 
 	/* All the zones are sequential and empty */
-	if (find_next_zero_bit(zinfo->seq_zones, begin, end) == end &&
-	    find_next_zero_bit(zinfo->empty_zones, begin, end) == end)
+	if (find_next_zero_bit(zinfo->seq_zones, end, begin) == end &&
+	    find_next_zero_bit(zinfo->empty_zones, end, begin) == end)
 		return 0;
 
 	for (pos = start; pos < start + size; pos += zinfo->zone_size) {


