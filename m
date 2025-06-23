Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85214221543;
	Mon, 23 Jun 2025 22:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717565; cv=none; b=M48SJMRyKrnczbicN5/rQ4gt/tfoPX1tEDqwGVi3DAnod5Oyx6Eym5sg8uHLpSkmQRLON8PrFJoGiZfi2SJ0p1m6dbZ1rX3syKvMapmF5xCeEoOvQZ5cbIFpEmDSovQiRIpVbiblIFFoe4kj8AgjUzwBf/lNJ4VibEmsr11tLM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717565; c=relaxed/simple;
	bh=Dc0ovY08yk3v/5VJWqqM3jA3tQBxoPKTxMzaRJC2II8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YT1zLJkZPe8R9PvyPG4OU3tXE8TX9uGAV/9JxhD1VwsEqscQBshKRyIljeMk+HRQ2UTr46Lxh9UP/U7+xKD5YbGSCY5KFwv0/+GPtF0EbihO1yxxiorZDdINeP2ZLDBmdW29zpcVvcmCwumJR283crDwUOuCzI3p7+Gvg9GcSL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBaSN4Og; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBaSN4Og"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA38C4CEED;
	Mon, 23 Jun 2025 22:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717565;
	bh=Dc0ovY08yk3v/5VJWqqM3jA3tQBxoPKTxMzaRJC2II8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBaSN4OgPnvKaOt/j+tSNZKRy6nnhYP10Bu0OKflXQS5UDipdUWUfiUG635VvXUKM
	 xQk5fo4WhMLYXTYN2OoL+SACZkf1jlFOY00vaoOJGZAIj7sgyUsMqCas6yTjjpByRq
	 elLfzRDoqL+n6NFpmJFKlS2WylVriX+boPnjrYK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 414/414] cifs: Remove duplicate fattr->cf_dtype assignment from wsl_to_fattr() function
Date: Mon, 23 Jun 2025 15:09:11 +0200
Message-ID: <20250623130652.306228496@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 840738eae94864993a735ab677b9795bb8f3b961 ]

Commit 8bd25b61c5a5 ("smb: client: set correct d_type for reparse DFS/DFSR
and mount point") deduplicated assignment of fattr->cf_dtype member from
all places to end of the function cifs_reparse_point_to_fattr(). The only
one missing place which was not deduplicated is wsl_to_fattr(). Fix it.

Fixes: 8bd25b61c5a5 ("smb: client: set correct d_type for reparse DFS/DFSR and mount point")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index b6556fe3dfa11..4d45c31336df1 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -738,7 +738,6 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 	if (!have_xattr_dev && (tag == IO_REPARSE_TAG_LX_CHR || tag == IO_REPARSE_TAG_LX_BLK))
 		return false;
 
-	fattr->cf_dtype = S_DT(fattr->cf_mode);
 	return true;
 }
 
-- 
2.39.5



