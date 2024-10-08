Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A451DE4CD;
	Tue,  8 Oct 2024 13:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393449; cv=none; b=EC2gZqTdwYWlRCQO/vztSFyJwnITQIxpC4a7mLnBlAYsHKgbsyltz6sulvmWzOrYB5yI/zrLPbpKix/Cp7TaBG4MBHmEwdKEqSSEIpooBWsfEeb7Z9Uqc8OKmhZlNirSHReDJ12YHbhAeTvIBoBq4HNr6a5NGlPWo3OECpTQ+Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393449; c=relaxed/simple;
	bh=FbJ+f0yxOlGS/BQOJ3IjMu1nrYkrmBLxMhZWhkW6zrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HU05L8I2j7EOObj6gDfWWd3mUmBl/fE/1c1XkJDbQrKKPtdSo7o+douhTM2fq4P9CQdbZsbdh/nQqBCZAesywMavZQMFT7Rs+CGt0wLbOhQu3wkU3NC/mDuimss97W3xyp0+mRGW1Z92raDJzQQXkQFf8lFUslfphaP3v4fQW7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6GGxyjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6GGxyjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71006C4CEC7;
	Tue,  8 Oct 2024 13:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393448;
	bh=FbJ+f0yxOlGS/BQOJ3IjMu1nrYkrmBLxMhZWhkW6zrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6GGxyjNLC+FkJKgqg7oT7hKKOKv2t4Xgo3xgTDbY0mdF447lyH8rVQBvQuR25fSC
	 LUVAYePjzNaIRGRMKNEbmOehK2ux15lu5ovxEng5FTwWv5JvsbhEcq9ACYrmH+xvSd
	 /g3+5ZK1hIWig2cxYaIyNLGopMuuIDihyOveoNC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/386] drm/amd/display: Check stream before comparing them
Date: Tue,  8 Oct 2024 14:06:39 +0200
Message-ID: <20241008115635.486638181@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 35ff747c86767937ee1e0ca987545b7eed7a0810 ]

[WHAT & HOW]
amdgpu_dm can pass a null stream to dc_is_stream_unchanged. It is
necessary to check for null before dereferencing them.

This fixes 1 FORWARD_NULL issue reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 4b34bc9d4e4be..99fcd39bb15e0 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -2154,6 +2154,8 @@ static bool are_stream_backends_same(
 bool dc_is_stream_unchanged(
 	struct dc_stream_state *old_stream, struct dc_stream_state *stream)
 {
+	if (!old_stream || !stream)
+		return false;
 
 	if (!are_stream_backends_same(old_stream, stream))
 		return false;
-- 
2.43.0



