Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CECD46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93567C433D2;
	Mon, 16 Jan 2023 16:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886358;
	bh=u9WqrnPVJ9jQElT9xcrWeDMun1mCi1qBsOZz8BvriCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvM4jAfLnFC/NW/1/LaOKAHK5umWmcbL5wibT3Yp/MjMbbNyFMHlLxfqRVBe7e1Z0
	 IKztYcFk6jCjlJiKBc6F48inPgpVx0JE0aX0J4JMHortRdygj20ZQYVaJHkk08B1aQ
	 KhVc7Mknu06LY6cuXPBPNW7ZbHR6zjZ1AOSRqakY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yuchen <zhangyuchen.lcr@bytedance.com>,
	Corey Minyard <cminyard@mvista.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 400/658] ipmi: fix memleak when unload ipmi driver
Date: Mon, 16 Jan 2023 16:48:08 +0100
Message-Id: <20230116154927.876589329@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Yuchen <zhangyuchen.lcr@bytedance.com>

[ Upstream commit 36992eb6b9b83f7f9cdc8e74fb5799d7b52e83e9 ]

After the IPMI disconnect problem, the memory kept rising and we tried
to unload the driver to free the memory. However, only part of the
free memory is recovered after the driver is uninstalled. Using
ebpf to hook free functions, we find that neither ipmi_user nor
ipmi_smi_msg is free, only ipmi_recv_msg is free.

We find that the deliver_smi_err_response call in clean_smi_msgs does
the destroy processing on each message from the xmit_msg queue without
checking the return value and free ipmi_smi_msg.

deliver_smi_err_response is called only at this location. Adding the
free handling has no effect.

To verify, try using ebpf to trace the free function.

  $ bpftrace -e 'kretprobe:ipmi_alloc_recv_msg {printf("alloc rcv
      %p\n",retval);} kprobe:free_recv_msg {printf("free recv %p\n",
      arg0)} kretprobe:ipmi_alloc_smi_msg {printf("alloc smi %p\n",
        retval);} kprobe:free_smi_msg {printf("free smi  %p\n",arg0)}'

Signed-off-by: Zhang Yuchen <zhangyuchen.lcr@bytedance.com>
Message-Id: <20221007092617.87597-4-zhangyuchen.lcr@bytedance.com>
[Fixed the comment above handle_one_recv_msg().]
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 736970312bbc..55f38058c0b4 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3535,12 +3535,16 @@ static void deliver_smi_err_response(struct ipmi_smi *intf,
 				     struct ipmi_smi_msg *msg,
 				     unsigned char err)
 {
+	int rv;
 	msg->rsp[0] = msg->data[0] | 4;
 	msg->rsp[1] = msg->data[1];
 	msg->rsp[2] = err;
 	msg->rsp_size = 3;
-	/* It's an error, so it will never requeue, no need to check return. */
-	handle_one_recv_msg(intf, msg);
+
+	/* This will never requeue, but it may ask us to free the message. */
+	rv = handle_one_recv_msg(intf, msg);
+	if (rv == 0)
+		ipmi_free_smi_msg(msg);
 }
 
 static void cleanup_smi_msgs(struct ipmi_smi *intf)
-- 
2.35.1



