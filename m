Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C15268FC9;
	Tue,  8 Apr 2025 11:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111577; cv=none; b=pC21/jSyLdKTQi6+AY1oinKomoJZpiFDZXcoCTMAsH+2i2NKfmscQXArv99JSf3a+HBJqctD2AZmiqtQ0GGKSjjl6qYDpSEMjyJbjwjqUMObOu1p7oEC1A0poBihbEtMyFwXKaG3eUFrgAkiCqCeNMAhLMBXJ+npa7NR1uEr6Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111577; c=relaxed/simple;
	bh=5qlvx5yQzJCrYDDdUsPw/Fp5O7VXNWuEn1HGtTiPIiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKv0iYStFvcqivRPW7Fq7GQQob/lvvSILWo/Z2IpivkBLZGobq5drhClyvAOgceeHUnTOcdTLn2QuJ85AiXoHDo1eeTDsKzZBHhSq18YLqOsp8MuLMlDCNeuHaKdekOKLI0VjgRKVu7MiKrwRNI4wvQKzY16eHbtD6aR2+YfVnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kjx6Hyw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kjx6Hyw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5D3C4CEE5;
	Tue,  8 Apr 2025 11:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111577;
	bh=5qlvx5yQzJCrYDDdUsPw/Fp5O7VXNWuEn1HGtTiPIiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kjx6Hyw34pL2q/dsWimvNUoFkWzhXNWq44VxRtc16F3ocoyt949R5VNjH+/YW6jvK
	 LfaFC+BgOQOpjNXAgWfbfVm5vKUO97R8C2CLbyheF27BqtFElWXWaEpA7uDctt6r1k
	 WhVPbeYb5g5mcWf95vwoCruwztY+7fxsOh4Ffmlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 482/731] fs/ntfs3: Prevent integer overflow in hdr_first_de()
Date: Tue,  8 Apr 2025 12:46:19 +0200
Message-ID: <20250408104925.489137456@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 6bb81b94f7a9cba6bde9a905cef52a65317a8b04 ]

The "de_off" and "used" variables come from the disk so they both need to
check.  The problem is that on 32bit systems if they're both greater than
UINT_MAX - 16 then the check does work as intended because of an integer
overflow.

Fixes: 60ce8dfde035 ("fs/ntfs3: Fix wrong if in hdr_first_de")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/ntfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/ntfs.h b/fs/ntfs3/ntfs.h
index 241f2ffdd9201..1ff13b6f96132 100644
--- a/fs/ntfs3/ntfs.h
+++ b/fs/ntfs3/ntfs.h
@@ -717,7 +717,7 @@ static inline struct NTFS_DE *hdr_first_de(const struct INDEX_HDR *hdr)
 	struct NTFS_DE *e;
 	u16 esize;
 
-	if (de_off >= used || de_off + sizeof(struct NTFS_DE) > used )
+	if (de_off >= used || size_add(de_off, sizeof(struct NTFS_DE)) > used)
 		return NULL;
 
 	e = Add2Ptr(hdr, de_off);
-- 
2.39.5



