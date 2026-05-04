Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DAB3D5645;
	Mon,  4 May 2026 14:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903830; cv=none; b=kthPP5jWIRmWRCpzYajGqEWZvpPHHI4Jqx+/myjG+oLi/y7rYJnm/JlZi84t1ZaIeBcS/bgjktFnWYZEl9Z1NaFHlKwuE/OJ0ubPUjF14XRjaBdFKA0K1wAm3QL+EBgeKprMXGJarHIhhjfYA5Q7AiaUqRnx0CTkECSVCueev0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903830; c=relaxed/simple;
	bh=+q8B6YwyJ1sd5gmqZKE+rDX+L+ZZ6tul+/OXpZJ0f3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6PLtFI+tkvPPGk7XxxJeqouH1VIJ2FyN8JOT+t5CcuY3DLSwzp7XxUAkHQRpFamitqhq2Hd7I6bz2t+7GBij5N0ICCUCWngM1mx2NSqtpDjerxGPzVruR8rrCirkE4JfWdEHXmm5FcKuTt5Ir/ZALffVIqXtmOWeBpdYScf7eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ci0n6KFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ci0n6KFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CC7C2BCB8;
	Mon,  4 May 2026 14:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903830;
	bh=+q8B6YwyJ1sd5gmqZKE+rDX+L+ZZ6tul+/OXpZJ0f3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ci0n6KFkb4PLq2JZbJcZWdpJTijmUmc56wo8IjPCZFPuNLxLUVq61Yzq8HhBiLn3E
	 bYJydofe5jKhLLGtE9sNRsHkJoHkoShv7ZIzDoV/bVHA5rWAMtpOo9zI0F2ur+QK8e
	 hOsYC9iWJbkIE38KhmIMKJPummJgoMg2z0y8iR7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Beckett <bob.beckett@collabora.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 078/275] nvme: respect NVME_QUIRK_DISABLE_WRITE_ZEROES when wzsl is set
Date: Mon,  4 May 2026 15:50:18 +0200
Message-ID: <20260504135145.822727511@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3393,7 +3393,7 @@ static int nvme_init_non_mdts_limits(str
 
 	ctrl->dmrl = id->dmrl;
 	ctrl->dmrsl = le32_to_cpu(id->dmrsl);
-	if (id->wzsl)
+	if (id->wzsl && !(ctrl->quirks & NVME_QUIRK_DISABLE_WRITE_ZEROES))
 		ctrl->max_zeroes_sectors = nvme_mps_to_sectors(ctrl, id->wzsl);
 
 free_data:


