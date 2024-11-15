Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806ED645;
	Fri, 15 Nov 2024 06:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652793; cv=none; b=oQFrWggnA2lKN/VjJsHDI0aIAxlFCmDgSts/0GsJX7XcLMvlWRb0V2ZKzD8yIFNscKfPuqLaAx8ScyKRJzhjKpLC8keCVK/sSemAetYbPPxM37V74r3m4Y2xb6zyMDyqVcevBOFE3zlJJ3IIrsYlI5bBznjYqG6v3GQ7n3U65mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652793; c=relaxed/simple;
	bh=v08OCQHNtn/z1y4ZFzDhtm/qBpUxGgNAv2y1MvBXozo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gML6M06HINAxNuvCAaQipScpZAy0CCujRxxEmkZAVzmqZF9WAoJj5fc0vMiPI++WPJmVu6nWgk+XLoPfkjoUzlfXdIYLyTTK0TsXYzVkJgSW9kA+j36lMKmfCZXRFXN5GiehHBWPryzBcOVzWIiYV2A4U9vfli0fuCGK1QfTERs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnEfK6ps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnEfK6ps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2376C4CECF;
	Fri, 15 Nov 2024 06:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652793;
	bh=v08OCQHNtn/z1y4ZFzDhtm/qBpUxGgNAv2y1MvBXozo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnEfK6psgAYvwDmPWkli0ZOgmL44JHFZ7HCSIJg/NemgZWPgKJM23KDLf9/8PQT0T
	 AfjViIrVJkZ7sw0D6HPPrX4kfkPWunJ2tlYyU5GBoiNqb4WUZHntgaNiJLNcwv9f6V
	 R4DSDseRAwbdWyQZu/HoHE8v+iSiwXziS8hg2RH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 17/52] media: v4l2-tpg: prevent the risk of a division by zero
Date: Fri, 15 Nov 2024 07:37:30 +0100
Message-ID: <20241115063723.477906715@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit e6a3ea83fbe15d4818d01804e904cbb0e64e543b upstream.

As reported by Coverity, the logic at tpg_precalculate_line()
blindly rescales the buffer even when scaled_witdh is equal to
zero. If this ever happens, this will cause a division by zero.

Instead, add a WARN_ON_ONCE() to trigger such cases and return
without doing any precalculation.

Fixes: 63881df94d3e ("[media] vivid: add the Test Pattern Generator")
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -1639,6 +1639,9 @@ static void tpg_precalculate_line(struct
 	unsigned p;
 	unsigned x;
 
+	if (WARN_ON_ONCE(!tpg->src_width || !tpg->scaled_width))
+		return;
+
 	switch (tpg->pattern) {
 	case TPG_PAT_GREEN:
 		contrast = TPG_COLOR_100_RED;


