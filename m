Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565C81DA112;
	Wed, 19 Mar 2025 14:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395096; cv=none; b=npMT94gyP7NtXqSwOH3EVsr4xySpDYJq1kqiRxluYlOymhxmURvKua8/iqldpO3oN1IA71UtjMq3tTxg2UXoJUKRGBfSB4CR3ogMO8YHldyHVXiLwmzg0DSyIROcEKi+hZUp5viv6MoDJbCNEu2t0wBeGKrtWRK6PW/AfnNDzzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395096; c=relaxed/simple;
	bh=z0DRr/8vbUTS9MP//K7C/lJfgGqPfTXyygCdrBPnAzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uuf/yJgXLOkcGAcdfJUhspLym7MS3vA8/51niwqVRXLrDvzt0hVuBLp6PXWgpi36HmVtxlfrZjKjoZLli2rd3xaurZ3Q3luyTAUhN3EqiZTbUItdQ8AYJMzY60QR3n0GAhCG54J4yvlxPA4cATI+3mWeqrb6SU4bKYfioMUqzwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vz/A8Pkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vz/A8Pkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2435AC4CEE4;
	Wed, 19 Mar 2025 14:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395096;
	bh=z0DRr/8vbUTS9MP//K7C/lJfgGqPfTXyygCdrBPnAzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vz/A8Pkqass8/FNFfFhFso8nLaIRSEw6yYe9deWDGydoSnqP/sWNQCmHKRIZxmHMl
	 bBcn59pmArB0e2NgCPvNzh0srSCkzefMOHg5Vu3xHmxziqfb9o6q6ECGuPmQqJhRol
	 luyyeuwRiprWskDsJinvxx2LTiU0k6pcahLX8SK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 145/231] cifs: Throw -EOPNOTSUPP error on unsupported reparse point type from parse_reparse_point()
Date: Wed, 19 Mar 2025 07:30:38 -0700
Message-ID: <20250319143030.422348628@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

[ Upstream commit cad3fc0a4c8cef07b07ceddc137f582267577250 ]

This would help to track and detect by caller if the reparse point type was
processed or not.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index bd8808e50d127..bb246ef0458fb 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -656,13 +656,12 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 				 le32_to_cpu(buf->ReparseTag));
 			return -EIO;
 		}
-		break;
+		return 0;
 	default:
 		cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: 0x%08x\n",
 			      le32_to_cpu(buf->ReparseTag));
-		break;
+		return -EOPNOTSUPP;
 	}
-	return 0;
 }
 
 int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
-- 
2.39.5



