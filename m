Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1720F3DB636;
	Mon, 17 Aug 2026 14:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976134; cv=none; b=oBPK3fgu5myj7iPDIph0hMerw5HfO5/NTkkzIjyJh9Q4aIKJLx23wHza627y/h1u1fILlgKAsiiErisqgQi6zKRTPdTLKJn8cFVVKHghN3RDYN8iyKq5u4mIDeHJaqfzFrOyrhq11yiQXJIcbr2g5Nmd5JTdL+vXLgTACQaHSD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976134; c=relaxed/simple;
	bh=rNbVqVQUEIsVm26kFTJy4hb4rIlC6Z7BK0b7nMrM8S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEc2u4gCzV0KhEyIt/j1iSLi8bLgRW7EltxL90/CECiV/wQxEfQbGF34wD6h2C+gzSwl0WC3ruUTVZ7AVRztXpJPhDEcJsmMqsjOb5VaPDgxulWWTroZt4TQMC1NCcHKEazn93+im2LkWwIbyhIlKXHbI8ULxTdqdw7moJ3cDXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qLMAC+xB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qLMAC+xB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB731F00A3A;
	Mon, 17 Aug 2026 14:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976133;
	bh=92ySkxhgtS405fuLDpKukuLl6TxK2zaQie08X+Enmr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qLMAC+xBf4iAkw6cGimqdq7s94S0Qunt2JX7bd2HUEHEwVynPNNVXnxqZHcp89FPG
	 NWxwobsaThVOOMDj+w4KwiHmJwnC9dEfMXfGyPaVgycvv4u9gJEt5vQ4Oo7Pyi+J8t
	 GtsSHuXMzaVhAVk8+T9Dfx5VkcXtAeqY4NykwDWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 267/389] net: bridge: stop fast-leave after deleting a port group
Date: Mon, 17 Aug 2026 15:31:46 +0200
Message-ID: <20260817132549.584841473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

commit a39789f211b8a4125f0c70e05b30cf715f4f187d upstream.

br_multicast_leave_group() iterates mp->ports with pp = &p->next in
its fast-leave path. After br_multicast_del_pg() removes p,
continuing the loop advances pp through the deleted entry.

If multicast-to-unicast was enabled, the bridge can hold multiple port
groups for the same port and group with different source MAC
addresses. Once multicast-to-unicast is disabled,
br_port_group_equal() matches those entries by port only. A fast leave
can then delete one entry and continue from its stale next pointer,
leaving mp->ports pointing at a deleted port group.

Fast leave only needs to remove one matching port group. Break after
br_multicast_del_pg() so the loop stops before dereferencing the
removed entry.

Fixes: 6db6f0eae605 ("bridge: multicast to unicast")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/1cf0898872ef7c72d5f4c0304414a192c6dac591.1784707712.git.zhilinz@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_multicast.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2838,6 +2838,7 @@ br_multicast_leave_group(struct net_brid
 
 			p->flags |= MDB_PG_FLAGS_FAST_LEAVE;
 			br_multicast_del_pg(mp, p, pp);
+			break;
 		}
 		goto out;
 	}


