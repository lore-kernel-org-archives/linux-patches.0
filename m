Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54C72676E1;
	Tue,  8 Apr 2025 12:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113695; cv=none; b=HsK22uHPeFmWk6RbIYXDWCWP2ylXApZWVaNV66Z7qIoMKNFqDCW1gLXZa5y3iTM7fDIOYKj1qnuqeCDHCPSI3WTG6rmjqRxQ3JoPx3MScSoyL5yiydoC7UVtxC9tWFOJ/qByMywGfNuY+lMrfihdqh42ek494EklHsMSIAzoqDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113695; c=relaxed/simple;
	bh=4u2UzXyM0gN25r6hAJQEYw7f2dBzYTBdATXuCBY+FXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NslD5cA+V+yXXHvYxU2hnCxxh3k7o3Gs6AHchz60TQIC1fG8Km7x5xtKY0y4Ami0/CyxoLug6CF4raFM5USM9LQnxgSp5NaggRq/YWgrVowRfMnJ/M9L6Cau7qK1Pr9lgbiDPxWPibfzNcx3T8z0gNAOCoV/9Bcl2iVKzBL6XSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTQk81hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTQk81hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C98C4CEE5;
	Tue,  8 Apr 2025 12:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113695;
	bh=4u2UzXyM0gN25r6hAJQEYw7f2dBzYTBdATXuCBY+FXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sTQk81hvNceFwc3l+uukTxAICAZWJ/dMY50dljJTZ/vDePveS94dB1sQ2SQnAJRp/
	 dXMeXu827rn+3vwEviRF5pMjPEhfvKe3JwJOcQCal7b6zs4DH4LnLoyDLkfpgbeQx4
	 Px2Y98s0tRZnE5oOJtjqGFcOKoUINWKkgF8Rw0KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 255/268] ksmbd: validate zero num_subauth before sub_auth is accessed
Date: Tue,  8 Apr 2025 12:51:06 +0200
Message-ID: <20250408104835.460312089@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Norbert Szetei <norbert@doyensec.com>

commit bf21e29d78cd2c2371023953d9c82dfef82ebb36 upstream.

Access psid->sub_auth[psid->num_subauth - 1] without checking
if num_subauth is non-zero leads to an out-of-bounds read.
This patch adds a validation step to ensure num_subauth != 0
before sub_auth is accessed.

Cc: stable@vger.kernel.org
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -270,6 +270,11 @@ static int sid_to_id(struct mnt_idmap *i
 		return -EIO;
 	}
 
+	if (psid->num_subauth == 0) {
+		pr_err("%s: zero subauthorities!\n", __func__);
+		return -EIO;
+	}
+
 	if (sidtype == SIDOWNER) {
 		kuid_t uid;
 		uid_t id;


