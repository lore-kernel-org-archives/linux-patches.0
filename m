Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB9C442390;
	Mon, 17 Aug 2026 15:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979385; cv=none; b=b/ljnx5St91JzpGx6LyVwPkye/PvM60EW/b3k867dfUkVEolX/Rjdz2/p7tkQQUqmAxyYwMmm7gsjUtlzDo8y2oGYlO6sFuzqiMApt4tVsoXUV/lAT6Nk6Mc/nylHW8eiMfx0qWTcFm8zjnPCNI7izfE5R1WQUn5Umk93hegz3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979385; c=relaxed/simple;
	bh=AooAh4a58CFJuUkbl6nyqAJKKeM3zKfEZ1lnK+J6YA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKIzSjQU0Cr4qmuwSRmnnQHvsZU/pSXAic6jeR7kgN1+loQzJPjykFlkNpVfJtPYXnhPb3qfTrPGfaKSL/a9wxC6U9CpvlGg1bhGZKmL59rmYQ53MvpCjhO82m9Nn4USzoM62JBHpJ3Zk4AfaNSp+VxYli9vAWb8TpTnpVMsyh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fhp/YS9F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fhp/YS9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2531F000E9;
	Mon, 17 Aug 2026 15:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979383;
	bh=CTAvlawnJukseXWAq/EbZ8faFGYIJ2k33x6Ysfl9GmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fhp/YS9FBc6nzwaSNLrKp5ozmFiJRa6wmRRgCLuyMtaG61i5/a2hsjY2FVF137RFZ
	 25piLIFVmsnZ3Cj/lSaT2IlVGUR6QISr1nPTmjaHeXGslA8IWY+0m3A0UIYv9rHUi3
	 PaE5Hnvo9lkTweU9zY6yYm8LDC2rIy/YYKqK8YzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Hungyu Lin <dennylin0707@gmail.com>
Subject: [PATCH 6.1 208/609] media: tegra-video: vi: fix invalid u32 return value in format lookup
Date: Mon, 17 Aug 2026 15:28:24 +0200
Message-ID: <20260817132551.055819491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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


