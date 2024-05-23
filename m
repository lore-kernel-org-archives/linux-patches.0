Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7415C13B7AE;
	Thu, 23 May 2024 13:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470683; cv=none; b=pS55kzvjZtOD7zndn09qwyHTbtFjtFeU4mX7xV8AX0wCHpdPJk2VUJ2cNS239CA8tE64cAopGZeIBg8mAj0WOuij2j+iPPQbPsjbFOFBpACcUcodnwFn+OqbACKwutAIM78bvBDJPS4jLeH4I3mLF0QVY21YR/hUzai2nS03umE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470683; c=relaxed/simple;
	bh=mnjraK8r7rw6cPYV1xYWztEr8hOgiAA4XyAl0init8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isnFhgAjo81f6g+Gi44IhNb1AU+tMHeLVYXENpNcQnrC3l1ilZkUeE6pifb6V1ftKmGdDFzE0jXiA1Te0xnMp0sO10yNog05/XUwd7n+/w1/zyOyPkuUl1D6+oDj3uBnIlaFpx4BS1klLSHBaGnkhV7Xop740J5h+so7zxAtOA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQvvO9xx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQvvO9xx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915D2C3277B;
	Thu, 23 May 2024 13:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470683;
	bh=mnjraK8r7rw6cPYV1xYWztEr8hOgiAA4XyAl0init8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQvvO9xxb5X+hQoXv499wuKs8GYxcNttbsgk4eXYivJE36yBOAazjNyB3VrNaF+gC
	 J3X7qE46jdG8fIEP/5ViEipAW0OTpdqteJa75DX84jSoz5L8LiLGKbabbMI2AkDQYs
	 LU9VtUEsQ8vAONjbhfFbsr2H1aZj10HUpk23mZgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/102] smb3: Improve exception handling in allocate_mr_list()
Date: Thu, 23 May 2024 15:12:45 +0200
Message-ID: <20240523130343.225001457@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 96d566b6c933be96e9f5b216f04024ab522e0465 ]

The kfree() function was called in one case by
the allocate_mr_list() function during error handling
even if the passed variable contained a null pointer.
This issue was detected by using the Coccinelle software.

Thus use another label.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 94df9eec3d8d1..d74e829de51c2 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -2136,7 +2136,7 @@ static int allocate_mr_list(struct smbd_connection *info)
 	for (i = 0; i < info->responder_resources * 2; i++) {
 		smbdirect_mr = kzalloc(sizeof(*smbdirect_mr), GFP_KERNEL);
 		if (!smbdirect_mr)
-			goto out;
+			goto cleanup_entries;
 		smbdirect_mr->mr = ib_alloc_mr(info->pd, info->mr_type,
 					info->max_frmr_depth);
 		if (IS_ERR(smbdirect_mr->mr)) {
@@ -2162,7 +2162,7 @@ static int allocate_mr_list(struct smbd_connection *info)
 
 out:
 	kfree(smbdirect_mr);
-
+cleanup_entries:
 	list_for_each_entry_safe(smbdirect_mr, tmp, &info->mr_list, list) {
 		list_del(&smbdirect_mr->list);
 		ib_dereg_mr(smbdirect_mr->mr);
-- 
2.43.0



