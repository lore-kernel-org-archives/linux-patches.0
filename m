Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E951A619D;
	Tue, 30 Jul 2024 16:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356151; cv=none; b=b6kg9oOhvg/r+WkjXJqW/wY2dfqKMU9ULGf3s27VYtSWxAdoaJ0GbDtOULopaopn5i1nrV9CQrGqumQPUzPR4lUrlzexz+ljxaYmu8d/XhpkJgzTx0duuo18naIIGkaLXLuXHLG42kjyPSXKqKVMF7Q6LHR3R96YnekPs2RQLtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356151; c=relaxed/simple;
	bh=dneC8eWXOMLhgc0rjGcT8snXxUE7xgeEQVOEKdSOMuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NrhXDAZXgxBspE5SZYoyF+yBtbMowa7YAf4LaU3fAbnmkiSTPJGd4FbOYhfZKW76xYnsyh0vMxXB1rZzkK+SM+rTTF2ykoYvFvKp25sY0JGqOa+2imqsT8DP+dBm40NtdX0mapv8Gt3+Lgg07bpBE6sBGoUYjdgEM7ran59JqZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUcJN5iK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUcJN5iK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FE9C32782;
	Tue, 30 Jul 2024 16:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356151;
	bh=dneC8eWXOMLhgc0rjGcT8snXxUE7xgeEQVOEKdSOMuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUcJN5iKijEG9YCrORsvWRfeku7p5jzA5+4+v9oAp/0tfWEXYgdY7jtDX5YHPbmAn
	 FmuX4S3ustly1PUwF2Nb6fBvGwxxDwuCUTGl5tvv/byNlgIV698BJdsRwbSyV4y307
	 y23vJVjRxHdXw+jYUnVK4FTP1cXwi3LIDN+09XtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nicolas=20Pomar=C3=A8de?= <npomarede@corp.free.fr>,
	Christian Zietz <czietz@gmx.net>,
	Eero Tamminen <oak@helsinkinet.fi>,
	Michael Schmitz <schmitzmic@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 124/809] m68k: atari: Fix TT bootup freeze / unexpected (SCU) interrupt messages
Date: Tue, 30 Jul 2024 17:40:00 +0200
Message-ID: <20240730151729.515330613@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eero Tamminen <oak@helsinkinet.fi>

[ Upstream commit f70065a9fd988983b2c693631b801f25a615fc04 ]

Avoid freeze on Atari TT / MegaSTe boot with continuous messages of:

	unexpected interrupt from 112

Which was due to VBL interrupt being enabled in SCU sys mask, but there
being no handler for that any more.

(Bug and fix were first verified on real Atari TT HW by Christian,
 this patch later on in Hatari emulator.)

Fixes: 1fa0b29f3a43f9dd ("fbdev: Kill Atari vblank cursor blinking")
Reported-by: Nicolas Pomarède <npomarede@corp.free.fr>
Closes: https://listengine.tuxfamily.org/lists.tuxfamily.org/hatari-devel/2024/06/msg00016.html
Closes: https://lore.kernel.org/all/9aa793d7-82ed-4fbd-bce5-60810d8a9119@helsinkinet.fi
Tested-by: Christian Zietz <czietz@gmx.net>
Signed-off-by: Eero Tamminen <oak@helsinkinet.fi>
Reviewed-by: Michael Schmitz <schmitzmic@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/20240624144901.5236-1-oak@helsinkinet.fi
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/atari/ataints.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/m68k/atari/ataints.c b/arch/m68k/atari/ataints.c
index 23256434191c3..0465444ceb216 100644
--- a/arch/m68k/atari/ataints.c
+++ b/arch/m68k/atari/ataints.c
@@ -301,11 +301,7 @@ void __init atari_init_IRQ(void)
 
 	if (ATARIHW_PRESENT(SCU)) {
 		/* init the SCU if present */
-		tt_scu.sys_mask = 0x10;		/* enable VBL (for the cursor) and
-									 * disable HSYNC interrupts (who
-									 * needs them?)  MFP and SCC are
-									 * enabled in VME mask
-									 */
+		tt_scu.sys_mask = 0x0;		/* disable all interrupts */
 		tt_scu.vme_mask = 0x60;		/* enable MFP and SCC ints */
 	} else {
 		/* If no SCU and no Hades, the HSYNC interrupt needs to be
-- 
2.43.0



