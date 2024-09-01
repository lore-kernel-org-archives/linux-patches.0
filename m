Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C352C1B4;
	Sun,  1 Sep 2024 16:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207642; cv=none; b=NzF09Jg/Y82y1KPrkI+JfmYISEIt68ZWEGAL/Cm3gDzLW9+RHU/UeBFQsvB2v0vfijajcjkyakejkLrH3q+rRL0sDmwWYcp93xVhOEPVeHgHQ8KHHJW5kcB6HevC1HGjkGbFG6ZNoXH/xAmS26Tschue90WyxNpSP1apro4YocE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207642; c=relaxed/simple;
	bh=kRwqkHIOD9i6yjTKpahYW2ae48QNQ/fuyVbicz/wZmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bO5xSUF12E/qKQy895PfWDHYI1Hyd78SR+IXN/R3x3s7CC01Jco66WB6zn4ldkJ4cqXEL3Jr0eUUkbEIbJOWhmvdh/amsAF910a8FEDKPm1n/OxFxeDcSfelGqhBPx+9dOQjJVZMkEAWhrDz++3cvqb5CV9R2H8XEpwMVjMxxsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlfkE58Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlfkE58Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB28C4CEC3;
	Sun,  1 Sep 2024 16:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207642;
	bh=kRwqkHIOD9i6yjTKpahYW2ae48QNQ/fuyVbicz/wZmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlfkE58Qy0ASM72Zeuv/Rx/SbyDWdTN1PUVVqmKVpy2jiLHVQaRnnfj6FthPIoEMY
	 BM1lozbE0qgOudYEkMcafs/gXvx2Xwdu7tWxldHKo7swJOgObSrimH8t4kywPh+bWh
	 e+sq1sw3+8R8KKddr3+DQoQgosCICcjsKQ5egWBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li zeming <zeming@nfschina.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 34/98] powerpc/boot: Handle allocation failure in simple_realloc()
Date: Sun,  1 Sep 2024 18:16:04 +0200
Message-ID: <20240901160804.984801373@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li zeming <zeming@nfschina.com>

[ Upstream commit 69b0194ccec033c208b071e019032c1919c2822d ]

simple_malloc() will return NULL when there is not enough memory left.
Check pointer 'new' before using it to copy the old data.

Signed-off-by: Li zeming <zeming@nfschina.com>
[mpe: Reword subject, use change log from Christophe]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20221219021816.3012-1-zeming@nfschina.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/simple_alloc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/simple_alloc.c b/arch/powerpc/boot/simple_alloc.c
index 65ec135d01579..188c4f996512a 100644
--- a/arch/powerpc/boot/simple_alloc.c
+++ b/arch/powerpc/boot/simple_alloc.c
@@ -114,7 +114,9 @@ static void *simple_realloc(void *ptr, unsigned long size)
 		return ptr;
 
 	new = simple_malloc(size);
-	memcpy(new, ptr, p->size);
+	if (new)
+		memcpy(new, ptr, p->size);
+
 	simple_free(ptr);
 	return new;
 }
-- 
2.43.0



