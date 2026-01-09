Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D742FBDF5;
	Fri,  9 Jan 2026 11:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959365; cv=none; b=EAS1oWYpPP+/5XrnsSLhjk3SMxaHIM6rkQs55ryFRetRJeXDsFqQMXH2MjPDXvPIyey2/NctEIMlsZv4WxXw0TapsbPlsY9SF33YusTWGt7isyWqWEdCxxwFYNRwsfrhfqUNlo7qFLwRRnSPwlc1D8RkztvbPXAA+YBKl94ORSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959365; c=relaxed/simple;
	bh=vIDuapnu3/Gmjc6Zobe2UiUkv0cl63PCKFIbXWqS+LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUz4dLSFVonuZ7uhqODrZWhWKi19o+g2lrttkzm7prvX/+ZGRnuy0CC9rjC8rSrP0/AH6g1v72w1gyxVJhuSDf+cKjsZCF+DqdtRNYTB5HyBJ5cWsK1dFOmvinfa7PAD2SzZpKoE1x0f4ZQXNoRWLS/Z1TCsiYkAJiZohuSoSnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8KddgHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8KddgHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C698C4CEF1;
	Fri,  9 Jan 2026 11:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959364;
	bh=vIDuapnu3/Gmjc6Zobe2UiUkv0cl63PCKFIbXWqS+LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8KddgHa/LevKndiqsz6WtUgSQxVBiJH98aKnokZeaVNIh4FlRixL1Z9InmePY7ko
	 FWSW+gQ8+t9oEq9O6CWKsZyoKFpcTAHeA/RvYUaR3TWkEHoYlWg0hUiSN7y5y3FZVR
	 UIh2N5MtWz9AbwFKAaF3LKUeM9NNTqrYX5JlE5c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/737] smb: fix invalid username check in smb3_fs_context_parse_param()
Date: Fri,  9 Jan 2026 12:32:45 +0100
Message-ID: <20260109112134.980240458@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
index a64c0b0dbec78..6358f2483c869 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1386,7 +1386,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			break;
 		}
 
-		if (strnlen(param->string, CIFS_MAX_USERNAME_LEN) >
+		if (strnlen(param->string, CIFS_MAX_USERNAME_LEN) ==
 		    CIFS_MAX_USERNAME_LEN) {
 			pr_warn("username too long\n");
 			goto cifs_parse_mount_err;
-- 
2.51.0



