Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409624EFFAB;
	Tue, 13 Oct 2026 11:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891955; cv=none; b=C98u1gdTvQ+a4d6uXPksOfCxuU6dhQi0RR4lbfmYfpHpzdf0mWj3hhV4zeuUvpw8eWtrljSxPqih+WGsJ1jc4ScV43B++6JmRNZAZGP3e8smbFdK6NKIA1CBKY5G5DPSx8J3EpNII+TYqSW6yObx5APlrZrB7Ffp9Xxd0ea9MNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891955; c=relaxed/simple;
	bh=IEiccAW90+8qvMKEQ+4e5XfKMaRBCr1qCpEMqPbF0TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEKq9GeB9xCvOCa2wT58hXazQCuAeJrGF/D3T71quQXjtYQP8odiezoUPY9uff5AqYrfe+7sxoClC/jKZjmsuLJZN1IA/+KoULF3mr/1vj8pGJbHonsSI2/bmcNae3OKodSO2kldZlcQUtsMXWzCtzPHRHBTA338N1PxEpRGyeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9zrq791; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9zrq791"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAFA1F00898;
	Tue, 13 Oct 2026 11:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791891952;
	bh=viJAW4QefSjr/gCfmpzaSfj+weW02yv6GPVJPF8skOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h9zrq791Kml/EsWhkT67Hwvj6jCQedlGB94ogWbjdkhjeiDh8QOUUtPg0vOlMwzcD
	 /C+CwkGIcwdkG9BcMYhrWILkQPvej/yhNWFRVuRexvg3LwhklhLrncnK7BA3A+sifm
	 iqCbGmgvL65QTJCo/ixSB9OuiaU1wxxVrx3r6VJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 012/281] ipv4: stop route notification sizing when nexthop group shrinks
Date: Tue, 13 Oct 2026 13:35:28 +0200
Message-ID: <20261013112855.347006337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit d3daa33c7af92e38f2274bbd2576f58bfbaf89e6 upstream.

Commit 680aea08e78c ("net: ipv4: Emit notification when fib
hardware flags are changed") added an RCU-only fib_nlmsg_size() call
for asynchronous hardware flag notifications.

fib_nlmsg_size() checks fib_info_num_path() before each iteration,
then fib_info_nhc() independently reloads nh->nh_grp. If
RTM_NEWNEXTHOP replaces a group with fewer paths between those loads,
fib_info_nhc() returns NULL and fib_nexthop_nlmsg_size() dereferences
it.

Stop sizing when the indexed path is absent. Nexthop groups are
dense, so the current snapshot has no later path.

Fixes: 680aea08e78c ("net: ipv4: Emit notification when fib hardware flags are changed")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/1054fa46165bba1b473782fa41367804aa908e86.1790915964.git.4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -542,6 +542,9 @@ size_t fib_nlmsg_size(struct fib_info *f
 			struct fib_nh_common *nhc = fib_info_nhc(fi, i);
 			size_t nhsize;
 
+			if (!nhc)
+				break;
+
 			nhsize = fib_nexthop_nlmsg_size(nhc, nhs != 1);
 
 			if (nhs != 1)


