Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78111CA8F;
	Mon,  1 Apr 2024 16:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988699; cv=none; b=LSd1yJFd0uShBkwNQFPtaH4tSxytVDti+uMgv0JH6POEZRZ+A09I96gizMIZPbCxWXJiK1Sg0iqm47iuqMfmpc5OV1b/uzRPGKWcZT8rZOGGKAExov4JwwiWcz+w+PNj8ZwEYGRYb9vZkdVKJLeH70ui8AXSbnMsnxAnJXwn7gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988699; c=relaxed/simple;
	bh=/NWAOZnqMHpu1erP8oKdCKZpf3JbxH5LdjibBY6cE/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxxJED1L+6ceDMtuXCwhpDCXsgDVjF5I/emU2esxfSmIMVqteX5K1gNUQEyDCmjeysvx+ZaLtnSVsfKs1xaiO0oFM6S18beOoqj5hFkqFMe05uypiELDMN4gf05OnjSQVJpHeF+knTTQgw+6QoU60piFLLvuZyCBqTI4kH0FDCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5USWdAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5USWdAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE972C433C7;
	Mon,  1 Apr 2024 16:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988699;
	bh=/NWAOZnqMHpu1erP8oKdCKZpf3JbxH5LdjibBY6cE/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5USWdAiUNZn8A9nJGAFFF9nl0cDUDNsX+DeKUrIu3V3b8aSPT5xGgUOq7pcoM6y3
	 V/CUdT57/tE5amdWOVzxzKDwQYP4pKIIVPMkyfCmpX9HMnxXi2niV42LdQdrXBkylF
	 aJdFI54oCVHsW0H7w0JrKrB4PlV/uoSSdo6mYYA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingi Cho <mgcho.minic@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.7 234/432] netfilter: nf_tables: mark set as dead when unbinding anonymous set with timeout
Date: Mon,  1 Apr 2024 17:43:41 +0200
Message-ID: <20240401152600.114209760@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 552705a3650bbf46a22b1adedc1b04181490fc36 upstream.

While the rhashtable set gc runs asynchronously, a race allows it to
collect elements from anonymous sets with timeouts while it is being
released from the commit path.

Mingi Cho originally reported this issue in a different path in 6.1.x
with a pipapo set with low timeouts which is not possible upstream since
7395dfacfff6 ("netfilter: nf_tables: use timestamp to check for set
element timeout").

Fix this by setting on the dead flag for anonymous sets to skip async gc
in this case.

According to 08e4c8c5919f ("netfilter: nf_tables: mark newset as dead on
transaction abort"), Florian plans to accelerate abort path by releasing
objects via workqueue, therefore, this sets on the dead flag for abort
path too.

Cc: stable@vger.kernel.org
Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Reported-by: Mingi Cho <mgcho.minic@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5423,6 +5423,7 @@ static void nf_tables_unbind_set(const s
 
 	if (list_empty(&set->bindings) && nft_set_is_anonymous(set)) {
 		list_del_rcu(&set->list);
+		set->dead = 1;
 		if (event)
 			nf_tables_set_notify(ctx, set, NFT_MSG_DELSET,
 					     GFP_KERNEL);


