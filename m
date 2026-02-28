Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0258636D9E9;
	Sat, 28 Feb 2026 17:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301432; cv=none; b=R1vL7q1V98c9FkzG9J0Mq7NgGm0t+4bPeWOdiupWN16dLsWm/R5vYaIuR67MtP9WKAkb2PJGkeYcWq4+uaGs7IjN6GmrTttkLkGOC4qNZLf6GgTtsiEGx0CiQzt/tk/sJa8/S2fEHqjJR0kbCJzeJhJhm+KfEqFAEgzupkNTtb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301432; c=relaxed/simple;
	bh=yxA5KaE4uvfBQpQprwMxjBhIEAzroIjNlZjVW68MtJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCU7wLdLmj4TKvEhrjhNxhTqZIH0tO3KDWVvsiFwVXCBmwLU/deJc81uoJYMY5au7JjY1GsexotYmls+7532jvBrytpKOHVC1IA2ly3vC2puaLfVnNPAWfZU+x5MxF01/zIilZIutaDVveBWKTtolSzePxjDDOlfb1JJ179PYIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JUY9U1HA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JUY9U1HA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF2DC116D0;
	Sat, 28 Feb 2026 17:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301431;
	bh=yxA5KaE4uvfBQpQprwMxjBhIEAzroIjNlZjVW68MtJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUY9U1HAqXPN7YPiMdhT/ht6Y9FyEYvRndUnoptMMgENmT8g4AJ+V3iLQTdtu6B+r
	 ZZwHn2EqhXrV79pIRw+cgrPqyQaHAMGCsmOuis9wRCVWClFaFy2MbtNZt5R2Bm1HnD
	 VQ0LPST+LfGHVrLau9TJCUApQJUpF1WiYO0UUB5CakYLl/gesbqvt9FG0uxk0/wGdN
	 HUkayGHrE5Vkbewn0kKVb31z+nEH/JIFIUPy8/xacH68ky7V3kBbHpa5kRxFQqZVQE
	 AfJxRkiZMKe0KjCQ4ssXtkzcaNt/7UCknh/JxFh5sAlB7JdLGF1MGZ9QG8/5vZy5Yi
	 XpjxXcDYxbb0g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	stable@vger.kernel.org,
	Srinivas Kandagatla <srini@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 622/752] nvmem: Drop OF node reference on nvmem_add_one_cell() failure
Date: Sat, 28 Feb 2026 12:45:33 -0500
Message-ID: <20260228174750.1542406-622-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit f397bc0781553d01b4cdba506c09334a31cb0ec5 ]

If nvmem_add_one_cell() failed, the ownership of "child" (or "info.np"),
thus its OF reference, is not passed further and function should clean
up by putting the reference it got via earlier of_node_get().  Note that
this is independent of references obtained via for_each_child_of_node()
loop.

Fixes: 50014d659617 ("nvmem: core: use nvmem_add_one_cell() in nvmem_add_cells_from_of()")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260116170846.733558-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 387c88c552595..ff68fd5ad3d6f 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -831,6 +831,7 @@ static int nvmem_add_cells_from_dt(struct nvmem_device *nvmem, struct device_nod
 		kfree(info.name);
 		if (ret) {
 			of_node_put(child);
+			of_node_put(info.np);
 			return ret;
 		}
 	}
-- 
2.51.0

