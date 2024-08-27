Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319FE1C6897;
	Tue, 27 Aug 2024 14:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769729; cv=none; b=YADq6ggwBNFuydhRXEesJOSMWtql1vxWJsQ9ZH3j/V9bfH3n5dw9SLBLR/T5OUVCvrD9cN1jATHKTnfX4bU6MTeHp5pz9CBr4s7xAl8Az/S/7XZo2KGnG3JMvKRM4NDUny/ehIRqjszshkegEZBuJqGGksb04oXCX9C1jaZkmcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769729; c=relaxed/simple;
	bh=M6JvdIi8AqnXR9tXa4wTCsP7wjtC4Ojr3jTzzGUgXcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUjSi59liViLQ5lMd02Fta1rBL/zkgdkvt8XVLDuiRRv4Rr5s/TQevzGDWQp83towNWr70F5rIVBkfg6Z8QSHojLwdf6InIu5TukEmaXwS7ZFesO872AnNphlElUJNqbxxDPsWtM1m+MdsfvtP2sqppxFEsE93+WiBABvLXola4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WVUBldh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WVUBldh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650CFC4AF15;
	Tue, 27 Aug 2024 14:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769728;
	bh=M6JvdIi8AqnXR9tXa4wTCsP7wjtC4Ojr3jTzzGUgXcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1WVUBldhzeRWBIH0hXCwPayQ+hq1bt3laMDy0TXRP7pdeAt++7Cn/RjTaxXWenDPl
	 6TRZVbVDtQ/SoaTZy+HA1pPO3oBh1SpN129LkjEuRgf/Ib5l5ZNwNFFMTub42i23e+
	 c4beL8b7U+z/h3JEImqriWrFUbI0oPAPh0HmXIWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 007/341] fuse: Initialize beyond-EOF page contents before setting uptodate
Date: Tue, 27 Aug 2024 16:33:58 +0200
Message-ID: <20240827143843.684695212@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit 3c0da3d163eb32f1f91891efaade027fa9b245b9 upstream.

fuse_notify_store(), unlike fuse_do_readpage(), does not enable page
zeroing (because it can be used to change partial page contents).

So fuse_notify_store() must be more careful to fully initialize page
contents (including parts of the page that are beyond end-of-file)
before marking the page uptodate.

The current code can leave beyond-EOF page contents uninitialized, which
makes these uninitialized page contents visible to userspace via mmap().

This is an information leak, but only affects systems which do not
enable init-on-alloc (via CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y or the
corresponding kernel command line parameter).

Link: https://bugs.chromium.org/p/project-zero/issues/detail?id=2574
Cc: stable@kernel.org
Fixes: a1d75f258230 ("fuse: add store request")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1618,9 +1618,11 @@ static int fuse_notify_store(struct fuse
 
 		this_num = min_t(unsigned, num, PAGE_SIZE - offset);
 		err = fuse_copy_page(cs, &page, offset, this_num, 0);
-		if (!err && offset == 0 &&
-		    (this_num == PAGE_SIZE || file_size == end))
+		if (!PageUptodate(page) && !err && offset == 0 &&
+		    (this_num == PAGE_SIZE || file_size == end)) {
+			zero_user_segment(page, this_num, PAGE_SIZE);
 			SetPageUptodate(page);
+		}
 		unlock_page(page);
 		put_page(page);
 


