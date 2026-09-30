Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F902798F8;
	Wed, 30 Sep 2026 15:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782812; cv=none; b=tyH9xiKhLn3GEblzrDqNEEp69XuaCSFDjfEcM5td/P3n/4fE4W4W0l4ENw1YSJbl58LQeT1uFtXxzgsyxK5qx2UYWKtSjoNm8YVOdYc2439mEJP3VH7//D34d+ZKqOw8VP0c2jl3nr1YmiC4OtGw0jaDwI0YQ/eMcYchxEuTYI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782812; c=relaxed/simple;
	bh=5R2xdsir/wMrN/5Ov8HkGM4zui6wDfyBX6M3qpq4Jrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcoJ6fDjSYulYb2lswAKdMhhH8kSFRv5OMiMniw6eNBiCnO8MwnLpK4lUPPMy1vJKXTH6gP2shp6EJm9XGTaTxKL/RmyPfNloQ7NxxHi6LCWbr2dLuSanMnzodo1aPAkBJcD2i3Jg0cvftouIIxYMKLFTqjyJ9URRr7j761MlD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+7CQZGo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+7CQZGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2341F0089A;
	Wed, 30 Sep 2026 15:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782809;
	bh=UwFoPj50EGGIo0AqXKTJUHYpsfnoyE8IAqtIB97TTGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e+7CQZGovd3RtgDLIYItbhdAdLSkf9AVmgYho4tpY+xGlkUxbQYu0chS1NC9K0Bqo
	 q48yQMH0nj/6jPEy67gw4xGcEyqWo0Dm8LNVnOZDECdwyIJ4KdPJkEoKquFoWqNY0E
	 2UgVK6xc4wFL9jbH8o0xukZqI5gDLo9ss8ymE0Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/595] cifs: validate idmap key payload length
Date: Wed, 30 Sep 2026 17:21:11 +0200
Message-ID: <20260930152351.569664913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 fs/cifs/cifsacl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index c8a0a2edc6500..d7f08116c4d5f 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -76,6 +76,9 @@ cifs_idmap_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
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



