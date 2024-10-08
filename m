Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53801DFE2F;
	Tue,  8 Oct 2024 13:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393811; cv=none; b=DYR4Bmhq5NJdZzELQ2rP8Z/RajImZvAtLx247f+Incur2IKvwSXqD+SurRBVMvWMcZ8W52KU4BLeBR1F4C0kVeqT7C3Kr1QC8Z6wFXQQvGA0RgRc5Pz8wUzz1EJe4ebae8uFQaKTo9fljf5BkfE7aZSU0I/vML/k1ne7Kn0lzCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393811; c=relaxed/simple;
	bh=TwOEAff8HbIzJOS0wT8i4PQyf3kypR1Jkl8KSmhAnvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APkIVn3Uu89ryL9B6pSsXyQMEUOm/qnofGTJxGJwc8tnZRC4oBd27/P707FDqIuYv295ohDOSsp8UUQtAk0uEx9Oayl1qmgYz2UtAby5ZBO8tyCrlnXiSmQxLgjIgMXt3/AuJ/3isPbQ1eVIgFxNW+n2Em0BoqSmo6Bi3TEOvMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Skk9K2m+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Skk9K2m+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E056C4CEC7;
	Tue,  8 Oct 2024 13:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393811;
	bh=TwOEAff8HbIzJOS0wT8i4PQyf3kypR1Jkl8KSmhAnvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Skk9K2m+08GoTMzyVjXVvK6dxfj+ojvavPyCdFWlVd83N4D5ITyG/5bP2QjONO3b6
	 aJmeDHwm4GHbBBVVtUjn1J5AJa/AZWOaEzOQTaSada2O912jOl4oEXvU5WuAItidD1
	 hKUeVS9p0dKrYC/FjDYeKAywOlTLA7XjoVtNv4BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ae688d469e36fb5138d0@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 231/386] ext4: no need to continue when the number of entries is 1
Date: Tue,  8 Oct 2024 14:07:56 +0200
Message-ID: <20241008115638.493803409@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


