Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9875518FDA9;
	Tue, 10 Sep 2024 09:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961496; cv=none; b=XqtthlJPO8pnuKuruSUQpZ74Cq2GkutCfTAOqdFUWw0kRS7iPrwSNYIz/Q8hrZkUZ5ls+aLElFTvrxkND+JsDz7LENpAr5A9/E0VSR2hJW1edr0BjxVV1iQT42RodW6m3KwTGM6R6TqfwC9JyKFVRFWwpBW04HM2GUKZHkG5qrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961496; c=relaxed/simple;
	bh=CF0ILf67XqdMRJ7L+tAd2reiq4o0b0k8oZFEEB6sXoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AamIatdGQZeDsqMlDzUlKY6k7ac0xzPiMGXd3110sojcqrwAdX9vLP9V9N9/+uBzo7xgFoQl3bJdwswtwfBgDMCj2qexK0QGGiUg2sa8Cyh/NvlGV47ZLITsSNx8JR+O1fUuN95DdRMWRtPfYRODK26YmmqN5WiEYmZOfB2wMH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMFoHFsN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMFoHFsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA95C4CEC3;
	Tue, 10 Sep 2024 09:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961496;
	bh=CF0ILf67XqdMRJ7L+tAd2reiq4o0b0k8oZFEEB6sXoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMFoHFsNHB+pKn4MB+cgYdRNuGklzP9GUJGcJ6vgh2sysJdKbDUhp/OkzNfS1G/1/
	 MbaWyrokxoVWYtbA+Xs6Xy+gzuKyn+xN+Fq3FDRmm6NcMJ41Jmr1OOzbILd4L6UmPk
	 KeSa/4aqf0Dfgo5MmHywRqQQpUBwLmhHl7xHvI9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Alan Previn <alan.previn.teres.alexis@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.10 090/375] drm/i915: Do not attempt to load the GSC multiple times
Date: Tue, 10 Sep 2024 11:28:07 +0200
Message-ID: <20240910092625.263261803@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

commit 59d3cfdd7f9655a0400ac453bf92199204f8b2a1 upstream.

If the GSC FW fails to load the GSC HW hangs permanently; the only ways
to recover it are FLR or D3cold entry, with the former only being
supported on driver unload and the latter only on DGFX, for which we
don't need to load the GSC. Therefore, if GSC fails to load there is no
need to try again because the HW is stuck in the error state and the
submission to load the FW would just hang the GSCCS.

Note that, due to wa_14015076503, on MTL the GuC escalates all GSCCS
hangs to full GT resets, which would trigger a new attempt to load the
GSC FW in the post-reset HW re-init; this issue is also fixed by not
attempting to load the GSC FW after an error.

Fixes: 15bd4a67e914 ("drm/i915/gsc: GSC firmware loading")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: <stable@vger.kernel.org> # v6.3+
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240820215952.2290807-1-daniele.ceraolospurio@intel.com
(cherry picked from commit 03ded4d432a1fb7bb6c44c5856d14115f6f6c3b9)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_gsc_uc.c |    2 +-
 drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h  |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/uc/intel_gsc_uc.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_gsc_uc.c
@@ -302,7 +302,7 @@ void intel_gsc_uc_load_start(struct inte
 {
 	struct intel_gt *gt = gsc_uc_to_gt(gsc);
 
-	if (!intel_uc_fw_is_loadable(&gsc->fw))
+	if (!intel_uc_fw_is_loadable(&gsc->fw) || intel_uc_fw_is_in_error(&gsc->fw))
 		return;
 
 	if (intel_gsc_uc_fw_init_done(gsc))
--- a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h
+++ b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.h
@@ -258,6 +258,11 @@ static inline bool intel_uc_fw_is_runnin
 	return __intel_uc_fw_status(uc_fw) == INTEL_UC_FIRMWARE_RUNNING;
 }
 
+static inline bool intel_uc_fw_is_in_error(struct intel_uc_fw *uc_fw)
+{
+	return intel_uc_fw_status_to_error(__intel_uc_fw_status(uc_fw)) != 0;
+}
+
 static inline bool intel_uc_fw_is_overridden(const struct intel_uc_fw *uc_fw)
 {
 	return uc_fw->user_overridden;


