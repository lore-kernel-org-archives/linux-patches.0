Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23993471268;
	Tue, 21 Jul 2026 20:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664521; cv=none; b=o8qWRfPjUPQNFKr9D+BjGwpMH57/SFToo20XukHn+nivvcCl7eRseNxpt8fja4olUD1OgpflK955aZjYPwOyJ41DaLSE9+BU9N97adM3fNR4ZdGJYwhKk9XRCVohJnoBY5J5Sjn5anlRvURcvKImF+hD5GIDt5dio0uBF0A0TPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664521; c=relaxed/simple;
	bh=q7cK+90wrtVOxDyEaW6nbimo1fuZPhG1fAQfu+qDRmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+P/BCGlcLXddMUD4n6at4Ai/XLSk+75233nSaWlgGgSsLbvEelvCndjoMCGtN3BVbqEZ7sgGHxFg91eC1eLh+HsUgYkU1QyQf72qobPS/D7sLf3SFMUSCU+h8yz5+PZGEa6YfL2DQVkuQAURUvXTTBJozVX5De6H0Ds2dzeb2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=waew4HYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="waew4HYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D5F1F000E9;
	Tue, 21 Jul 2026 20:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664519;
	bh=QAtkasyqAHlxw77FGCu9M4Imo+24CahFOHOYhDMnXNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=waew4HYDyfqDusQIZyJMvD/w5K57+HSJV1FoemONb+LxE2JSJK+rn66BmEl1hjlW6
	 lh+QJLGQVZTShK5WAzeaDrIXQYwY1iDEC5hneqHGLRYLkmSQBk8yuS+5Vj+jf9A3qr
	 Qqk14pekiS4G4G0cdCrzI0ee99K3+hEqc1u77kpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1230/1276] exfat: fix incorrect directory checksum after rename to shorter name
Date: Tue, 21 Jul 2026 17:27:53 +0200
Message-ID: <20260721152513.609549807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chi Zhiling <chizhiling@kylinos.cn>

[ Upstream commit ff37797badd831797b8a27830fe5046d7e23fdc3 ]

When renaming a file in-place to a shorter name, exfat_remove_entries
marks excess entries as DELETED, but es->num_entries is not updated
accordingly. As a result, exfat_update_dir_chksum iterates over the
deleted entries and computes an incorrect checksum.

This does not lead to persistent corruption because mark_inode_dirty()
is called afterward, and __exfat_write_inode later recomputes the
checksum using the correct num_entries value.

Fix by setting es->num_entries = num_entries in exfat_init_ext_entry.

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 942296784b2a ("exfat: preserve benign secondary entries during rename and move")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/dir.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -507,6 +507,7 @@ void exfat_init_ext_entry(struct exfat_e
 	unsigned short *uniname = p_uniname->name;
 	struct exfat_dentry *ep;
 
+	es->num_entries = num_entries;
 	ep = exfat_get_dentry_cached(es, ES_IDX_FILE);
 	ep->dentry.file.num_ext = (unsigned char)(num_entries - 1);
 


