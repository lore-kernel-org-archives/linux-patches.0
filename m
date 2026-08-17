Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A0B175A6B;
	Mon, 17 Aug 2026 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977521; cv=none; b=EKfQUuf8G6U6DV0PMpASZ8L9gd3j6R5giksYkDxGb+Axv355rxhnLr47olI31kKoCemLgPfHwUQw+agjeFOXSX9e43VVacGfhbQp08lp2zSXN1b6kufKHZ/FQHkE+as/5CpC/mNYkhMJQM2CSgkSDtT9aPym29mxWeHzjevyZlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977521; c=relaxed/simple;
	bh=cHDYD1DT6PPHVv8lw6SvVfDivPATAEm+0kHCQAXcNQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0cxo+X1lTQa4tb8HzOPAjQB8trW9n/JZ5iTTZFhF3RRO4s1RkWXYNcmlVpkTd4Q5L49lqf3muh6rJUoLnvMeXndva9GMP6vldv7/HW2pKpJzIZ7lt2Z+kMJhcsXbCkw4lFECMlc4VDItoNxDIPzyu+LrrbTY3Ax7vMZ/FwC3v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kzTAlxwS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzTAlxwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227F91F000E9;
	Mon, 17 Aug 2026 14:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977520;
	bh=MWxM/Ej6kIaTLWHaW9gIFtLntvR7lWumIZtGlkjGJF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kzTAlxwS1MmmCt4B0E1swqsh3K3clzkGfwujbMulfI91iQw50mDqAk7VFOnwJ2oJg
	 O9OKDgFBL/FpwmFK/gattb87j7ijRkewx7k4R07qL+X8Wg1I1wgSYwkVCOzf+UY2JI
	 I6O7prkTHkX9QOsieJgEfW0uU06yiu+gZ3p1Iwxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 319/456] net: bridge: stop fast-leave after deleting a port group
Date: Mon, 17 Aug 2026 15:31:49 +0200
Message-ID: <20260817132552.176069662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3511,6 +3511,7 @@ br_multicast_leave_group(struct net_brid
 
 			p->flags |= MDB_PG_FLAGS_FAST_LEAVE;
 			br_multicast_del_pg(mp, p, pp);
+			break;
 		}
 		goto out;
 	}


