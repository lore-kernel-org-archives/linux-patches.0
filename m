Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E2817BEAD;
	Thu, 15 Aug 2024 14:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731319; cv=none; b=RASTUWRYJkn9ascjwfceMGNm/T29kcv3kK3s7PpI6HeHEx2ifQgef/Pd5yeBjufo4gKjfu72uF3nwQwfKFIdZvFWnlojukCPhAgFUXQPSvdagWfC9lNvITFx4QLdHDR3Wsmm5SeHS0LdczQPnyOcatoHXxzoiOEF//cSKY4Ap5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731319; c=relaxed/simple;
	bh=wDm0VU9wP60CxTk3XiQpx6oQ3ZIM1f/6UgMdnlKyGUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkKVnABjfQzZFyI3ZO2HjXNul70/vzbRzbA+/Gt3SeeMXiGVs3jdrQRsP8cWjtfqOFkQywO35/9snUuJb3UpTIkAH3bQuzPDLKtwLESQoUhnv11e/z1npRG+AIOT/EreROIpi2Rh3VTZByTesC5Wu2Bs1ZFEwIblE4UBtSjcux4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iC+g30Gb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iC+g30Gb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD39C32786;
	Thu, 15 Aug 2024 14:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731319;
	bh=wDm0VU9wP60CxTk3XiQpx6oQ3ZIM1f/6UgMdnlKyGUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iC+g30GbF1Ep5pl0MaV5HGA3ubA6NE11xMkkRz/+A0lwGfxX+MUHlMDEjpo1XyM5z
	 aIzhciGWfMAEADBdqoMibKt3iaG7pI024zTW0RssgSyhs89IqylkYxtmgOXd3UeATs
	 lE0GDMICawoWjxDw4LRFFtT+/0Qwz1cNsiSYWV2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 090/259] net: netconsole: Disable target before netpoll cleanup
Date: Thu, 15 Aug 2024 15:23:43 +0200
Message-ID: <20240815131906.277783091@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 97d9fba9a812cada5484667a46e14a4c976ca330 upstream.

Currently, netconsole cleans up the netpoll structure before disabling
the target. This approach can lead to race conditions, as message
senders (write_ext_msg() and write_msg()) check if the target is
enabled before using netpoll. The sender can validate that the target is
enabled, but, the netpoll might be de-allocated already, causing
undesired behaviours.

This patch reverses the order of operations:
1. Disable the target
2. Clean up the netpoll structure

This change eliminates the potential race condition, ensuring that
no messages are sent through a partially cleaned-up netpoll structure.

Fixes: 2382b15bcc39 ("netconsole: take care of NETDEV_UNREGISTER event")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240712143415.1141039-1-leitao@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/netconsole.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -715,6 +715,7 @@ restart:
 				/* rtnl_lock already held
 				 * we might sleep in __netpoll_cleanup()
 				 */
+				nt->enabled = false;
 				spin_unlock_irqrestore(&target_list_lock, flags);
 
 				__netpoll_cleanup(&nt->np);
@@ -722,7 +723,6 @@ restart:
 				spin_lock_irqsave(&target_list_lock, flags);
 				dev_put(nt->np.dev);
 				nt->np.dev = NULL;
-				nt->enabled = false;
 				stopped = true;
 				netconsole_target_put(nt);
 				goto restart;


