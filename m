Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B9A1DF750;
	Tue,  8 Oct 2024 12:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392377; cv=none; b=nVPSFrdPOI11+EdqYN9WVrW5CwssJAbMC4TKPiGN7Qydr6LcbG2KaKOLohYIDwjy1LXG36oV5ViejHSiMZJdxUfQmKhUuYunWW4hKfzFCY9gFKSWtp4WV2C/ZGr3Ihd78xmkE6iZEUSwR4JSvjoHNc904UuVfNF+JL/bcnsnKks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392377; c=relaxed/simple;
	bh=PmIWps9fZVZe9HejoL2M8PMBnUXzOzqgiRHWEU+mzu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmiGXyiNgA7O6yp45ofILSgPxFBx94b9W0X7mCB2Ky73jXa3ASmX17EQE0i8bGcBp3+n5y8ZrrZmVUvvCxlcBoueXGesE4k0odl4aNv21Q+vZvRv0gK9eF+q9Ju6qLRG7/VSW3LVZy+JLMKMLU/I3IGrt3xvnTcVU72yaRr+Vwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9UzJbzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9UzJbzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58156C4CEC7;
	Tue,  8 Oct 2024 12:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392376;
	bh=PmIWps9fZVZe9HejoL2M8PMBnUXzOzqgiRHWEU+mzu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9UzJbzTC09TsZJ5BX4EOkxy/bzZ5vC+L2AruWjLrHPWxhvGvkyvvDrmcCDIxWSN3
	 nh/QB9eIiWcO17Y54bvcgxCf3JiLyKMpQW8HUj2L2C9stk3W6SBPFH+LnDmIn7QFvc
	 dyxLi9aZiutElZmXCL/vZn7KuuCU3UHVydamHlZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.11 397/558] ext4: mark fc as ineligible using an handle in ext4_xattr_set()
Date: Tue,  8 Oct 2024 14:07:07 +0200
Message-ID: <20241008115717.903578479@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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
@@ -2559,6 +2559,8 @@ retry:
 
 		error = ext4_xattr_set_handle(handle, inode, name_index, name,
 					      value, value_len, flags);
+		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR,
+					handle);
 		error2 = ext4_journal_stop(handle);
 		if (error == -ENOSPC &&
 		    ext4_should_retry_alloc(sb, &retries))
@@ -2566,7 +2568,6 @@ retry:
 		if (error == 0)
 			error = error2;
 	}
-	ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR, NULL);
 
 	return error;
 }


