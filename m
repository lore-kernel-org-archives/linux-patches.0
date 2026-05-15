Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAFA3EFFBF;
	Fri, 15 May 2026 16:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861837; cv=none; b=Sfto3v7QV1xnaXmy+us8z/ZYstyJz+HYbVTBwMULrV+f87AILDI1n04vgOM6oMQtP/x26VrWF5vfirynzffHmkBdynhHBTFsYysQgu9Q4dcJTZ0BG/sBRSeslLuTcWRw6XsR5QwGilnTlmcIdF/wWXHuLwPj9lPUThYcvJlTBtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861837; c=relaxed/simple;
	bh=QsKbpiHWoKnCGsyP1M624L03yPvQBeZdhRHz3K9o5I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVAamXmIq9AO8UzOMvC+0ca27oZYUVRDXscmBj5loK6JnKSJkWvvFMSteDcuwUmRxsEl5yk1zfXC5GnBCYI1HFcEa671mxNU2k+D77e/YibZtK3nZWlRN+tMEgTS7o+LEVCX8WIlwrVFzWbDbtGY/B4ZmPe7FGGbUw5oTR2W8Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ju052s4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ju052s4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA27AC2BCB0;
	Fri, 15 May 2026 16:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861837;
	bh=QsKbpiHWoKnCGsyP1M624L03yPvQBeZdhRHz3K9o5I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ju052s4oyIFF9PHRXZ2vhX3UI3cSNyif4xv53kl9yq8qaxRxRzJjRngeRfJ+fBmU2
	 DUsCp9WQPLOYTLzw55QXzil2t5K9FBue+E8QPMfYdl7vBXuPetignFmIIUDdmWlozM
	 MPGoRCJXpzGF0nEuHROWW5Ib4jBIiWc2iUap67AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SDL <sdl@nppct.ru>,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 468/474] drm/amdgpu/vcn3: Avoid overflow on msg bound check
Date: Fri, 15 May 2026 17:49:37 +0200
Message-ID: <20260515154725.235116377@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1852,6 +1852,7 @@ static int vcn_v3_0_dec_msg(struct amdgp
 
 	for (i = 0, msg = &msg[6]; i < num_buffers; ++i, msg += 4) {
 		uint32_t offset, size, *create;
+		uint64_t buf_end;
 
 		if (msg[0] != RDECODE_MESSAGE_CREATE)
 			continue;
@@ -1859,7 +1860,8 @@ static int vcn_v3_0_dec_msg(struct amdgp
 		offset = msg[1];
 		size = msg[2];
 
-		if (size < 4 || offset + size > end - addr) {
+		if (size < 4 || check_add_overflow(offset, size, &buf_end) ||
+		    buf_end > end - addr) {
 			DRM_ERROR("VCN message buffer exceeds BO bounds!\n");
 			r = -EINVAL;
 			goto out;


