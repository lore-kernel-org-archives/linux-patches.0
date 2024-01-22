Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E262B128394;
	Tue, 23 Jan 2024 00:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970973; cv=none; b=bfP2aunsmo/gHIwCkduTNNMgPWQEVtnAgvHy9+2PmAEKCcKK+qFTzzgIQoNJwQ8yWMu5RsRsf/p/jF6IrQVn5/4u5H79c80A9CRXDOMoQQBHmumbYSyKRS5LIF4n1Bv0zuqia7jBstIaaPpzLS+bFZWvxxBMtOig0+CnwL8jwkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970973; c=relaxed/simple;
	bh=n5KKsXnqQYkfKQy7qeRoFKYw70NSKh1uIfU5mZLKgcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vrrtx+E+xP4VMl0M/wt/KG132VI/8ZcfwCR0RqzqQ2FbftkNa417hdKPF+6ywaCIFYZ5xT1aZHbTrVPSemv7dBXEOw1Q3tESAfHZZi0bllcXZ5fffYhFKUW0b/qLlnyqqGhrXdVgTwXHYFRZWUYviN5eIdcuAnPn6LqjfTefXRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J8aGOlnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8aGOlnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596B4C433C7;
	Tue, 23 Jan 2024 00:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970972;
	bh=n5KKsXnqQYkfKQy7qeRoFKYw70NSKh1uIfU5mZLKgcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8aGOlnj3lE52Gly1RNVV9XTp5N20BRD2NgUoMfE8lK0PY3JHFaEDsuSc1LqNc8tr
	 QTILW0aZBf4O/bKGpXTcsgJ4AwueH6SxmJWo4+cinWbqPj6g3NNxoFY1nPAgfUm7s6
	 PsDS5CkZFbVRWQgY7rWsaHhSdBwmRQ5unGA1c+L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/286] powerpc/imc-pmu: Add a null pointer check in update_events_in_group()
Date: Mon, 22 Jan 2024 15:56:06 -0800
Message-ID: <20240122235734.342465150@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 0a233867a39078ebb0f575e2948593bbff5826b3 ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: 885dcd709ba9 ("powerpc/perf: Add nest IMC PMU support")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231126093719.1440305-1-chentao@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/imc-pmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/perf/imc-pmu.c b/arch/powerpc/perf/imc-pmu.c
index 3e15d0d054b2..5464c87511fa 100644
--- a/arch/powerpc/perf/imc-pmu.c
+++ b/arch/powerpc/perf/imc-pmu.c
@@ -292,6 +292,8 @@ static int update_events_in_group(struct device_node *node, struct imc_pmu *pmu)
 	attr_group->attrs = attrs;
 	do {
 		ev_val_str = kasprintf(GFP_KERNEL, "event=0x%x", pmu->events[i].value);
+		if (!ev_val_str)
+			continue;
 		dev_str = device_str_attr_create(pmu->events[i].name, ev_val_str);
 		if (!dev_str)
 			continue;
@@ -299,6 +301,8 @@ static int update_events_in_group(struct device_node *node, struct imc_pmu *pmu)
 		attrs[j++] = dev_str;
 		if (pmu->events[i].scale) {
 			ev_scale_str = kasprintf(GFP_KERNEL, "%s.scale", pmu->events[i].name);
+			if (!ev_scale_str)
+				continue;
 			dev_str = device_str_attr_create(ev_scale_str, pmu->events[i].scale);
 			if (!dev_str)
 				continue;
@@ -308,6 +312,8 @@ static int update_events_in_group(struct device_node *node, struct imc_pmu *pmu)
 
 		if (pmu->events[i].unit) {
 			ev_unit_str = kasprintf(GFP_KERNEL, "%s.unit", pmu->events[i].name);
+			if (!ev_unit_str)
+				continue;
 			dev_str = device_str_attr_create(ev_unit_str, pmu->events[i].unit);
 			if (!dev_str)
 				continue;
-- 
2.43.0



