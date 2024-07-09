Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBAE13A25F;
	Tue,  9 Jul 2024 11:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524336; cv=none; b=uY8vMX+fhCSYI29ObMBAfYDpd+1Snbg1co/LdOrUuzhfIhoMXGqq6VY6Tjp+MHsTPXuXZqFuKq60LFng4I5HIxeRnICwDK2DKPlNQMJjpzD0txFnDDpMOCgGATAM9xdc2e3tu2uFTDcnath82YumC6RuzuJiw9FpB5D5ZTvBri4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524336; c=relaxed/simple;
	bh=LONeglKDTXK4n2p3rhAUT4p9066IK/w+0h0X5iyS/HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Db1g5a+UHPEPm+NFwnuH1+E3Fq1RxydeyTWPW6q/eF6caBRMB8xwn2BX8/hbzfzqxxLtZ8IylXZ9HdzF2E6Tqlni0Rt4JADXqdlWCBmhfNPmo+SEDg/PtlK5LAu8NFKSb/N5kYxuwZWf2rEeAAP7gzbHGd6aUcpDsmV+XQrPisc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1nbYTpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1nbYTpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB099C3277B;
	Tue,  9 Jul 2024 11:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524336;
	bh=LONeglKDTXK4n2p3rhAUT4p9066IK/w+0h0X5iyS/HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1nbYTpjNKjYt3Z+gQhzwh29HzvfyW7Meo8HCvKbL8DwjCBif2Ue/FIlSvP/l2KZr
	 n4uanjR6rHMjoJt500j0Ac6rOwN7gLegGh/4acz6oHli0WGfkB0QLei5GWsl9msq/p
	 gwKy95RSXktzoBPHoTyTUJD8q5fU+e5tSmJ6IZZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH 6.9 149/197] drm/xe: fix error handling in xe_migrate_update_pgtables
Date: Tue,  9 Jul 2024 13:10:03 +0200
Message-ID: <20240709110714.714957798@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit fc932f51926698488f874ddf7d8f18483ca10271 upstream.

Don't call drm_suballoc_free with sa_bo pointing to PTR_ERR.

References: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/2120
Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240620102025.127699-2-matthew.auld@intel.com
(cherry picked from commit ce6b63336f79ec5f3996de65f452330e395f99ae)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_migrate.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -1336,7 +1336,7 @@ xe_migrate_update_pgtables(struct xe_mig
 						 GFP_KERNEL, true, 0);
 			if (IS_ERR(sa_bo)) {
 				err = PTR_ERR(sa_bo);
-				goto err;
+				goto err_bb;
 			}
 
 			ppgtt_ofs = NUM_KERNEL_PDE +
@@ -1387,7 +1387,7 @@ xe_migrate_update_pgtables(struct xe_mig
 					 update_idx);
 	if (IS_ERR(job)) {
 		err = PTR_ERR(job);
-		goto err_bb;
+		goto err_sa;
 	}
 
 	/* Wait on BO move */
@@ -1436,12 +1436,12 @@ xe_migrate_update_pgtables(struct xe_mig
 
 err_job:
 	xe_sched_job_put(job);
+err_sa:
+	drm_suballoc_free(sa_bo, NULL);
 err_bb:
 	if (!q)
 		mutex_unlock(&m->job_mutex);
 	xe_bb_free(bb, NULL);
-err:
-	drm_suballoc_free(sa_bo, NULL);
 	return ERR_PTR(err);
 }
 


