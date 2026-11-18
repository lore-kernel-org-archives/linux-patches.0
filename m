Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021191;
	b=dKiLnDYn9rfScgcgeAW7Q1xjTBOAOsOaEVCYVNfJD22nF1Z1GLtTqZnGpORNT8EeZJZp
	 RQB1saRLxoRL+/9wVp5QEhFqpzafhr1JL35y/AfG3c/9NOklDLGeT5P1Tg0inLNgIAQ7l
	 RRDao6cEUYudw4uZqYkv2gOejvGYYNx8JimC45BolDS3vyCiusQL2a+3Oeq1FFlqEem5C
	 gPigsxYSZv8ijpGs9BY04H0X09Y07W8QuLyYMNw4yhpYv/v5W/Xi3AWQW4aG/9p7q+gIS
	 YEvbPwaTE3TJzW1fj+1/XZmUkkVhvTAPRsyJHQNCQftoiZNFu+APgHVXWDEgDgjQuaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hbm9bfOawnaKZdTfJRAARvC+buM1M3e9JNfIEtAskUM=;
	b=RQ7e7CUX1FoieA6qBccpECqPKzUZSkqfqvkpzs80HY4ngoAMkL2JUfEthxDusCI08aOQ
	 DMLR3iPtqC3UQx8B0lwYdD3bvUmwJhMIX5ewCZczPjC0aWSJjf/5QdwIqHAs2J0+I4l1U
	 CT/tg+4354y39IYZeOkp8e/6Ed6TARuBi5msJ5HcLlh6dlPycpxR8moFIrBPIkYC90qhM
	 cOs1dpSgkvLRG6HMyb5ryFPiE42+WYPlRU2PWL+kTHaKk73F1p510fYmDrvKkkdTwFcii
	 CYtpBowkop0yuYVXaGeTn9BigOp9gN1efRato8jISLRuA5wSZB2uUlBX6N7mOT1R0pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FvLOBInN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E0A606A325;
	Wed, 18 Nov 2026 16:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FvLOBInN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892CE1F000C8;
	Wed, 18 Nov 2026 16:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021191;
	bh=hbm9bfOawnaKZdTfJRAARvC+buM1M3e9JNfIEtAskUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FvLOBInNHJwxJZhm1UjLhIWQfuMGGsH4Xsh9gDN7VIVMLslbIulV5vgGucuUO0Ghc
	 M7KQcXPlw4tkC7yrkVzRE8ueGMlumQQfe+LM81ajbkssNCOAScsIVrwp8dc1lmEgMG
	 ZbXjcFurnk/gQ048qSlYTpXAHq/SKihpAbhW9D8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2218/2651] ntfs: do not give a contiguous cluster allocation a second run
Date: Wed, 18 Nov 2026 15:57:38 +0100
Message-ID: <20261118150405.453506714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit b05a67615b982cfaa903df8a6fb055d18ebafe11 ]

ntfs_attr_map_cluster() asks ntfs_cluster_alloc() for contiguous
clusters and merges the whole result into the runlist, but reports only
its first run, so its callers zero only that run.  Within a bitmap page
the allocator keeps such a request to one run, because a cluster in use
ends it.  The zone search can also move on without testing the clusters
after the run, though: it skips a bitmap page that has no free clusters,
it goes from the end of the zone to the start of pass 2, and once every
zone has been searched it shrinks the MFT zone by half and goes on at
its new end.  After each of these jumps the first cluster tested is
still taken as the next one of the run, and if it is free it starts a
second run elsewhere on the volume.

fallocate() over a hole then leaves the clusters of that second run
holding whatever they held before: on a nearly full volume, 16 of 20
fallocated clusters read back a deleted file's data, in each of the
three cases.

Delayed allocation gets a second run without punching any holes: filling
the same volume with write() reaches the last case when the MFT zone is
shrunk.  The allocator then takes only the first run off the
dirty-cluster count, and after the fill statfs() reported no free space
while 939 clusters were still free, until the next mount.

Before setting the bit of a cluster for a contiguous request, check that
the cluster comes right after the run, and return the run as it is if
not; no bit has to be cleared.  ntfs_attr_map_cluster() already handles
a short run, which a cluster in use produces in the same way: its
callers ask again for the rest.

Fixes: 11ccc9107dc4 ("ntfs: update runlist handling and cluster allocator")
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Link: https://lore.kernel.org/all/CAKYAXd-agPFvDj2-HvjP3SLtG7AxkqUeNPqYyrLt-BN7fT8w6g@mail.gmail.com/
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/lcnalloc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ntfs/lcnalloc.c b/fs/ntfs/lcnalloc.c
index c58e689fb5852..3ebcac4c28648 100644
--- a/fs/ntfs/lcnalloc.c
+++ b/fs/ntfs/lcnalloc.c
@@ -375,6 +375,16 @@ struct runlist_element *ntfs_cluster_alloc(struct ntfs_volume *vol, const s64 st
 				has_guess = 1;
 				continue;
 			}
+			/*
+			 * A contiguous request gets a single run.  The scan can
+			 * move on without testing the clusters after the run
+			 * (past a bitmap page that is full, to pass 2 or to
+			 * another zone), so return the run when this cluster
+			 * does not follow it.
+			 */
+			if (is_contig && rlpos &&
+			    lcn + bmp_pos != prev_lcn + prev_run_len)
+				goto out;
 			/*
 			 * Allocate more memory if needed, including space for
 			 * the terminator element.
-- 
2.53.0



