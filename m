Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD63929E116;
	Mon,  4 May 2026 14:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904501; cv=none; b=tgqSmVGlhwJ0iaUf2VIyD9kWO3nPkOrvh7UVrhpyW9LypGvJgISlcc6C0lFQdwfq5q5LjkvPPhD8/j0cE34mhH+61v4c1hwNL0s5Y3eheATcLe+n8EMhX6cqzlNxri78wVPHLd6jW6t4razzU3PakZlNSqDOhPuMk526fpD4Nag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904501; c=relaxed/simple;
	bh=IOUd1Qwnxt0G5QqT21+xuYkF6OVdbxPkhLNbkruhjPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rA4MTO6vFh7914x65+C5LY64ki+lMvIxu/oR6sQNlHqQ1ewiVsUepNtj6JCkaLMWrsfU8cglq3kl+XoG3P6Wavp6/o8E/GSuEDxOYIjcOpE46WTjwND0e/0uxWTKoclGv1i4oSaH1iW1Ic0TR2auKTSj7E12ssRNI8Md7TyTyUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLmhhLtM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLmhhLtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62120C2BCB8;
	Mon,  4 May 2026 14:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904501;
	bh=IOUd1Qwnxt0G5QqT21+xuYkF6OVdbxPkhLNbkruhjPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLmhhLtMykSHHSVXiyw6On+Xo8zbey7VoVmT9EtTg/E9lzaqTNua/JPdnhhxcKFkG
	 acvN2t8dr35/R1RBS3M5foAHFZS7QYyMtug1PspeQamt79JOMo2iwn10Z/Hddu1JIW
	 ulBK1pn9gJ7P2kOksfNoQZI2uLt22Oxt4LvHZ0IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Beckett <bob.beckett@collabora.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 062/215] nvme: respect NVME_QUIRK_DISABLE_WRITE_ZEROES when wzsl is set
Date: Mon,  4 May 2026 15:51:21 +0200
Message-ID: <20260504135132.438039977@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Beckett <bob.beckett@collabora.com>

commit 40f0496b617b431f8d2dd94d7f785c1121f8a68a upstream.

The NVM Command Set Identify Controller data may report a non-zero
Write Zeroes Size Limit (wzsl). When present, nvme_init_non_mdts_limits()
unconditionally overrides max_zeroes_sectors from wzsl, even if
NVME_QUIRK_DISABLE_WRITE_ZEROES previously set it to zero.

This effectively re-enables write zeroes for devices that need it
disabled, defeating the quirk. Several Kingston OM* drives rely on
this quirk to avoid firmware issues with write zeroes commands.

Check for the quirk before applying the wzsl override.

Fixes: 5befc7c26e5a ("nvme: implement non-mdts command limits")
Cc: stable@vger.kernel.org
Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
Assisted-by: claude-opus-4-6-v1
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3169,7 +3169,7 @@ static int nvme_init_non_mdts_limits(str
 
 	ctrl->dmrl = id->dmrl;
 	ctrl->dmrsl = le32_to_cpu(id->dmrsl);
-	if (id->wzsl)
+	if (id->wzsl && !(ctrl->quirks & NVME_QUIRK_DISABLE_WRITE_ZEROES))
 		ctrl->max_zeroes_sectors = nvme_mps_to_sectors(ctrl, id->wzsl);
 
 free_data:


