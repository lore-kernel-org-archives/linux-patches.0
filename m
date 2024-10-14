Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D433B298;
	Mon, 14 Oct 2024 15:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919199; cv=none; b=ts9ABpEsqe8iptUlts8pQs8CvGsTq4eLEPnAZz+3KmWZwt+KwvZim/bHdgKZjb29037HY55wx2E+U4i5EUrbteNXIOIm0dSN7dRCNd/SKOx4Wd62E8WA+JhrOYVToW2JQZGYgik9R8HNCqyyEV2wcDS/LfvwzMRshJrqvfvyUwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919199; c=relaxed/simple;
	bh=O7HmYc9aIM3jnhwfy0X7uuHrqTmVI4fOrvABtx0FgwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmvAbN5aeZhSZ2n652caS8BzfDlodhftwO4Ow+J2kge/+LWQXpKT/iat8yRogOuXWRl56MMrNHivLgi/WqsJTgmY5sulLlXAeSq7lw/SbI64hoGIlVrrNIMay0RSdnwfHgaIu9lAvSh6GjWjrnsdfnCElW/esWSdSMB+vRBT0gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdG8ymn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdG8ymn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835FFC4CEC3;
	Mon, 14 Oct 2024 15:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919199;
	bh=O7HmYc9aIM3jnhwfy0X7uuHrqTmVI4fOrvABtx0FgwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdG8ymn9o871XfLDN4VdR7aJbbLkSticG7zfnyYDNo+gLakC9MD01wW8+VhN1V7uD
	 iuM/ps3kCGq5sO1TLpJZ+oCRS2CH3g3fcccD4gIH8xn61Gogdr133svP8bzG2lAvyJ
	 upqVddiJ7S/m+3Iuo7bFi3T5T+QDnguYKwer0B58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ae688d469e36fb5138d0@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.1 541/798] ext4: no need to continue when the number of entries is 1
Date: Mon, 14 Oct 2024 16:18:15 +0200
Message-ID: <20241014141239.253093225@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

commit 1a00a393d6a7fb1e745a41edd09019bd6a0ad64c upstream.

Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
Reported-by: syzbot+ae688d469e36fb5138d0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ae688d469e36fb5138d0
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Reported-and-tested-by: syzbot+ae688d469e36fb5138d0@syzkaller.appspotmail.com
Link: https://patch.msgid.link/tencent_BE7AEE6C7C2D216CB8949CE8E6EE7ECC2C0A@qq.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2047,7 +2047,7 @@ static struct ext4_dir_entry_2 *do_split
 		split = count/2;
 
 	hash2 = map[split].hash;
-	continued = hash2 == map[split - 1].hash;
+	continued = split > 0 ? hash2 == map[split - 1].hash : 0;
 	dxtrace(printk(KERN_INFO "Split block %lu at %x, %i/%i\n",
 			(unsigned long)dx_get_block(frame->at),
 					hash2, split, count-split));


