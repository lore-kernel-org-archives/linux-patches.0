Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02DC30DEA6;
	Tue, 16 Dec 2025 12:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887689; cv=none; b=kmvwSDfQtBI6a+kF64ZJ8qrwt97tg996Y7NDYfs0d3SeYbgUF6pRWCJDaIfiG11vtZKjtrB1rX4QIiHbbyj/HQ68BSc2gnsKR5k6ZPtbJUqeE7nykvxB6nSXI80iQj9XX+tNiXTirSIATcBEoVp7yvPwKg456agyM2V3BeMNNKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887689; c=relaxed/simple;
	bh=s2lAjG99hkMOYtOR1p/kRIOxduP+UMnlJqyyTJAzUEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pq8zVhxxTtlU6Cx+y9eWLTAIsldjbZaLszfiwWyfl9u9fXqe1cTZWVoX2GoJXdzPo3RnJigxcKOa5UB73z8KEbnHzGftUrmvL+LPYlZWnVKRKTYtukAPFZ4AvJ6YGzoQZ/1UXexo3fuiUq7Q/X4SvnDtp8qiRdKgrGaMj5BaMQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/hdI717; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/hdI717"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335A4C4CEF1;
	Tue, 16 Dec 2025 12:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887689;
	bh=s2lAjG99hkMOYtOR1p/kRIOxduP+UMnlJqyyTJAzUEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/hdI717j9aJpfa2JED//WbNLqs8fM0UO4pG0Gk6Cfq1kKftwaDPiY6mLSd954Cul
	 SntJRorEaAn1XQdUbtSKrnHEUPGL6YpvL9nvA3aCi9qlDczqUDV3j1ByT0cw97kkvz
	 LnRkrqbpFtIGMnDe9tNU8f53Wxp6xMjHiZ4IF3bA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 307/614] drm/msm: Fix NULL pointer dereference in crashstate_get_vm_logs()
Date: Tue, 16 Dec 2025 12:11:14 +0100
Message-ID: <20251216111412.491779379@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit 3099e0247e3217e1b39c1c61766e06ec3d13835f ]

crashstate_get_vm_logs() did not check the return value of
kmalloc_array(). In low-memory situations, kmalloc_array() may return
NULL, leading to a NULL pointer dereference when the function later
accesses state->vm_logs.

Fix this by checking the return value of kmalloc_array() and setting
state->nr_vm_logs to 0 if allocation fails.

Fixes: 9edc52967cc7 ("drm/msm: Add VM logging for VM_BIND updates")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Patchwork: https://patchwork.freedesktop.org/patch/687555/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gpu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index 17759abc46d7d..e23f70fbc8cb2 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -348,6 +348,10 @@ static void crashstate_get_vm_logs(struct msm_gpu_state *state, struct msm_gem_v
 
 	state->vm_logs = kmalloc_array(
 		state->nr_vm_logs, sizeof(vm->log[0]), GFP_KERNEL);
+	if (!state->vm_logs) {
+		state->nr_vm_logs = 0;
+	}
+
 	for (int i = 0; i < state->nr_vm_logs; i++) {
 		int idx = (i + first) & vm_log_mask;
 
-- 
2.51.0



