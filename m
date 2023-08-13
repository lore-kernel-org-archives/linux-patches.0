Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B979443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB5EC433C8;
	Sun, 13 Aug 2023 21:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961990;
	bh=grkV0e1HVms14phTa8TYPuHKkH63kWXIlRPo12TX4Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1z6M7QVUQr7h1nDwO9SrwWc8ibsJ5KzInD5/2yZMehgoK2jAiU+uvYZ3SsZJ/9nN0
	 01A1Ff+llZ+r/4rXpGdoUXokEmsnxTr3GlmORuZUM+5rw4HyC7fimofEcIQ1xbsHez
	 LvjG7XpTAPP/WmTeSogL9Nq8P1ClzgSeijfuu8RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.4 073/206] thunderbolt: Fix memory leak in tb_handle_dp_bandwidth_request()
Date: Sun, 13 Aug 2023 23:17:23 +0200
Message-ID: <20230813211727.157832311@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 596a5123cc782d458b057eb3837e66535cd0befa upstream.

The memory allocated in tb_queue_dp_bandwidth_request() needs to be
released once the request is handled to avoid leaking it.

Fixes: 6ce3563520be ("thunderbolt: Add support for DisplayPort bandwidth allocation mode")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -1810,6 +1810,8 @@ unlock:
 
 	pm_runtime_mark_last_busy(&tb->dev);
 	pm_runtime_put_autosuspend(&tb->dev);
+
+	kfree(ev);
 }
 
 static void tb_queue_dp_bandwidth_request(struct tb *tb, u64 route, u8 port)


