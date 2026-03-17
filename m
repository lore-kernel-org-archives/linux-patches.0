Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE65F3F54C2;
	Tue, 17 Mar 2026 17:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767024; cv=none; b=D1kXvwBhB4F5PNvIDxX72EK9phhQrAZgSUd0j6sT2QPEvSYaPRAcKXLIvGLYZJ+j3yi00DDzqZ4zPim4IV45uo/ygnHm1f7cDpVu/ReeomEL0Obr8Td+lxNtIHQLKc3PEcp5x5LZVwAJPybslKJyrtPCbQA1uz4F/VnNa2bPOvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767024; c=relaxed/simple;
	bh=tuk4V/rYzR3gjXQ1tIgFK+UsBJuMf4B7JDhqpE3iYLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJ6Af1TMrRy4h6YlUOqiZCgj0gnor1cjk4V7VB+pbLtmYLYMVGENaV5cbauOzs31R85LGNr3PJGKCmwHLoN/RO80l3EgcJH/NFgQ6atfgdZ0rti3pvmqdUD616q7wNDsWjFrDD356d4f4a6WjXVtbZaEL1XyMELeR4HKo2JOZ/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwOssNQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwOssNQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA40C2BC86;
	Tue, 17 Mar 2026 17:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767023;
	bh=tuk4V/rYzR3gjXQ1tIgFK+UsBJuMf4B7JDhqpE3iYLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwOssNQTfCofDIu4UvzZ8jGLbnDaNR7bQFtZJXXBpUUIjhROlNsnbhYsVOc8QRJBu
	 quWV3xGsVc/Fq0fkHwWtIYp70TMeB5eIXSlg93xLexryKz3DWJC1OW+F0hwiM6m4I4
	 8U9WIpPJGE0rUaDoN9geh7ZQS+1pMPeoLT6M5rHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	Bart Van Assche <bvanassche@acm.org>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.19 344/378] btrfs: add missing RCU unlock in error path in try_release_subpage_extent_buffer()
Date: Tue, 17 Mar 2026 17:35:01 +0100
Message-ID: <20260317163019.647352027@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit b2840e33127ce0eea880504b7f133e780f567a9b upstream.

Call rcu_read_lock() before exiting the loop in
try_release_subpage_extent_buffer() because there is a rcu_read_unlock()
call past the loop.

This has been detected by the Clang thread-safety analyzer.

Fixes: ad580dfa388f ("btrfs: fix subpage deadlock in try_release_subpage_extent_buffer()")
CC: stable@vger.kernel.org # 6.18+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4475,6 +4475,7 @@ static int try_release_subpage_extent_bu
 		 */
 		if (!test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags)) {
 			spin_unlock(&eb->refs_lock);
+			rcu_read_lock();
 			break;
 		}
 


