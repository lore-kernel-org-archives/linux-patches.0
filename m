Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692DA43C7A8;
	Mon, 17 Aug 2026 14:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976988; cv=none; b=pJx1/HGDQYn1h7xrXYOFW2CilAIREVcyfkgovTlX6Idva0Ac04bAXj0t56roi5rKYVuvgBZ29lE7O5fSJMAe+UoZ+t3U1+32r1bBYwfybkNATDpUpCZv4Z0dbnK5A/I5uaXWg55mggUUsHhpRJBPr/ibKNoY+IsOPoaSdpkVWWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976988; c=relaxed/simple;
	bh=BqA0QdbkLDwEy03z0rQWKjSAKBC4RSjAutuj5q6D/0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nU4Ukbt1DG2AmPItb4qa2y13nuzkMFgRBqwlCDR9Q0KTDo5Nlknj1hatfo7nIKz/s0Tra8R6dkmeVMoWc1mRkgupHv81bn9LYdRHLsFEAe+KrmUrbIPJzrcD1Ir4N/P730qjcO6sPwF1Zli1iw5872enjryZD9rH5wcen8E3bxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=giG8ubm3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="giG8ubm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491501F000E9;
	Mon, 17 Aug 2026 14:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976985;
	bh=yiDwV7wtrn+k2m1PNagZ4ECF7v8MNojJz4NZZ0aYEAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=giG8ubm3gu4RJycC5j2wVDRHwmX8pT/eeXrOPUeSgTwNk3vwkdRwG6XCKFbKdD0y1
	 wiB4FAeyfhNxnL+Y7giqnsKDRDxDfDO1mq+DicSuLFjgUy0hLTwBfmVNCjYXI+W6n4
	 gwP6mVygtfk5cUjMN9V96/kVUdl6pHxWLVFozL4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH 5.15 172/456] media: tegra-video: vi: fix invalid u32 return value in format lookup
Date: Mon, 17 Aug 2026 15:29:22 +0200
Message-ID: <20260817132546.854307100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

commit d5b50055338e131a1a99f923ebb0361974a00f36 upstream.

tegra_get_format_fourcc_by_idx() returns a u32 but uses -EINVAL to
signal an out-of-bounds index. This results in a large unsigned
value being returned, which may be interpreted as a valid fourcc.

Returning 0 is not a valid fourcc either. This condition should
never happen, so use WARN_ON_ONCE() to catch unexpected out-of-bounds
access and return a valid fallback format instead.

Suggested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Fixes: 3d8a97eabef0 ("media: tegra-video: Add Tegra210 Video input driver")
Cc: stable@vger.kernel.org
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/tegra-video/vi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/tegra-video/vi.c
+++ b/drivers/staging/media/tegra-video/vi.c
@@ -76,8 +76,8 @@ static int tegra_get_format_idx_by_code(
 static u32 tegra_get_format_fourcc_by_idx(struct tegra_vi *vi,
 					  unsigned int index)
 {
-	if (index >= vi->soc->nformats)
-		return -EINVAL;
+	if (WARN_ON_ONCE(index >= vi->soc->nformats))
+		return vi->soc->video_formats[0].fourcc;
 
 	return vi->soc->video_formats[index].fourcc;
 }


