Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0787B30171F;
	Wed, 10 Dec 2025 07:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352044; cv=none; b=uGkf7F+gV3XxG5yETAsgTyOYy7ptzhnjhH//T2rL5/9Iiy27SOgwBjQt5rkmMjXPK99vzEt1y2feyQ0BrCUk+JynGJuMxqGyZBCJTLKx/2XgsBSMJ9QNmagTIlPxKKUkcP6mTeLTdGLUGrvYrwFia/xp1CkkSULdXBUoMT8nRhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352044; c=relaxed/simple;
	bh=7X89bPJrSd6E88POrwI9XajM94MmPjQ+9FmptPHCcZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uj7biafjY/6N2dRYPDbNpDIPmgpfpvapxZIfNbxgSWd1cCAQZv1YEfJggI5xl2EvJxOJOqpPMathmqjtTiLms1odZ/AaNBT+KKnvwRZmHtnbWSzjFtuDePrvl5LIKaW/a+anNa94nBSQBNxUXktpOjW3HV9ml5LwOLzIMlbPgo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lC/qfi/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lC/qfi/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE36C4CEF1;
	Wed, 10 Dec 2025 07:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352043;
	bh=7X89bPJrSd6E88POrwI9XajM94MmPjQ+9FmptPHCcZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lC/qfi/+dHqhlvtkyK/o/T37jio53GH9oF88khvR0LNKM/OICKdoN97l7BnjckGxN
	 a1o5MzUShwPF9UZXQr99SCc5nkSXHfgCGN7E7FC6eKnGEvXM4uxeVBJ1iw3twJs9pI
	 0umPgD7gdWDTpmkO/go+RZ2QURN1fXHpshBKDCco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 28/60] smb: fix invalid username check in smb3_fs_context_parse_param()
Date: Wed, 10 Dec 2025 16:29:58 +0900
Message-ID: <20251210072948.529868768@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yiqi Sun <sunyiqixm@gmail.com>

[ Upstream commit ed6612165b74f09db00ef0abaf9831895ab28b7f ]

Since the maximum return value of strnlen(..., CIFS_MAX_USERNAME_LEN)
is CIFS_MAX_USERNAME_LEN, length check in smb3_fs_context_parse_param()
is always FALSE and invalid.

Fix the comparison in if statement.

Signed-off-by: Yiqi Sun <sunyiqixm@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index c9cd00b96cde1..44dc5e24482e8 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1472,7 +1472,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			break;
 		}
 
-		if (strnlen(param->string, CIFS_MAX_USERNAME_LEN) >
+		if (strnlen(param->string, CIFS_MAX_USERNAME_LEN) ==
 		    CIFS_MAX_USERNAME_LEN) {
 			pr_warn("username too long\n");
 			goto cifs_parse_mount_err;
-- 
2.51.0



