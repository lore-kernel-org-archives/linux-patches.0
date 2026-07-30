Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E88743B3F8;
	Thu, 30 Jul 2026 14:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422675; cv=none; b=OY6NSPwcJrS90/pU9FL21MVIUdzKFVV6/G+u7aDjdfb681bjh5NbT+0LjU65zZbg3Gc4YwySjaMUTsJ5OfmnEMybHp/bmfFcBpvo34XAw7LjvD4JOKs81uZ5y3G/oJdih/FDgTnVD7V2ip1KZQXtNdX4Ks6hwHJs9/nyJzEBxMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422675; c=relaxed/simple;
	bh=Ku18p30Jde6Zc+vMe+bsC08GzH4YJ0lVPiPWfRas198=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7EgVvrVhnG12kZbtQeF8jUq/KM1sI0XgCIi+XVODph++LwT/623biPNqm552jznQh3LYLouRH961xTDoCPvNqP8Y/ZK/N0fanCHe1SwvtaKwIokrzR+I4pe8N5393S7qIMsi8dbK/uMrgb9MNNGbgYsUzeEBdr2gEcuFhTTYXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OOAVEyqn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OOAVEyqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E741F000E9;
	Thu, 30 Jul 2026 14:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422674;
	bh=6Y1pXuweWYpiIFlX2MfQmzlpBcBamPCRGIDFxeg575U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OOAVEyqnIkTIajjJJ6RpWtmj5ZqOIP+9jfz6YV3dROfiP6uCeYMO2uNEpSuVmAwb3
	 r5nLx/iOVZ1ry7EdYTgHymIYCQGnRXbpIcCe5WEiweVv4va/OWMPxBV9tUJ2T4XlUN
	 QUWxkxpy3H5XO1B7mDrp6meP9Dnl72r2duMktccU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH 7.1 520/744] media: tegra-video: vi: fix invalid u32 return value in format lookup
Date: Thu, 30 Jul 2026 16:13:13 +0200
Message-ID: <20260730141455.328690873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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
@@ -80,8 +80,8 @@ static int tegra_get_format_idx_by_code(
 static u32 tegra_get_format_fourcc_by_idx(struct tegra_vi *vi,
 					  unsigned int index)
 {
-	if (index >= vi->soc->nformats)
-		return -EINVAL;
+	if (WARN_ON_ONCE(index >= vi->soc->nformats))
+		return vi->soc->video_formats[0].fourcc;
 
 	return vi->soc->video_formats[index].fourcc;
 }


