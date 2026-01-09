Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60E1334C24;
	Fri,  9 Jan 2026 12:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961377; cv=none; b=Sa2EMvDE4n3VFDT4ZoT/h/MGma7UDt4URiSciGADeircHbTcWvKx1UCXcM00aeE1Dtp883nLPvl1emmjPP734aAelO5idQAcyxEhmAKaqsRi25feMp27hvSMLSTZaIFfs64Or9WHhH3g1auaNDAr0BU5Eg2eOQJVGj4axY5Bg6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961377; c=relaxed/simple;
	bh=fa1GqnHZWdcnIMNyrxh8B7vhoNn/SSKb9yK0xHdRWN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lf2a3vRX8WapOMsK5ADZzlVDtWNCfmtFqkUsm4YC9cZQtBQW08tfoshvvBCWYLlfgy6YQtrNMFBVZpml9GBv9Nh41TXlb3dsejFbzD1DoMUX+9Zh5ztstUOg/wqrxPdzzAchRCPzMFpF7f8FunL4Z8InnQspEEPimfWLRy6Kc+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHF6wJ/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHF6wJ/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323C0C4CEF1;
	Fri,  9 Jan 2026 12:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961377;
	bh=fa1GqnHZWdcnIMNyrxh8B7vhoNn/SSKb9yK0xHdRWN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHF6wJ/JdIdfYqgRhZArnOnAQaPBoEVdUBANN6S2Yl1jsU9jnZ9m5+lMiGR8Df0Jw
	 GpT0/7BkHdSNDelz33IvuBL6rsi1rPBfE6XYb/wUmK7WBt1Y7laiSUy8mzblQR5pL9
	 T022MFYRAuCBk95du+y6FLgQM6s2wOYF/iv/Bou4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Theodore Tso <tytso@mit.edu>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.6 731/737] ext4: filesystems without casefold feature cannot be mounted with siphash
Date: Fri,  9 Jan 2026 12:44:30 +0100
Message-ID: <20260109112201.603806562@linuxfoundation.org>
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

From: Lizhi Xu <lizhi.xu@windriver.com>

commit 985b67cd86392310d9e9326de941c22fc9340eec upstream.

When mounting the ext4 filesystem, if the default hash version is set to
DX_HASH_SIPHASH but the casefold feature is not set, exit the mounting.

Reported-by: syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Link: https://patch.msgid.link/20240605012335.44086-1-lizhi.xu@windriver.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[cascardo: small conflict fixup]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3632,6 +3632,14 @@ int ext4_feature_set_ok(struct super_blo
 	}
 #endif
 
+	if (EXT4_SB(sb)->s_es->s_def_hash_version == DX_HASH_SIPHASH &&
+	    !ext4_has_feature_casefold(sb)) {
+		ext4_msg(sb, KERN_ERR,
+			 "Filesystem without casefold feature cannot be "
+			 "mounted with siphash");
+		return 0;
+	}
+
 	if (readonly)
 		return 1;
 


