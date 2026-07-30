Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533DD4432F2;
	Thu, 30 Jul 2026 14:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422173; cv=none; b=jakSTN2MTHL5wfXVL01WPKu+FaFKWF9ti0SMi9bOs5p7Tf5h3xKeEdrK5H1AfV17PyRIavRRWclkFaRJShzVjF2ezg5VljgBjZNNda4xSiQPoXyXLAoYE4KmRrk2f2yQb573RxkaKrenwwHDHsXt++P3533O7hFzyioZSvenvOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422173; c=relaxed/simple;
	bh=8wr1k/Jz+TekO1lnwOfYNo1wsWYKiF1eln7Q/jxtJd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uq0euGiWr8R98m5JGALBACjdDfohJr5sWLjGwCD673hPmiYyRk8IxWDESpzqVgBuXKQ/Wyl6QcKPPXnGXG4/3o27zLFlIZTQG5tUVIs1vyxq05EbBpfKBkxejTqIzx0u5QxgLY/Shqg5eJMj5FzRyL6NUK1tQxH9geZZUGv18xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8Uml2yB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8Uml2yB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF161F00A3A;
	Thu, 30 Jul 2026 14:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422172;
	bh=CWnKZH7iZ4pBDS2BkMrRAZWDzSwkBk38UHv0K18mNRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w8Uml2yBzRU8V8L06fCBXDZFxq2Mgh9pbDxswFCBlcpCjGPPwIbo9lj48+YEUOX7B
	 yXoD2YMUbshsbth8DdFFo1v40gobz1JUhnndpJUxYy3OJUY2UvLoQrC4foG7l7LF0W
	 AePOfek9bM+8Yphtw2TtWF3p1um4TGrGaaRWwYso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minhong He <heminhong@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 348/744] mctp: check register_netdevice_notifier() error in mctp_device_init()
Date: Thu, 30 Jul 2026 16:10:21 +0200
Message-ID: <20260730141451.683504166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Minhong He <heminhong@kylinos.cn>

[ Upstream commit d9a33cadc70a94c1582f65e6042e81027cd200c6 ]

mctp_device_init() handles errors from rtnl_af_register() and
rtnl_register_many(), but ignores the return value of
register_netdevice_notifier(). If notifier registration fails, init can
still return success while the module is only partially initialized.

Check the notifier registration error and fail module init early.

Fixes: 583be982d934 ("mctp: Add device handling and netlink interface")
Signed-off-by: Minhong He <heminhong@kylinos.cn>
Link: https://patch.msgid.link/20260720072518.112614-1-heminhong@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/device.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index 2c84df674669b2..822120e860c82a 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -536,7 +536,9 @@ int __init mctp_device_init(void)
 {
 	int err;
 
-	register_netdevice_notifier(&mctp_dev_nb);
+	err = register_netdevice_notifier(&mctp_dev_nb);
+	if (err)
+		return err;
 
 	err = rtnl_af_register(&mctp_af_ops);
 	if (err)
-- 
2.53.0



