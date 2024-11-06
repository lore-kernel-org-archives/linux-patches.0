Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546461DE8A2;
	Wed,  6 Nov 2024 12:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895350; cv=none; b=WFYhtMkgfsJK+0XHC84J6hk5fPHqq38qrkNfPqPLmIrvtMmNZT6TDgvtRd9/s+oM8KeQDt2wXZIhUT+dmHK2/3gUSfl+FG2vXvkcPVklcAyfvuzsltsKkzAnfTztnqsBnSGI21wSbtHlNWtOLuZAnHcE4jh+/aRg3CQ+I5Fd3JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895350; c=relaxed/simple;
	bh=0MKfJR2N5nZQiMADHSpEEYKzsKySVXX6f7TTG/PpXL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auXb+FMDDMRajirSUPi8ybPK3Sp0BQn1bM8v/1skzBKKk7EQXvGTt42IsbZ/HPDqQJ7TUZ7B1yffXfpiQjjFSEoDAAxYKcL14lNo1HD75JDZxxvq7pEBrg4cD2aIcCHaM+w0P3LQ1fR6EE0OqYMZt47XCvKcfSiu3fOWVf3jojA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=inhuS4Tk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inhuS4Tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEAE9C4CECD;
	Wed,  6 Nov 2024 12:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895350;
	bh=0MKfJR2N5nZQiMADHSpEEYKzsKySVXX6f7TTG/PpXL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inhuS4TkWwxlVoeuHLGcIg0FuHeps0WslTmTzCef7iKoiolOuF7wdjLqEGFR3QPqn
	 jOdDWNhWI0LXL40nTRL54tNAfM7pYGgiWHHh3Soimn19T3ZP5vPJfzxVEeT7PT4JYq
	 MxlNNlLb5sRWVN/ubNdcu8voEitrtnCNg9la2upY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ae688d469e36fb5138d0@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 4.19 188/350] ext4: no need to continue when the number of entries is 1
Date: Wed,  6 Nov 2024 13:01:56 +0100
Message-ID: <20241106120325.598920889@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1832,7 +1832,7 @@ static struct ext4_dir_entry_2 *do_split
 		split = count/2;
 
 	hash2 = map[split].hash;
-	continued = hash2 == map[split - 1].hash;
+	continued = split > 0 ? hash2 == map[split - 1].hash : 0;
 	dxtrace(printk(KERN_INFO "Split block %lu at %x, %i/%i\n",
 			(unsigned long)dx_get_block(frame->at),
 					hash2, split, count-split));


