Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965527E795;
	Wed, 21 Feb 2024 14:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524158; cv=none; b=Wko6cf5PeYmuTUL7yVMqFxYGC2NDqoiKGGt7EnfhTt6fLuuCTsSWB27K7ycK6CKt0xkU2jq1QKFcQJvgyP86Je0oG3pJxzX81H4KoK/DQnbNO76Efm63eLMQbCEvcr8b7IUvM2x94c9My6npOLJ9ITEVxSS47D32EWoJgGRpHjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524158; c=relaxed/simple;
	bh=nG9oGOpQJBSCmwdyroGWr13Qn+Ngp6rRRol4/2xDdcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8Vjj15N2OQMZIpIGMCFi2mEyCFYpBCyh9x+eYpOybWXuxqwGMORUCa8pmqA0ffYYQH1AG4hB9MwRV+t431tEwMfK7JIYxcghQlIgHtjzBgciMZ611vrcnwSWDpdhcjv9sTYlOE2S0jj/IrXxjRF4Zcr8cvH/n/gsV3Air4zkis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t73exshK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t73exshK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BD8C433F1;
	Wed, 21 Feb 2024 14:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524158;
	bh=nG9oGOpQJBSCmwdyroGWr13Qn+Ngp6rRRol4/2xDdcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t73exshKfFqneMeacZR+xV1PyEbfojGz3z6k9iLIn7GZy/lXBTu+WNCRmh2d5yF/R
	 LSqcBwFJ73TJySGzP2Aar+GpT1Bzw5Lxo4MKmwKs27IGlFDU1yhCOLmJAzm3K6Kq5m
	 QVKujb3TnWEprQCaTsh52aUmKDcl+rnCNwMnLMG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weichen Chen <weichen.chen@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/379] pstore/ram: Fix crash when setting number of cpus to an odd number
Date: Wed, 21 Feb 2024 14:05:02 +0100
Message-ID: <20240221125958.567068015@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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
index 98e579ce0d63..44fc3b396288 100644
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



