Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9832D5436;
	Tue, 21 Jul 2026 17:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655584; cv=none; b=GN+Atb1kCnxZqi8UkpUBu5P0q5OdOB2tnTXe9EWSsogsHQ/uPgqxmBYAMhfn1Q61ZNoqVmFR962UU9dPEMdAolnbkiNDZWosjMeewqTD5+g9J4l+qmZQqtsfVa2alHc/y6znnUsQEmrtPz7x8QCKcoFZUPnsJJAX2cKgc38jMrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655584; c=relaxed/simple;
	bh=q0nMd44P4P0p/FVb3fXqnM9eFN4Oe4PGUR0XU1WON2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jIUNeQ+7xtr4MNzMJzfFOqt8bSIltCA7vkp/ru+6Q3lOsQ7bYSGiDINd2b37LxFGM9Sl7domzbILsd+Fu522f27TGpH72Ju8D+DZGE9m7sUaGmqDse5p0Q0Nt8sDMmzlzP/ATL2XAgleLGNADV6hh+khFqNkfB4AwU84GPekc+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZOaBI66g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZOaBI66g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40051F000E9;
	Tue, 21 Jul 2026 17:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655583;
	bh=PUSoRcu8QljL1UnGdpJHGhO6GyJ9MnTEElXfpTMSVsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZOaBI66gOSux81NYrfUkYUmEAqIg4+cEUkPdvXtM7fJZGWMHaRm2FRsEXUbRHo3uD
	 8KCnRef4vRlY5u+gSKKK1vsKdONtrf5BkzvE0df2zSUQjLOtW3B/WkJm1IVvHXjibB
	 7U6IZzNDnMknqplhIAO4dTmzds0Q8eOZxTsKcZbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0065/1611] drm/gpuvm: Do not prepare NULL objects
Date: Tue, 21 Jul 2026 17:03:01 +0200
Message-ID: <20260721152516.294174956@linuxfoundation.org>
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

From: Jonathan Cavitt <jonathan.cavitt@intel.com>

[ Upstream commit 88f059f6f6f589bd78e2ceb05a1339a8c10b8626 ]

Statis analysis issue:

drm_gpuvm_prepare_range issues an exec_object_prepare call to all
drm_gem_objects mapped between addr and addr + range.  However, it is
possible (albeit very unlikely) that the objects found through
drm_gpuvm_for_each_va_range (as connected to va->gem) are NULL, as seen
in other functions such as drm_gpuva_link and drm_gpuva_unlink_defer.

Do not prepare NULL objects.

Fixes: 50c1a36f594b ("drm/gpuvm: track/lock/validate external/evicted objects")
Signed-off-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Krzysztof Karas <krzysztof.karas@intel.com>
Link: https://patch.msgid.link/20260130191953.61718-2-jonathan.cavitt@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gpuvm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/drm_gpuvm.c b/drivers/gpu/drm/drm_gpuvm.c
index af63f4d003155d..23e43406a1a8be 100644
--- a/drivers/gpu/drm/drm_gpuvm.c
+++ b/drivers/gpu/drm/drm_gpuvm.c
@@ -1289,6 +1289,9 @@ drm_gpuvm_prepare_range(struct drm_gpuvm *gpuvm, struct drm_exec *exec,
 	drm_gpuvm_for_each_va_range(va, gpuvm, addr, end) {
 		struct drm_gem_object *obj = va->gem.obj;
 
+		if (unlikely(!obj))
+			continue;
+
 		ret = exec_prepare_obj(exec, obj, num_fences);
 		if (ret)
 			return ret;
-- 
2.53.0



