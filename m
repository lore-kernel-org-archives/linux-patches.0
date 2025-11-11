Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE38034B402;
	Tue, 11 Nov 2025 01:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823789; cv=none; b=BPSNvWyfX2TBjHdYJW3/7FQIsO+1xHIcHJ8TPhADn95QslCDeQgOPntVcWQPvRRYB7ZEMdq2BCwK9OjryT4KTeDyU2rZVbWapCS86bKuQxxq8X0AkpinovzCjb5SRKsFP2usSQXrBrYf1lEZnp5wEulBufkcIjj8WuQ9+odcf7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823789; c=relaxed/simple;
	bh=wPlMKeDdJenYmMgpKisIF0GL+/DK8sq7I3oRt4iIx/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0QbmO3l4G/iV2+xl4jFGGH9USowTnaR3QaZlptbTCx3HAst243hdd3Dl5dWQYNWXJpfrZD/RI86Bj/6VpOFlpO29by4CoHBq049wRRPCMML5KgUptsDiFsqgsBC18EqZZ7TBQllW3x8tDDLIClcPe37mWKcPRFhlP6rdmJ5QJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oj9ZyYZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oj9ZyYZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7821CC19424;
	Tue, 11 Nov 2025 01:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823788;
	bh=wPlMKeDdJenYmMgpKisIF0GL+/DK8sq7I3oRt4iIx/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oj9ZyYZs9snO/FdCF9zvbXOnHwEG/wy5dpzYEZqr46UXfZ3uNDxkIVfXm1BeN0zAE
	 VLCSdGQ7tVK+FjTWH1dE2r7ND/H5Nfl3BBTdXiplZQEADoljiY0KKkpgHTp7WKA0u9
	 Q6NNnlaZqdbMl0+zfl/XXFbhu7KMTo8EoKXR0fPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ce Sun <cesun102@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 372/849] drm/amdgpu: Correct the counts of nr_banks and nr_errors
Date: Tue, 11 Nov 2025 09:39:02 +0900
Message-ID: <20251111004545.423725635@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ce Sun <cesun102@amd.com>

[ Upstream commit 907813e5d7cadfeafab12467d748705a5309efb0 ]

Correct the counts of nr_banks and nr_errors

Signed-off-by: Ce Sun <cesun102@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
index d1e431818212d..9b31804491500 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_aca.c
@@ -76,6 +76,7 @@ static void aca_banks_release(struct aca_banks *banks)
 	list_for_each_entry_safe(node, tmp, &banks->list, node) {
 		list_del(&node->node);
 		kvfree(node);
+		banks->nr_banks--;
 	}
 }
 
@@ -238,6 +239,7 @@ static struct aca_bank_error *new_bank_error(struct aca_error *aerr, struct aca_
 
 	mutex_lock(&aerr->lock);
 	list_add_tail(&bank_error->node, &aerr->list);
+	aerr->nr_errors++;
 	mutex_unlock(&aerr->lock);
 
 	return bank_error;
-- 
2.51.0



