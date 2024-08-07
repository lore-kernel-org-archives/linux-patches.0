Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D57782499;
	Wed,  7 Aug 2024 15:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043081; cv=none; b=I7lEjHEM9BNBovxbgEBpK2j3Ty0aMNPx2DTCeUGb8Qig3EpItui49+y7l3o6uoDSLzg92KtcyngNIWiIF4IyrtXr+CNLZ6aqP5y8wFevyrvEkTNyq82+xXm4O0p7JA47/E/8qAELZoRL/8ODSQufTEE3r9DyYWkxcwIz6R1yCAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043081; c=relaxed/simple;
	bh=xFHs0j2LgHD7Mf3akn6RGwS/ijo8haA/xD8MHS6bl2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/BX64RHPjO+XSMJKQHOWaeVb1X5/4IqxK3KTMU7Tye+pJ4nw61Uf0s4VS9r9BN3Uw8nwo+IQOQ0kTEMEsHDHjQMsCLoYYc7ZxCjRVijBDR6nCYJYTRKRNHS4aU3ayT/jmVdCeYuavfqVjVix+P5+gdinaMZmBxtSQZlhIxFSrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwnjtYN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwnjtYN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4906C4AF0D;
	Wed,  7 Aug 2024 15:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043081;
	bh=xFHs0j2LgHD7Mf3akn6RGwS/ijo8haA/xD8MHS6bl2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwnjtYN5a6DdtwAm1AxGh9mGL/NDYR5bvZEWsjw974E8moln1E44NcM+TFs2/aRo3
	 mMOjvhvcCx5g746F25M7OrbJM1g7h1jNkuFye/MiMID8C3mI+V/hg0dbETI++FpJcL
	 dx0wnCdHB+Dmeo34acm8Qba1ZJ3iISr0grBF6BJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.10 083/123] protect the fetch of ->fd[fd] in do_dup2() from mispredictions
Date: Wed,  7 Aug 2024 17:00:02 +0200
Message-ID: <20240807150023.499778021@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1248,6 +1248,7 @@ __releases(&files->file_lock)
 	 * tables and this condition does not arise without those.
 	 */
 	fdt = files_fdtable(files);
+	fd = array_index_nospec(fd, fdt->max_fds);
 	tofree = fdt->fd[fd];
 	if (!tofree && fd_is_open(fd, fdt))
 		goto Ebusy;


