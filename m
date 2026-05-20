Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4DB33BBAF;
	Wed, 20 May 2026 17:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297413; cv=none; b=f1NkJZqwMwY0xwSa3NAW+ceCyoBqwXqkttzsViZzJuD8yN/+mCX0tcGd05AEVZbe/EKfhAmFDOttpWqwu0BaCNH2sWHbi7mNBv29Yr3cGl+oCrVVt0aEjKiZI3JidgA1o8RtNfZnwlAV1J1gnPNZaL0nlpfNkdIykhKnSPRT3Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297413; c=relaxed/simple;
	bh=3e0SiiXT8S1URB/5OEwtjNtc/DJyZf9WmkGyduON0nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdzP+R3n2AHtYTnYoXsceSD2h4E7GK/4e0OKA6CihRWLCyN26zFVzWEZ3tVGh3quIqTcbuiI/Ys9LqzWslBolA3w4XEzFNU8iuWsaNOI8fHnh4QB6F3y5ra4HXD52XkomvEKX1nsj0jLBnhO7XpnFBPUkuM82bsbtBFqadC9yPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qutoYyaz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qutoYyaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1061E1F000E9;
	Wed, 20 May 2026 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297412;
	bh=CgztJkNO0PZS5phY54eKgKs8cu0VO+XOfGpAOJswAWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qutoYyazIjdpflhrHSvLAKcOCNp+9kII5R5TCbGgImu+SHjR2+eazWCgBysbwHcAL
	 TN58XC43iVa1yA/q5pVOtohziXEeQ+Lh3Du3UT8L9YjfQuXLgPnUV0ZqJiMvvDo9Mp
	 lY1Ne/os730TruRbhmRL+GfUuRlMHkIA+8J+NpmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/957] devres: fix missing node debug info in devm_krealloc()
Date: Wed, 20 May 2026 18:08:25 +0200
Message-ID: <20260520162135.041687076@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit f813ec9e84b4d0ca81ec1da94ab07bfb4a29266c ]

Fix missing call to set_node_dbginfo() for new devres nodes created by
devm_krealloc().

Fixes: f82485722e5d ("devres: provide devm_krealloc()")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260202235210.55176-2-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devres.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index c948c88d39560..9893d656302d9 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -940,6 +940,8 @@ void *devm_krealloc(struct device *dev, void *ptr, size_t new_size, gfp_t gfp)
 	if (!new_dr)
 		return NULL;
 
+	set_node_dbginfo(&new_dr->node, "devm_krealloc_release", new_size);
+
 	/*
 	 * The spinlock protects the linked list against concurrent
 	 * modifications but not the resource itself.
-- 
2.53.0



