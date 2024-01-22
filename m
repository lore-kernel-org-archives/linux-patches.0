Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9132A14A4DA;
	Tue, 23 Jan 2024 00:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969219; cv=none; b=QBGcuzlmP3TNdvfPn1Sqep5jlzYFxPY4da76ND12R4BfO5afm8BnzK0AEeE1D4Rt+3pJDTG2gxNmOJJ/z1/Y6X1HYHnNaIGlboF4yAIWCRsZZwOvwNlBOerKYsJ9c9vJWBGyjwKj4fq2NIWJpp3xQUHdY7KBXTH3zODQ+Vds97Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969219; c=relaxed/simple;
	bh=9KOFSi6hv8E3mV+thkO1tLReIxWR6DtFKo76/ryEvC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JoI0glnrJa9ZTpJtL+u4xjyE+VoMkjn5IvwKXh2NHDnI/hUE5k2zWiud4FCzIGPbzKPa3x2P5TutItKPUAwkQHzPhJJhZL52wUFkx0AhWADaI2+H5C5LWTYAussvzxkUpmvuDh7GV4jYCzVk6ruu6nOOYa3A45WppxAOLz0Btnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+aHtNi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+aHtNi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5208BC433F1;
	Tue, 23 Jan 2024 00:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969219;
	bh=9KOFSi6hv8E3mV+thkO1tLReIxWR6DtFKo76/ryEvC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+aHtNi3uz0bbPUTTguQVGllzE1NTrYvVpDyQGjkqRFoMrv1ZmtKzWMTiyVz++zFG
	 wd5mfSMo1C0suLZfpRsjpnVWaySuuRfNt3iAlCSZYLd66nDtD/ucl7D56b9cZomSa3
	 WmD01+0t30yfavVYKSR4moJ9z485figUAxnmF6As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	David Howells <dhowells@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 083/641] keys, dns: Fix size check of V1 server-list header
Date: Mon, 22 Jan 2024 15:49:47 -0800
Message-ID: <20240122235820.631500254@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit acc657692aed438e9931438f8c923b2b107aebf9 ]

Fix the size check added to dns_resolver_preparse() for the V1 server-list
header so that it doesn't give EINVAL if the size supplied is the same as
the size of the header struct (which should be valid).

This can be tested with:

        echo -n -e '\0\0\01\xff\0\0' | keyctl padd dns_resolver desc @p

which will give "add_key: Invalid argument" without this fix.

Fixes: 1997b3cb4217 ("keys, dns: Fix missing size check of V1 server-list header")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Link: https://lore.kernel.org/r/ZZ4fyY4r3rqgZL+4@xpf.sh.intel.com/
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dns_resolver/dns_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index f18ca02aa95a..c42ddd85ff1f 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -104,7 +104,7 @@ dns_resolver_preparse(struct key_preparsed_payload *prep)
 		const struct dns_server_list_v1_header *v1;
 
 		/* It may be a server list. */
-		if (datalen <= sizeof(*v1))
+		if (datalen < sizeof(*v1))
 			return -EINVAL;
 
 		v1 = (const struct dns_server_list_v1_header *)data;
-- 
2.43.0



