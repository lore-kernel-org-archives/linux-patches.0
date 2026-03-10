Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7244C1C5D44;
	Tue, 10 Mar 2026 11:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142111; cv=none; b=cNBOEflZtLS5lyYLHKnBsCo9CWhaXrnLR5s+4y4+7EcYkfoHlUTBy7R5AMLfsXHWcyuN7WEbZT1A/zSVBlxOXj3I+kSnNpb8TDHp/OOZoxMkshndt0dhhPdpXiIrVjyhoD1rnrr0U8O+FcAffp0n2eDESqbS/WEyRjqGyNYRENo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142111; c=relaxed/simple;
	bh=MWijD6Tk69EfdLG+jiIlAMBomWGwws4BCg2dAX4+WyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QO8iu4ojiP/IlujiSEjrI90lUHsaqyrxIx1B/2e9tdqpPnafhSIhJX4xzsFisEswKbMGyMtquQ6c28k3pwDYUZTgmrmXx994+c4a5NDmIcpnBqWrY5dfpbjtCOe8Uf/3ZK3vspc8mo8m8PsLJuWMZz6TpR0Tzb5hMpFjTVMn3fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kg2bC9L3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kg2bC9L3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7345C19423;
	Tue, 10 Mar 2026 11:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142111;
	bh=MWijD6Tk69EfdLG+jiIlAMBomWGwws4BCg2dAX4+WyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kg2bC9L3enCQ1ge8t0SGj4IuO+gPcWAweQJSXC3tBz4vOOxelXve+pIquwfSxLICb
	 g+OFg3qdvJRPCDXJAPqYRt9T9QMer5yzsf7zV6iR8cF9pOrWoi/+0SC0tgYNrKWNgJ
	 saVyIsyrx3QVsoUxgvQ+cLhklV6yd5jyfzs6jHb9JzvUNvPkdrM+0mcSRcNhEjFhK2
	 OJYaAZ3FoSPsLMb2Gdu6Yy2lge1zUUNFQjxRuF+ZeGH7hiZ+ySAu9NFmoKUMeLMLvw
	 XbOidzFWeza03MGLEYVTjCq6a7IbqH0IQQ3/DUvJDByc9UH3ANZK2mAbXGNDDrdXlL
	 fGLUSjqA44NnQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Corey Minyard <corey@minyard.net>,
	Breno Leitao <leitao@debian.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 199/314] ipmi: Fix use-after-free and list corruption on sender error
Date: Tue, 10 Mar 2026 07:17:38 -0400
Message-ID: <55797fb9737e6ca1b92d1a722385a5fee24d841d.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Corey Minyard <corey@minyard.net>

commit 594c11d0e1d445f580898a2b8c850f2e3f099368 upstream.

The analysis from Breno:

When the SMI sender returns an error, smi_work() delivers an error
response but then jumps back to restart without cleaning up properly:

1. intf->curr_msg is not cleared, so no new message is pulled
2. newmsg still points to the message, causing sender() to be called
   again with the same message
3. If sender() fails again, deliver_err_response() is called with
   the same recv_msg that was already queued for delivery

This causes list_add corruption ("list_add double add") because the
recv_msg is added to the user_msgs list twice. Subsequently, the
corrupted list leads to use-after-free when the memory is freed and
reused, and eventually a NULL pointer dereference when accessing
recv_msg->done.

The buggy sequence:

  sender() fails
    -> deliver_err_response(recv_msg)  // recv_msg queued for delivery
    -> goto restart                    // curr_msg not cleared!
  sender() fails again (same message!)
    -> deliver_err_response(recv_msg)  // tries to queue same recv_msg
    -> LIST CORRUPTION

Fix this by freeing the message and setting it to NULL on a send error.
Also, always free the newmsg on a send error, otherwise it will leak.

Reported-by: Breno Leitao <leitao@debian.org>
Closes: https://lore.kernel.org/lkml/20260127-ipmi-v1-0-ba5cc90f516f@debian.org/
Fixes: 9cf93a8fa9513 ("ipmi: Allow an SMI sender to return an error")
Cc: stable@vger.kernel.org # 4.18
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 0a886399f9daf..5ed8e95589fb7 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -4848,8 +4848,15 @@ static void smi_work(struct work_struct *t)
 			if (newmsg->recv_msg)
 				deliver_err_response(intf,
 						     newmsg->recv_msg, cc);
-			else
-				ipmi_free_smi_msg(newmsg);
+			if (!run_to_completion)
+				spin_lock_irqsave(&intf->xmit_msgs_lock,
+						  flags);
+			intf->curr_msg = NULL;
+			if (!run_to_completion)
+				spin_unlock_irqrestore(&intf->xmit_msgs_lock,
+						       flags);
+			ipmi_free_smi_msg(newmsg);
+			newmsg = NULL;
 			goto restart;
 		}
 	}
-- 
2.51.0

