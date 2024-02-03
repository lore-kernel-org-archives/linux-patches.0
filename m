Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A3D10A3D;
	Sat,  3 Feb 2024 04:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933502; cv=none; b=duL71cn0KgvsXbkhy4lhpxbp7mqBu8N/pNBMpVWH6y+uHn4a5rZA5wvTNVCrwfuRFtnKrvIxJ3V3zJvlvEFmcwMYA8SVLadw5+nZRv33FRHMW8je6x/p5mRe728ocMtSDHcMAju9wQ+jc0Zu/9NP/XjFvEqtgtE1VQc/jJpiIx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933502; c=relaxed/simple;
	bh=/w5JFbQ0io1l1uF+BmZRYfnDELg4mZX0OrgNACdAJhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RufLqk9IIu1KaCleKvgSMmwgNzCOHQZ9T7FnFlMWCXqlT0ePKGuEJOOjftQKkLAQbqPBXKIo+xaaZYkFlEhNfB3fypYpZ9m7z86VNVWM25g8N+3AQO3cVwQM32x79JdAQBmWsc5y1K4T7IKyK39xcocx/h2p7Cws6gartR4VMcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKt41ufs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKt41ufs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB902C433F1;
	Sat,  3 Feb 2024 04:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933501;
	bh=/w5JFbQ0io1l1uF+BmZRYfnDELg4mZX0OrgNACdAJhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKt41ufsmtZIc+iyDPbiRc8KRcHrd+BszycfCoeqpbdUQ8T3Iud1gU5pi1LVtczgg
	 hfjKRbQk7Ycmq+x3n1G6owvVjwPFotLrMGc3Y113+YHrGaX5d0hQjgA7f3Gunqx4rr
	 tzFpfiNiqOsF5RVcw/z3b96hIvJSnrOCp3WPxj4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weichen Chen <weichen.chen@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/322] pstore/ram: Fix crash when setting number of cpus to an odd number
Date: Fri,  2 Feb 2024 20:02:10 -0800
Message-ID: <20240203035400.136563114@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d36702c7ab3c..88b34fdbf759 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -529,6 +529,7 @@ static int ramoops_init_przs(const char *name,
 	}
 
 	zone_sz = mem_sz / *cnt;
+	zone_sz = ALIGN_DOWN(zone_sz, 2);
 	if (!zone_sz) {
 		dev_err(dev, "%s zone size == 0\n", name);
 		goto fail;
-- 
2.43.0



