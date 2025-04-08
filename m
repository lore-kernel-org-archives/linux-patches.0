Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17DE25FA13;
	Tue,  8 Apr 2025 11:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112444; cv=none; b=FaHkwC2HikE1eF3jPakp3UD1qQBeH5kxpklRr0d7+DmxUqBmIPUq4AEibAesE6W+eSUvPdpusmF2VBWPIW1YKWwr0VMCuaiSKpthcihLNVuxDi7zb2IPS6rKZ2wq0SSSdtAKLlafPx8Se/zAmpp6k3f5mfa/AwbP5GQlC663pK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112444; c=relaxed/simple;
	bh=N0uyRE+PeRY80DTyUISxdlp5aYrtZ/WKc1kPT9LDegg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFqdF06Zl9Ki7a4gYdt1nmEPHft0JCpLwY3dVgVOFuC3qy6auwnfJDyHmn2xn85DbusKYIWK/64Ng96kkEVyOusqxd81kmsHEMgHkXRBcKQUGxCw/X6Eqr6srpDYbQBgMmaSp4g+hxY0gQ9ojTv9A57Sbc+12x9/cwrvYdd+yjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vA0JmIst; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vA0JmIst"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307DBC4CEEC;
	Tue,  8 Apr 2025 11:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112444;
	bh=N0uyRE+PeRY80DTyUISxdlp5aYrtZ/WKc1kPT9LDegg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vA0JmIstAgom2xk+WPBz5bgDMeyA7yo05JmyelgyXr5JWA+Z39p6vyU8/0Wy+Ox/Z
	 zZGOXXeahtDU2Tod7OwXdKVKUoPaEKmglMdbm3C16iBaRW5CZ+gvrg4+xtbKoZEnIu
	 Ku9viuwL43tWPDrOkxMLEVUGw78iE5/bIAmpGneI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@mt-integration.ru>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/279] cifs: Fix integer overflow while processing actimeo mount option
Date: Tue,  8 Apr 2025 12:47:33 +0200
Message-ID: <20250408104828.231208284@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@mt-integration.ru>

[ Upstream commit 64f690ee22c99e16084e0e45181b2a1eed2fa149 ]

User-provided mount parameter actimeo of type u32 is intended to have
an upper limit, but before it is validated, the value is converted from
seconds to jiffies which can lead to an integer overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 6d20e8406f09 ("cifs: add attribute cache timeout (actimeo) tunable")
Signed-off-by: Murad Masimov <m.masimov@mt-integration.ru>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/fs_context.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 9b1c0e0dfc63b..f45a29a51700b 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -1069,7 +1069,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		ctx->acdirmax = HZ * result.uint_32;
 		break;
 	case Opt_actimeo:
-		if (HZ * result.uint_32 > CIFS_MAX_ACTIMEO) {
+		if (result.uint_32 > CIFS_MAX_ACTIMEO / HZ) {
 			cifs_errorf(fc, "timeout too large\n");
 			goto cifs_parse_mount_err;
 		}
-- 
2.39.5



