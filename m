Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAB62D12ED;
	Fri,  7 Aug 2026 15:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116148; cv=none; b=WXbh0xkGRaTmnPdQ/45dkBjR9Axo3+7C4LGUHgChS4IDPvsk3j62P2wdAst4Is52FtgGtvgSKvI2fW4SJw6rr8cLc81yqYnXWNm8hFUQP5ggafcTGF/MNgaFEjpQh7F9QnU0LAw2RmcuLYy+/WOAExDOxn+Lk4SfKbkElK49vKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116148; c=relaxed/simple;
	bh=wLYHC67BG1yjlY4S6FhKg4SehCDxgZcZMlA1eOl2G08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsJsRyvGRtOfIlrpIbWdEo1WtZ/RuLCLy/S+qy0QOBTpM7Ee6Lfl/VJu7xgS52LvYYCL05RwrNYuVQvrPhldK9LOlCGZsskfwOzgla9DTp4rU7QU9n3k9jGwkzcwscE3vP858QL9nof8gA5N1RGorthBylaP/YXl/VBVqg0teEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ErrLoFDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ErrLoFDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD41B1F000E9;
	Fri,  7 Aug 2026 15:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116147;
	bh=/RFauwbjCg5d+zz3NO5yJHphYwgNHfbX+ZmyzvDpAgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ErrLoFDBGB6vc3m1v54RgPuJaXyRaMuYosSTTnRJvQsDL7sKVd9GliTz6VjpBXPIs
	 uY8+GwGYxPlDbPvJvVXB4IbsDyJZ64KLHpbNOZWnjIhnM9dBdzRbSO+gfuebT+S6K/
	 DCApyQOM/v1MahimWvPCA4oUnemWJtw+HudyZ9JQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 130/261] net: bridge: stop fast-leave after deleting a port group
Date: Fri,  7 Aug 2026 16:38:07 +0200
Message-ID: <20260807143418.169940975@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3684,6 +3684,7 @@ br_multicast_leave_group(struct net_brid
 
 			p->flags |= MDB_PG_FLAGS_FAST_LEAVE;
 			br_multicast_del_pg(mp, p, pp);
+			break;
 		}
 		goto out;
 	}


