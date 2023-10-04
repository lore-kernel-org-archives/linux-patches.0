Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEC01D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kR4L9ciB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8609FC433C8;
	Wed,  4 Oct 2023 18:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443630;
	bh=+g+/Y8bUhwqWUOAsq4aLIISw9veiwxng81GuE1vYuBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kR4L9ciBRIGobMhKfDiDO7i2RIk3cUryE9mCSNF2g/lbEXKzuZC7y3FnNFJqHZ6uq
	 1rdR9mkfm/g/ivTOULcYQNXZSYO0ynX9lt7n2ooG1RZXtDUzszNMIwj9VDHfJgNa0p
	 7TIEVfyCWCvrTn2OhBNod58Vqbr9pWsFtgF6AVMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 6.1 217/259] Revert "tty: n_gsm: fix UAF in gsm_cleanup_mux"
Date: Wed,  4 Oct 2023 19:56:30 +0200
Message-ID: <20231004175227.286633566@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Starke <daniel.starke@siemens.com>

commit 29346e217b8ab8a52889b88f00b268278d6b7668 upstream.

This reverts commit 9b9c8195f3f0d74a826077fc1c01b9ee74907239.

The commit above is reverted as it did not solve the original issue.

gsm_cleanup_mux() tries to free up the virtual ttys by calling
gsm_dlci_release() for each available DLCI. There, dlci_put() is called to
decrease the reference counter for the DLCI via tty_port_put() which
finally calls gsm_dlci_free(). This already clears the pointer which is
being checked in gsm_cleanup_mux() before calling gsm_dlci_release().
Therefore, it is not necessary to clear this pointer in gsm_cleanup_mux()
as done in the reverted commit. The commit introduces a null pointer
dereference:
 <TASK>
 ? __die+0x1f/0x70
 ? page_fault_oops+0x156/0x420
 ? search_exception_tables+0x37/0x50
 ? fixup_exception+0x21/0x310
 ? exc_page_fault+0x69/0x150
 ? asm_exc_page_fault+0x26/0x30
 ? tty_port_put+0x19/0xa0
 gsmtty_cleanup+0x29/0x80 [n_gsm]
 release_one_tty+0x37/0xe0
 process_one_work+0x1e6/0x3e0
 worker_thread+0x4c/0x3d0
 ? __pfx_worker_thread+0x10/0x10
 kthread+0xe1/0x110
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x2f/0x50
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1b/0x30
 </TASK>

The actual issue is that nothing guards dlci_put() from being called
multiple times while the tty driver was triggered but did not yet finished
calling gsm_dlci_free().

Fixes: 9b9c8195f3f0 ("tty: n_gsm: fix UAF in gsm_cleanup_mux")
Cc: stable <stable@kernel.org>
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20230914051507.3240-1-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2509,10 +2509,8 @@ static void gsm_cleanup_mux(struct gsm_m
 		gsm->has_devices = false;
 	}
 	for (i = NUM_DLCI - 1; i >= 0; i--)
-		if (gsm->dlci[i]) {
+		if (gsm->dlci[i])
 			gsm_dlci_release(gsm->dlci[i]);
-			gsm->dlci[i] = NULL;
-		}
 	mutex_unlock(&gsm->mutex);
 	/* Now wipe the queues */
 	tty_ldisc_flush(gsm->tty);


