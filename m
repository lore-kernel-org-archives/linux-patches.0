Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472F43101BF;
	Thu, 16 Jul 2026 13:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210333; cv=none; b=fA7t/NIQJDSlApw3OtFiMuUagYBTlpqCY4kirHznQMri0XS6WPnFuwzRJROFnGyTEDyPMGpC8iuCyIL73JurNGpEoI6sCiRbgESyYNDjk8PMhQ677abHt50BVQQfa30vJxZjoc6+BcdoN7krekgmz9hiCR3DBR69HgCGZ/PBE04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210333; c=relaxed/simple;
	bh=dlHg1srECMbUBHjfXsLvt5pnlhnt+TdHKRkhm8ze2gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YY1u0E0yjbJK2iGtgMf26P9O+a0MishdgnW1+dSh4YGCHKvPOgb1LTddrR0mheM33mVHbAVuVuGEV4ur4pffBkWcfZjHSTTyjtmm/fNu+dtq2vrY5IRvZu2MJz9wJci2ajgUGOO7o/6JcERTvDQNsltHDHYlZnIaQ4fb9vLC5gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAMv6kXY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAMv6kXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5051F000E9;
	Thu, 16 Jul 2026 13:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210332;
	bh=9cT+H39B0wrjo8yZI9VPXNvr7GP1jX1hBBECpsnEUQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAMv6kXYBlYTEveps+QadPW8P3bnvHTRkJOrJQiRw21ikt11psAO914AO4SCpC8y2
	 zbjWvxtHj772dD/9sy3vXIRlTDwnObCCRHwIAGuXKUIWQhg6VepzwgeFlIN44SKYKP
	 GUDvpjcM6vjt5CJRG7uTHXMVaIkSA/tj0hwfU63w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 490/518] Input: gscps2 - advance receive buffer write index
Date: Thu, 16 Jul 2026 15:32:38 +0200
Message-ID: <20260716133058.567319161@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit d86d4f8cbb5a55a3b9b86f7b5ab8c4cdda600a3f upstream.

Commit 44f920069911 ("Input: gscps2 - use guard notation when
acquiring spinlock") moved the receive loop into gscps2_read_data()
and gscps2_report_data().

While moving the code, it preserved the writes to
buffer[ps2port->append], but omitted the following producer index
update from the original loop:

	ps2port->append = (ps2port->append + 1) & BUFFER_SIZE;

As a result, append never advances. Since gscps2_report_data() only
reports bytes while act != append, the receive buffer always appears
empty and no keyboard or mouse data reaches the serio core.

Restore the omitted index update.

Fixes: 44f920069911 ("Input: gscps2 - use guard notation when acquiring spinlock")
Cc: stable@vger.kernel.org # 6.13+
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/460B5655BA580C60+20260624094739.850306-1-raoxu@uniontech.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/gscps2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/serio/gscps2.c
+++ b/drivers/input/serio/gscps2.c
@@ -219,6 +219,7 @@ static void gscps2_read_data(struct gscp
 		ps2port->buffer[ps2port->append].str = status;
 		ps2port->buffer[ps2port->append].data =
 				gscps2_readb_input(ps2port->addr);
+		ps2port->append = (ps2port->append + 1) & BUFFER_SIZE;
 	} while (true);
 }
 


