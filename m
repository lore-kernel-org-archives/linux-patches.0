Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B555863CB;
	Wed,  2 Oct 2024 14:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880310; cv=none; b=SQg40Z2AYAIvh97U8SDEbPLkA7jTjq3tad4aDBYiQqXILQAeby9voWMlwSQoq9p+CAJsQRBzcMiS24+isOAJhbbZWScW595iEzcabACNKQ/WxGDrbYT8Lb6VRNP/l/ugIbGnz/sf2UrkwwAg8vW3AORAQGfM6BgHLGES42Zyoeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880310; c=relaxed/simple;
	bh=eFvYxuUmIS55UcP8WYlWtzQ2oSzZQ0bwd08X8I9jIyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwKow3TwKnEEpSh4t9gRMDOxmXM8WKSqrM9aAxuqp47IfpK1NFBhSTGhl5ttL9DAhEYmiLAbxJvfO8SXSHb2O7xLLitH8ll8Ec8O4+xcKaPXuewDppqyQsiGqAhWvdLX5ElnFXtC/acnSPESSH2iLp6iaHwigaU+O+PS0m9ZTks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/u5cHmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/u5cHmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4114FC4CEC2;
	Wed,  2 Oct 2024 14:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880310;
	bh=eFvYxuUmIS55UcP8WYlWtzQ2oSzZQ0bwd08X8I9jIyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/u5cHmRgApRrvRmPx+X0XToy1DkJELZ2ejKYtbjetkCvCHfXKzv1ekTA21U9EaR6
	 MlVz4KhDR2CcoqQ4eY8muSVO3pEFeia5EYylruklSXW1D5ih6N61L/S+mhHp9yUh1H
	 t5z+TlrrDcM3LpbJN67Xu07X3xbbvm4Cn2+4woK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Anthony Koo <anthony.koo@amd.com>,
	Robin Chen <robin.chen@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.6 416/538] drm/amd/display: Round calculated vtotal
Date: Wed,  2 Oct 2024 15:00:55 +0200
Message-ID: <20241002125808.853324237@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Robin Chen <robin.chen@amd.com>

commit c03fca619fc687338a3b6511fdbed94096abdf79 upstream.

[WHY]
The calculated vtotal may has 1 line deviation. To get precisely
vtotal number, round the vtotal result.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Anthony Koo <anthony.koo@amd.com>
Signed-off-by: Robin Chen <robin.chen@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/modules/freesync/freesync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -133,7 +133,7 @@ unsigned int mod_freesync_calc_v_total_f
 
 	v_total = div64_u64(div64_u64(((unsigned long long)(
 			frame_duration_in_ns) * (stream->timing.pix_clk_100hz / 10)),
-			stream->timing.h_total), 1000000);
+			stream->timing.h_total) + 500000, 1000000);
 
 	/* v_total cannot be less than nominal */
 	if (v_total < stream->timing.v_total) {


