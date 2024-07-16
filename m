Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AA31DDF5;
	Tue, 16 Jul 2024 15:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144642; cv=none; b=gBBnCHsK1qp1oDvWL3bpNmoEeg/xUhRt9JIcASCQhT6z6SJKTzhPHsYanl1F9mCKlH38hrhtvT5DjOdYXq0yg4wSZ7A1zGojfldSnNCduU1TWekV9Z2uxUOQKOWX69frVRlip9jzPZQEyQP0MTdnzfqNNKOJjGk+yDO+j13/Dmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144642; c=relaxed/simple;
	bh=S6QOL8jkET5l4vzY8XcIAMQDxBgfKk9TDOygnrN957k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CImoA0cMG0TmPoq8iwjkbWJ3dYpLFOWnrU3T1l+RvV36QoWpZ6zYgWd+YXyI5iCKIKmlw6QZybxckjMbosljkFHM5DYvyTtFCesyDsDw6i6wz2+yjYMV+W7OWFPLOBKhLsMeR8VVPlALe6biyRmE/x1sePElHJasLnXHhH5lUuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrRwqZrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrRwqZrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51320C116B1;
	Tue, 16 Jul 2024 15:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144642;
	bh=S6QOL8jkET5l4vzY8XcIAMQDxBgfKk9TDOygnrN957k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JrRwqZrLXI5OGkOhdS+/buLwQ1V1c5goIDGfV/WAh4tATnivazNt86oN1Rxb5SewN
	 pBlNWNqbuVEGZ00hJR720eqCEYOaSqKHpE8PSouvJjkvsJuMIMdMTqZRsxksybdAIW
	 CF96nlFelQeEzdu0F+MZ2bMr0Ebup9XNpFNR72Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/108] mm: prevent derefencing NULL ptr in pfn_section_valid()
Date: Tue, 16 Jul 2024 17:31:13 +0200
Message-ID: <20240716152748.212923036@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 82f0b6f041fad768c28b4ad05a683065412c226e ]

Commit 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing
memory_section->usage") changed pfn_section_valid() to add a READ_ONCE()
call around "ms->usage" to fix a race with section_deactivate() where
ms->usage can be cleared.  The READ_ONCE() call, by itself, is not enough
to prevent NULL pointer dereference.  We need to check its value before
dereferencing it.

Link: https://lkml.kernel.org/r/20240626001639.1350646-1-longman@redhat.com
Fixes: 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing memory_section->usage")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mmzone.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ffae2b3308180..71150fb1cb2ad 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1353,8 +1353,9 @@ static inline int subsection_map_index(unsigned long pfn)
 static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
 {
 	int idx = subsection_map_index(pfn);
+	struct mem_section_usage *usage = READ_ONCE(ms->usage);
 
-	return test_bit(idx, READ_ONCE(ms->usage)->subsection_map);
+	return usage ? test_bit(idx, usage->subsection_map) : 0;
 }
 #else
 static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
-- 
2.43.0



