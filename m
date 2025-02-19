Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B181E1041;
	Wed, 19 Feb 2025 08:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954602; cv=none; b=MRXL8ZcPXCKnpAcgC1md27SdpXdL+e9556H1cyDgJYQx8h+r59lz+jaYfG6dY/1cU8aoX4FgIEeiRXy9MgFEdkqL7+PhG8NOePhluojCzLSrbSuNgHXCxSHrYNSvNW0KNWVdpjE9GAghxI+d973kOxM8nJl/paMZTSuGhvr3758=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954602; c=relaxed/simple;
	bh=qc3gBGE4Fdt2a6hiKSrcPGP5bwXfMZygfte3mNpXG/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJmlIrdQytFQp2H2jSVvDLHIMEYepxvu5AjWAaz539rKtyR7mZKuyfIK9sBqSS9N7JbrK+GWj2CCyZBRXfSCnnByBvsxaEUPVv3yqDfmp4sFVO0cu+zrq6+fQGowNUcgyjXuXyMePGukB3Ao9znvJkqm8786p8u4Wi1h5ZZ84+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHpzJQ/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHpzJQ/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681D9C4CEE7;
	Wed, 19 Feb 2025 08:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954601;
	bh=qc3gBGE4Fdt2a6hiKSrcPGP5bwXfMZygfte3mNpXG/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHpzJQ/RX3HmM2QELLx9Y5fgvtIKJpeHTjIe6H8NM3n4VIi7gpeUAhiJrWghYwECe
	 S+RMwthVh/b5V4lqRQPS1UEJZPyCvxXIDWUTYBU7YKdCiU1Rpa4XJ+8fuo7elaX58V
	 xvSXPlDviYHjNfgQfe9RcQNLktA8vjexoFy0d6e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Rob Clark <robdclark@chromium.org>
Subject: [PATCH 6.13 255/274] drm/msm/gem: prevent integer overflow in msm_ioctl_gem_submit()
Date: Wed, 19 Feb 2025 09:28:29 +0100
Message-ID: <20250219082619.562973712@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 3a47f4b439beb98e955d501c609dfd12b7836d61 upstream.

The "submit->cmd[i].size" and "submit->cmd[i].offset" variables are u32
values that come from the user via the submit_lookup_cmds() function.
This addition could lead to an integer wrapping bug so use size_add()
to prevent that.

Fixes: 198725337ef1 ("drm/msm: fix cmdstream size check")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/624696/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_gem_submit.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -787,8 +787,7 @@ int msm_ioctl_gem_submit(struct drm_devi
 			goto out;
 
 		if (!submit->cmd[i].size ||
-			((submit->cmd[i].size + submit->cmd[i].offset) >
-				obj->size / 4)) {
+		    (size_add(submit->cmd[i].size, submit->cmd[i].offset) > obj->size / 4)) {
 			SUBMIT_ERROR(submit, "invalid cmdstream size: %u\n", submit->cmd[i].size * 4);
 			ret = -EINVAL;
 			goto out;


