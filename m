Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544032123D2;
	Tue, 12 Nov 2024 10:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407051; cv=none; b=AOsgZA681t9drDetJ82x1af5r+A1Fk34bMjngHst5F5EF/10Me6dkItkaoETmk+CgDJvcLD7w6Eqty6zaYSdVhwanVmvlV0KHxxJJZUCRYp7a5jt808aYUrr2N3OlAJpAnP01fMZ9nsCP8oTZ9wOTkZMJnLNoKiMUOfIi00kjTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407051; c=relaxed/simple;
	bh=DNNZuzLSjgw4LBrneyP/7J8GTolqwE+yVo0HyQL+yL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1Us7I3fJP7FzHVfAzN2T0eBzlPOwLGqZv9xIfYdpkca+8HH0IY24HrptX8+ek/TbZdMRph+O59A9ZAmOINlxLBzWA9jYsF15qXynOUaZNZNdtZBOi5oVe9s5ZW/vGIq3M7Nhkb1gnpy0+iCpJWUwiiDRqNbmKOvHSvDYFXOuHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSTDZREC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSTDZREC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD037C4CECD;
	Tue, 12 Nov 2024 10:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407051;
	bh=DNNZuzLSjgw4LBrneyP/7J8GTolqwE+yVo0HyQL+yL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSTDZRECMy1bRG8/6667aO+yy9UmYU5qQyEnzzAxiATP8+WxVM/StTcCRhsV6Xv3d
	 78zEFvIPQtzoNvtm5ocXFpLB/3qwW9keFT/uVP49TA5C49q/hS1EJ9duYVxUvB5+jS
	 w9aT5Uwih9ZUuGQA1x+xgmrzUe1GVOzjp3BLwc/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 36/76] media: v4l2-tpg: prevent the risk of a division by zero
Date: Tue, 12 Nov 2024 11:21:01 +0100
Message-ID: <20241112101841.161898614@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1789,6 +1789,9 @@ static void tpg_precalculate_line(struct
 	unsigned p;
 	unsigned x;
 
+	if (WARN_ON_ONCE(!tpg->src_width || !tpg->scaled_width))
+		return;
+
 	switch (tpg->pattern) {
 	case TPG_PAT_GREEN:
 		contrast = TPG_COLOR_100_RED;


