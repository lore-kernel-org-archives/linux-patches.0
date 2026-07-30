Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DC843F09B;
	Thu, 30 Jul 2026 14:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422085; cv=none; b=GbDUENsYxHtgoAw6EL2lXeMyLwW2QorG8xtjdiy3xEeiQRmmjuh+oR6f49oUblk4S8rwuBy7RXGZ092O5fYke0pvko8pHJkbMH52nPVKOyCtWZKOFsTq2T33P3mX/kh47nHU5cTuu5R9qi3Qh5MrzY3KUVjVyQ8SFuiqMsp9cSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422085; c=relaxed/simple;
	bh=L7So+M7LHFdK2deLVSUWHhIywv3EdhSXI0UJlmspdlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAZHIwQbbCB635G09/N85e3y4RtAEO+D4QoTBVX5DxH3FzydhoXxRHz55NbYtaMqUrEQEAtTzC+yURKyMj4laDyTRJQlI1CAUb5GinXVYVthJpElgCBzXIAxmIf70XzjrgTwA37dt3ipI9ORvElGFBVoY6poyjhA2ydcAr6pnYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zfdk3LNI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zfdk3LNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792291F00A3A;
	Thu, 30 Jul 2026 14:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422084;
	bh=gLf204pskQClzWoB7UcMBGCYvPU8sdLbcRVdenpSloY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zfdk3LNIEOP1k4dInMKrqY9sfpVNYx1//3fOipuIQdJzb9Bhrb+WeTK2wVmy6KV5V
	 HSmeXrGIW+yK7607qCZ+nXReuoJ/j8Xy1AT+K4SmYI5+ec0TfJhAnnLjNHi5nRPz6l
	 djJ/X916XSoa/+6sbjOl+M1gcwViYNrRP7lI5VxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 275/744] net: mctp i3c: clean up notifier and buses if driver register fails
Date: Thu, 30 Jul 2026 16:09:08 +0200
Message-ID: <20260730141450.135786599@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 03d1057305ef17ac3f5936ac1580bc9a1a826e14 ]

mctp_i3c_mod_init() registers the I3C bus notifier and then walks the
existing buses with i3c_for_each_bus_locked(mctp_i3c_bus_add_new, NULL)
before registering the I3C device driver.  If i3c_driver_register()
fails, the function returns the error directly, leaving the notifier
registered and every mctp_i3c_bus object created for the existing buses
allocated.  The notifier is left pointing into the module that failed to
load and the bus list is leaked.

Mirror the module exit path on this failure: unregister the notifier and
tear down the buses that were added before returning the error.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: c8755b29b58e ("mctp i3c: MCTP I3C driver")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://patch.msgid.link/20260715072517.13216-1-mhun512@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i3c.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/mctp/mctp-i3c.c b/drivers/net/mctp/mctp-i3c.c
index 6d2bbae7477b39..88d9e36cd4a2bc 100644
--- a/drivers/net/mctp/mctp-i3c.c
+++ b/drivers/net/mctp/mctp-i3c.c
@@ -731,18 +731,21 @@ static __init int mctp_i3c_mod_init(void)
 	int rc;
 
 	rc = i3c_register_notifier(&mctp_i3c_notifier);
-	if (rc < 0) {
-		i3c_driver_unregister(&mctp_i3c_driver);
+	if (rc < 0)
 		return rc;
-	}
 
 	i3c_for_each_bus_locked(mctp_i3c_bus_add_new, NULL);
 
 	rc = i3c_driver_register(&mctp_i3c_driver);
 	if (rc < 0)
-		return rc;
+		goto err_unregister_notifier;
 
 	return 0;
+
+err_unregister_notifier:
+	i3c_unregister_notifier(&mctp_i3c_notifier);
+	mctp_i3c_bus_remove_all();
+	return rc;
 }
 
 static __exit void mctp_i3c_mod_exit(void)
-- 
2.53.0



