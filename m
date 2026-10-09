Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44414E56C2;
	Fri,  9 Oct 2026 14:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556213; cv=none; b=KNG7EoB814RoW/SejxU50MDE/70Zo4Y6iIrTTXa3JJtC1AoAwdK+3qFcjGOSCYycGv+pQwVYtnaLPNGErnlpz/Ea3vyCYDmfIyoJDF2W1sYCac7ac9H60+JD5Fl8WBXl7/wdhw7W69ta8ot60ebbSb9qQGRhvVCgZmGomfImEVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556213; c=relaxed/simple;
	bh=D6CUNtP58YYLFOAL3h64bc1SgddidGaOyqPlWBvTK0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViIm8f9ciy6GlCYoD+0nA3wggrwO0YClOYYM+d9sLV35dDP2tJ7twTme4NoSn1nPZuqfvZKobR9Nf7xdVnPSP3tCZ+Mil7AGOsclS/v5PtBZE3tfANKzGwm8EQTdB6BVKjDe8L2smnmUjuRXG+/NSpi8IpBL7baOGkHsKgOpJoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbU8ND7a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbU8ND7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB561F000FF;
	Fri,  9 Oct 2026 14:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556212;
	bh=gHKwmaQtLQm4/E8peGckwg6L9HCol2ZsVgxfXYlY7OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xbU8ND7a5/vfGnoa4Kw+aEC5kllnyNtfRQfEhc8kzjeKHE+/zfdgtB4ySYDm8sQt7
	 hLcRbWs4jzEILLCsM4pUQ6VWgz6jXB+jJOxAMn8bGU66woSGf/j9w3Ru+5jCrXpfDu
	 VGucoiflGuKzhFIH5hE/wuObc8A7J7o0C7V22seA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.18 192/403] tty: vcc: zero-initialize control packet in vcc_send_ctl()
Date: Fri,  9 Oct 2026 16:09:13 +0200
Message-ID: <20261009140956.618334545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

commit 1f71f565e3585da1098ff19ca3c24687dab59185 upstream.

The stack-allocated struct vio_vcc pkt was partially initialized,
leaving the tag.stype_env field uninitialized before being sent via
ldc_write(), potentially leaking kernel stack data to the LDC peer.

Assisted-by: AISLE:Snapshot
Cc: stable <stable@kernel.org>
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260803-aisle-tty-vcc-v2-1-a50bc9b15193@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vcc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vcc.c
+++ b/drivers/tty/vcc.c
@@ -492,7 +492,7 @@ static ssize_t domain_show(struct device
 
 static int vcc_send_ctl(struct vcc_port *port, int ctl)
 {
-	struct vio_vcc pkt;
+	struct vio_vcc pkt = {};
 	int rv;
 
 	pkt.tag.type = VIO_TYPE_CTRL;


