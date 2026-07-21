Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FD2403AE9;
	Tue, 21 Jul 2026 22:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674259; cv=none; b=aEx5f6UKkO+N600ODAuCpUwSFcuT23KSqHcQBS2/vGTt61HA+VG15conGX+EzdXGORXdWZZiEVWYEpQY2MuMl57Dgx9EMTs+GjSstBY/TgcbU9hxeIaMS8XtM+WuCLrNMxshXwZEjhwyiXXz1fTbi6LQXabqiCEUNAtOhrS6pj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674259; c=relaxed/simple;
	bh=BCG+QTSWdoGJ8gnhfpisSG6H4dGbNfate+ucgKCBzug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3wCpgxXvM6zHdzARcpC3n0kuiuouIJqrvEyxmAIxJcibwpPcewsBOMBed+1Kt3RqkpeY6TP4n7XEiUVdmJCwEuPHRrYcLIznWHQpJFkUnNnyIMToDnJiKOSdeb9FX05S/A+NZPyqiWfTv3rhbkg1iq8wO9XZKjlXDC415Smov4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfD1hSsi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfD1hSsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7580E1F000E9;
	Tue, 21 Jul 2026 22:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674258;
	bh=FnsCGvS5T8xH6q8hw9F38SbmiXTJKq0elfQf5kP/yk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vfD1hSsiIlD1x+E101clYtRBzpdQljuBweW1/5gUIbGkE1GXXXrEcIVWOLniex6Bi
	 +/HXBParQUh7FLxxQPvUAR7SZiilA9V9+yuJKlzJhMUDpjoH40xZBcPyYAalrVSo1F
	 E3U0Iklbla97lW5LLn25gi+sgK+91/GGazUwFG5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 473/699] lockd: Plug nlm_file leak when nlm_do_fopen() fails
Date: Tue, 21 Jul 2026 17:23:52 +0200
Message-ID: <20260721152406.368302392@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit f16a1513452edb532fec81e591c64c320866719c upstream.

A client can repeatedly drive nlm_do_fopen() failures by presenting
file handles that the underlying export rejects. After kzalloc_obj()
succeeds in nlm_lookup_file(), the freshly allocated nlm_file is not
yet inserted into nlm_files[]. The nlm_do_fopen() failure path jumps
to out_unlock, which releases nlm_file_mutex and returns without
freeing the allocation, so each failure leaks one nlm_file.

Route the failure through out_free so kfree() runs before the
function returns.

Fixes: 7f024fcd5c97 ("Keep read and write fds with each nlm_file")
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svcsubs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -139,7 +139,7 @@ nlm_lookup_file(struct svc_rqst *rqstp,
 
 	nfserr = nlm_do_fopen(rqstp, file, mode);
 	if (nfserr)
-		goto out_unlock;
+		goto out_free;
 
 	hlist_add_head(&file->f_list, &nlm_files[hash]);
 


