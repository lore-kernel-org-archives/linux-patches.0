Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E711E633C;
	Mon, 20 Apr 2026 15:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700384; cv=none; b=V5YKg2i8OKNqZK0grpkS9tlKcSZvlV3VJ+HzbEvufFkGR4PfRpTswwSOiEaxI3QThXyHZiAUstDnnqHUhpkxVEDLgvWieUIsxH231BplYHVmH0mZPMYpqUI9t7e0Qveg4zhJfqthDTrP2WyZJH6f4XOO6pgvdykzH/OmWDMA3z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700384; c=relaxed/simple;
	bh=EF9nupvaIMpfhQlmXcfwtBgXLLLU3jquxRYQDErNUA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQdqk7fetUgRF35kxjE8q6EI+i1iex+GpXPqsQxKC0lxy1DGzvhozOkLruiRYsHg/xu1QjCZNBr32aUAf8wWsdWBEtc01THbyU+yy+vOwFuuofJsj5XZarNr/TFqkGKfpLb7op7lqvUfjwDT3LsfRG7rO64NZtB0zpGvN6qUqVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNQ7mVLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNQ7mVLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFF5C19425;
	Mon, 20 Apr 2026 15:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700384;
	bh=EF9nupvaIMpfhQlmXcfwtBgXLLLU3jquxRYQDErNUA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNQ7mVLkg58XF3EVmy3dA3Ny4gXlffQTuq3jbjYOE2rjJ/RBcYD1Q3c6w9qLcXe9Q
	 h7jB+dwQdH1M0mVNvuMifIA6YhSIcMf8WeSX5EtCzsmN3GN1ylyhJAe1LhCulWxwIy
	 YcZfVHPp7b/h81wRN8SEsL3SqphoBXBqfv3yiIWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	stable <stable@kernel.org>
Subject: [PATCH 6.19 152/220] fbdev: tdfxfb: avoid divide-by-zero on FBIOPUT_VSCREENINFO
Date: Mon, 20 Apr 2026 17:41:33 +0200
Message-ID: <20260420153939.502103296@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8f98b81fe011e1879e6a7b1247e69e06a5e17af2 upstream.

Much like commit 19f953e74356 ("fbdev: fb_pm2fb: Avoid potential divide
by zero error"), we also need to prevent that same crash from happening
in the udlfb driver as it uses pixclock directly when dividing, which
will crash.

Cc: Helge Deller <deller@gmx.de>
Assisted-by: gregkh_clanker_t1000
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/tdfxfb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -496,6 +496,9 @@ static int tdfxfb_check_var(struct fb_va
 		}
 	}
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (PICOS2KHZ(var->pixclock) > par->max_pixclock) {
 		DPRINTK("pixclock too high (%ldKHz)\n",
 			PICOS2KHZ(var->pixclock));


