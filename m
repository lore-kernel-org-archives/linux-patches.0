Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C06A349CCF;
	Sat, 30 May 2026 18:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166170; cv=none; b=Mo1spHPRgUquAsh5jDuCQmR8dr7fI6PQyLgizoTJYVw0UL8Wiy55w/mhB86W+FYBkkoCiFKXgiGKJQ8qjRSzLoFPc9o9nPM0eeuI0PdaoQbUlcGg5cffz/KjjaHFuufLMnS3gcY+ZMz6JL3CkleBPTQK4k/ZbZbC9+unw+DbBAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166170; c=relaxed/simple;
	bh=a7t0yMAKAlw5ZQ+Cm8Y2t50xO0C9rq3oYAu71mAYTsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dw+0EJUOH399U1zklXwyhGq5vnLMrRIeiyeHbiyKWo7CD9+is0yKqL5KDpFQiKaX+mPvu3NBlskvu87MGtGA2TGOXXEgZC4Fse9C154PI4Rsatym12gvPzmMRXZhnJQ3isn5biFCIS0Ou5dKQoFu79Gu+P0ZghDJLBR0goWvtHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qymalb3F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qymalb3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810B21F00893;
	Sat, 30 May 2026 18:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166169;
	bh=xL9J2GkCXUmDc6c+svOot0tFHELnzCs0ogxAWYaEX5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qymalb3Fv0Tq6zNVsaZAVa2RzsD6MayAIgw4IncuWKjQKvRV0NDWe7PTJNNk8e7Md
	 wCm2/OE0A9ipJrpawcOtzpF66geT/klOwuOOcINDFjIhncPJR+D5QPmQHkNuwdK0Af
	 Poxu9RvUG3lep2lgb9TDgUqmRbDUjrlOhFCF7NpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 295/589] devres: fix missing node debug info in devm_krealloc()
Date: Sat, 30 May 2026 18:02:56 +0200
Message-ID: <20260530160232.694741638@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e3a735d0213a8..4bfc7f670ab0c 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -911,6 +911,8 @@ void *devm_krealloc(struct device *dev, void *ptr, size_t new_size, gfp_t gfp)
 	if (!new_dr)
 		return NULL;
 
+	set_node_dbginfo(&new_dr->node, "devm_krealloc_release", new_size);
+
 	/*
 	 * The spinlock protects the linked list against concurrent
 	 * modifications but not the resource itself.
-- 
2.53.0



