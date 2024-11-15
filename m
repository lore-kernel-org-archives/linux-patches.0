Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3281C17DFFD;
	Fri, 15 Nov 2024 06:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653889; cv=none; b=rm7l/T4zbYCoXlNAHJ6swK3WMzMvSdnoq1yUrtmGFBY7mOBJR2Cf8eWIdjJnjf1++blprTwU9aTeyx23kzogE2kh0BqVzHkL+slKkX520/kEA9HmlC1geTbTBTw/tdTknWvHfX6M7RH1AFYW8FVKBIx9ozLR2ENHeWwWIDBH9OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653889; c=relaxed/simple;
	bh=RKWhtQKZOvP0+wEvJwGFG57PA0T/xId+WvIyZO6a95Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEXRidLIYDeZxku3FGLVKCw1mlK+eIvWlvMSOfVf+OCK222pFujbFtzP1Qxfs/srKef/LkiugASoG0x/s9mlPzBt3b4PMsu8a4+2mxp3dpVWetL01heb7/fQN1AdFDO39KZYEPtIm5GufnoMcSZ5j3hrPoDUk5iM66l8Kl9t6nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKm15kMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKm15kMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97391C4CECF;
	Fri, 15 Nov 2024 06:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653889;
	bh=RKWhtQKZOvP0+wEvJwGFG57PA0T/xId+WvIyZO6a95Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKm15kMNdJpcjsr9EqJTMCgCcfkCdziEcRyHxXSWIkuifn1kV20ghppQP2HbKSWpa
	 bUeudsZXCbT+9Cc/eSNFxlVuXMecozpIg/tDK5nX/pVpNhsX36PPlEtKgwSA+hIcLl
	 1EZ8FfYj022TZpL8c9lGRZNOlacW60F/iPUeCIok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 32/82] media: v4l2-tpg: prevent the risk of a division by zero
Date: Fri, 15 Nov 2024 07:38:09 +0100
Message-ID: <20241115063726.722301964@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


