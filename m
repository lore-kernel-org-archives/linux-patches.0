Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8484D4756D5;
	Fri,  7 Aug 2026 15:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117386; cv=none; b=fT+smm3ofH+yUHvDRjj0C7XObaOqWZP4uwfEyqodtd/l3bgKxLvvc6ca3j/yiWeoIZNHL81yyEsxurlJR79IcwPjUhpereDfdSIczlZqUFXvJC2JwcG0X12R5IzTYKeneofQ8x5P8hIl8XABxToCxJxZvM3x3NoZ5nITX8FZAbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117386; c=relaxed/simple;
	bh=apBF3RMRJiUp7zAhjfjlMMiaARoezf1CzARMLd8ylJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUqIYoNjapZwu24q9tnjczJMjtDjLCbX4wS0zBzcGTKTXAiRBrhYlz0sZHHAAJPuAb0vl9UOjHtwuAikWUi8lr2j+epQoITw6pNQn/zhbbY56Z/QvWka79EFlp3f4Rp+1jgw/VpJ4FZEam0UlvAdnhK/NLdc/e+NVli9OC6waGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fT6q0VcH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fT6q0VcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B844E1F000E9;
	Fri,  7 Aug 2026 15:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117384;
	bh=U/47Hsb0NKEHt1jIfzAYkGGjE4m8/hpGOYudGqYIwYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fT6q0VcHpC/ZbjUgaOUGEHzaXn4Ir/G92QvF1a83vdNGjEtyQ8Yc/pvvF4esaqQbe
	 gnXEYU3H644bzCjWKX0aGs+vO7XFCfOB27Ikn1a3dfhaxzwl34+SLw0/JyQiA2ReHb
	 sl3uk6YtBxz4Z2xwl+7V9RzoakHQaeJBKfJvlMd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 298/438] net: bridge: stop fast-leave after deleting a port group
Date: Fri,  7 Aug 2026 16:38:14 +0200
Message-ID: <20260807143434.325695174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3686,6 +3686,7 @@ br_multicast_leave_group(struct net_brid
 
 			p->flags |= MDB_PG_FLAGS_FAST_LEAVE;
 			br_multicast_del_pg(mp, p, pp);
+			break;
 		}
 		goto out;
 	}


