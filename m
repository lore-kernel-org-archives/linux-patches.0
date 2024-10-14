Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AFF1798C;
	Mon, 14 Oct 2024 14:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916341; cv=none; b=Awpwf6Fg/Tjv4iebh7v3f3awDkudeUTmQELuuLobxBa9Mfe/vxESEk1QBbed5MvNOnYGsWX/qPveUtNq4k1wJtwtYLh0w8zruGVGnAHx7SpjYhJ8v7/Zdmdus+i8z228jQOAFBv4QNfF9ilw6rX8qLMrt4iAHdJmIoFyQsjS42Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916341; c=relaxed/simple;
	bh=bp4/XTy1mvJuIy35jhZttRsbmGmult6hEuS3oJROtF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNg8jABJ47L5YPkhIq911/DsSbaVjIf0cV3FfpL4ZRA1L2y3tkqp8cL1n1w5uoOwWqV25Wr58plRYsbw6/KX2KgXz/mXPcn6j0lJ4eU1huOm/cnKFAIzlD3bOlJXYw/mVw9FtgbbyrfenbOgHUw0AG1sqNCLIgdEdFDgsg7K1/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VP+0HNzE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VP+0HNzE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397A8C4CEC7;
	Mon, 14 Oct 2024 14:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916341;
	bh=bp4/XTy1mvJuIy35jhZttRsbmGmult6hEuS3oJROtF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VP+0HNzEQu+kSK02yGNsuJyMOU8mnkeHwM6egnsTCbijOfRN7uPvMHNx2qMXrg89p
	 lTtMsTCMoSLQb9ogewoCv42tQr++n208vZmOnGKgHveXHWYkX7k09Ml1+Kz6IHa/py
	 SrwLKcWgcKhAaHCLSasJF+be4xQXQDYrMfhqY5/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 128/214] drm/xe: Restore GT freq on GSC load error
Date: Mon, 14 Oct 2024 16:19:51 +0200
Message-ID: <20241014141049.988246428@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

[ Upstream commit 3fd76be868ae5c7e9f905f3bcc2ce0e3d8f5aa08 ]

As part of a Wa_22019338487, ensure that GT freq is restored
even when GSC reload is not successful.

Fixes: 3b1592fb7835 ("drm/xe/lnl: Apply Wa_22019338487")

Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240925204918.1989574-1-vinay.belgaumkar@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 491418a258322bbd7f045e36884d2849b673f23d)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index cb9df15e71376..0062a5e4d5fac 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -874,7 +874,9 @@ int xe_gt_sanitize_freq(struct xe_gt *gt)
 	int ret = 0;
 
 	if ((!xe_uc_fw_is_available(&gt->uc.gsc.fw) ||
-	     xe_uc_fw_is_loaded(&gt->uc.gsc.fw)) && XE_WA(gt, 22019338487))
+	     xe_uc_fw_is_loaded(&gt->uc.gsc.fw) ||
+	     xe_uc_fw_is_in_error_state(&gt->uc.gsc.fw)) &&
+	    XE_WA(gt, 22019338487))
 		ret = xe_guc_pc_restore_stashed_freq(&gt->uc.guc.pc);
 
 	return ret;
-- 
2.43.0



