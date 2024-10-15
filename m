Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D841DD0F6;
	Tue, 15 Oct 2024 13:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998095; cv=none; b=Qyq2tMPFf3z0qai76C4Qrrb+Lew0uG11Z2GqyCFWPBDbh7N4w3nfz7wGmnZDEOuNSney1caMq+X204NXC+1gTTF0TVPQ+BFjSnPMmdGS+jLnLgLhvaddcB4GiLOFfzXtTh/ee2yUtTU79cHc3uj9Gl4qS2VM81UleTy+OUXC1U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998095; c=relaxed/simple;
	bh=HmZkGp9qmhAx+MhTBlJ3OHaxoTMPsNMiR7AIyeHrl4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkZvIRz1jbn67ceS8VlW6SIL9isd6ajS+akkRntk5rIuiLdmL5Ftm5GObJgFwLNKD4n+Ayb8/15X5D2OyjRHNS40vpG/YKiTYfH2DqducK32/Y7qZ8DijnF2eTPhjXrnlmaDJTSSVI3QW21X4yLQS+Hz1MZxAOmzor62KotuwNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oG2IqydB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oG2IqydB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8ACC4CEC6;
	Tue, 15 Oct 2024 13:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998095;
	bh=HmZkGp9qmhAx+MhTBlJ3OHaxoTMPsNMiR7AIyeHrl4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oG2IqydB/MDNn6+LI5ke3gihkzr8spmT1ypduRWSv5NsyialW99R53qa/+MBNq4+w
	 TfFxSt4YhDHBzj2/3yiSCDttRCQ/OG+su7kcpYV830cHaWlE97iS7iYhYIW1j3wHDe
	 viMptwfR5V5FVFCGmcAURNLspYZMiVX/1Fl7wm1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ae688d469e36fb5138d0@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.10 370/518] ext4: no need to continue when the number of entries is 1
Date: Tue, 15 Oct 2024 14:44:34 +0200
Message-ID: <20241015123931.254316333@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1936,7 +1936,7 @@ static struct ext4_dir_entry_2 *do_split
 		split = count/2;
 
 	hash2 = map[split].hash;
-	continued = hash2 == map[split - 1].hash;
+	continued = split > 0 ? hash2 == map[split - 1].hash : 0;
 	dxtrace(printk(KERN_INFO "Split block %lu at %x, %i/%i\n",
 			(unsigned long)dx_get_block(frame->at),
 					hash2, split, count-split));


