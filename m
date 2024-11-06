Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526951D86E8;
	Wed,  6 Nov 2024 13:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898462; cv=none; b=N4EAY+VAryv5UGu3uXtnfzu/7Gj0UpAnrse0S5E/HIAnP7hXZSNFvxZhADGlJ1Qzy8DpQXAfx8cs7NQnVhH4jUUVhgR6Tff3f0ndE63unbNjp0UgnIaEsVecpH0DXTSKgJxArH1L7x9aphIlnimdNnV4NZ+UyOznj2C+k09MUBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898462; c=relaxed/simple;
	bh=rbye4YXE5j3ATjuRbJq2tNC4fjjxiCcaf7ZHLAtfiXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDnm1z0zDJBIhQjWmAeYg4N3gI5tvYXNU9nZ2I4wTbm2u/ix1xB3tU0rlnEac1YuHdmqIIUb0FvPq2a7CHYSYZPxBGATrq6jVUJpgKIPVAeF01BN/oPRy1qMOwNwOCyoPWhVh8axcfbLSAeHVANF05/JxR+ZwI43pN3W3HFJVMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBeJ1i8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBeJ1i8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5A5C4CECD;
	Wed,  6 Nov 2024 13:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898462;
	bh=rbye4YXE5j3ATjuRbJq2tNC4fjjxiCcaf7ZHLAtfiXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBeJ1i8B6lYC5Gkko0kzqaeKInvWQqq9R+3OU2SejfalBqoi9GUNt6nxyFm/dUexQ
	 9LLU0SnagZqk4CaDL+dWtPcSU/xudWQJjlLfzjHVvoqzLh561YdQVCtV/tGbgD3kef
	 t0fBOTck7ZUYzpdj0k2zq5lbwWK/29Iu2tvQeWTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ae688d469e36fb5138d0@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.4 246/462] ext4: no need to continue when the number of entries is 1
Date: Wed,  6 Nov 2024 13:02:19 +0100
Message-ID: <20241106120337.602147288@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1924,7 +1924,7 @@ static struct ext4_dir_entry_2 *do_split
 		split = count/2;
 
 	hash2 = map[split].hash;
-	continued = hash2 == map[split - 1].hash;
+	continued = split > 0 ? hash2 == map[split - 1].hash : 0;
 	dxtrace(printk(KERN_INFO "Split block %lu at %x, %i/%i\n",
 			(unsigned long)dx_get_block(frame->at),
 					hash2, split, count-split));


