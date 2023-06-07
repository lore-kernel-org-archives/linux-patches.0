Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A4F34CF6
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3DEC433D2;
	Wed,  7 Jun 2023 20:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169242;
	bh=AIbABzyTHD7AnBP4JE7Y1/B2zgdqwOA73Bxjgmug+D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozL+DX0O0I6m5aBcjI4u/svTCobxQI0dg5wFa7p6PesJJ/qvU26R4yF8GhVp1lkav
	 hcUcpUWmzcqCY3z6ZLBXQUNlA5yn9oeTTdk7p2gNPAYUy+miedIkK1fwmyDH94bymt
	 9mX10gBogC8Pci8GEenssvq2GiAODSb/GNJOYRyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Uttkarsh Aggarwal <quic_uaggarwa@quicinc.com>
Subject: [PATCH 4.14 39/61] usb: gadget: f_fs: Add unbind event before functionfs_unbind
Date: Wed,  7 Jun 2023 22:15:53 +0200
Message-ID: <20230607200848.860240752@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200835.310274198@linuxfoundation.org>
References: <20230607200835.310274198@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uttkarsh Aggarwal <quic_uaggarwa@quicinc.com>

commit efb6b535207395a5c7317993602e2503ca8cb4b3 upstream.

While exercising the unbind path, with the current implementation
the functionfs_unbind would be calling which waits for the ffs->mutex
to be available, however within the same time ffs_ep0_read is invoked
& if no setup packets are pending, it will invoke function
wait_event_interruptible_exclusive_locked_irq which by definition waits
for the ev.count to be increased inside the same mutex for which
functionfs_unbind is waiting.
This creates deadlock situation because the functionfs_unbind won't
get the lock until ev.count is increased which can only happen if
the caller ffs_func_unbind can proceed further.

Following is the illustration:

	CPU1				CPU2

ffs_func_unbind()		ffs_ep0_read()
				mutex_lock(ffs->mutex)
				wait_event(ffs->ev.count)
functionfs_unbind()
  mutex_lock(ffs->mutex)
  mutex_unlock(ffs->mutex)

ffs_event_add()

<deadlock>

Fix this by moving the event unbind before functionfs_unbind
to ensure the ev.count is incrased properly.

Fixes: 6a19da111057 ("usb: gadget: f_fs: Prevent race during ffs_ep0_queue_wait")
Cc: stable <stable@kernel.org>
Signed-off-by: Uttkarsh Aggarwal <quic_uaggarwa@quicinc.com>
Link: https://lore.kernel.org/r/20230525092854.7992-1-quic_uaggarwa@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -3500,6 +3500,7 @@ static void ffs_func_unbind(struct usb_c
 	/* Drain any pending AIO completions */
 	drain_workqueue(ffs->io_completion_wq);
 
+	ffs_event_add(ffs, FUNCTIONFS_UNBIND);
 	if (!--opts->refcnt)
 		functionfs_unbind(ffs);
 
@@ -3524,7 +3525,6 @@ static void ffs_func_unbind(struct usb_c
 	func->function.ssp_descriptors = NULL;
 	func->interfaces_nums = NULL;
 
-	ffs_event_add(ffs, FUNCTIONFS_UNBIND);
 }
 
 static struct usb_function *ffs_alloc(struct usb_function_instance *fi)


