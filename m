Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500FE488748;
	Thu, 20 Aug 2026 17:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247299; cv=none; b=OSuuDA3kdrAV2uDwHPs7sozFs3T6iiecbUnJPe8W7ptyrwsGzJ8TILQU6vBGS+v7MKp8KkBnPQWKVEFSsfHNDEO1Ir/8ZIxpIcGQ9HjIem58PT8B3FAWadpnCRhRj6Q9Tro/2iXMJN+8cO0J4XWdWNrB/gYJQCYShYGly01ahhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247299; c=relaxed/simple;
	bh=VdBdTqPhp0VoRUeRzDaUG9MDsQBme026dMGNtnTiNGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GluLxQNlFRmlnnoUlxgMEhZ9SWzZbiL5wGzjLM9io/ElXxZ7cjK0uTmcMnLkwqC91F/0JZo8AVKRzcOscCSEPN+wU1IIiun+tpkcQJn/wAzt+X9I2M0ocYPr3DD1B4ZFpASJ79YVJAs8hNc4rhSI7dvfGNwSnVi/03iaSqVUJnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1uN1WBE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1uN1WBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A827E1F000E9;
	Thu, 20 Aug 2026 17:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247298;
	bh=RM6yqz/6r36obQfEzBnvd7GwlWwQ1kEQ7OeyddzBoR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C1uN1WBE/BAs4m7GOAh3I5y6NoMF9tSp5HdlMOM9EtStfwtONgoouDD2d77BS/qub
	 MDCdEiHQQLoYYiCrT+wdECYFXQAnsbqNqf7DV6a5q0u2Cw32t7FBveY8ZNJHcGszSd
	 a/D6SlJmfDO4QKKsmas4Dwepzu2oiskP+uNaKMUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 217/220] fs: unlock the superblock during iterate_supers_type
Date: Thu, 20 Aug 2026 16:56:47 +0200
Message-ID: <20260820145230.060379912@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 0b9d62a47149083d581d8b2abb04124b6175cb29 upstream.

This function takes super_lock in shared mode, so it should release the
same lock.

Cc: stable@vger.kernel.org # v6.16-rc1
Fixes: af7551cf13cf7f ("super: remove pointless s_root checks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Link: https://lore.kernel.org/20250611164044.GF6138@frogsfrogsfrogs
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/super.c
+++ b/fs/super.c
@@ -970,8 +970,10 @@ void iterate_supers_type(struct file_sys
 		spin_unlock(&sb_lock);
 
 		locked = super_lock_shared(sb);
-		if (locked)
+		if (locked) {
 			f(sb, arg);
+			super_unlock_shared(sb);
+		}
 
 		spin_lock(&sb_lock);
 		if (p)


