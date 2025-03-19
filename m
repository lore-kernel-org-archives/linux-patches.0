Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22401DA112;
	Wed, 19 Mar 2025 14:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395095; cv=none; b=KfZ8VhN6KKRAFYxdAZLqmgufsJh6jlVvHjTM+li+eOYTOIS/1sWzR2RDa8+CjferxjYFiPrFq2vv/HB/V8kZ216p10SFS966rxLtKEklGP+1Hj23X4nhPlQRywzTH1Bl4PEMYyK+uvImdxyywKI9hz6S4SPFGp76TbxJ+1d9Yos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395095; c=relaxed/simple;
	bh=1sW+S4q6FEwEzYbX69Yu16eKEsoM7Enrm9ttBcEgBVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KjWHiLWvl3dYv6GcLirTYFMVrMTofY08HXpw8aOElEH4dR9TiYmRqTnpCEj3uBPdKnaVplnI3x58C+JhQJ0+h+wN2ZwUS62e2XIeT8pGzOLonubsUc5jTPc2ulfApq/8B3iMzy+u3gQ0qw/wapKQC7v8h+yhagwRXs5eJKzRr9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSgbnBY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSgbnBY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75C3C4CEE4;
	Wed, 19 Mar 2025 14:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395094;
	bh=1sW+S4q6FEwEzYbX69Yu16eKEsoM7Enrm9ttBcEgBVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSgbnBY+U+lJ9gACD3H5KzHHhc6RdS1W4rMZhfPhqdfCRZDHhsx1RQQTQFrmeBEim
	 1o74wtYGpemPXmiK2gs8YwDinC3QljqJdJCfXf1pI7MBQTRV99TSPpV/WOy4W14dvw
	 +FyYcuHt2s1sC6cdU6o4/9uLmHkbsF4TSC2/NS4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 144/231] cifs: Validate content of WSL reparse point buffers
Date: Wed, 19 Mar 2025 07:30:37 -0700
Message-ID: <20250319143030.395423316@linuxfoundation.org>
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

[ Upstream commit 1f48660667efb97c3cf70485c7e1977af718b48b ]

WSL socket, fifo, char and block devices have empty reparse buffer.
Validate the length of the reparse buffer.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: cad3fc0a4c8c ("cifs: Throw -EOPNOTSUPP error on unsupported reparse point type from parse_reparse_point()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index e56a8df23fec9..bd8808e50d127 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -651,6 +651,11 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 	case IO_REPARSE_TAG_LX_FIFO:
 	case IO_REPARSE_TAG_LX_CHR:
 	case IO_REPARSE_TAG_LX_BLK:
+		if (le16_to_cpu(buf->ReparseDataLength) != 0) {
+			cifs_dbg(VFS, "srv returned malformed buffer for reparse point: 0x%08x\n",
+				 le32_to_cpu(buf->ReparseTag));
+			return -EIO;
+		}
 		break;
 	default:
 		cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: 0x%08x\n",
-- 
2.39.5



