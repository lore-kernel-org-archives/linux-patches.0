Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CAE3B6C19;
	Mon, 23 Mar 2026 15:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279097; cv=none; b=BVGo4nY7OJkYExkuVrmxdgsldCIiME2o29PDiGHp1PCclHnJkTRX1wZHPbzUU19Y5ILERcWG+1GpPCQK/H2GbEPEC6pUCsRQ3k8iBoY+VOK8nOx+guphw9nLNIZmAnM2hRgXqgRJfiG23LTzXdqXudyDHi557Myz8HFfHBNUveY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279097; c=relaxed/simple;
	bh=QHOJwV8oQLbOnNBftt4VcFVnTpksszxbBow2yQVASwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fv4EcP1+p5rKsWpt3y9TwL7mgHh98JOzGTL+jLyp0+Ek6FBVcNwjSw+l8VR+aOSZefWiw0xMMGFZOgtf9KsrvMCYq8lGPFtXTj3Bu3bhqO4KrmKa8tPC0wEk78Q4KAHJTeIqh883XGKTeyyKQ1/1RfRzlrIsFmTBAkH2B5tA08I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YEKSNyz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YEKSNyz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C421C2BCB8;
	Mon, 23 Mar 2026 15:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279096;
	bh=QHOJwV8oQLbOnNBftt4VcFVnTpksszxbBow2yQVASwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEKSNyz5oW8OEOY2D45icdIbIgfwtFcZQ6fqsBp6HI7p/p/K/zKx5Ha4Zzp1ugVj6
	 QAjYXP1+gm4X5cA9lAVXswSAtGcoXyHWoH4M/TQU2sDmKWjDPIQb7+rrF3LINEPgad
	 YG5PDinh5x/ndRYJQSBLfOqQy+uoq9HAvja5x+wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 487/567] drm/amdgpu/gmc9.0: add bounds checking for cid
Date: Mon, 23 Mar 2026 14:46:47 +0100
Message-ID: <20260323134546.031736728@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit f39e1270277f4b06db0b2c6ec9405b6dd766fb13 upstream.

The value should never exceed the array size as those
are the only values the hardware is expected to return,
but add checks anyway.

Cc: Benjamin Cheng <benjamin.cheng@amd.com>
Reviewed-by: Benjamin Cheng <benjamin.cheng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e14d468304832bcc4a082d95849bc0a41b18ddea)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -672,28 +672,35 @@ static int gmc_v9_0_process_interrupt(st
 	} else {
 		switch (adev->ip_versions[MMHUB_HWIP][0]) {
 		case IP_VERSION(9, 0, 0):
-			mmhub_cid = mmhub_client_ids_vega10[cid][rw];
+			mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_vega10) ?
+				mmhub_client_ids_vega10[cid][rw] : NULL;
 			break;
 		case IP_VERSION(9, 3, 0):
-			mmhub_cid = mmhub_client_ids_vega12[cid][rw];
+			mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_vega12) ?
+				mmhub_client_ids_vega12[cid][rw] : NULL;
 			break;
 		case IP_VERSION(9, 4, 0):
-			mmhub_cid = mmhub_client_ids_vega20[cid][rw];
+			mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_vega20) ?
+				mmhub_client_ids_vega20[cid][rw] : NULL;
 			break;
 		case IP_VERSION(9, 4, 1):
-			mmhub_cid = mmhub_client_ids_arcturus[cid][rw];
+			mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_arcturus) ?
+				mmhub_client_ids_arcturus[cid][rw] : NULL;
 			break;
 		case IP_VERSION(9, 1, 0):
 		case IP_VERSION(9, 2, 0):
-			mmhub_cid = mmhub_client_ids_raven[cid][rw];
+			mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_raven) ?
+				mmhub_client_ids_raven[cid][rw] : NULL;
 			break;
 		case IP_VERSION(1, 5, 0):
 		case IP_VERSION(2, 4, 0):
-			mmhub_cid = mmhub_client_ids_renoir[cid][rw];
+			mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_renoir) ?
+				mmhub_client_ids_renoir[cid][rw] : NULL;
 			break;
 		case IP_VERSION(1, 8, 0):
 		case IP_VERSION(9, 4, 2):
-			mmhub_cid = mmhub_client_ids_aldebaran[cid][rw];
+			mmhub_cid = cid < ARRAY_SIZE(mmhub_client_ids_aldebaran) ?
+				mmhub_client_ids_aldebaran[cid][rw] : NULL;
 			break;
 		default:
 			mmhub_cid = NULL;


