Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8A71A619E;
	Tue, 30 Jul 2024 16:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357305; cv=none; b=n++FafrMhXlh8A4iOCZ07dKAlELbzCAFz7bk8hy7LMgTmE1l0s2AjX8VQi+rmUshkZvxevxXtZvVWVFmOeo9Djf8fN8OVntMzElvM73MpLIL0yR2q1LD8NHt9yZRql9f8ppaSKWCy7/3qHpdTNI3odeAQnz1Irz+yF2oXclE0xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357305; c=relaxed/simple;
	bh=VYxDizxFm83K7y9WLt8NrNhXKwGpsytAHYf7cqksalw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oepSBFJ2sUv22fjUr2TBhpjL4iUXgmbmDLepvp5UqkMWZ9ORuITV2UKldcne97MtL6Tmz8xHpryrEDx9ZISjn+1Jv4cxg+qheSQD/UD1bqlC4LzlKek4anMuo/jk57pfwZITOogK9pTPr3gQ20Ys/6paUzNkWx14BbmcIFrsXQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ux+4yagz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ux+4yagz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E48C32782;
	Tue, 30 Jul 2024 16:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357305;
	bh=VYxDizxFm83K7y9WLt8NrNhXKwGpsytAHYf7cqksalw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ux+4yagzxTfudsbfhbLX0OPZ0yLjvkaSa5kAYdWMnPhKBQIfX30Ikj/+piVVaUyzd
	 lGggdAUhXlZX7MTqu0pkjoHoMrJa/gJgUNjLNWs/hSXFebjHlUZxvzuqf1UpN1ZwFp
	 bgFtFnJSnRzxBXmFWNWH/O/omOBjJLBnjzaSgkEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 278/440] net: netconsole: Disable target before netpoll cleanup
Date: Tue, 30 Jul 2024 17:48:31 +0200
Message-ID: <20240730151626.690433964@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
@@ -716,6 +716,7 @@ restart:
 				/* rtnl_lock already held
 				 * we might sleep in __netpoll_cleanup()
 				 */
+				nt->enabled = false;
 				spin_unlock_irqrestore(&target_list_lock, flags);
 
 				__netpoll_cleanup(&nt->np);
@@ -723,7 +724,6 @@ restart:
 				spin_lock_irqsave(&target_list_lock, flags);
 				netdev_put(nt->np.dev, &nt->np.dev_tracker);
 				nt->np.dev = NULL;
-				nt->enabled = false;
 				stopped = true;
 				netconsole_target_put(nt);
 				goto restart;


