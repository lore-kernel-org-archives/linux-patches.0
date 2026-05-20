Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FC53EE1C0;
	Wed, 20 May 2026 16:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294938; cv=none; b=i9Pd0gJtJBGPHqfpyv1oFh9Nh8/nlTM6mqeDU6HintgIXPCQ4BIoTeLNJyfaov6ZzRDG2XrabxsFznmahE2DZFF+xxCh+1tTND8aF+6s5tOzWfK3xNwEdc0pKylG5D5b1/cZRvfVAywnu0PeTUIK2FfeuX+Ifi3u/Yb+ci/h33c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294938; c=relaxed/simple;
	bh=Rjxo6B4ygyGIYvPk1tpKnt5VV//wuuBU5g+esHCCR4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hY9yyzvTqc2TeHnKCHTLm4kTXPYd6IFlApVZQ8UfoqqS6emqiOdnbnxdzfS8xmUPpYbUmXNooZMVJY7wTrQA2HJqiEj55JKHDwXDbwcwI1rwqp3Pc9CJT57jZdl56QXuuLSFQDQF3W88zzuSXdLGt+d1W+o/lZQGjJLloeW4i0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZoBDSAbl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZoBDSAbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7F71F000E9;
	Wed, 20 May 2026 16:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294937;
	bh=HaW+jvcTD7s2BUPi0AY+dD/E1B0JwRR5h+tN69HXWOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZoBDSAblXGTXn+GvcuVEqNNkcuLvb9RN6M8DXOFoeKQKnEgT7UY0EJdVP7eiK/iOu
	 KywLLLnTlD4yeS8g8GPyAxmEUt8o7RbyyH4EyDu7bPJF8JMFgikfBP+Vd/s+NFzcfB
	 numTZZD/Zp5KjX4ni1AAdMtVaQttOafj4dk/Kxrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Patelczyk <maciej.patelczyk@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0229/1146] drm/gpusvm: Fix unbalanced unlock in drm_gpusvm_scan_mm()
Date: Wed, 20 May 2026 18:07:59 +0200
Message-ID: <20260520162153.434646095@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Patelczyk <maciej.patelczyk@intel.com>

[ Upstream commit d287dee565c3c32e1ed76ec1847af46809c29b90 ]

There is a unbalanced lock/unlock to gpusvm notifier lock:
[  931.045868] =====================================
[  931.046509] WARNING: bad unlock balance detected!
[  931.047149] 6.19.0-rc6+xe-**************** #9 Tainted: G     U
[  931.048150] -------------------------------------
[  931.048790] kworker/u5:0/51 is trying to release lock (&gpusvm->notifier_lock) at:
[  931.049801] [<ffffffffa090c0d8>] drm_gpusvm_scan_mm+0x188/0x460 [drm_gpusvm_helper]
[  931.050802] but there are no more locks to release!
[  931.051463]

The drm_gpusvm_notifier_unlock() sits under err_free label and the
first jump to err_free is just before calling the
drm_gpusvm_notifier_lock() causing unbalanced unlock.

Fixes: f1d08a586482 ("drm/gpusvm: Introduce a function to scan the current migration state")
Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260209123433.1271053-1-maciej.patelczyk@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gpusvm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index 04bdc386c3fd8..35dd07297dd08 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -819,7 +819,7 @@ enum drm_gpusvm_scan_result drm_gpusvm_scan_mm(struct drm_gpusvm_range *range,
 
 		if (!(pfns[i] & HMM_PFN_VALID)) {
 			state = DRM_GPUSVM_SCAN_UNPOPULATED;
-			goto err_free;
+			break;
 		}
 
 		page = hmm_pfn_to_page(pfns[i]);
@@ -856,9 +856,9 @@ enum drm_gpusvm_scan_result drm_gpusvm_scan_mm(struct drm_gpusvm_range *range,
 		i += 1ul << drm_gpusvm_hmm_pfn_to_order(pfns[i], i, npages);
 	}
 
-err_free:
 	drm_gpusvm_notifier_unlock(range->gpusvm);
 
+err_free:
 	kvfree(pfns);
 	return state;
 }
-- 
2.53.0



