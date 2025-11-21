Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65C623183B;
	Fri, 21 Nov 2025 13:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730950; cv=none; b=FoW+/hno2vu9kpmHKfEzrWUDzWcEVWQ81mvw7P+R8hrHkHEO/lNzQEuAtDQKkgSEeELXU2juIBUInPgUqJQVbKtbDJR2QdwCuVrehkXoplMzoYQOd+GoiXFjylNUNAecsmE9mJJ/QT77uQlShBqOawYQfuwaZRK65/5Mvu0OncA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730950; c=relaxed/simple;
	bh=OMlJsB1KuZSdCNyqwb/oTTlCsArhBXQ/qm1DwS1pzpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcOeKdPkov4MzZdfg9evQHMPYYLgBWF+gXSft7LbIJAHcrs8uxWLtkKusfrG4hJrUgApf0ihkQ2cdtBJulNFyXN+i8osuPaMaD4qPt6lKD4xCL1Q5mUSP1aLxE5mbJpnexWGzHbq96BboShQxF+q7qt5Pr1Zp2W8mMFNrEzg7aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8U4gMex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8U4gMex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401E3C4CEF1;
	Fri, 21 Nov 2025 13:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730950;
	bh=OMlJsB1KuZSdCNyqwb/oTTlCsArhBXQ/qm1DwS1pzpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8U4gMexFz5MrTDH5aDPzX/EsRTjo7q1g8Xmeg32/amIziEKRtmM+Bc1Bka6XXhu9
	 n0N9AzNwyvuV/4yxtQIBDvJH8N2GgvIqwQAaahm9Md8NRTjZcZL0RTswQvP/UilXoD
	 6uGqeg+GqoK0m/AXIduNX/cSKekCtN2ih09cT32c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhanjun Dong <zhanjun.dong@intel.com>,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 011/247] drm/xe/guc: Synchronize Dead CT worker with unbind
Date: Fri, 21 Nov 2025 14:09:18 +0100
Message-ID: <20251121130155.004442752@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>

[ Upstream commit 95af8f4fdce8349a5fe75264007f1af2aa1082ea ]

Cancel and wait for any Dead CT worker to complete before continuing
with device unbinding. Else the worker will end up using resources freed
by the undind operation.

Cc: Zhanjun Dong <zhanjun.dong@intel.com>
Fixes: d2c5a5a926f4 ("drm/xe/guc: Dead CT helper")
Signed-off-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://patch.msgid.link/20251103123144.3231829-6-balasubramani.vivekanandan@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 492671339114e376aaa38626d637a2751cdef263)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_ct.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index 22eff8476ad48..75ac0c424476e 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -200,6 +200,9 @@ static void guc_ct_fini(struct drm_device *drm, void *arg)
 {
 	struct xe_guc_ct *ct = arg;
 
+#if IS_ENABLED(CONFIG_DRM_XE_DEBUG)
+	cancel_work_sync(&ct->dead.worker);
+#endif
 	ct_exit_safe_mode(ct);
 	destroy_workqueue(ct->g2h_wq);
 	xa_destroy(&ct->fence_lookup);
-- 
2.51.0



