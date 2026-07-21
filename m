Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E8B46EF6E;
	Tue, 21 Jul 2026 18:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658643; cv=none; b=Em9oWaE0ChBuaYGHEul7nDwtBVDPZ1Yz8ZtsyDp7EZMZwNOzLCkA2QICP+uP+uVkkSsh9HKwpU1S4DvBlFf0wXllm1YK7fJFxg+FBn+9oae89KSIZO+AVMf9hfqgomCBE3wZ1q/Oldd3DNqRK0yIn5XjsT/1PfI5dj+m75I9lGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658643; c=relaxed/simple;
	bh=FFiexU0ey6Gfkrq/vaND5PgiFp4TWGzp01yWqODg9L0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooO8yzRRrWM3RAhlWGx7+1nJNtPWvGAC5Lbxy2gGG8+WuKyq3taTohmb8TzMYD43AxMPcVOLgyI4+fZaG0ZZUD807fvcq90JnXbR+qayP8ZF4ZBgXlKE+l092ugZ0qlEHjOsoT84kMqkg5KeoOATrsDp9dd4jQp3sgX3xUDfdgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOyJ44fE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOyJ44fE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB60F1F000E9;
	Tue, 21 Jul 2026 18:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658641;
	bh=rcRq1SRDlXc8f06eL1IW4NGY6n1Q/VncCy/v4RfYh/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOyJ44fEfzu77oKBUb5UvMSpdm4sxrZMbpn8usWWD5ysPxW2JHh1KC1cImoQ0omFq
	 AYmBCons/0KbxNXWaipugKCGzkzM6841nrx6P7iuW+p2gp6cq6jmz5Jg2GiNjRxTlu
	 Im84bJ11JQ9CRX1hn0mfvhROOy6sla7OxVmJ0mok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.18 1221/1611] lockd: Plug nlm_file refcount leak on cached nlm_do_fopen() failure
Date: Tue, 21 Jul 2026 17:22:17 +0200
Message-ID: <20260721152542.900226585@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 70a38f87bed7f0694fd07988b47b2db1e10d8df3 upstream.

The cached-file path in nlm_lookup_file() reaches the found: label
unconditionally, even when nlm_do_fopen() fails. At that label
*result and file->f_count are updated before the error is returned.
The wrappers nlm3svc_lookup_file() and nlm4svc_lookup_file() then
bail out of their switch without copying *result back to their
caller, so the proc handler's local nlm_file pointer remains NULL
and the cleanup path skips nlm_release_file(). The f_count
increment is never released, and nlm_traverse_files() can no
longer reap the file because its refcount never returns to zero
between requests.

Short-circuit the cached path so neither *result nor f_count is
touched when nlm_do_fopen() fails on a hashed nlm_file.

Fixes: 7f024fcd5c97 ("Keep read and write fds with each nlm_file")
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svcsubs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -138,6 +138,8 @@ nlm_lookup_file(struct svc_rqst *rqstp,
 			mutex_lock(&file->f_mutex);
 			nfserr = nlm_do_fopen(rqstp, file, mode);
 			mutex_unlock(&file->f_mutex);
+			if (nfserr)
+				goto out_unlock;
 			goto found;
 		}
 	nlm_debug_print_fh("creating file for", &lock->fh);


