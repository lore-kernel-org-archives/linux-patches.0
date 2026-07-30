Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F8B373BEC;
	Thu, 30 Jul 2026 15:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425804; cv=none; b=nqWyXtfs3JD5I3IP99btnfPVtFAItlWbE4j2ugjnk2wjJiOqG7yH7SSY8FYYujKOcTKzhaU53eNAM478UI+T2WOgxx/ihnXlldLj5KEdvUYd3Yn7vRBHEQSYrFY/cBbHanL+2Q7Z6uTdlBZseo+Kg2AWYyRpY01TlyUa9OtcnV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425804; c=relaxed/simple;
	bh=tEoD1Y+X8Pnp3ffd0+IPESWOjinDM86T2U+xmGfDU00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Er6Pd95dBLt44f4NENvWxyoWeh7/EG1qdRlgqW+oOl601SKnpOu5QJYq/t/YD3AY4maUWl6d34xxdsVaNqyO3/t25RdPAUezViWqsaMzg+/GiZEO64Qd+9RyN1Vt/DjzztsWgWNqPndRSqR3GvPz2iFvr+WSsCrIAruCEXo6gpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8LfvDsN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8LfvDsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E031E1F000E9;
	Thu, 30 Jul 2026 15:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425803;
	bh=YPD4doyvHD1zd8WL9cC4rq2L/U4ZSKy8M/hPSmiUm4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8LfvDsNUF786A0RaU/a5Go8v3mw3Mv3O9e9HOJ/XslPm8GCh1rA4FwnNf+OrsEto
	 erNLcbNW5os+ZFhCKlsAPaNyStntaq+ej7+IJeo6LEXA8sZzkwCXBd/KZTaDWp0tsr
	 qFVn8edFEFhivYJGmo/3fiZsB2103Dbw96mT/j60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 198/602] net: mctp i3c: clean up notifier and buses if driver register fails
Date: Thu, 30 Jul 2026 16:09:50 +0200
Message-ID: <20260730141440.118434356@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 47513ebbc68079..fbcd48f1971a45 100644
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



