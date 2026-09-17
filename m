Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA20D3D3D1B;
	Thu, 17 Sep 2026 18:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668511; cv=none; b=Kfa5+qJdXQaHEizBQRf/qHCQ/Wlidha9cWvNqCnMJRz/BkwllJgstNZtcYSOoGfLj0SEDksms89SO5BKbi7YINUGEkCi1UDNinSbwOk1eSpSOtUuHzkVZJkPoNpSfWNDSxvGgVGFjvDcXsggQ/UOHhiL0o2psC8IAsIKpv8uz3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668511; c=relaxed/simple;
	bh=Uam1/eaM1sUiJIrRmHqObug8XbAcMmB7h+t5Kxxo0Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDf3Zw3/UVUWj2Cb8FwB++RJqvlVxIpa7pbFxZimLT04geHZ6F9u/c4Pu0nuHqPZpe9VUphMtvjQeVDiFqKZagrL49/XB4LaUeMnOr3cWbu56FpTmECIRwA7f8lswt1WxxyosOr3hVjAAcZLaDyEUdf8fAW+ryy67gMxOl6OECo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7fenB4i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7fenB4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1497E1F000FF;
	Thu, 17 Sep 2026 18:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668510;
	bh=U83tFPygOCmHKh7dv9vtpZGd5HtHJ5qVXe1JjCYHMqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7fenB4iFg+mPEp/5hAFOsQ75aFtwZ+bZXH1Q2ijS1w1dKl+Aa7yy4hPo+FXgl5sN
	 MQDzLg/KFUSCGHMwos0UwAhRAl/D3Fc/fi02lxL8kKVNOA08nQ45ZyLDrx390VI3bK
	 Kg/i3eXIjiGRzxDYMDGi/jcf1Qq6+gyrfqF7iMH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0447/1102] cifs: validate idmap key payload length
Date: Thu, 17 Sep 2026 16:06:30 +0100
Message-ID: <20260917151550.903870733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit 455488cd5054bcc59db40fa1cc2c004031a5b2a5 ]

The cifs.idmap key type stores its payload length in key->datalen, which
is limited to U16_MAX.  Accepting a larger key payload truncates the
recorded length and can make later users interpret the payload using
inconsistent bounds.

Reject oversized preparsed payloads before allocating or copying them.
This keeps key->datalen consistent with the stored data for both inline
and separately allocated idmap payloads.

Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsacl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 230b98b3a272c..1f596d2493bd9 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -69,6 +69,9 @@ cifs_idmap_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 {
 	char *payload;
 
+	if (prep->datalen > U16_MAX)
+		return -EINVAL;
+
 	/*
 	 * If the payload is less than or equal to the size of a pointer, then
 	 * an allocation here is wasteful. Just copy the data directly to the
-- 
2.53.0



