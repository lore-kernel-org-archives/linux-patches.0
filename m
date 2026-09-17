Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF6C207E00;
	Thu, 17 Sep 2026 15:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660262; cv=none; b=cT1qyAiKoXN/B+KqVsTu+DJ67S7V3CpoT5k/7tA5dZ6FqGdJ8XKkQAeKEthnbB6TQoXkNKzBBLCshobaPs3u66SLOQbUZ7pfx5xGZsyNrmBd+9Tu/aQ1bGsmIWweKxvYJViGz6vg0pTxqLVBngjum3FQq3CxpabzVsL0cEUjlMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660262; c=relaxed/simple;
	bh=xL16LpzBxd3n36t7XlLG+CVuXp6RzRWponnVml88kg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lO3LZyUI18DZrSGWtuTRSIjasVEdgohvu8gIRjLJjQA8u/1YC1wndXwo0MR3z2e6SjyawUyrkKlCv8yI8xeQXTkG6DCimaCFQyvq8SXzguQ+PCiV7IBwVbphnpIXZGkkJbp+J6c+bIUceJ1IDzJRsh/I8yStCdeHuYVelNCBTH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJDKx7Mt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJDKx7Mt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06EFD1F000FF;
	Thu, 17 Sep 2026 15:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660256;
	bh=Q824Bhy37ZBxsH0ejk+Se1B0B3WvKKIlXmnjSR2cKZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tJDKx7Mt00BfABJirLadvn5x0FSRj0Sgk5C/fjhsF7L4WmUuoBMf9VqXtlPEzjYsD
	 qfVKNO6ckq+5YBTR9mx0Dvqx5IrrN67PsjsimMy200tqKYkKSAw/vBks4k6lIDQSA1
	 LVvMlrYz9+a2ytflTR0VulJcu10py8hUcF/mgR+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 7.2 530/733] drm/drm_exec: fix up contended obj when num_objects is 0
Date: Thu, 17 Sep 2026 16:13:58 +0100
Message-ID: <20260917151405.396222981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

commit 159720704d9d652b64390c11fb971e15b0a78d23 upstream.

drm_exec_prepare_array() silently returns success without calling
drm_exec_lock_contended() when num_objects is zero. This breaks the
invariant upheld by drm_exec_lock_obj(), where every entry point into
the locking sequence must first attempt to lock any previously
contended object before proceeding.

Drivers that chain multiple drm_exec_prepare_array() calls per
drm_exec_until_all_locked() iteration (e.g. amdgpu's userq signal/wait
ioctls, which prepare separate read and write BO arrays) can pass an
empty array for one of the two calls. If contention is hit while
preparing the non-empty array, exec->contended is set and the loop
retries; on retry, the empty-array call preceding it is a no-op that
never clears exec->contended, so drm_exec_retry_on_contention()
immediately jumps back to the top of the loop without ever reaching
the call that would resolve the contention. This spins forever.

Fix it by having drm_exec_prepare_array() call drm_exec_lock_contended()
directly when num_objects is zero, so a pending contended object dont
loop infinitely.

Fixes: 09593216bff1 ("drm: execution context for GEM buffers v7")
CC: stable@vger.kernel.org # v6.6+
Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Link: https://lore.kernel.org/r/20260908091729.2749399-1-sunil.khatri@amd.com
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_exec.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/gpu/drm/drm_exec.c
+++ b/drivers/gpu/drm/drm_exec.c
@@ -322,6 +322,19 @@ int drm_exec_prepare_array(struct drm_ex
 {
 	int ret;
 
+	/*
+	 * Make sure to lock a contended object even when no objects are
+	 * given, otherwise drm_exec_retry_on_contention() would loop
+	 * forever on patterns like:
+	 *
+	 *	ret = drm_exec_prepare_array(exec, objs, num_objects, ...);
+	 *	drm_exec_retry_on_contention(exec);
+	 *
+	 * with num_objects == 0.
+	 */
+	if (!num_objects)
+		return drm_exec_lock_contended(exec);
+
 	for (unsigned int i = 0; i < num_objects; ++i) {
 		ret = drm_exec_prepare_obj(exec, objects[i], num_fences);
 		if (unlikely(ret))


