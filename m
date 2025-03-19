Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB26C1CAA86;
	Wed, 19 Mar 2025 14:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395265; cv=none; b=kvw/End86xhjpLwbr0MsAn/U8E6y/CWa67QMGWy9kKRMHt/5gJChxh0/WXB3Pryv28YFWXFJTtDkaldea0cXaF/rigp71egnhzSA3xBxgAhdSuHxIvQSE7PlnzJYrihYZBKoTYASZwBitPBsJaIFaq53uDhV2Rz4J9Xi1I4sHi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395265; c=relaxed/simple;
	bh=eoknnpDP6BNEtg1AO+gauQZ0hZe1aFSHIkd5Ss5MQNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mMAmxk3hm8JI/kVEpidENoQShCZ3kE/+2NPDD2g9wM24kgpc6XOYDn1xLCHWb663HttooUOYc7uNLlcXD3LDueCN9nJ7LlZShrIZF58Zxm9tIEHhfIyRILTZsevJpN7+io9vMvhfWbAWCaSwtQJRLy/7SH5GnESw4j4SWbcJfgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwelYzQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwelYzQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03BBC4CEE4;
	Wed, 19 Mar 2025 14:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395265;
	bh=eoknnpDP6BNEtg1AO+gauQZ0hZe1aFSHIkd5Ss5MQNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QwelYzQdaPG63wtoHK0pqwgL2wYaW0H9brm9ATa4NbzHDXJbRO0ywHT7HutvFpOo1
	 +NDYreAOt7kKxVAhGFgpyNl8IfNwP5ozAVeOQ656BadZfxaudiOolAk9zW8eri+LeK
	 cuJr38bNnoK0HC0AR05PhbnsyhjBjtreJpmiZRZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/166] cifs: Throw -EOPNOTSUPP error on unsupported reparse point type from parse_reparse_point()
Date: Wed, 19 Mar 2025 07:32:03 -0700
Message-ID: <20250319143024.142005977@linuxfoundation.org>
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



