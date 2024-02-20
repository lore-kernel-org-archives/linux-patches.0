Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE43446C9;
	Tue, 20 Feb 2024 21:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464868; cv=none; b=fM+xRYHL4flPaYkheNDyB6xvEMeP5yfu6O1V83ZOELzsFFHoITr2r874YAGHpy2VnIFlCJfrXppBm4wZPsGGXbXznY0WnAKhX+AxXFn7VIEJPCdoKjrQN8MPQyRPYiRmj0pmuFFLaYLkJaMvmuMaDxOKAhZMFCNoP3gis6GwPxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464868; c=relaxed/simple;
	bh=FBPTwYJSI02jqHQw3KamrTfux2F8/vre2eMK0xWVLh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppmUhNOQ0qqPGyuLum9q6Tf45VvzglKPk/GtMjVxP6uymxCoSHj2Tmhujj45oPeaLfv3vXxTzWSzVxKMqxSyNwd8nlkqsMrdLfBeFN2ZoCk6N85pSWdklNR6nhkKat1qCd6Gbby7N7c7zH9KzhxcOcqs4ETuS3az9SzxWmYPaRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nLOJEc9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nLOJEc9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A10FC433C7;
	Tue, 20 Feb 2024 21:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464868;
	bh=FBPTwYJSI02jqHQw3KamrTfux2F8/vre2eMK0xWVLh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nLOJEc9DvbvEvOaF9xQj3IxCi71GdNt9xRiu0KKJ7Hm2Y1dVxwPrjn/oViigWI0EC
	 efUEi5h5QQt9xwduORqswCYzCq1gL8RW6mK7+L1hHj4EHlqGHsUfF/m27e2qT7ChVr
	 fTy4LaqO/zNzc1AdQkjUxf94/JDTENW5Fa8QkLS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Keqi Wang <wangkeqi_chris@163.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.7 132/309] connector/cn_proc: revert "connector: Fix proc_event_num_listeners count not cleared"
Date: Tue, 20 Feb 2024 21:54:51 +0100
Message-ID: <20240220205637.277173975@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


