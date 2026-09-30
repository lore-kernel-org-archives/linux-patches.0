Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFAB50B8A8;
	Wed, 30 Sep 2026 16:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784814; cv=none; b=uYaR09pBu7JJ2Wwo69RSLvO+lvKWVIQQhFRD5j0viuTK2EmoJ4Hav2Sz1j+mIrz1vp2JmayEeeK9owjCNSkUQBMyJhLqC/oAOkW76PhADhtxHYjgQPOOFst6C0YIe8QLo4QFP19btIHfdGg1U9+Dhh8eVBnGjm5I79yVYu3iHAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784814; c=relaxed/simple;
	bh=MEGoNEPeKDjp+/0Hh1utvjM6bTQfy0B5FVQacac9r20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJ6dbdNDEf91KPypa9dGA09xXYn4yNq06/8qdCg2cQBcCgHKu+XKtKI/Rju3NbZhn9aOIeFO0HSq7mmauNAlxqsNBUbBCcyS8IrfM+B9dRPWeuukOqZTowY88C61tpaGL24HvW3qmCfci8RmZWJGUF3ZyMqu60qZDW1wMN3Ely8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mpXLp66w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mpXLp66w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0AE1F00898;
	Wed, 30 Sep 2026 16:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784807;
	bh=H8UyTW4vCUxeHGmKOHUBD+Ki2lg04G/0nGRwFpLincU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mpXLp66wyBLFtHMCl2zmi3dw9VDClTRlzF/1DD2dZFOqZWuQYXT5DO1c+PICF8BRX
	 vWs+Cr5VKddZsofmVRekPGMnSLzYlQpPC1AoPiYBiWhvyjUt6xKIdPkk4o/bio/agv
	 bBXUUEcSiWpciZyw5IaRaleUO9TaXmSDXLk4xPz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 285/982] cifs: validate idmap key payload length
Date: Wed, 30 Sep 2026 17:17:01 +0200
Message-ID: <20260930152422.921897227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3dbc71556cb00..1bcaf2644a6f1 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
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



