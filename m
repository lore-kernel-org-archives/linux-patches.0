Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AEF26FDBF;
	Tue, 26 Aug 2025 13:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215220; cv=none; b=tL1Nu/x09Zxwgg/+3f9DeGm4uzyYWvmwt5c88D1yDK9p7dwAkmU+VTS2jJr/iV9EiUM2O37onUo7ViQrMlDod08dQqgOjPYMFWy7X2up/PGFzuNb9+YYhCUUTtJdajqDOuP9e5A141YQ2x0OQf0uvmuU7120YXZSUSHl0q0WB9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215220; c=relaxed/simple;
	bh=cWlV/hkyHJmoPkqH9tUdbXgtaq4FYwv7VnE6SovtPnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvC5EVqVN5KQpeEyFOA3kuPkmKZ7iqE93IbularHajahJ6XxQqBseTZzKyQ05rgpd1JB6x/hm64ugYl/IxlMtJvvsSuTmQzGB4zvnIVLB4D3+zqDltf71ZCVvN2hnrD4+i61YNIvfGyGUhTszthDilqteo0GVnKFNp7U/Aa5lKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OIolr8I7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OIolr8I7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14710C19421;
	Tue, 26 Aug 2025 13:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215220;
	bh=cWlV/hkyHJmoPkqH9tUdbXgtaq4FYwv7VnE6SovtPnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OIolr8I75gMAWsoQcm5HqtcPg/H9wZZUqcnsy9Mr8xEkCVjPabCsnDhmBonI1110A
	 cT5TnNkMzyvyUEeZqm7EWYBXmK8O767bnYw0Ngb+VNNoSx5ggie0O/QDRnGpTeuMcK
	 Kyu4pM3GAj8HEbbGan+4PjTMMJJSj2LboTCV0lKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 433/482] f2fs: fix to call clear_page_private_reference in .{release,invalid}_folio
Date: Tue, 26 Aug 2025 13:11:26 +0200
Message-ID: <20250826110941.527714405@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 6779b5db90c5b925293f7ccc5ed5336c5b24ed50 ]

b763f3bedc2d ("f2fs: restructure f2fs page.private layout") missed
to call clear_page_private_reference() in .{release,invalid}_folio,
fix it, though it's not a big deal since folio_detach_private() was
called to clear all privae info and reference count in the page.

BTW, remove page_private_reference() definition as it never be used.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 77de19b6867f ("f2fs: fix to avoid out-of-boundary access in dnode page")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |    2 ++
 fs/f2fs/f2fs.h |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3729,6 +3729,7 @@ void f2fs_invalidate_folio(struct folio
 		}
 	}
 
+	clear_page_private_reference(&folio->page);
 	clear_page_private_gcing(&folio->page);
 
 	if (test_opt(sbi, COMPRESS_CACHE) &&
@@ -3754,6 +3755,7 @@ bool f2fs_release_folio(struct folio *fo
 			clear_page_private_data(&folio->page);
 	}
 
+	clear_page_private_reference(&folio->page);
 	clear_page_private_gcing(&folio->page);
 
 	folio_detach_private(folio);
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1428,7 +1428,6 @@ static inline void clear_page_private_##
 }
 
 PAGE_PRIVATE_GET_FUNC(nonpointer, NOT_POINTER);
-PAGE_PRIVATE_GET_FUNC(reference, REF_RESOURCE);
 PAGE_PRIVATE_GET_FUNC(inline, INLINE_INODE);
 PAGE_PRIVATE_GET_FUNC(gcing, ONGOING_MIGRATION);
 PAGE_PRIVATE_GET_FUNC(atomic, ATOMIC_WRITE);


