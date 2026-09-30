Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED21751FCCC;
	Wed, 30 Sep 2026 18:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791231; cv=none; b=m0oai74sU+BqFe0ns1XT9Bvw28/GE0NcHSivQ5SsI//NDrjfofpsMUARgeTAk5yoDk6po56INfinklruhFMz8+u5WxOEYFhRUaJs3kTqK9SyYPE5+s5aje+t/pE78TR42T9kh2muODIId/igeCk4FSz9OivYQ/9hTIsGEBZAOjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791231; c=relaxed/simple;
	bh=8Om7xozKBWd8chWhc/BGtLcnbYzOj/78R/fBO0ZjEm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZUgYF7h3dYo98u0dZ9NjhDCif8fQVqbciXmEj6DpbdnYIScCKS+j7lZO0srixmFIbs/k9dhP7i3JagMkKBH7qj4SLLiK1Z6Y862kQpo/4uZXE57qE0+FO745rKrzaBXGCHf7XcFBOXv0JHmvMiPgP2ElkosujTX5Fibg1XDMxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y9rDJgLL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y9rDJgLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D4C1F000FF;
	Wed, 30 Sep 2026 18:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791229;
	bh=0OK83l11uSW8fs/fhDgbZgbePr/nk6V94LHmuiYRVds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y9rDJgLL5OsIMnshNEbSI6EN+DLD8XyqOsOvOGymu5BPH5M/YXCUqRh3zIyyZ1/5a
	 QxDVk17SV20RRPzHqr1DaU2fp7ga1xP8hJGP3OperE/hBMblHQAk4gnbvp7orhLcC5
	 FJI2uK/fWa2ORnU2n2q+z7cNSIZCaC29sAYP9+2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 222/752] cifs: validate idmap key payload length
Date: Wed, 30 Sep 2026 17:21:32 +0200
Message-ID: <20260930152403.058661499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1b52e0c88877a..3872bef8c063a 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -64,6 +64,9 @@ cifs_idmap_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
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



