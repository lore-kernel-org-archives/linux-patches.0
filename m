Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F4E8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD47C433D2;
	Mon, 13 Feb 2023 14:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676299942;
	bh=r/OMLJzhlrHg+5uzhwT/c328dR87L/lltmas73C3t4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BaH6hTkWRnjiKRfzY+EOxdlHdKEEbOFiDZqXk/vEYI1OjtNmiVvp9HHdEpvK0wlPC
	 RFbEO7tgpRvrn76w0ggwrKSxFSHBiVTTHIIcM1GEQhkZkc9TdCmuDOuIPTgj3DLldp
	 mjzZHuZjI8RIWWyXIzyhORryz2b4D9XesHICFIiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+14d9e7602ebdf7ec0a60@syzkaller.appspotmail.com,
	Alexander Potapenko <glider@google.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 003/114] btrfs: zlib: zero-initialize zlib workspace
Date: Mon, 13 Feb 2023 15:47:18 +0100
Message-Id: <20230213144742.388554905@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Potapenko <glider@google.com>

commit eadd7deca0ad8a83edb2b894d8326c78e78635d6 upstream.

KMSAN reports uses of uninitialized memory in zlib's longest_match()
called on memory originating from zlib_alloc_workspace().
This issue is known by zlib maintainers and is claimed to be harmless,
but to be on the safe side we'd better initialize the memory.

Link: https://zlib.net/zlib_faq.html#faq36
Reported-by: syzbot+14d9e7602ebdf7ec0a60@syzkaller.appspotmail.com
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/zlib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -63,7 +63,7 @@ struct list_head *zlib_alloc_workspace(u
 
 	workspacesize = max(zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL),
 			zlib_inflate_workspacesize());
-	workspace->strm.workspace = kvmalloc(workspacesize, GFP_KERNEL);
+	workspace->strm.workspace = kvzalloc(workspacesize, GFP_KERNEL);
 	workspace->level = level;
 	workspace->buf = NULL;
 	/*


