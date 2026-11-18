Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051430;
	b=ATOV8tGsR7/wJpVjekt7WPgOt1Ls/3m0mG5BnG9KQZVE8fMNG4Fu8DIXPqZtEJo/t6mF
	 ZRbzocoSOo4r0/5/xxZh0eLy8ongiPntYz7MCVdbK0JL53ENrJVYpci9L5nzOKNwT7dTj
	 4exhuCyCRx5bbgRV6zTtDGxYlO+yG8yeUsOmHTk+10BwxQkAW0Bfbo0EB4tdYa+xg53eo
	 tEgL62Abwc1ArUoqrF31cIaVeQ8DL+BV9tE312pstPxKjUFbqxjz6dUp2lPl/veK+DKBD
	 J0fLRTfs3E4JUCzryZJnV/geQPdatTkZYcgXHbNcRsegzFOglw2tfuTVANieulVOrMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=210KTjqlz5+vLhtJukT6nZvBWD979ncJ2utkwWig0Yw=;
	b=e4UjoCAQCeU9/nO9LmLgE254VHphtllHiVztnLjoiuLSz4feD5JE/5Zv+N2W2zOqIkgQ
	 6qgvob57TMGcqZ5CusjM09xOimwmPB2Js9xBTWZpJbqtfuEj8rHZmCMVamZTRKnQwn/w+
	 l7czxvDKWjrJPAwgF/Rx0iyKrUc0yerKbi/G0BKWkNpOTr0hqBD+N7ETVHW1OnWJeupW1
	 FLiJm2OkiukT+YUzoMr5i/6IViOr5PM52bY/CZF/h8gE9cX3OHXK2Etuz9SNndw9p79Ef
	 cDHyyVP1AULUaGhq8LrJFVAN2XRoE2f25euf0Z+UEZdRBeqG4r6nbWhSlmpxN2V8nyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NVLCf5y1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E80606A325;
	Thu, 19 Nov 2026 01:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NVLCf5y1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4566B1F000C4;
	Thu, 19 Nov 2026 01:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051429;
	bh=210KTjqlz5+vLhtJukT6nZvBWD979ncJ2utkwWig0Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NVLCf5y17Tsm+n3zDUdF6GZmaP6Hf8uN3FH6RzyAfPAyTtI3WXtY2LT6GaIupnuJP
	 diC+homcOID0ewlNsKsW7D3q6f9cIoV0HcKUCvuCZOC3u+X6lIxa/8ZKZmvBDdBIgE
	 NJvPJugd3F02QWLWbo89LE+2ImD5+tCeRq0sXMU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Tatas <michail.tatas@gmail.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0204/2214] ipmi: Fix leak in __ipmi_bmc_register
Date: Wed, 18 Nov 2026 15:31:20 +0100
Message-ID: <20261118150018.365175790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michail Tatas <michail.tatas@gmail.com>

[ Upstream commit 18e633dd9674c8bf118ea8583bb5a531edc2728a ]

In case that ida_alloc(&ipmi_bmc_ida,...) succeeds and then
platform_device_register() fails, ipmi_bmc_ida is leaked.
Fix by freeing the error path

Signed-off-by: Michail Tatas <michail.tatas@gmail.com>
Message-ID: <anUK_HOy_pCgvsBm@michalis-linux>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 2a3ab1e9507a6..df7c306b299b2 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3127,6 +3127,7 @@ static int __ipmi_bmc_register(struct ipmi_smi *intf,
 	list_del(&intf->bmc_link);
 	mutex_unlock(&bmc->dyn_mutex);
 	intf->bmc = &intf->tmp_bmc;
+	ida_free(&ipmi_bmc_ida, bmc->pdev.id);
 	put_device(&bmc->pdev.dev);
 	goto out;
 }
-- 
2.53.0



