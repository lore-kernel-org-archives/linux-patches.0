Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB62D2110E;
	Tue, 27 May 2025 17:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366449; cv=none; b=EcKcoQKpU4pv1Cu9lTPljtbEwikyFbvrSA+QnWnhUQJZ9OYlN13S5HN/sfUhr70Fg6GRnDA0ZJtveJSG0iG0aGfDzHx2JFgEkctWlwTBY3wHslyHmVJ52xT+c6ajL5JaTek1W/0T1OfN016l16p2dM9fo3KIUAmSNUcRG/FHuLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366449; c=relaxed/simple;
	bh=eJDPmkyweFinnb5QRtkHQbFpZiqhq7xWEXVQTz3e68k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5cdoiIlUPc2zW/uHHwLXomHasxw65+vqzoLnLPalCH28oiHyhj6hT+JRTVSd+TUi+4vDjOCCN6S2EygCudoD4aRqD0bxvn8fLWpC02kGpBnTwc9yLeYcGjHl9E6dtt1d5fZuD2djReafKDQBFcMC8TJEEt5dNxSIx2dIhDqHWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5AY5K3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5AY5K3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF7FC4CEE9;
	Tue, 27 May 2025 17:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366449;
	bh=eJDPmkyweFinnb5QRtkHQbFpZiqhq7xWEXVQTz3e68k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5AY5K3TR012BZje2AbPqfHy0tN0CNYYaF5xnZ+FoWSrOquM1CMm+E6LTNK+MpjQG
	 W1KsDW+Rm/lE+NqGOew3iFRCpAsQtm61rOyVgGYFHGESQScTSf0YgUntS87JDBRyX4
	 1SxsYLtuIRIGgMUocSa+e5YMWmCF0Dyr80hlrlio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 071/783] cifs: add validation check for the fields in smb_aces
Date: Tue, 27 May 2025 18:17:48 +0200
Message-ID: <20250527162516.020467943@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit eeb827f2922eb07ffbf7d53569cc95b38272646f ]

cifs.ko is missing validation check when accessing smb_aces.
This patch add validation check for the fields in smb_aces.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsacl.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 64bd68f750f84..f9d577f2d59bb 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -811,7 +811,23 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 			return;
 
 		for (i = 0; i < num_aces; ++i) {
+			if (end_of_acl - acl_base < acl_size)
+				break;
+
 			ppace[i] = (struct smb_ace *) (acl_base + acl_size);
+			acl_base = (char *)ppace[i];
+			acl_size = offsetof(struct smb_ace, sid) +
+				offsetof(struct smb_sid, sub_auth);
+
+			if (end_of_acl - acl_base < acl_size ||
+			    ppace[i]->sid.num_subauth == 0 ||
+			    ppace[i]->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
+			    (end_of_acl - acl_base <
+			     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth) ||
+			    (le16_to_cpu(ppace[i]->size) <
+			     acl_size + sizeof(__le32) * ppace[i]->sid.num_subauth))
+				break;
+
 #ifdef CONFIG_CIFS_DEBUG2
 			dump_ace(ppace[i], end_of_acl);
 #endif
@@ -855,7 +871,6 @@ static void parse_dacl(struct smb_acl *pdacl, char *end_of_acl,
 				(void *)ppace[i],
 				sizeof(struct smb_ace)); */
 
-			acl_base = (char *)ppace[i];
 			acl_size = le16_to_cpu(ppace[i]->size);
 		}
 
-- 
2.39.5



