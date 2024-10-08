Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD041DF260;
	Tue,  8 Oct 2024 13:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393759; cv=none; b=Q3PyBmkc7nVrvBJHrqduCaNKyCr3UaSwrWpxV0mn+fZxX6HIBNo/x4f63MLvbQn6FHSo0alhPKBRTxexSS4zCqkpsh1vd2SRjWN1QekukfRXoGpD7XwEAS+FxcRmL+4/s/GP/DDiLK9tJCF0QMBRIdx6jemSxpARjzqVUs6ADNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393759; c=relaxed/simple;
	bh=fxWml+ukE4heC5KKqHLxHeW7XKzdln9Qqaj/jwU7rRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8d1+zlQ6p8e8e6iXwezcyYYG+xshyp0vUiadcNWnM7u4SiVwIqB0b+kUvJI+qKTK0J13kmSszaZG2uq19uFp8psLgBqXGhBcoYNqLjWFyAnMIyXKdPcu5n5WiWcCgw+z/+S8P08X0hazqPAO1ogz17AKlx7NZaOGt5CSe1VaAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jnqPe5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jnqPe5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75AFC4CEC7;
	Tue,  8 Oct 2024 13:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393759;
	bh=fxWml+ukE4heC5KKqHLxHeW7XKzdln9Qqaj/jwU7rRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jnqPe5rACboXxnvY+mqvWD8LOZXpokoS/ay+e52wzmnxtx+GEUNOSZJI4HAp0MlA
	 DuoQBk6KRfkerI49iitIBM/VNtpLytLwGUpxSHlaSm/NDioyMY/vWGLy+bKYB7VGi2
	 yQqpDBDcQ3orU+rczVJqxuqAIb0caFC395EUnCtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 247/386] ext4: mark fc as ineligible using an handle in ext4_xattr_set()
Date: Tue,  8 Oct 2024 14:08:12 +0200
Message-ID: <20241008115639.113419966@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques (SUSE) <luis.henriques@linux.dev>

commit 04e6ce8f06d161399e5afde3df5dcfa9455b4952 upstream.

Calling ext4_fc_mark_ineligible() with a NULL handle is racy and may result
in a fast-commit being done before the filesystem is effectively marked as
ineligible.  This patch moves the call to this function so that an handle
can be used.  If a transaction fails to start, then there's not point in
trying to mark the filesystem as ineligible, and an error will eventually be
returned to user-space.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240923104909.18342-3-luis.henriques@linux.dev
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2554,6 +2554,8 @@ retry:
 
 		error = ext4_xattr_set_handle(handle, inode, name_index, name,
 					      value, value_len, flags);
+		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR,
+					handle);
 		error2 = ext4_journal_stop(handle);
 		if (error == -ENOSPC &&
 		    ext4_should_retry_alloc(sb, &retries))
@@ -2561,7 +2563,6 @@ retry:
 		if (error == 0)
 			error = error2;
 	}
-	ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR, NULL);
 
 	return error;
 }


