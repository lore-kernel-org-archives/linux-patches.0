Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C52218EBA;
	Thu, 20 Aug 2026 17:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247033; cv=none; b=K6wgFR+pwHC8RpcFdkoifPv9GRhsNvGXp1JHGplnGGabLfqzAnGqc3uf6LwBsWzfeOGR3xZ6eRvKsefHjRIXs4Jjzn8jiMiU17lj7GBC3oga9q+VWVMGt00airUgbJGx8N5eS+7dbEQqB+GwGhDy+E7fYPd3F+0FJRQ7gCuK7pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247033; c=relaxed/simple;
	bh=+Q1kfTEwOpUoiMcqRlJRzBEFjijKrjxiMPSXt/PAVSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+Mswk+Na5FtnwljpPg4kOnnX1sMlqd6UVQDalDwathNGdhVwgtlmcOJ8TRzrYmAVgRWX/ySYsFF/GSytI+20tmByPwMkZv6xHNeVuZ1A35DYv9IewPVVs3fk/Q3/XGsW6ulVKOm5FXsdzo7oh1D9fn5v5ZO/J9Nq+fc2ADWoMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=01/f4QEt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="01/f4QEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C185F1F000E9;
	Thu, 20 Aug 2026 17:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247032;
	bh=b9tVhoZHjAVro7mdObHUAm61FqEDM+bWXtzY32dQMyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=01/f4QEtm7ndupIpr65wSRVlpc4IsT1jqDk6m7sikNHVHLvdAhSHVuuelG/iU3vzF
	 pTdvDLR11QelPapHChn16mB19SJwPk9JCv3TOflkXG0H7EIZML6DJVXhT5QTWIehJ6
	 SEIWnaFkp+fZRN7jYiEtagnVJUaOaLgh4A+rh5cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 125/220] super: skip dying superblocks early
Date: Thu, 20 Aug 2026 16:55:15 +0200
Message-ID: <20260820145227.230058345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 6920e3388ba4c66b0468d43bb7a373f5fff15d35 ]

Make all iterators uniform by performing an early check whether the
superblock is dying.

Link: https://lore.kernel.org/r/20250329-work-freeze-v2-3-a47af37ecc3d@kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 749d7aa0377a ("super: fix emergency thaw deadlock on frozen block devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/super.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/super.c
+++ b/fs/super.c
@@ -925,6 +925,9 @@ void iterate_supers(void (*f)(struct sup
 	list_for_each_entry(sb, &super_blocks, s_list) {
 		bool locked;
 
+		if (super_flags(sb, SB_DYING))
+			continue;
+
 		sb->s_count++;
 		spin_unlock(&sb_lock);
 
@@ -962,6 +965,9 @@ void iterate_supers_type(struct file_sys
 	hlist_for_each_entry(sb, &type->fs_supers, s_instances) {
 		bool locked;
 
+		if (super_flags(sb, SB_DYING))
+			continue;
+
 		sb->s_count++;
 		spin_unlock(&sb_lock);
 


