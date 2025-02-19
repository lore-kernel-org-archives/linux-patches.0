Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9591C548C;
	Wed, 19 Feb 2025 08:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954621; cv=none; b=kKj37P/i0GM+fgKw2fZmf4BEucbtYIshrjkVaU0GmhPkZOiBZYlO5cKT62F4nV5hVaxHp6H1DG3Z/8FVqZfbuHvPJzvZRvjg17LJcWu0g/rQvC4Pd1syCV4RX9BQzG4HnhbZXX6uCf7i+57u4B3B/LppG2yWD2TqbFhto0dU6jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954621; c=relaxed/simple;
	bh=46sFXpqAmnNH0GqVjfyfJISyRgmUSYRcGqOFcSC8+NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhhF9dOTlFGF9bBvHOixLmPm4CcTuKlPscmUBUKHkBeahjJHuHaNt1wl/bPJFNwYrQz6yXDFvCdmzi+cQXlxe/Me8myXl2sDZJGTXuUJEYLl6DMoIc3jivsC9wCNuEhUN8HHKNHFM7tbYOSGmpTSxRKb1WEh9tKzXfSVKoTSowo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1PuAbuvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1PuAbuvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E963CC4CED1;
	Wed, 19 Feb 2025 08:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954620;
	bh=46sFXpqAmnNH0GqVjfyfJISyRgmUSYRcGqOFcSC8+NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1PuAbuvlM/72pL61zyBduIs5fz0LsBqoenDHGbjFd8gR//CDtiTAW0nXx1qS80SMK
	 7OsdAaphB+zI7gNqjCvHh7bkn6zQArJjGRW8RXlpFXlMb4EMsK/Lc+m/QYUodHPiIJ
	 Ij1Pjf/UFz7ZrwJXhbRMp6p/uuMnNl3olSnSUCgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Przybylski <karprzy7@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 6.13 260/274] drm: zynqmp_dp: Fix integer overflow in zynqmp_dp_rate_get()
Date: Wed, 19 Feb 2025 09:28:34 +0100
Message-ID: <20250219082619.764612680@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Przybylski <karprzy7@gmail.com>

commit 67a615c5cb6dc33ed35492dc0d67e496cbe8de68 upstream.

This patch fixes a potential integer overflow in the zynqmp_dp_rate_get()

The issue comes up when the expression
drm_dp_bw_code_to_link_rate(dp->test.bw_code) * 10000 is evaluated using 32-bit
Now the constant is a compatible 64-bit type.

Resolves coverity issues: CID 1636340 and CID 1635811

Cc: stable@vger.kernel.org
Fixes: 28edaacb821c ("drm: zynqmp_dp: Add debugfs interface for compliance testing")
Signed-off-by: Karol Przybylski <karprzy7@gmail.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/stable/20241212095057.1015146-1-karprzy7%40gmail.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241215125355.938953-1-karprzy7@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xlnx/zynqmp_dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xlnx/zynqmp_dp.c b/drivers/gpu/drm/xlnx/zynqmp_dp.c
index 25c5dc61ee88..56a261a40ea3 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_dp.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_dp.c
@@ -2190,7 +2190,7 @@ static int zynqmp_dp_rate_get(void *data, u64 *val)
 	struct zynqmp_dp *dp = data;
 
 	mutex_lock(&dp->lock);
-	*val = drm_dp_bw_code_to_link_rate(dp->test.bw_code) * 10000;
+	*val = drm_dp_bw_code_to_link_rate(dp->test.bw_code) * 10000ULL;
 	mutex_unlock(&dp->lock);
 	return 0;
 }
-- 
2.48.1



