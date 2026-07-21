Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E768B46AA67;
	Tue, 21 Jul 2026 15:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648066; cv=none; b=L1lFj8UIWHIGmxyuNssjq0dOWla1h+FQ7FCbao+tz3b2SyFD1A8S9/PT+8nnh0GnhnBvI9NbO9UVR41SAzD+ZkPTMOOboQtgnUexDwLzRiXo5nUFT6RYiXAIPHneKEaR+gbPBVJfzF6A1e3ZP15q8kQTJIBgcKjcA/ak/xfF8RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648066; c=relaxed/simple;
	bh=T56mJCvT98J5rJ9k5TyxoxjoGUETlq8teXbvqFLLX1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N49mYipoTq2dvXI7FTZxn981mWPcrs9vWFiJnACo+qLgkCP0n8jQtV3rvRZU7L7NAFPM47m8zVkCluz97kuYOW1GbAt//gVlJG8eb7k1VaCi0UGdbKeTfqIl6v5CXWKWNtFWtKMAtvh63lV2caMqMV1gKnU8TGTdfSrBrRLaqzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8kH7lYy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8kH7lYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405CE1F00A3A;
	Tue, 21 Jul 2026 15:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648065;
	bh=cQUqwDvEMM22mZ0dxZ3W4P+i46KjaJ4tLqO18ORzVuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8kH7lYyL+ObBudy+LJY+43HN7egH2Qa5DHNoivQWazT6sVyJJkYOJ/HOxmW4JNDv
	 N0uLUNWC8ngHiy8hUdJmcy2VducXrSpa81N/12m56BwoK95dNisClohmdtbxxvfVYw
	 N9DwvTl79CCT6tOBoQIC5Mlnp5fpNDYGgjm5yI/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0059/2077] drm/gpuvm: Do not prepare NULL objects
Date: Tue, 21 Jul 2026 16:55:32 +0200
Message-ID: <20260721152554.084649293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 44acfe4120d243..f56719e9f4350a 100644
--- a/drivers/gpu/drm/drm_gpuvm.c
+++ b/drivers/gpu/drm/drm_gpuvm.c
@@ -1322,6 +1322,9 @@ drm_gpuvm_prepare_range(struct drm_gpuvm *gpuvm, struct drm_exec *exec,
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



