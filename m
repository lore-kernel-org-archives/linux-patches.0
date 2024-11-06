Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B731DDA15;
	Wed,  6 Nov 2024 12:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896197; cv=none; b=mzn2xMY0+BKOXhwnU1cfGg+eBze278o9E6bjTIevO44iEod6WpA8gtr0aexWL/s8BSfsoR4PbV2hEiLRxNkBddbweDnPQWsCNt67uPju4sFJFnpKVsyWSEk3/6H3Gw3GuzCINNN00x6RRasYMTsFbnYhCJULmhcE411DY3HdAFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896197; c=relaxed/simple;
	bh=7PvsKCtGy96VDMNVmB/xfHtjU58J8oLfuCcFAOISvQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8GtRzCiKdvdHl/PVWRqsolGcxZcIZ4h3eMBp0iSw31UsCvZymlUFqoFj9p5pmU37Hghobqm7lf8N71b07jbooOYkbef8a8sZqHJUZAU9HrayinQ1sTKp9JW7KjNX+qdxwOQ8I1RD9F9aGNpBotOfyUc4vHboXjCgtMZlpRfkno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FH6XMIu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FH6XMIu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2930C4CED3;
	Wed,  6 Nov 2024 12:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896197;
	bh=7PvsKCtGy96VDMNVmB/xfHtjU58J8oLfuCcFAOISvQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FH6XMIu89e2zYWng+C4EbSe3LPLn7MLKYB4vaMDtUfxjlVs75I9KWT4BpMKg13Hvq
	 BzD8mNiHeP0Zc1Z/MwmP0jMXDUUoCn1KElVCWWmTHCM+/1Kgg8OmzFw2ZqtP6kkkQu
	 YyDumRACQszTMWMl9g1gsdlHGWLRHKAaNhtMVNDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c6d94bedd910a8216d25@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 086/245] fs/ntfs3: Add rough attr alloc_size check
Date: Wed,  6 Nov 2024 13:02:19 +0100
Message-ID: <20241106120321.323349544@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit c4a8ba334262e9a5c158d618a4820e1b9c12495c ]

Reported-by: syzbot+c6d94bedd910a8216d25@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/record.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index 2a375247b3c09..427c71be0f087 100644
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -331,6 +331,9 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 
 		if (attr->nres.c_unit)
 			return NULL;
+
+		if (alloc_size > mi->sbi->volume.size)
+			return NULL;
 	}
 
 	return attr;
-- 
2.43.0



