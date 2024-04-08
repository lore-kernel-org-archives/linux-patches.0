Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66CD2E405;
	Mon,  8 Apr 2024 13:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582573; cv=none; b=Zie43IHvyM/KEa8K2309CJwcDHtFUsnqxTAtQnzhAoFTbo/cR5Ji7W4kmkTdLX6v796xols0IlTHUuum+ULh++8LvSswQX2rFZ0JpPcPpg6fAv/DPo1XqVW1cto/+y0AK0KeycSYMQ/vo5GUaRtMFqSNlFmm/wcdULkCH8QwUGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582573; c=relaxed/simple;
	bh=JgBQA4laqsvxOL7LMZMUyqWKBXwQGElmMLUna0er+QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWpZimjK1zMpDOfX6b7+kqdZtVQJ27sy17sMkxzaLowCn2bBwsh+otmY9nqyTM+uSDKq1cYOx62FzDz2nLyex+qRgulwl924iaahCMBDalYUfdsfCQgAPFVpPohlqq+T3eDbuljCXVO/gomtLITqcyp/SxLLZ5jLolP9m26WB0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R48/1fow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R48/1fow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5D5C433C7;
	Mon,  8 Apr 2024 13:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582573;
	bh=JgBQA4laqsvxOL7LMZMUyqWKBXwQGElmMLUna0er+QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R48/1fowiRcXtqAJCZEJqj5XnUAPHnlfvOqNYaRji/hNXUK59eox2xHhg//wvCeIL
	 NVrhW61klqJ+FW66tT/NpHR+9PYRqhqZGU2x/1QJ8dYERR7w7sqB36VIodIJp9jvz9
	 Saf9dhdeC2O/+eihbceIlEbAEerL2CTs1+HL+UOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.8 087/273] netfilter: nf_tables: reject new basechain after table flag update
Date: Mon,  8 Apr 2024 14:56:02 +0200
Message-ID: <20240408125312.007130453@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 994209ddf4f430946f6247616b2e33d179243769 upstream.

When dormant flag is toggled, hooks are disabled in the commit phase by
iterating over current chains in table (existing and new).

The following configuration allows for an inconsistent state:

  add table x
  add chain x y { type filter hook input priority 0; }
  add table x { flags dormant; }
  add chain x w { type filter hook input priority 1; }

which triggers the following warning when trying to unregister chain w
which is already unregistered.

[  127.322252] WARNING: CPU: 7 PID: 1211 at net/netfilter/core.c:50                                                                     1 __nf_unregister_net_hook+0x21a/0x260
[...]
[  127.322519] Call Trace:
[  127.322521]  <TASK>
[  127.322524]  ? __warn+0x9f/0x1a0
[  127.322531]  ? __nf_unregister_net_hook+0x21a/0x260
[  127.322537]  ? report_bug+0x1b1/0x1e0
[  127.322545]  ? handle_bug+0x3c/0x70
[  127.322552]  ? exc_invalid_op+0x17/0x40
[  127.322556]  ? asm_exc_invalid_op+0x1a/0x20
[  127.322563]  ? kasan_save_free_info+0x3b/0x60
[  127.322570]  ? __nf_unregister_net_hook+0x6a/0x260
[  127.322577]  ? __nf_unregister_net_hook+0x21a/0x260
[  127.322583]  ? __nf_unregister_net_hook+0x6a/0x260
[  127.322590]  ? __nf_tables_unregister_hook+0x8a/0xe0 [nf_tables]
[  127.322655]  nft_table_disable+0x75/0xf0 [nf_tables]
[  127.322717]  nf_tables_commit+0x2571/0x2620 [nf_tables]

Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2437,6 +2437,9 @@ static int nf_tables_addchain(struct nft
 		struct nft_stats __percpu *stats = NULL;
 		struct nft_chain_hook hook = {};
 
+		if (table->flags & __NFT_TABLE_F_UPDATE)
+			return -EINVAL;
+
 		if (flags & NFT_CHAIN_BINDING)
 			return -EOPNOTSUPP;
 


