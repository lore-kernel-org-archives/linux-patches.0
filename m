Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5071898FC;
	Tue, 30 Jul 2024 16:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355557; cv=none; b=Id3cNHGbkPh8rJuSkO6UW0dvbzYIVFTeSyK91j0m3I7D4Y/Q1E1z5/iEvfeekUdvScD5tDDTyglwTRslRq7i66KCK7GKth2jmP6rBKDXal5+zugB4L5sIqvGaWXppv6hhpfrS8raq5DX7c9hyLpSqW9IFsi2sOl2PYN+ca7w1nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355557; c=relaxed/simple;
	bh=llSyg5IiemXmRq6bX/t9aWkgqeTX7tU6JbWOe9umJVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DreHQLm0Q8SsU5LrpEd5NzA4tN5vbPvgOW+OWCpd3dHG6wfPap59xe8j9EsHjVtLhcHr9I6YVRNGNn5z7TOZrDeqCTuaogzPdV2wWNCa9N8BqqM8gOFkgPoAKfyZLAuD8pBpeNBogeApgUxYJ2AhG1H3Rg9hDFnCo7QDSNxT6oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsee2Nq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsee2Nq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BA5C32782;
	Tue, 30 Jul 2024 16:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355556;
	bh=llSyg5IiemXmRq6bX/t9aWkgqeTX7tU6JbWOe9umJVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsee2Nq02eKHCmJ1OaSgM4/Y6/5hqqxsBocm7phO7crGO3Uz7VENNRh3tbY4ZNdQn
	 mumtai1e8QSR1R/dTr4oOCdb6UXXi7BFSoPkSGWnP4vKOqlvcfypFea3S8dkvjp+RB
	 HMAV0Y3hLPMMwJDEz9ctS/KSZ29oFG4laAXQ4Da4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Zubkov <green@qrator.net>,
	Ido Schimmel <idosch@nvidia.com>,
	Amit Cohen <amcohen@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/440] lib: objagg: Fix general protection fault
Date: Tue, 30 Jul 2024 17:45:26 +0200
Message-ID: <20240730151619.390436584@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit b4a3a89fffcdf09702b1f161b914e52abca1894d ]

The library supports aggregation of objects into other objects only if
the parent object does not have a parent itself. That is, nesting is not
supported.

Aggregation happens in two cases: Without and with hints, where hints
are a pre-computed recommendation on how to aggregate the provided
objects.

Nesting is not possible in the first case due to a check that prevents
it, but in the second case there is no check because the assumption is
that nesting cannot happen when creating objects based on hints. The
violation of this assumption leads to various warnings and eventually to
a general protection fault [1].

Before fixing the root cause, error out when nesting happens and warn.

[1]
general protection fault, probably for non-canonical address 0xdead000000000d90: 0000 [#1] PREEMPT SMP PTI
CPU: 1 PID: 1083 Comm: kworker/1:9 Tainted: G        W          6.9.0-rc6-custom-gd9b4f1cca7fb #7
Hardware name: Mellanox Technologies Ltd. MSN3700/VMOD0005, BIOS 5.11 01/06/2019
Workqueue: mlxsw_core mlxsw_sp_acl_tcam_vregion_rehash_work
RIP: 0010:mlxsw_sp_acl_erp_bf_insert+0x25/0x80
[...]
Call Trace:
 <TASK>
 mlxsw_sp_acl_atcam_entry_add+0x256/0x3c0
 mlxsw_sp_acl_tcam_entry_create+0x5e/0xa0
 mlxsw_sp_acl_tcam_vchunk_migrate_one+0x16b/0x270
 mlxsw_sp_acl_tcam_vregion_rehash_work+0xbe/0x510
 process_one_work+0x151/0x370
 worker_thread+0x2cb/0x3e0
 kthread+0xd0/0x100
 ret_from_fork+0x34/0x50
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Fixes: 9069a3817d82 ("lib: objagg: implement optimization hints assembly and use hints for object creation")
Reported-by: Alexander Zubkov <green@qrator.net>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Tested-by: Alexander Zubkov <green@qrator.net>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/objagg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/objagg.c b/lib/objagg.c
index 1e248629ed643..90f3aa68c30a0 100644
--- a/lib/objagg.c
+++ b/lib/objagg.c
@@ -167,6 +167,9 @@ static int objagg_obj_parent_assign(struct objagg *objagg,
 {
 	void *delta_priv;
 
+	if (WARN_ON(!objagg_obj_is_root(parent)))
+		return -EINVAL;
+
 	delta_priv = objagg->ops->delta_create(objagg->priv, parent->obj,
 					       objagg_obj->obj);
 	if (IS_ERR(delta_priv))
-- 
2.43.0



