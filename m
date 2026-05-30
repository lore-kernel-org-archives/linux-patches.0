Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3C6481DD;
	Sat, 30 May 2026 17:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160768; cv=none; b=Q5kTdlgBd3KpPaiktVPqzChz1gSSiqKpYKy75VfnsVqvZ7vpI/nbxokQz7X0ZvtR+4VkTAsjJ8O7iEATxYNyOXBX/nvO2qdELyeAUOg9A1Yqkp4VLfV/31Ig4ncZ9k3BoLMtsZKe9kyDL2IDJSyASecKvnnc/PmIB8lBfCmid3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160768; c=relaxed/simple;
	bh=sQPAVjCDOoyZXKpRrpk/jmYaZV/BXiW8cn2zDvAZXlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6F29SYJaPqcmQtL5bqIgPV29o3tdsYJi18XAnb/VRrDXUffUU3hb23w3HTgaaGT0qnJdMGX7ma4m4Q3yT1xbBRSHgbf4Hb7Bht2TBRql07cdikR34vUKPGS6+4cr8Zxk3+4BLLhhYiOpQAZ9V5fY861vukuimWZNVjkaoI6gTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Phxfy4UC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Phxfy4UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBC61F00893;
	Sat, 30 May 2026 17:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160766;
	bh=xXP6T1k3YdbdP2U2tinSLKA+H5xOw67piZdfi5srxok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Phxfy4UCU3V29bSxcFNmGS99BvSclg7Tmj18vv0yuJQwl/G6jdqx94OfWRqtiCQzE
	 EvH783WI9T/DlRWoV6zrMzYICo6t7tw3Yue18/lN0N8m2BoIXugH4iTrcuebfXfZG7
	 Udjv4c6tjdNWLfGvy6t+Kq4p5PbNJA6yN8E7R5Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SDL <sdl@nppct.ru>,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 428/969] drm/amdgpu/vcn3: Avoid overflow on msg bound check
Date: Sat, 30 May 2026 17:59:12 +0200
Message-ID: <20260530160312.076939887@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Cheng <benjamin.cheng@amd.com>

commit e6e9faba8100628990cccd13f0f044a648c303cf upstream.

As pointed out by SDL, the previous condition may be vulnerable to
overflow.

Fixes: b193019860d6 ("drm/amdgpu/vcn3: Prevent OOB reads when parsing dec msg")
Cc: SDL <sdl@nppct.ru>
Signed-off-by: Benjamin Cheng <benjamin.cheng@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit db00257ac9e4a51eb2515aaea161a019f7125e10)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1844,6 +1844,7 @@ static int vcn_v3_0_dec_msg(struct amdgp
 
 	for (i = 0, msg = &msg[6]; i < num_buffers; ++i, msg += 4) {
 		uint32_t offset, size, *create;
+		uint64_t buf_end;
 
 		if (msg[0] != RDECODE_MESSAGE_CREATE)
 			continue;
@@ -1851,7 +1852,8 @@ static int vcn_v3_0_dec_msg(struct amdgp
 		offset = msg[1];
 		size = msg[2];
 
-		if (size < 4 || offset + size > end - addr) {
+		if (size < 4 || check_add_overflow(offset, size, &buf_end) ||
+		    buf_end > end - addr) {
 			DRM_ERROR("VCN message buffer exceeds BO bounds!\n");
 			r = -EINVAL;
 			goto out;


