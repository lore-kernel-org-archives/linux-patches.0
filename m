Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B0927CCDF;
	Tue,  8 Apr 2025 12:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117139; cv=none; b=WtuM3+2nb/h13Oc5fcPqe4pUNKKg/sqC/2P9+QI6yXD5OXokIwHqT8UrwqnZzbb6E+Bp5uFzVmQvIj2dgdLqGWQci4dlOr+T0fFD9cc337EmE/rDzDHTA7jd6gheKEqdUPt0VrGU4SwlJMxDIOZ7/ntHg/T2cuyWiPGBmhvVfHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117139; c=relaxed/simple;
	bh=gchogbbi9NooacrVLRF+35QLA01RvlrwR+7GudT1WKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXJV9G7qDOpDCACXVqSxdU5fsY6X1EpVmkFPR14eN4NiR2t+bRsWQ3vfxb3sa5F8BDmSPNHoXWVSemfuk3zOexz7VsD94m5z5T9NfNXJx6ycvWrMLWL2yb5LTgvuD7xwpuqGDEmy85PpjcuO8hgnm0GY+suNbe9+zUgSu/ZULdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLhsgcNt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLhsgcNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47652C4CEE5;
	Tue,  8 Apr 2025 12:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117138;
	bh=gchogbbi9NooacrVLRF+35QLA01RvlrwR+7GudT1WKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yLhsgcNtBc6T/g53L+5vaUfdocuQ/2OSe/HRMG2uFjTR2Hs8fAaFeYr1Nj7h+fUIL
	 m4fY+5yfN84pdtLh9ozSwdfVbhIjmoE7ZqNUMqCDUIEe1EMR/AZl2cYOzj2TsarS8x
	 w4r6kkSaYT5E3f9l790m7jn51UhB8m+qceWBYGvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 399/423] ksmbd: validate zero num_subauth before sub_auth is accessed
Date: Tue,  8 Apr 2025 12:52:05 +0200
Message-ID: <20250408104855.196650992@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


