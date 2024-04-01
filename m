Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1352246420;
	Mon,  1 Apr 2024 15:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986618; cv=none; b=Mj8q2RulQjkG7xevYmLXMg1fEGFZhCrDdTNK70+hw3bZ6KZPOM73WVVKkrXyKlzJZYpdpXTV/ku8WwwEemy58RjGVN4kekTPs2p8sqRf6AI3JeFUvS5JIY4YNwF6JOpJEAvGD/LvYji/RQ5rXGsSf03+FjFST/YJqv9WOcI7/Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986618; c=relaxed/simple;
	bh=iezbkCOLBDNPUnnvXN4dcCe8D60gSu8vtuJmaxI1F3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRP4943z0/dd6Q12visJN8MPPDBLSqitlL7yUDpYiMBUT7eSUaC6wNs2eFgqrdE+OF+O2UfUzmNw+Kl5t+ICMm/OuN17ZZeKQEE2QILLOLugKb9PbtXh3tV7++Sfgvwce5moND5/IzITD+Q00t+q7TReAY5bzy0m0yPUsd15p4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THNRD+Xa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THNRD+Xa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2E7C433F1;
	Mon,  1 Apr 2024 15:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986618;
	bh=iezbkCOLBDNPUnnvXN4dcCe8D60gSu8vtuJmaxI1F3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THNRD+Xa0DnvRWWIK1TQq8Ui+Ch0uxaJqufSJYOnDx0A1fUoJfBC/TzD+sx3E6mUs
	 gy4ItHbgMP5VDSokFQDG6muUUbGYOoWjJTZCZknOfp4MrOo0SY7OiNVRgs32ooBeZV
	 tVjce+W8BwtHuw+AiItKIHtxXNmLi8GUpxKkHCjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 030/399] powercap: intel_rapl: Fix a NULL pointer dereference
Date: Mon,  1 Apr 2024 17:39:56 +0200
Message-ID: <20240401152550.063272304@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 2d1f5006ff95770da502f8cee2a224a1ff83866e ]

A NULL pointer dereference is triggered when probing the MMIO RAPL
driver on platforms with CPU ID not listed in intel_rapl_common CPU
model list.

This is because the intel_rapl_common module still probes on such
platforms even if 'defaults_msr' is not set after commit 1488ac990ac8
("powercap: intel_rapl: Allow probing without CPUID match"). Thus the
MMIO RAPL rp->priv->defaults is NULL when registering to RAPL framework.

Fix the problem by adding sanity check to ensure rp->priv->rapl_defaults
is always valid.

Fixes: 1488ac990ac8 ("powercap: intel_rapl: Allow probing without CPUID match")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Cc: 6.5+ <stable@vger.kernel.org> # 6.5+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 2feed036c1cd4..1a739afd47d96 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -759,6 +759,11 @@ static int rapl_config(struct rapl_package *rp)
 	default:
 		return -EINVAL;
 	}
+
+	/* defaults_msr can be NULL on unsupported platforms */
+	if (!rp->priv->defaults || !rp->priv->rpi)
+		return -ENODEV;
+
 	return 0;
 }
 
-- 
2.43.0



