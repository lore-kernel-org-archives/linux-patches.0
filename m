Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889D137DE89;
	Thu, 20 Aug 2026 15:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238337; cv=none; b=uZEW4T20ltzqnNC8ErSkJ3azLicMxSngSjqoX6HR3svBKTnWknwK7b7Lm/gTlDI/eLySESCLLajoX3C85NhO9dHpzTINo4lzhh5GeUGap297xklImQhjnaVH9IxVPFWUw97k4E4kUFLRn8518jTIbKOMfV9OKJB0WfaY5kS0KPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238337; c=relaxed/simple;
	bh=bUA1q4LQO1Ja2dVZynwBTxeVq3e9mQZh8wzHyZ69o00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hw/RrJjB0jI6ew3bEGO4PaOVXbetW+BhvG9ivfPQkOdGkdipeILK5YySoL54WUzv6ri1FAe3AnzVAz25hnr8zpoW/MHDOMNKV73dM0LGn8rUmd7eh1jLY4tWHrQxhIfn0ORO247zgL5V5JzKZrYFHtbB6El/rjnM4jRla/xYKTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWBxS2pH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWBxS2pH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EE11F000E9;
	Thu, 20 Aug 2026 15:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238336;
	bh=g+79pS9xGasXCARW0O/zLZD+SEV7cIhWRcP6mtxaI44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CWBxS2pHL58FKlrDQM+q79aGsCN3Rw5fIb/4ddT3TZbJQEcarlZuWOW0q1nwh/jvl
	 E0a2fBpFHctsF0aWojmF+QMzAu7VHPm9LIRZi2VPBMNuffW59xe77ZPDIolL/3ir0K
	 uLJlPjWd1EbvKlrc17q7Y1+2a/hCC1K0M/Pnz4nM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 113/228] drm/amdgpu: Reject UVD message with invalid number of h265 refs
Date: Thu, 20 Aug 2026 16:54:15 +0200
Message-ID: <20260820145248.071043798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

commit 9fca434208f1f9ab977feac62df8ebb1cc7ce893 upstream.

Same change as for h264, avoids overflow later when calculating
min dpb size.

Signed-off-by: David Rosca <david.rosca@amd.com>
Reviewed-by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a4b0720e4f1601f97f59a2be9c1b4b94fa6527d5)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -803,6 +803,9 @@ static int amdgpu_uvd_cs_msg_decode(stru
 		image_size = ALIGN(image_size, 256);
 
 		num_dpb_buffer = (le32_to_cpu(msg[59]) & 0xff) + 2;
+		if (num_dpb_buffer > 17)
+			return -EINVAL;
+
 		min_dpb_size = image_size * num_dpb_buffer;
 		min_ctx_size = ((width + 255) / 16) * ((height + 255) / 16)
 					   * 16 * num_dpb_buffer + 52 * 1024;


