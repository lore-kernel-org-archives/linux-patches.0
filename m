Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046290;
	b=lqRGm+l+GYl+OsFneBHDrIYuLMhiyXHyrPUZfWP2Z/npSWCpO2Hb3Efjrp9TacaJ7AGe
	 krZTDBjpuTOq80ZRgGPOEkNGFuPB4G4JfAOH8GTNRC2w8okUAiis5/RJt9TKqPSpnc6JK
	 OXztluchANWBKb6I0hpamOGImdpneZ0ZEANGSRb76/2s6ROsZBqZTbxsMFJ0AxWIGLek0
	 yHG+iNSdmXIjXRhES3Xhw7ZCDqZBfdqS1rB6wgADBt8gjJ/cxUu1HAJ0EQOHmiKsDekPz
	 9uNXawIuq8srOQczu6lmLVYV6E4UzjttW4Du5qRXjaFjSVo9dCtjQ2n5tg5RVdnfSrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sZ9iv4SnwdMPH45pt6vWooWTdWdgrocIz3ynfq1TiIg=;
	b=heUU3xenKLpZGfkTjwSHEafvKfseeoTtOJIHvg9DCEZ6euyE4SRFuJrDnxXRGfrsfktw
	 f88dpafFWU0vUlDAlkMq4IKXz7C1EVmDGesTAe9QUUwAYLThCY0fY3cGk6Ivp3WPUEk6u
	 AG7lOL2EjO/QqUpsBJU6fSSfuNpj469/0DKzysFhzyZHnENJXqiQ0F9iOG76ktNGVrDJC
	 p7yLu9yQhvBRTGCUIH8b3bXFRpIldO7wJzHDJJXATjGHbytCCyCk3+cWD1EnJ5u/Fty/9
	 8MSUcco3Br/DadifcbAa3zZJNyq6pzMrhpx+Mx+4KBhfdtU/rLX2LxTGpvx91uVaJMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C6Rp3MH1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3642A606A320;
	Wed, 18 Nov 2026 23:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C6Rp3MH1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5251F000C4;
	Wed, 18 Nov 2026 23:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046290;
	bh=sZ9iv4SnwdMPH45pt6vWooWTdWdgrocIz3ynfq1TiIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6Rp3MH1cL7Jwq+rXaPM7iwQaZQ1XxLzvdOz/mNGizIEvZytUovg8uKAPw3ZQ/oEH
	 DDoyH69mONVus5uAM7TVGLf0PbpNuAEN3+PxFeCo/a+A9BxzHf2HViZ8f/cW1wyGje
	 2gzy+AXFS5kmy3yBa2RZ62wIp2bMxsblsPDCD7OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1228/2857] mm/shmem: fix truncation of files containing only swapin-error markers
Date: Wed, 18 Nov 2026 15:37:42 +0100
Message-ID: <20261118150245.777733585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 59511d630a6942356ac4b6984797998a8f3a9017 ]

It might not be very common, but we can end up with shmem files that are
composed only of swapin-error/poison markers.

Such markers are not counted in info->alloced. Consequently,
shmem_setattr() can skip shmem_truncate_range(), leaving the markers
behind.

Truncating the file to zero and growing it again will result in reads
failing with -EIO instead of returning zeroes.

Check whether the mapping contains entries, in addition to
info->alloced, before skipping the truncation. Keep the info->alloced
check so that shmem_recalc_inode(), called at the end of
shmem_undo_range(), can fix up accounting after reclaim has emptied the
mapping.

Fixes: 6cec2b95dadf ("mm/shmem: fix infinite loop when swap in shmem error at swapoff time")
Cc: stable@vger.kernel.org
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://patch.msgid.link/20261029-fixes_shmem-v4-15-392fc715d8f6@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index be1a6dc9a3dfa..289707965dd1c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1164,7 +1164,8 @@ static int shmem_setattr(struct user_namespace *mnt_userns,
 			if (oldsize > holebegin)
 				unmap_mapping_range(inode->i_mapping,
 							holebegin, 0, 1);
-			if (info->alloced)
+			/* Swapin-error markers are not counted in alloced. */
+			if (info->alloced || !mapping_empty(inode->i_mapping))
 				shmem_truncate_range(inode,
 							newsize, (loff_t)-1);
 			/* unmap again to remove racily COWed private pages */
-- 
2.53.0



