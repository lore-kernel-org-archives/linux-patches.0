Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EC21DFFB;
	Thu, 15 Aug 2024 14:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732643; cv=none; b=OD4BkXMzewJ4WLpP7QiDv3PeECTDpdJubWbk3FaDvmKlmSy1lG5Hw0Xf2JVxUWTMQ/wIX3GifHIELB4W7YF7tjaTgHW7U6H9NKFNUzTa5xtsr8WSmX5siKxWx8st5Wlopq+N9J332X0k+yw6+ew/NWqetlSJPLVBgB866irIRoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732643; c=relaxed/simple;
	bh=neQZ21esSGT9WWRN7v33G3UeO/I2VhgNQPHhwV093Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wk5IXn23hFSmtoOadE86Al8rHTY9hkVtc21DTSUEtEq12VtDGjbuz54A9e0rbnd2nCSHEnJBW9Bl7G4x/IDjU21HfRjMh2HPu4vI+wBnJFEcUSmUONkNNFBssigVsy9cD5fr3wLx8EbjgrxMuX2e5eUMs1HRNDEMQV+D7yO3PNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmdKgkBS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmdKgkBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3EAC32786;
	Thu, 15 Aug 2024 14:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732643;
	bh=neQZ21esSGT9WWRN7v33G3UeO/I2VhgNQPHhwV093Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmdKgkBSHu9a5ILJH5Nwtb9N8pSLk3gr5FeykWT/YgX1H4xJ68NjxhFhDU0SoyoB3
	 SCnWnMIF8dF5acfXpzhsPYVhp0gxEExJwvcS2h4gnL6W3pvBWEZlDvP44JZlrzOs5N
	 ZjyqYFzu0VpO0wuU7rOJUr75FY0j2re+1H7NJijk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.10 242/352] protect the fetch of ->fd[fd] in do_dup2() from mispredictions
Date: Thu, 15 Aug 2024 15:25:08 +0200
Message-ID: <20240815131928.791057254@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 8aa37bde1a7b645816cda8b80df4753ecf172bf1 upstream.

both callers have verified that fd is not greater than ->max_fds;
however, misprediction might end up with
        tofree = fdt->fd[fd];
being speculatively executed.  That's wrong for the same reasons
why it's wrong in close_fd()/file_close_fd_locked(); the same
solution applies - array_index_nospec(fd, fdt->max_fds) could differ
from fd only in case of speculative execution on mispredicted path.

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/file.c
+++ b/fs/file.c
@@ -1057,6 +1057,7 @@ __releases(&files->file_lock)
 	 * tables and this condition does not arise without those.
 	 */
 	fdt = files_fdtable(files);
+	fd = array_index_nospec(fd, fdt->max_fds);
 	tofree = fdt->fd[fd];
 	if (!tofree && fd_is_open(fd, fdt))
 		goto Ebusy;


