Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCA8246781;
	Fri, 15 May 2026 16:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862833; cv=none; b=OrEoDNWCCFLzqkOdxP0lyQnmQ03vk6ZCCllDbBwvbcuD4AV9uF0xVcbeyfgDJ2r9CkABwHV2BwSquDrdS/RcH5oKE32qgtZO3eIHoih7q2mBSIFySpjz2KoEo8DeCj3SgjhCuRH15goeofiLdVNY+U9Sd0sZVcPCZWII0koY2cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862833; c=relaxed/simple;
	bh=x1lzgQ5/3iZjmO4ta8TD/hYRkKsHzVWnpBNUHmQDb7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGcZuRFh5DGDoxjzcxM4gTD6Npwbq/gf8wuiwL6Qj/oEQGyhVTI1EVgpeXQ/FP6LWeWEqivvZJxNqbsMpgzJY3mUp0M2wsaES99s1nj4Xf7uUGnKm5nVSH3BF841Ad+md2LNM5YszJi/3fXq9y6UuRv/eGpNE+2cf7RSM/SdLqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKv3tx9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKv3tx9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600F1C2BCB0;
	Fri, 15 May 2026 16:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862833;
	bh=x1lzgQ5/3iZjmO4ta8TD/hYRkKsHzVWnpBNUHmQDb7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKv3tx9lOK5c58UGKgOFPY4vhQCNJ8jbjAxAMdurtbeMNLTPCHfAanPKGsWJp1omQ
	 9S5Mtxt9GSbPc5ewpOjWh+MQe+BRCHfOpeQxrGJbFM7oDf9Smux/GM7Dghq2e7fysw
	 sZ9QjekK77OwjKosb2AuxTLPKN6iDHHxrzh2Ngts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SDL <sdl@nppct.ru>,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 200/201] drm/amdgpu/vcn3: Avoid overflow on msg bound check
Date: Fri, 15 May 2026 17:50:18 +0200
Message-ID: <20260515154702.911580809@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1972,6 +1972,7 @@ static int vcn_v3_0_dec_msg(struct amdgp
 
 	for (i = 0, msg = &msg[6]; i < num_buffers; ++i, msg += 4) {
 		uint32_t offset, size, *create;
+		uint64_t buf_end;
 
 		if (msg[0] != RDECODE_MESSAGE_CREATE)
 			continue;
@@ -1979,7 +1980,8 @@ static int vcn_v3_0_dec_msg(struct amdgp
 		offset = msg[1];
 		size = msg[2];
 
-		if (size < 4 || offset + size > end - addr) {
+		if (size < 4 || check_add_overflow(offset, size, &buf_end) ||
+		    buf_end > end - addr) {
 			DRM_ERROR("VCN message buffer exceeds BO bounds!\n");
 			r = -EINVAL;
 			goto out;


