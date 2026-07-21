Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48A245DF4D;
	Tue, 21 Jul 2026 21:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667814; cv=none; b=QDvLQSkrxp97nflo8Vl/UvQ0OW28EG8RZlFfr7im9Sc9EbeEXDUsGBh4meS6b6hEwzD2swcUPmVM3ljH61o92Bo4qc20Lmu9+6s9sLEvnJp9qSY3RDrybtdzwurXw3h3MQe2tOaYK1HFqPPcSv5fm760FbP5Jq+nhgAs+2sOLzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667814; c=relaxed/simple;
	bh=YoReRKPJ9HH6wOyA3B9jImpA4yq0FaB0rUcIv3SdX5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=My47K17b0FdS5c3hQ/U8ypM31ZZuHbQXwVYKf1t1F9JAO3HAchpdbJiChSmsPE/WlHs66i4zjQTyZUVhrpMd2jf1kMcM3D3Y3hMISU5KD/JaTQS4quz6G8K6ZysS7ORDpTEuhtxnYacTx+GY/zuJMFW2jqA/pw6hEX0MFIh8lXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7CCc2S5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7CCc2S5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6C51F00A3D;
	Tue, 21 Jul 2026 21:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667811;
	bh=+w4nSIcszi4ERprPmmrWf6a8jMa9lAcL7HvfE54w84I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n7CCc2S5HuqwL1nmQBPyTltL0SAzwEDbtlkONteBwzattsCEFZscQvg10+U4y3A2a
	 U1X5KWdym2zCkZIFrCDKH6W8j9GKYpXdPKBtw4u5/eUJuk6gh7lAdK5h44o8+aeudq
	 EFet1j2DXDkT1fXMJLIemD5bSra3fWEpvoSbTuAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1195/1266] smb: client: Improve unlocking of a mutex in cifs_get_swn_reg()
Date: Tue, 21 Jul 2026 17:27:12 +0200
Message-ID: <20260721152508.536662415@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit e2080b70c5851a132547bec3bd7dde847e649678 ]

Use two additional labels so that another bit of common code can be better
reused at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: ec457f9afe5a ("smb: client: resolve SWN tcon from live registrations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifs_swn.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -313,17 +313,15 @@ static struct cifs_swn_reg *cifs_get_swn
 	reg = cifs_find_swn_reg(tcon);
 	if (!IS_ERR(reg)) {
 		kref_get(&reg->ref_count);
-		mutex_unlock(&cifs_swnreg_idr_mutex);
-		return reg;
+		goto unlock;
 	} else if (PTR_ERR(reg) != -EEXIST) {
-		mutex_unlock(&cifs_swnreg_idr_mutex);
-		return reg;
+		goto unlock;
 	}
 
 	reg = kmalloc(sizeof(struct cifs_swn_reg), GFP_ATOMIC);
 	if (reg == NULL) {
-		mutex_unlock(&cifs_swnreg_idr_mutex);
-		return ERR_PTR(-ENOMEM);
+		ret = -ENOMEM;
+		goto fail_unlock;
 	}
 
 	kref_init(&reg->ref_count);
@@ -354,7 +352,7 @@ static struct cifs_swn_reg *cifs_get_swn
 	reg->ip_notify = (tcon->capabilities & SMB2_SHARE_CAP_SCALEOUT);
 
 	reg->tcon = tcon;
-
+unlock:
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 
 	return reg;
@@ -365,6 +363,7 @@ fail_idr:
 	idr_remove(&cifs_swnreg_idr, reg->id);
 fail:
 	kfree(reg);
+fail_unlock:
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 	return ERR_PTR(ret);
 }


