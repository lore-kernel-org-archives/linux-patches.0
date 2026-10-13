Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B98A35E549;
	Tue, 13 Oct 2026 12:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895680; cv=none; b=CYvUtALEzZkUdyytGAy8cnNab5wjpxv61soNOgCJQ19rslV1xay89BEfnnNqcEGZmOr2NlC6gqL9D/XDkKuLuKqRUZ/HLlvz1T5CMC9Bzm1GQ5NmSsq61/vvjIVMU7NtvPlM5v1M0NYyDBWNLREsRSHwn81/pDNpNYAsL0wuNaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895680; c=relaxed/simple;
	bh=aMvVaZxNeE6a5L+eUe0OcRLbS26T4DbWSbh55lz4nTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uN+rTkmBy5pqTdfhJLWup6l1EQqVknoPHGjsxKeAeiOZuD09i6zDvmg0g7bAmH5VyECyC7uz44rYUtga9fFiaCHHbY2i8i4Azs79Vfn/BX+3HH90vz8XzewkvVbFdYCI//5GQV/ChskFJrjnNJtZfi0f/K/i2MWPscsxb/r4w70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+3piNuR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+3piNuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5428F1F000FF;
	Tue, 13 Oct 2026 12:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895678;
	bh=yiNPFugl98OKluB/Ewyz2/CHZueokbFLtx3XzRsqvtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s+3piNuRHLPcTRZLmeOY9TCNQMzAACM6tpOKZxvvUjfx2+CYsR+Dp2q3R2UpV3hjz
	 k3u7NlVQLUa4lUao+71VcCtFv/xTYuOiQnpCIJNiYbfJ0PC+W+1ga/XJkPN8NaUtn/
	 WE6H4oJY7Pd9P0Fu+rVWHlyeWBbPbb3oYLdWsmZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 355/497] ipv4: stop exception dump when nexthop group shrinks
Date: Tue, 13 Oct 2026 13:38:42 +0200
Message-ID: <20261013112916.332540391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit 4f4afc07dcb2edd4f9afa36595373f8cdb9b58c2 upstream.

Commit 4ce5dc9316de ("inet: switch inet_dump_fib() to RCU
protection") allowed IPv4 FIB dumps to run concurrently with nexthop
replacement.

fib_dump_info_fnhe() uses fib_info_num_path() as the loop bound,
then fib_info_nhc() independently reloads nh->nh_grp. If
RTM_NEWNEXTHOP replaces a group with fewer paths between those loads,
fib_info_nhc() returns NULL and the dump dereferences it through
nhc_flags.

Stop the walk when the indexed path is absent. Nexthop groups are
dense, so the current snapshot has no later path.

Fixes: 4ce5dc9316de ("inet: switch inet_dump_fib() to RCU protection")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/netdev/20261001170513.GA1657889@shredder/
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/5bb7bd97411eb9db454464bf449107395e760f26.1790915964.git.4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3127,6 +3127,9 @@ int fib_dump_info_fnhe(struct sk_buff *s
 		struct fnhe_hash_bucket *bucket;
 		int err;
 
+		if (!nhc)
+			break;
+
 		if (nhc->nhc_flags & RTNH_F_DEAD)
 			continue;
 


