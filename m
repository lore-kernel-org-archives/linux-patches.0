Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F83346E75;
	Sat, 12 Sep 2026 07:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197452; cv=none; b=pCsIFQNqhD7I4LwDiJOiA5EkKh1kxugWwuWtM19CoLuddfOQCJiFBV5x0PDLQkyv7M5LY3QyKRwCfrujhzi6B2yUeSVf6tzWiONH5s1SNlh8Ym7YpVNbzC1k8aEsKbkb4uo7WEIllF2r/gvXh+1HzjcM3+oO/XWHvkeNmhzO+kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197452; c=relaxed/simple;
	bh=y3i+NZlDBC9ZerngejHvI5VdQHSGJynWHLxX8q3LiB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lj4WEvTQGsZ4anqAXLZFIbKNBZzOzLuup8k3zG1SjhPFWH3Sp/QGxXwasebl1Hc53ki8XzCtfwNZnxLH4dhnoCmebbToNJQHUdD4oxuSUVI1zc7nScHp8vcBzIC4z4XX3DLcg8gHko7rWyZPMUqLXdaabjoR5Ryg779l4YQL3Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DgEmx1gD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgEmx1gD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6682D1F000FF;
	Sat, 12 Sep 2026 07:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197451;
	bh=K3oC6MSdJA37Ogb7vhq9h3rrWV8XvHZ57cpf9rylrhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DgEmx1gDYyVGW5pg4+AVOLsTzpTO0XTQYRSQLmcFtbVO3+R3gKph/8aCIy7vU/JXG
	 QOkDUN9oT7uoY5Iv82oG0EC/ito3S+9pQxWK2F41Y5neVVAefkSU2An6gjV3lTL74C
	 OqH9o50y6gxn4VqKKIWBGx3Hoy+Ohi3qklIn6qss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0175/1815] uprobes/x86: Allow to copy uprobe trampolines on fork
Date: Sat, 12 Sep 2026 08:32:05 +0200
Message-ID: <20260912065653.117016910@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit d9a48e77f6fe0c11d3cdfcbbcbf4a98ec402e55a ]

When we do fork or clone without CLONE_VM the new process won't
have uprobe trampoline vma objects and at the same time it will
have optimized code calling that trampoline and crash.

Fixing this by allowing vma uprobe trampoline objects to be copied
on fork to the new process.

Fixes: ba2bfc97b462 ("uprobes/x86: Add support to optimize uprobes")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Link: https://patch.msgid.link/20260703114917.238144-5-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/uprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 7f820560e6f83..ba7ca62f96059 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -701,7 +701,7 @@ static struct vm_area_struct *get_uprobe_trampoline(struct mm_struct *mm, unsign
 
 	*new_mapping = true;
 	return _install_special_mapping(mm, vaddr, PAGE_SIZE,
-				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_DONTCOPY|VM_IO,
+				VM_READ|VM_EXEC|VM_MAYEXEC|VM_MAYREAD|VM_IO,
 				&tramp_mapping);
 }
 
-- 
2.53.0



