Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342A81CAA86;
	Wed, 19 Mar 2025 14:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395265; cv=none; b=cyCbMl/ebNaPpMxd+YIJ1faUKyMkGyGip+R+YyK4uXLWHtUQJqm8f7qIH/wxL9V+5Tx6jGKElEcKxuB8+XeJfSFc6OCnzvvUs+qnoxloRZFo2XOCV8k/S6mbiQGJUZnazRR62eZe0CUAUPnZA04ZNALZ51CpQLZ2S4E0I3UBbA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395265; c=relaxed/simple;
	bh=Do8eNZ9TD8UyX6yx4+HJON5yVg3WkOvZMAfXmkjYS/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ptNcjTj0/Y/63Gd11HC0080bsIZK/KOejl+V4vopPD4cWn6Y0i6xTRJ6Ru315/c7jYj3jU2+HyWec/V0mIv2h5k2UuDehO0LrKo6hwd+tdDddzV2lyX5InR4U+HMPq2I2Zoc6Pv+M0Blfwf9dk7kWJkhUGZnB7ApyrLh1Oglg60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWm0omQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWm0omQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0098DC4CEE4;
	Wed, 19 Mar 2025 14:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395265;
	bh=Do8eNZ9TD8UyX6yx4+HJON5yVg3WkOvZMAfXmkjYS/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWm0omQkNSGijhRPe6XF6G4cTDFu3PdlcJsIPud2fROn5P60wJyA7RRcZ2GCab+l+
	 CZV5t+Es18HVZhAR1MIiUQ1Wxx/vhWLK2CuURTMZTDrR4DqGs8mD3Mj+WXVEfnWPxu
	 dexLeOfPufjYQQD1SazOIw/a1wU3s1CITo4MOqwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/166] cifs: Validate content of WSL reparse point buffers
Date: Wed, 19 Mar 2025 07:32:02 -0700
Message-ID: <20250319143024.115168188@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



