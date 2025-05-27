Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09BF42A9B;
	Tue, 27 May 2025 17:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368157; cv=none; b=qmCsLW4aFGI9zsKWDGw5IeLZlUhP4zBxsBLb71yObsghCbv+eQJj6IH6oV+qVe89HKxbDqXB4VkXkl+F4sZbPD5J0inqRg8M5j9S936pMqFFpVVAg3WMpkfXgWswz6kzExJMoa133qyWuD+6yOjYaEGcB+R8MkgHE1KXfUOuHDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368157; c=relaxed/simple;
	bh=mJD9DsMWQHE1eUrVJNkqFp5Jg1NRSdPjZII2Oui4SuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQYZcP5Gyp40QHSw/z2bvHvJQG8NNbjDUl5odU44jHO1IpdYiByhG5kKPWSNX1ERPeXD8nYpk+pcR0nKQLRUQnzlOFPnNNwDl9Z9FYMfHiu9bpMdCltEiZ9qRF9Vc5DZ7SC/QPg9mDPAfzcWiZzi6/TdVbRuRzwADuRhdBpyzsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aL7RoClt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aL7RoClt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E13AC4CEE9;
	Tue, 27 May 2025 17:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368156;
	bh=mJD9DsMWQHE1eUrVJNkqFp5Jg1NRSdPjZII2Oui4SuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aL7RoCltCw7ShyjUfdzD167ECiwvTYt61h1NAWXc0biBQepY1HAAncuyAgP/qeNiy
	 ZTGq2ZguecNyqc670vBYvJuH/SBZcmNEInzLbwCYMnaK+NDzl+waCblPMnhYc5uGqb
	 kkkD4yHr8wC3pUSSltq9UuQAavvHut+664W9JLK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 617/783] drm/xe: Do not attempt to bootstrap VF in execlists mode
Date: Tue, 27 May 2025 18:26:54 +0200
Message-ID: <20250527162538.273355644@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten Lankhorst <dev@lankhorst.se>

[ Upstream commit f3b59457808f61d88178b0afa67cbd017d7ce79e ]

It was mentioned in a review that there is a possibility of choosing
to load the module with VF in execlists mode.

Of course this doesn't work, just bomb out as hard as possible.

Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241210083111.230484-12-dev@lankhorst.se
Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_sriov_vf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_vf.c b/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
index 1c764f200b2a5..a439261bf4d72 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
@@ -236,6 +236,9 @@ int xe_gt_sriov_vf_bootstrap(struct xe_gt *gt)
 {
 	int err;
 
+	if (!xe_device_uc_enabled(gt_to_xe(gt)))
+		return -ENODEV;
+
 	err = vf_reset_guc_state(gt);
 	if (unlikely(err))
 		return err;
-- 
2.39.5



