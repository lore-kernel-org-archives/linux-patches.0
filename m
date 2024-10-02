Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FBA1D04B4;
	Wed,  2 Oct 2024 13:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875876; cv=none; b=s5dZaP68LSUTg8kCV+GPjvAZgOksbQSHF40E1LJDOHf5GPIjwIQH5mlDNZL4rGKauQDRLnQL2r422xNfeV1NWox9hDUhc1UV9bEQSb9hEkIXTjDhgA/WNl/1wqeEdTuSquJ6qCEC+VRJR85qcicYYsu+/h3H/aPtSArwbct4xB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875876; c=relaxed/simple;
	bh=47jzbcWp3COhZMlwGzzw2iOHzG88585ah0VvmNODI/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swTftkyJnczZh9B9qd/Mgu4+lrbq0YLdJkyM5VZZpbGV9SJ5PhcGnPNA78IFSuaTZOHEWAX112h/ppbluIhueY+hzfGjpAJp6EVDBSUitn4Ld5Vo/9awJ8Evwz5ihOUrO6POqApOjo4XIyOwgxkUNcheCIrqd56BghKs2s9O4x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wz/QhlrV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wz/QhlrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA6AC4CECF;
	Wed,  2 Oct 2024 13:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875876;
	bh=47jzbcWp3COhZMlwGzzw2iOHzG88585ah0VvmNODI/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wz/QhlrVrMtJJlkg20n3T0FvirpM2J8Lqegb5jMxPXTr9aacBZ14K4TU0Ed96KeHr
	 W7MbzI+r6w4m4CYrqCJ2dcA351Rtl0giGHsnlhKz/Vl93DrsSW6HoEVbRA0yoBqC2i
	 VbMptMILQD63MBRpdHR7gmS8t60CwiUbHkiqgRww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dafna Hirschfeld <dhirschfeld@habana.ai>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 250/695] drm/xe: fix missing xe_vm_put
Date: Wed,  2 Oct 2024 14:54:08 +0200
Message-ID: <20241002125832.428003202@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dafna Hirschfeld <dhirschfeld@habana.ai>

[ Upstream commit 2efba0c095419f93f8913f1cbae8bf3fb030db20 ]

Fix memleak caused by missing xe_vm_put

Fixes: 852856e3b6f6 ("drm/xe: Use reserved copy engine for user binds on faulting devices")
Signed-off-by: Dafna Hirschfeld <dhirschfeld@habana.ai>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240901044227.1177211-1-dhirschfeld@habana.ai
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 249df8cbecf0ab4877eab66cae857748631831a9)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec_queue.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
index c2953ddbd16e1..d0bbb1d9b1ac1 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.c
+++ b/drivers/gpu/drm/xe/xe_exec_queue.c
@@ -221,8 +221,10 @@ struct xe_exec_queue *xe_exec_queue_create_bind(struct xe_device *xe,
 							   gt->usm.reserved_bcs_instance,
 							   false);
 
-		if (!hwe)
+		if (!hwe) {
+			xe_vm_put(migrate_vm);
 			return ERR_PTR(-EINVAL);
+		}
 
 		q = xe_exec_queue_create(xe, migrate_vm,
 					 BIT(hwe->logical_instance), 1, hwe,
-- 
2.43.0



