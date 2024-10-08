Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396361DE8BE;
	Tue,  8 Oct 2024 13:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393242; cv=none; b=jEz72FvBIpq8LUErdFgaYFsa8hDRnz6I20Tub0Ybwguo8Y99PuSha3dzizVkFywtmyM6iQKjNzK0Jo8nzhVNsLZnhnQRyh39X54iMB6eHUKIkjgM4lEMXLtlgATmoxtSPgedC3dNBzbYCA1OxFl8cyqZ2kcEeuLnknSnDUT81pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393242; c=relaxed/simple;
	bh=Pd9D6yZz41ULcAujBI3PeLcpFjFGXDQwqgORpX5zzak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rHXEvpNXB/X2Em8NLC75FbfuQ+vgGBh5jHduwcA92OQ4eHsNEnsXlNNRB510xh5IvsCiA70FrXmBi57aew8B6dvUYzndgaJ4Z8jKbW1mpqLeELbtWHe6h9NCyreuEf4iz9H3xxfjo7WSR5jdSjAsNDBa1s3DqqVRNfaDVDQocW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBrPpi2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBrPpi2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A022BC4CEC7;
	Tue,  8 Oct 2024 13:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393242;
	bh=Pd9D6yZz41ULcAujBI3PeLcpFjFGXDQwqgORpX5zzak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBrPpi2DliPxOH3MkiRMouMUQCLadFCO2nYkyQCf5EtvZ7OWopEjzBZOQ531w6PRh
	 agpLL0tn92UazhoLfx89ydcymu1HRHBk9uhLWIg1UOIGoU6Ip72WZRVI2EtfLIcwRj
	 6NOgc3P8tFiel90a+wcIsRXsK1oeRO1DJnANV9n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/386] cifs: Do not convert delimiter when parsing NFS-style symlinks
Date: Tue,  8 Oct 2024 14:04:58 +0200
Message-ID: <20241008115631.557162317@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit d3a49f60917323228f8fdeee313260ef14f94df7 ]

NFS-style symlinks have target location always stored in NFS/UNIX form
where backslash means the real UNIX backslash and not the SMB path
separator.

So do not mangle slash and backslash content of NFS-style symlink during
readlink() syscall as it is already in the correct Linux form.

This fixes interoperability of NFS-style symlinks with backslashes created
by Linux NFS3 client throw Windows NFS server and retrieved by Linux SMB
client throw Windows SMB server, where both Windows servers exports the
same directory.

Fixes: d5ecebc4900d ("smb3: Allow query of symlinks stored as reparse points")
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index cfa03c166de8c..ad0e0de9a165d 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -335,7 +335,6 @@ static int parse_reparse_posix(struct reparse_posix_data *buf,
 							       cifs_sb->local_nls);
 		if (!data->symlink_target)
 			return -ENOMEM;
-		convert_delimiter(data->symlink_target, '/');
 		cifs_dbg(FYI, "%s: target path: %s\n",
 			 __func__, data->symlink_target);
 		break;
-- 
2.43.0



