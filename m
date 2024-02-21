Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A265B3FB21;
	Wed, 21 Feb 2024 13:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522491; cv=none; b=G5eL2cTnLshhjydjMHRTb1t2i79GT6ZsJQ/kzo0EE7PDNMD13FB3kYRhgKp51DmPmozMKDWqDM1sojrpfM9Ia0X3xfQP82kEW/xyoxMd4rVXqcv3ayY2zutjJ/ODJ/A+xakeEUO5yG/VVTjziLRrMgoGcYZtI1xlQwhHtowg6vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522491; c=relaxed/simple;
	bh=2XDSceo2setOmVMKyV4Ni42xvAk14S+klYYfN5rbY7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqL1IplnNVvI4kRyu77RyNLKOLOCq3gzbGZO3Ov4jwnbblLWFYApCUdXeudfVuTEMS3iigcCdi9RdT+3V/tVtSVUPdItLMofqT1c97cbsHPzOWzb59x4aEsoNP/DxrEW0usKSBVM/EE0G38mx8IeUROhkmKTRBeb1EZIj5AJeis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPTt7Rb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPTt7Rb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAD5C433F1;
	Wed, 21 Feb 2024 13:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522491;
	bh=2XDSceo2setOmVMKyV4Ni42xvAk14S+klYYfN5rbY7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPTt7Rb28fxMtyJQ/eZem2Foy1BUDJdiNuvaOuVGAEY+ZuekWsf4zpZHMoj06Bq3a
	 UP/AIUrnt4rpxq47TkiZlwTpJwLwmYDLMoWTLNSFd6Ap8aKqf6k+/UoF/ekZaw6Hur
	 7i8DpmeU+OW5mkpuKYpWIgC9eJyG4Mo7XtmmV4zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weichen Chen <weichen.chen@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/476] pstore/ram: Fix crash when setting number of cpus to an odd number
Date: Wed, 21 Feb 2024 14:03:20 +0100
Message-ID: <20240221130013.435243631@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Weichen Chen <weichen.chen@mediatek.com>

[ Upstream commit d49270a04623ce3c0afddbf3e984cb245aa48e9c ]

When the number of cpu cores is adjusted to 7 or other odd numbers,
the zone size will become an odd number.
The address of the zone will become:
    addr of zone0 = BASE
    addr of zone1 = BASE + zone_size
    addr of zone2 = BASE + zone_size*2
    ...
The address of zone1/3/5/7 will be mapped to non-alignment va.
Eventually crashes will occur when accessing these va.

So, use ALIGN_DOWN() to make sure the zone size is even
to avoid this bug.

Signed-off-by: Weichen Chen <weichen.chen@mediatek.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Tested-by: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Link: https://lore.kernel.org/r/20230224023632.6840-1-weichen.chen@mediatek.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index f3fa3625d772..e15b4631364a 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -519,6 +519,7 @@ static int ramoops_init_przs(const char *name,
 	}
 
 	zone_sz = mem_sz / *cnt;
+	zone_sz = ALIGN_DOWN(zone_sz, 2);
 	if (!zone_sz) {
 		dev_err(dev, "%s zone size == 0\n", name);
 		goto fail;
-- 
2.43.0



