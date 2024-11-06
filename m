Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DBF54765;
	Wed,  6 Nov 2024 13:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899100; cv=none; b=pqPfAf+TOpskgVq3lIcaR1wTiX4IrLG0WDoguxf5H4evEk+xM8Xe8N98Geket8xVR1LYRm1S2Gb6XLGQI1zpuGTgl/i08NaXANA77InctGdOfpL0vcOfXOnBEXxiIEeqJYhaPlCEsfc722WnpvBLdLG0qEQEcGFaThUpik4kbeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899100; c=relaxed/simple;
	bh=Cj73cU7fpnqjKLkcoxkWVf988qYGhpoXnGW1LcGJ+cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sc0kI8/2VDhO/kZ/I7kHPWeMl4MQwpwwvqPrqt9Rl2zY+MfCPHGVuqFY/Ymg+74HuQrdwK9g/sWaMEqlI+5fIQI+XcRJon9FGDf7BWqVOdtr9Xl7x5n3of7nKCa3YBYGGyg2zNckMxcw4VpfHlNrZdmq9UZp6vj2bgPTyR8wGwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obJAXGH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obJAXGH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBE5C4CECD;
	Wed,  6 Nov 2024 13:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899099;
	bh=Cj73cU7fpnqjKLkcoxkWVf988qYGhpoXnGW1LcGJ+cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obJAXGH1uC3uueG55a2ZFBjAIHNKUBb5AFkho/prODjcMzCyR4CZtNM52luQ7nAFK
	 n4jdXEMuUC/epfm/GmzvTXm5kkW7J2c5KtlhC9h44x77XTAfek3Y9al9WQYFrLy+U3
	 /TyEKotcqmCG/el5EJ10KfUiM15aBjBOi70d/smg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+955da2d57931604ee691@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH 5.4 460/462] vt: prevent kernel-infoleak in con_font_get()
Date: Wed,  6 Nov 2024 13:05:53 +0100
Message-ID: <20241106120342.866094000@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

commit f956052e00de211b5c9ebaa1958366c23f82ee9e upstream.

font.data may not initialize all memory spaces depending on the implementation
of vc->vc_sw->con_font_get. This may cause info-leak, so to prevent this, it
is safest to modify it to initialize the allocated memory space to 0, and it
generally does not affect the overall performance of the system.

Cc: stable@vger.kernel.org
Reported-by: syzbot+955da2d57931604ee691@syzkaller.appspotmail.com
Fixes: 05e2600cb0a4 ("VT: Bump font size limitation to 64x128 pixels")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Link: https://lore.kernel.org/r/20241010174619.59662-1-aha310510@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4519,7 +4519,7 @@ static int con_font_get(struct vc_data *
 	int c;
 
 	if (op->data) {
-		font.data = kmalloc(max_font_size, GFP_KERNEL);
+		font.data = kzalloc(max_font_size, GFP_KERNEL);
 		if (!font.data)
 			return -ENOMEM;
 	} else


