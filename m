Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F14651AFDA;
	Thu, 17 Sep 2026 17:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664976; cv=none; b=nNH09EIscHC69BF+MQ2HTNuB1B5Vr/UIqXSLDSbKkpDwWKkS6NTqgxhbDi7mbmFQY0St/bjP7A0FAw+5t86U+e3/KG8YTdUWlULjuGUJeyZ2J+Ya7uzW7u6+wucJKEhPMB7gDDgPxkzwEBJRVWzcirfWQwpdIzjJdbjuzZxSDhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664976; c=relaxed/simple;
	bh=LYe9pFIY0v9jO8oc3ZeCuL7FYXm3LlAEBZ8+tqvzrnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqMEZg/O03bnSj2bWKE7BZjhFF1AEzoTLVq6NyQZ52eKUCMKD0w6Fkpss1Ya0wydMyIzCDKAfkhgoIQUNRKamwYQWIqg+q0cqMim2aXZoIrWul6K1sl41wcCrMKxfvcTbQDHiYvIWq4WXs6owfnfUK3kgR4/rByK7cQ9xSegg0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqjdq2ye; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqjdq2ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DFB1F000FF;
	Thu, 17 Sep 2026 17:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664975;
	bh=MPkqIHNgHwtUFtUtaLA74f/0tsvBAHKunwLihtbWxno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aqjdq2ye2U379VsH73AgviFFCmKXvGb1HIMguA0p/z79u5ZECkrLOAezcUxGi0GZp
	 QzPZgxOjeulE2ywljDr5Pe3TP/fbYUZPwMJQwrQlhntjsN2Py++KTvibxqs44xNAkp
	 JlegNLwx3yjr88jQhbPxYWzMgVZrmchjp3s7MKCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0550/1250] cifs: validate idmap key payload length
Date: Thu, 17 Sep 2026 16:05:45 +0100
Message-ID: <20260917151606.842239352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 92ee03cd01b39..50cf6345975e3 100644
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



