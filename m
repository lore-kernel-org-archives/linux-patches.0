Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5BA79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DB4C433D6;
	Wed, 30 Nov 2022 18:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834514;
	bh=QLWc+4j4o5RmaCGc/s1KZ0/n5GazixD2L5Dcg1U/T1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqPoTuv5o+/4b8H0WS9cKyRirMsMG+GhbRKOSJFEkNwu3bvPuN3hATgXXkwlOoCgp
	 h1OeVs+3YbSOJT+z9P/eoXDUyMypYuL+DjBxnt6J6NpmP2xBP16jpT17CecLumcMFy
	 deH2zt8Xfh8t5AZHmdkc2sORPF05q21gI75S0AW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 281/289] drm/amd/dc/dce120: Fix audio register mapping, stop triggering KASAN
Date: Wed, 30 Nov 2022 19:24:26 +0100
Message-Id: <20221130180550.473870554@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lyude Paul <lyude@redhat.com>

commit 44035ec2fde1114254ee465f9ba3bb246b0b6283 upstream.

There's been a very long running bug that seems to have been neglected for
a while, where amdgpu consistently triggers a KASAN error at start:

  BUG: KASAN: global-out-of-bounds in read_indirect_azalia_reg+0x1d4/0x2a0 [amdgpu]
  Read of size 4 at addr ffffffffc2274b28 by task modprobe/1889

After digging through amd's rather creative method for accessing registers,
I eventually discovered the problem likely has to do with the fact that on
my dce120 GPU there are supposedly 7 sets of audio registers. But we only
define a register mapping for 6 sets.

So, fix this and fix the KASAN warning finally.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
@@ -359,7 +359,8 @@ static const struct dce_audio_registers
 	audio_regs(2),
 	audio_regs(3),
 	audio_regs(4),
-	audio_regs(5)
+	audio_regs(5),
+	audio_regs(6),
 };
 
 #define DCE120_AUD_COMMON_MASK_SH_LIST(mask_sh)\


