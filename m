Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82574151CD8;
	Tue, 20 Feb 2024 21:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463781; cv=none; b=p99D+JF/LfNHZp5kLqB7kPQFFu/cYxI8tugsJAuafqX3Bo3jhEuR7iSS9/kpGgbMiQ2c6CNR4lzU51No4BnMlCUwZDlXJen8M0jfDHKsXbolJYvLUxclzn810oKJTw+08ewL9CI5N4O3PQnskROpyhzgQ0C+NvDrHIinIdSvJTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463781; c=relaxed/simple;
	bh=Zz1HhAQQsaN9xefVCj0ZUMWwzkJfXIffNxyqQsE8C90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVG0wHacGMo7Rn0K7ZqD/jcdykqFTgEoRciT/V5XZa6o6wvvFAmzqTGXsTODZf0mT1WrcD36yoaFUuSeMDISZC0uCvqPXY5/09WRUjMBotoFd3HXq2E3/kTSyoJXcQDarCFhi6kqhwVZFwzPEVhBAmZaciGDcY/OVEsYz/7f5cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVgvrjs4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVgvrjs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E05C433C7;
	Tue, 20 Feb 2024 21:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463781;
	bh=Zz1HhAQQsaN9xefVCj0ZUMWwzkJfXIffNxyqQsE8C90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QVgvrjs46mHpy6MZCRVXoVoZ8FZ1uy95liaRBzdEtlSa2aMloZrWmdyy7Uy9+MViO
	 DnRAhwV7Kqs+UTI+2LyaW/ELuXQINwySMenqJWa+zsTuS0715a/bfSShk9QlbRya2e
	 2MQJackW+IEmKXMuv/ZNEIajctVeTn/9rDG2lHxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Keqi Wang <wangkeqi_chris@163.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 121/331] connector/cn_proc: revert "connector: Fix proc_event_num_listeners count not cleared"
Date: Tue, 20 Feb 2024 21:53:57 +0100
Message-ID: <20240220205641.408311658@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Keqi Wang <wangkeqi_chris@163.com>

commit 8929f95b2b587791a7dcd04cc91520194a76d3a6 upstream.

This reverts commit c46bfba1337d ("connector: Fix proc_event_num_listeners
count not cleared").

It is not accurate to reset proc_event_num_listeners according to
cn_netlink_send_mult() return value -ESRCH.

In the case of stress-ng netlink-proc, -ESRCH will always be returned,
because netlink_broadcast_filtered will return -ESRCH,
which may cause stress-ng netlink-proc performance degradation.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202401112259.b23a1567-oliver.sang@intel.com
Fixes: c46bfba1337d ("connector: Fix proc_event_num_listeners count not cleared")
Signed-off-by: Keqi Wang <wangkeqi_chris@163.com>
Link: https://lore.kernel.org/r/20240209091659.68723-1-wangkeqi_chris@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/connector/cn_proc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -108,9 +108,8 @@ static inline void send_msg(struct cn_ms
 		filter_data[1] = 0;
 	}
 
-	if (cn_netlink_send_mult(msg, msg->len, 0, CN_IDX_PROC, GFP_NOWAIT,
-			     cn_filter, (void *)filter_data) == -ESRCH)
-		atomic_set(&proc_event_num_listeners, 0);
+	cn_netlink_send_mult(msg, msg->len, 0, CN_IDX_PROC, GFP_NOWAIT,
+			     cn_filter, (void *)filter_data);
 
 	local_unlock(&local_event.lock);
 }


