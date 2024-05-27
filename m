Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91DA17E90E;
	Mon, 27 May 2024 19:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837144; cv=none; b=lYgsjB8Okor7bo4du7QGbgLf+BiRrjigQZqK0g/MhgnEo0/VJwFmbEs2W3Nv/C9JSzPNdFYP2+WO9W4jPkNUdrrEO07LjWCTSlrj3NjXrf4RsQFKAN02cSrBnYQE7SZozyALDfESmWaR54f8vlN9tzbEa4VVZ7yU8iflZekuAMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837144; c=relaxed/simple;
	bh=gyFpTDZo/I5l2ps5Of7aky6SYqfN78qaMh7zDki6Q4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9OLRv/Z6iKfEDuadAd49BDB10Mc37WtWHVmIzvr6gXKqfIv/oBl4Sg+C21ekOamwn1BBuPLYRrGmZ8LAB1BoxD5yU6wg6206CceDybZPNZugGqO/XCtJsVXKdAquzasU7KvVy2LyxmY3pqa0sZfpcg5TtjUiB//zG1T8FA8uR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ln6Hc5hU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ln6Hc5hU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C105C2BBFC;
	Mon, 27 May 2024 19:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837144;
	bh=gyFpTDZo/I5l2ps5Of7aky6SYqfN78qaMh7zDki6Q4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ln6Hc5hUuKf+jIHqhABXNJ9lY3BjKg5xYiVqemScDRn1taC0RumK7Nc/2e1iSZjWG
	 Z3U7fgvraTQLYDj8CslwuHHtJgUl3kTjFA6K0EKS2gcRDYi+cl0FVEuSy0ZI40vD4Y
	 zVEZslLLLzs7J7EZ9BgSY+k6iwBBqm9BjDm2/Cds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 328/427] drm: vc4: Fix possible null pointer dereference
Date: Mon, 27 May 2024 20:56:15 +0200
Message-ID: <20240527185632.067721524@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit c534b63bede6cb987c2946ed4d0b0013a52c5ba7 ]

In vc4_hdmi_audio_init() of_get_address() may return
NULL which is later dereferenced. Fix this bug by adding NULL check.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: bb7d78568814 ("drm/vc4: Add HDMI audio support")
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240409075622.11783-1-amishin@t-argos.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index d8751ea203032..5f8d51b293705 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -2740,6 +2740,8 @@ static int vc4_hdmi_audio_init(struct vc4_hdmi *vc4_hdmi)
 		index = 1;
 
 	addr = of_get_address(dev->of_node, index, NULL, NULL);
+	if (!addr)
+		return -EINVAL;
 
 	vc4_hdmi->audio.dma_data.addr = be32_to_cpup(addr) + mai_data->offset;
 	vc4_hdmi->audio.dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-- 
2.43.0



