Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69ADB1DDA15;
	Tue,  8 Oct 2024 12:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390557; cv=none; b=nY7ZAO2Olxs0xHn6art6a5rd+HcV3urTlqsM/zRpGXhw/RQ1I9vSdOJP37ahWZQgieRqKmH4uzPu12mgKsOeF+OdOmzK+jMDG61oPKbDI22+0Ag8O6hdWT8kvKlulcemcyG/7RKi04F/J03KfZFZ4tAF1F4+iFL+35y2wpwLuBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390557; c=relaxed/simple;
	bh=9w9MG/UjwBDDK047W8FyqhPL0fmodjl9IL+QFZET91c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRHOszQYHa2fbbQJuU+M+ygUgQ0eCrXC5YzuMcR0B4TCXRUWVq94zpDNE3N46TSUG29uMXuzm+emul2ofR+RIDy8QR6SfRz10rsHrg7DzZ7uxRQ/nGuJDN/E/8EfEKSBF3zjijJea6KLIKZwjccGwUSJTbHUa5164iorcXGb/yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvrjDSsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvrjDSsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90EFC4CEC7;
	Tue,  8 Oct 2024 12:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390557;
	bh=9w9MG/UjwBDDK047W8FyqhPL0fmodjl9IL+QFZET91c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvrjDSslWWHNqmvaLcYBqb/IVD7/0MhSe3XczOnuSr83cUzDvpDdIoe8YvxdQ5JkR
	 bSQ1S/XwK42AVEVBByFQtnDdpaiy9vfQebWF+k3cLkNoMix1BFU+mRjH7OD9x/y57n
	 EBo6OWHO9wHrM4IquuJkyHRBOWE+AmpqN7CguyCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ae688d469e36fb5138d0@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.10 322/482] ext4: no need to continue when the number of entries is 1
Date: Tue,  8 Oct 2024 14:06:25 +0200
Message-ID: <20241008115701.099585142@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2046,7 +2046,7 @@ static struct ext4_dir_entry_2 *do_split
 		split = count/2;
 
 	hash2 = map[split].hash;
-	continued = hash2 == map[split - 1].hash;
+	continued = split > 0 ? hash2 == map[split - 1].hash : 0;
 	dxtrace(printk(KERN_INFO "Split block %lu at %x, %i/%i\n",
 			(unsigned long)dx_get_block(frame->at),
 					hash2, split, count-split));


