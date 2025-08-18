Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778D1321F42;
	Mon, 18 Aug 2025 13:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524416; cv=none; b=S4IyvlFJbqMQ7SDRmsS4IuuyL8vNusOg4vDssL1k//p/jTp1Fqtit1GcEa5IEm0lPZxiSXcuFaq1nRl6hgwNUrVXJ9De2jqTLya9Awtra1aVlWU9Xx+f4nJN7YZjhuA6mNDjwBXg9FYSb3WS+kz9A8Rq6yp6fW+zXhmUiTRKA5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524416; c=relaxed/simple;
	bh=eVhoad7wBIEiLwWBgq4r3MXMU4AJN3CbrVGW3+quSpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmDC/5VB5+HtEpg/CoLVyu87xibNn/I7YoKsjyQWMf/2/HiMq9oAlTXny+TaPiGwA4jTJNMKMpfdZv/mTqEMTNb49ytyA3IzOR1JW4U6Ihs9BLX+A9WPqrSn9TP1D+YZVr24k2YtdkqXcaYEtbZyj6TXoXVENQQL/jFfU5TixA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOYULVvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOYULVvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926A5C4CEF1;
	Mon, 18 Aug 2025 13:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524416;
	bh=eVhoad7wBIEiLwWBgq4r3MXMU4AJN3CbrVGW3+quSpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOYULVvzEQZmHhmloVzxihJcCvrArpmG1XdxKLLsnpoc3n6cGXtBWWmbh7C4iDapW
	 vkd9/P8k6YaO5UXwDxOoBaQJ10BNH/4Q5Z5zvH6sDjzVSQN5k3OIksef3bo/chUpp2
	 bqcBPCtweiyazv/rfDva+Jjw1E01befMza8ey5/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.15 464/515] btrfs: zoned: requeue to unused block group list if zone finish failed
Date: Mon, 18 Aug 2025 14:47:30 +0200
Message-ID: <20250818124516.281752967@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 62be7afcc13b2727bdc6a4c91aefed6b452e6ecc upstream.

btrfs_zone_finish() can fail for several reason. If it is -EAGAIN, we need
to try it again later. So, put the block group to the retry list properly.

Failing to do so will keep the removable block group intact until remount
and can causes unnecessary ENOSPC.

Fixes: 74e91b12b115 ("btrfs: zoned: zone finish unused block group")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1619,8 +1619,10 @@ void btrfs_delete_unused_bgs(struct btrf
 		ret = btrfs_zone_finish(block_group);
 		if (ret < 0) {
 			btrfs_dec_block_group_ro(block_group);
-			if (ret == -EAGAIN)
+			if (ret == -EAGAIN) {
+				btrfs_link_bg_list(block_group, &retry_list);
 				ret = 0;
+			}
 			goto next;
 		}
 


