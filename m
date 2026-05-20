Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393DA3A6EE0;
	Wed, 20 May 2026 17:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297208; cv=none; b=n2hMA8ciA+L86uqG4tlSWodDOd7nciuIdFEGSWrtXLJrsUf/tXsJYFcEAvZYPO3W20SFG31UrFVMMaIBBbDwRAIDj1G9+dTyt2c/H/M4eQ6VcWHlCDplzGS1K4foW5SV450l9WzhFGgrNbElMT138pdAIAvpd+HQVI4WkmH5kr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297208; c=relaxed/simple;
	bh=LkEb18pyy6PxmCTBf0SZrPrU3L849RojUnMziHSWxOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usWZBLHIO2aGq0Spa62L+TrQQOAJUgwLB/j9TedRJnsK1eX8S86nRrek9C62xGmLdfd2NRcyvjXusH+n2RWUxVzXp5z4Wm9NiU3MwxUQaLYmRVLdeP9GbaZGyxXi4Rknis61Y268Jc5Br/9T8rhToFcEQlUVP+xPM5v1ds/SRag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDYtHc0k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDYtHc0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8021F000E9;
	Wed, 20 May 2026 17:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297207;
	bh=sQJR7K0lki6rPNzuHcjARwuOrU/klUPOrXiIVyWJLUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bDYtHc0kCQqKT9tptCXYVEHwpywjq2UeTtc7cji7YKXJanzf9omb7OFsRpuTJ1AT8
	 6VJVUmTbbmMcBEMUaezL39Ye88H+ZX2SbaThuHEseDgR2u/joqSP0SZdXqbdkPxHOj
	 4RJWAeskQ8Mv+F+jYtJOzkqFQrevZ7Wf2TE8oQ7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.0 1049/1146] cgroup/dmem: Return -ENOMEM on failed pool preallocation
Date: Wed, 20 May 2026 18:21:39 +0200
Message-ID: <20260520162211.972853671@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

commit 796ad622040f7f955ccc3973085e953415920496 upstream.

get_cg_pool_unlocked() handles allocation failures under dmemcg_lock by
dropping the lock, preallocating a pool with GFP_KERNEL, and retrying the
locked lookup and creation path.

If the fallback allocation fails too, pool remains NULL. Since the loop
condition is while (!pool), the function can keep retrying instead of
propagating the allocation failure to the caller.

Set pool to ERR_PTR(-ENOMEM) when the fallback allocation fails so the
loop exits through the existing common return path. The callers already
handle ERR_PTR() from get_cg_pool_unlocked(), so this restores the
expected error path.

Fixes: b168ed458dde ("kernel/cgroup: Add "dmem" memory accounting cgroup")
Cc: stable@vger.kernel.org # v6.14+
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/dmem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -602,6 +602,7 @@ get_cg_pool_unlocked(struct dmemcg_state
 				pool = NULL;
 				continue;
 			}
+			pool = ERR_PTR(-ENOMEM);
 		}
 	}
 


