Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A847136404E;
	Wed, 20 May 2026 16:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294864; cv=none; b=RuU3p1G50lopD/OUKWptSZfqoLcXUIEWotii0X7aKtZdZejYjaFF2/csygk5kfu9FVSgT5Ekwe6kSyJkO34lnwWXjCyTji6JfEG/HKDRmapXCxLzV4vhUY8lgWCpc/vySjaGYMeFOKXMALNIudXYf19wyEVLQBgbl1WoUxKks58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294864; c=relaxed/simple;
	bh=OSl8UVlvSj5T8igL58j8RN/4203dXYLMaGnWRXp7j8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oock/dJ0YSFOGdfoILl81N5gRDjYL0uomDoSllSStBs59IomvPQNofC3g2p1m1pT5sqHeM5AfH8cukDGA5ez6Zu8hnFOlPHG0uu9aqMlSqjtzY4R4IyNibAL1Jqgubq8AcAX5Ruz4y+PL2c6oFFwM/lS0dc6ccBQ22rtsg78NKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ci5AVjdz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ci5AVjdz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F4B1F000E9;
	Wed, 20 May 2026 16:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294863;
	bh=pJXhDOUxa0OfS+fq0gKJNkyDl7pyRWoBt8EJZJO5vPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ci5AVjdzkYw2Ciay2v5XlY5ScUBCyw2OZETZwutFxMIoPtEUbdcZGPAkQK4IqMHDP
	 1inY472fz0qHlY138yPSQuMcBO9G8b2Bvf7TN8dLg3JDuPygVg8ANi38TrsIzORa9h
	 81cQJcdeYgD41p+gPyaOvxwPDJer/vAAakUzqfzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaiyan Mei <kaiyanm@hust.edu.cn>,
	Lang Xu <xulang@uniontech.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0200/1146] bpf: Fix OOB in pcpu_init_value
Date: Wed, 20 May 2026 18:07:30 +0200
Message-ID: <20260520162152.798772471@linuxfoundation.org>
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

From: Lang Xu <xulang@uniontech.com>

[ Upstream commit 576afddfee8d1108ee299bf10f581593540d1a36 ]

An out-of-bounds read occurs when copying element from a
BPF_MAP_TYPE_CGROUP_STORAGE map to another pcpu map with the
same value_size that is not rounded up to 8 bytes.

The issue happens when:
1. A CGROUP_STORAGE map is created with value_size not aligned to
   8 bytes (e.g., 4 bytes)
2. A pcpu map is created with the same value_size (e.g., 4 bytes)
3. Update element in 2 with data in 1

pcpu_init_value assumes that all sources are rounded up to 8 bytes,
and invokes copy_map_value_long to make a data copy, However, the
assumption doesn't stand since there are some cases where the source
may not be rounded up to 8 bytes, e.g., CGROUP_STORAGE, skb->data.
the verifier verifies exactly the size that the source claims, not
the size rounded up to 8 bytes by kernel, an OOB happens when the
source has only 4 bytes while the copy size(4) is rounded up to 8.

Fixes: d3bec0138bfb ("bpf: Zero-fill re-used per-cpu map element")
Reported-by: Kaiyan Mei <kaiyanm@hust.edu.cn>
Closes: https://lore.kernel.org/all/14e6c70c.6c121.19c0399d948.Coremail.kaiyanm@hust.edu.cn/
Link: https://lore.kernel.org/r/420FEEDDC768A4BE+20260402074236.2187154-1-xulang@uniontech.com
Signed-off-by: Lang Xu <xulang@uniontech.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index f7ac1ec7be8bf..3dd9b4924ae4f 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1056,7 +1056,7 @@ static void pcpu_init_value(struct bpf_htab *htab, void __percpu *pptr,
 
 		for_each_possible_cpu(cpu) {
 			if (cpu == current_cpu)
-				copy_map_value_long(&htab->map, per_cpu_ptr(pptr, cpu), value);
+				copy_map_value(&htab->map, per_cpu_ptr(pptr, cpu), value);
 			else /* Since elem is preallocated, we cannot touch special fields */
 				zero_map_value(&htab->map, per_cpu_ptr(pptr, cpu));
 		}
-- 
2.53.0



