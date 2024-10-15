Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F8C1D8DEA;
	Tue, 15 Oct 2024 12:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993747; cv=none; b=Xax6/ogjM7rZ7+Yn6DuNBk8YNrh4orpGb8HIUg1to/cvKPEeuuGGc1R9h4Eg9hKtwVLsOqv7co5VgLRn9/ragwaQOhviTnqbTdx57w4gK9bu4tvYrgSZZkJ1H0NVifZNLoWoL0MJTsMd/R6opjvoI4jWmHvOxfoNrFmZmBLQRDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993747; c=relaxed/simple;
	bh=vytAFp2n9DINcKQE+XYr1p0gTiphVgb1lqrbMg2+sxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZDRshPFnqK8uekK/7XVk/cpLVDIhx0KyfW3tjoOguCG/cRDK4CzHGWveQiTLJXDFAxseb7HIH4GLSqs1IvhlV7iXeCURHcAHyI7LhxMBaFO3pRrwPdhq8is64iIN2vG/lpnUYHDWY2iwWDYH0Q+xVkW0Xp0BSAoq5LZH2NQPHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bbqqBeZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bbqqBeZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3746BC4CEC6;
	Tue, 15 Oct 2024 12:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993747;
	bh=vytAFp2n9DINcKQE+XYr1p0gTiphVgb1lqrbMg2+sxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbqqBeZWrceJOHhNcPqPRWrioY9ky4fvg00/5hebPCvGu226YbO8ZqqEBkoWU2Z5s
	 rsJFMWZDJUgiPEYAvf1AcF9IGI6xA1/bFpMMLBIlyB010qHL0iw6R4gjyrLQB+YL//
	 gg+7F0R4zeyohk2rfuEWFAYf5cuyke+1H5Uo00/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ae688d469e36fb5138d0@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.15 503/691] ext4: no need to continue when the number of entries is 1
Date: Tue, 15 Oct 2024 13:27:31 +0200
Message-ID: <20241015112500.307527301@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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


