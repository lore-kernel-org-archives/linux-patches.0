Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701F21FBC8C;
	Mon,  2 Jun 2025 14:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873143; cv=none; b=IWgM7A6L8IOuFlDb0rCq0FJo5MTgEsyMrGDstA/n59BkqaGVE1W+XVcur7lTDyL721EQRmrYuxCmVXIKp4AYmw3eKN6KPDD7wP9nyW8+2TdMvxBAAWlyRtGP89iOwvdrZfPFWy5m5l+0AW3lOjsDviX+S+EJZ1/vi4QxPFGpULo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873143; c=relaxed/simple;
	bh=s+ZQlEgH/Dds0AGP6iliXxHqqG4clLeIfL0DQFJc14U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INju+uGNTYLcqIFdo1GAD1jsk7v5CnzQyLrgREwbA5Mp3os7VBByg99lxWUUQGN4XYElfeFU6gKjueQw0vfw40oEpgcE6AerEHWZw5iCbWc21WvfsPnvnS27JLfAHFlGy9lgT93cQKANacIiZidDZRFH2TnJciTdI8P6SINdyZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYw2IUF6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYw2IUF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F49C4CEEB;
	Mon,  2 Jun 2025 14:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873143;
	bh=s+ZQlEgH/Dds0AGP6iliXxHqqG4clLeIfL0DQFJc14U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYw2IUF63UJGVQ49m4TZ3jUHXUboUv0J1p2R4xLxJN6ln3iSwY2Ph38z3R2Kl2X7t
	 Jnc6gj8Gj7qU41e6eKdst8ng3VwJIbRFoQb6UIYvG0jppufBXYdqrl5LFTkLtAKNGm
	 XECZr1yKN744JkXIu7LggDkbWEAUBjwuWYuAKWZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/444] cifs: add validation check for the fields in smb_aces
Date: Mon,  2 Jun 2025 15:41:56 +0200
Message-ID: <20250602134343.034206909@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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
index db9076da2182a..bf32bc22ebd69 100644
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



