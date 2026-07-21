Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF1A3368A2;
	Tue, 21 Jul 2026 18:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658310; cv=none; b=uy2vWMs0FbOd1iVWGrJZeEShpq/EUjYPl1OGnSll/iatm33JyyZDpxo1rccJAiQMW2bQXrjDUj6dAnPmLvur6X943xw7NSh807mbau87MpFRyl39lxOkQIUt/IVwHaOzLDlKOKbWAMaD7iT7OlBMWIxJ4jHNpT5F+Zm/CZJtDtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658310; c=relaxed/simple;
	bh=P3GCAYR1PbnrBX4+1OEuGQKcdiv6k8gbNqTLmJz7Zf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EPqQ5tdgOM8bfHkoca1LVVL2Em9c4HD0cJMQOpFEgOdHjWD1uGC3xMOiYE9egHEvitvfdq4R8Dninr40RENn+8VF+9hU80H6v9Qlz3Serpxn9AkuN8e8qeBlJizl/liYz7pg9xLwgTjsZcyfvI8Grb06ETi9X2zbYS01zDCdpQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=my4K91Mp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="my4K91Mp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1561F000E9;
	Tue, 21 Jul 2026 18:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658309;
	bh=PO5Ytjz/Lv6m1g92ivYN/FLvAy7fn++MNeGemxCEpOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=my4K91MpwrxXbb95d4b3qlWz76BiJueToHTXp6g4K6qB79/UkVy0LLkSIeeVE+ckg
	 Y/75g3MlLk+BXxbOUIulh/kBFqb/rV+uzj03+la2BtDbVf4PLiuJ6/iNH8J1kX2xpC
	 tHhJUZllu9lSEIQcw9c5PGRNjivLUVw18zY5vthc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1068/1611] drm/v3d: Reject invalid indirect BO handle in indirect CSD setup
Date: Tue, 21 Jul 2026 17:19:44 +0200
Message-ID: <20260721152539.430273794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 2f8b8593c7832fad655290cef9e99af05b1b52b3 ]

v3d_get_cpu_indirect_csd_params() looks up the indirect buffer object
from a userspace-supplied handle but never checks the result. A bogus
or stale handle makes drm_gem_object_lookup() return NULL, which is
then stored in info->indirect and only dereferenced later when the
indirect CSD job runs, turning a userspace mistake into a NULL pointer
dereference in the kernel.

Bail out with -ENOENT as soon as the lookup fails, so the bad handle is
rejected at submission time.

Fixes: 18b8413b25b7 ("drm/v3d: Create a CPU job extension for a indirect CSD job")
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Link: https://patch.msgid.link/20260703-v3d-cpu-job-fixes-v3-2-bc51b1f3eeb5@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_submit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/v3d/v3d_submit.c b/drivers/gpu/drm/v3d/v3d_submit.c
index 95b9e68b0dfe5e..1274e6010bea2f 100644
--- a/drivers/gpu/drm/v3d/v3d_submit.c
+++ b/drivers/gpu/drm/v3d/v3d_submit.c
@@ -462,6 +462,8 @@ v3d_get_cpu_indirect_csd_params(struct drm_file *file_priv,
 	       sizeof(indirect_csd.wg_uniform_offsets));
 
 	info->indirect = drm_gem_object_lookup(file_priv, indirect_csd.indirect);
+	if (!info->indirect)
+		return -ENOENT;
 
 	return v3d_setup_csd_jobs_and_bos(file_priv, v3d, &indirect_csd.submit,
 					  &info->job, &info->clean_job,
-- 
2.53.0



