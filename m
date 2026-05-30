Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658EA481DD;
	Sat, 30 May 2026 17:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160770; cv=none; b=oM0m3mxuOueSPRlyLBEdHdFhODv1O1s2/FJAPOiiUkAb35iEBu03T9SxVbqM270ENPm0NjAZyHoT7SnRbYmj4oHNo6Xy+/5gEr9SIYM/uj5QbBV5/aZ3ftwpacZprCAv+Gf+2nqP4dz5hz4TNG3VoT771Cw4qNun6BD61B4EOIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160770; c=relaxed/simple;
	bh=PTgU8rO8l84CNznStLDJTXqLfkuu+PsPppV9sj/dzh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8JarKHfAs92IwFL4Pm80KDvI4/vZRZ6YuFGVoUcEQoJIrszlfIa6xUWvD0Yt8x8wXI1FbN3xjxYNbH5Ul5dH+ZKBhyyylEzcktawGFMw5rEsU2U7ZPoxdysoQXxK1PHkNsRnNIUL97ibEsIns4YKVUrWo7WG3NAHbm1BgU7a2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4B5O52W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4B5O52W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81F41F00893;
	Sat, 30 May 2026 17:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160769;
	bh=WtdhLiGZtny/M2BI55VHJ2tm6cPMZreAcwJftAfxnSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s4B5O52WgNoUYZ3kn5JGWh7zFv9WjuMDIbN23XXa8Km49n/M6C2Uv2CLmTP6NRhHM
	 Ao9D+CSl+sSRk+ffLP9G3SPgZ71nLnMo/W0xBW6LoocUVmkmfe5DabxNPP+IX3Eq7S
	 Q6QDLq0PvXb2A55TQjv7HZEsPa8Il4o30y97yWvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SDL <sdl@nppct.ru>,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 429/969] drm/amdgpu/vcn4: Avoid overflow on msg bound check
Date: Sat, 30 May 2026 17:59:13 +0200
Message-ID: <20260530160312.104884223@linuxfoundation.org>
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

commit 65bce27ea6192320448c30267ffc17ffa094e713 upstream.

As pointed out by SDL, the previous condition may be vulnerable to
overflow.

Fixes: 0a78f2bac142 ("drm/amdgpu/vcn4: Prevent OOB reads when parsing dec msg")
Cc: SDL <sdl@nppct.ru>
Signed-off-by: Benjamin Cheng <benjamin.cheng@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3c5367d950140d4ec7af830b2268a5a6fdaa3885)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0.c
@@ -1675,6 +1675,7 @@ static int vcn_v4_0_dec_msg(struct amdgp
 
 	for (i = 0, msg = &msg[6]; i < num_buffers; ++i, msg += 4) {
 		uint32_t offset, size, *create;
+		uint64_t buf_end;
 
 		if (msg[0] != RDECODE_MESSAGE_CREATE)
 			continue;
@@ -1682,7 +1683,8 @@ static int vcn_v4_0_dec_msg(struct amdgp
 		offset = msg[1];
 		size = msg[2];
 
-		if (size < 4 || offset + size > end - addr) {
+		if (size < 4 || check_add_overflow(offset, size, &buf_end) ||
+		    buf_end > end - addr) {
 			DRM_ERROR("VCN message buffer exceeds BO bounds!\n");
 			r = -EINVAL;
 			goto out;


