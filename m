Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6726322D9E7;
	Mon,  2 Jun 2025 15:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876887; cv=none; b=ESCI65EhfLrZeNArict4k84CxO9TaUe9WkO9Is0wWTjUDhlTFbBf1lZL3xlf29NeWaLBjezj/1+NAgKtyugN5wSoxZ5ZGKqVIR8W2qVvdQbVtuLN1C0td7OzKx69aX0jBVTvrlc4bkr13SWwLTqDj5VMAprKekiDiPB3o+IGWVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876887; c=relaxed/simple;
	bh=VCkwJfG2TFI61pWvJ+xhhJN2I/Ozy6V7GhH9INONLjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHzMbRpf0VG1k8JdQfM08kFTNQgRFQiqsJsTe+ONLShfKeko54p1W1nmxbLf+lxUAcJo0J5dTAyc/20WOGkTO+ICEj+tsWluse1cj502dcPz9oFxCJmPkH2vkbOKfCOGL1yXESTjP6XxPjBPXcI9wyrQk8m+yFkVqzOwfdxRWJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RfS0RsL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RfS0RsL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51CFC4CEEB;
	Mon,  2 Jun 2025 15:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876887;
	bh=VCkwJfG2TFI61pWvJ+xhhJN2I/Ozy6V7GhH9INONLjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RfS0RsL1U0sg0rRCmZQMXh27zZ8kt/m/V0BGDKuHYUSoNLp4RETbZDxtqSmivBIdH
	 sn5T0VgICcXL4DaUQ1/7+ZWbpvjk9dQPesmgbdB0aDU/o59Bgic5CK4zWZ0G4D5s6y
	 l3zRsQ9JiSGDjV3pLLU7tW4A84Ele4rFa5NlfbSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mike Marshall <hubcap@omnibond.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/325] orangefs: Do not truncate file size
Date: Mon,  2 Jun 2025 15:46:20 +0200
Message-ID: <20250602134324.009229626@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 062e8093592fb866b8e016641a8b27feb6ac509d ]

'len' is used to store the result of i_size_read(), so making 'len'
a size_t results in truncation to 4GiB on 32-bit systems.

Signed-off-by: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Link: https://lore.kernel.org/r/20250305204734.1475264-2-willy@infradead.org
Tested-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/inode.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index b3bbb5a5787ac..cc81ff6ac735e 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -23,9 +23,9 @@ static int orangefs_writepage_locked(struct page *page,
 	struct orangefs_write_range *wr = NULL;
 	struct iov_iter iter;
 	struct bio_vec bv;
-	size_t len, wlen;
+	size_t wlen;
 	ssize_t ret;
-	loff_t off;
+	loff_t len, off;
 
 	set_page_writeback(page);
 
@@ -94,8 +94,7 @@ static int orangefs_writepages_work(struct orangefs_writepages *ow,
 	struct orangefs_write_range *wrp, wr;
 	struct iov_iter iter;
 	ssize_t ret;
-	size_t len;
-	loff_t off;
+	loff_t len, off;
 	int i;
 
 	len = i_size_read(inode);
-- 
2.39.5



