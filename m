Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BAE42586B;
	Sat, 12 Sep 2026 13:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220453; cv=none; b=KpMy0nD2JIqcTcQT0HVgq4pYLwWJuoX81XTvev683iX183ZLJlLLbnQmTjIWrRuomm2+BiCkOVvCQyP3IFvTgt/EeyUZbvgEDtkPJqzDCjE5Xu/bv62Rb3REOtXmskbfTrrvj3JlTyQtAjSR3W0gX0rsbBB7BRUy5gObLScR8Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220453; c=relaxed/simple;
	bh=oK1m4HEB5g/hL+HK9zWplxbDryMhq+lkuQgnTHqJQnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUmJ/kP8g3fVNG2x0NhswaOFC86zrlegJEEw+tBSesJzC+4v29lkU/VjBsF8Ce11sUlxddC2noTITTIJJ0WZy+fjCRtA8SfCDdVThz7uAQTTs06SuwtcpbWyDoSEGkQeRd2rtMbEjVIo2/TWgiQSQpGYT3ygusWt65wNTNi6wkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emV3y/YN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emV3y/YN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EDB1F000FF;
	Sat, 12 Sep 2026 13:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220451;
	bh=w0eql4V26cvUsu43ueYQCtPct6T2WO+Aio1SzGYku+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=emV3y/YN86Tvs1mvIdGghd2d8xFOeflV+WxEksXOsjjQ7JED2CQGNkCxQUWvtPXf+
	 ts+965l8XyyqSuUxZ8RYeoL91AT9Ob2nqpDPx1/86iYWG83ggwR9b+ELLxCCgi+LhO
	 prRlGrQE7/lop1rw8FVsVR9x8INmlCC9Mn9Hqn2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Changwei Ge <gechangwei@live.cn>,
	Heming Zhao <heming.zhao@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Jun Piao <piaojun@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 0180/1424] ocfs2: bound namelen in dlm_migrate_request_handler
Date: Sat, 12 Sep 2026 08:43:32 +0200
Message-ID: <20260912065611.322973929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit ea5b5609305a8437bc955a0834a530c12246d78f upstream.

Patch series "ocfs2/dlm: bound peer-controlled lengths in the o2dlm".

The o2dlm receive handlers trust u8 length and count fields from the wire
without bounding them, so a node in a DLM domain can corrupt or panic any
other node with a malformed message.  Three defects:

  - dlm_migrate_request_handler() passes migrate->namelen unchecked to
    dlm_init_mle(), which memcpy()s it into the 32-byte mname[] of an
    o2dlm_mle slab object: a heap out-of-bounds write of up to ~215
    attacker-controlled bytes.

  - dlm_mig_lockres_handler() passes mres->lockname_len unchecked to
    dlm_init_lockres(), which memcpy()s it into the 32-byte o2dlm_lockname
    slab object: a heap out-of-bounds write of up to ~223 bytes.

  - the same handler trusts mres->num_locks without checking that the
    message is large enough to hold that many entries, so
    dlm_process_recovery_data() walks mres->ml[] past the kmalloc(data_len)
    copy and trips a BUG_ON (an out-of-bounds read ending in a panic).

The other o2dlm receive handlers already reject an oversized name; the
migration and recovery handlers have omitted it since the DLM was added
(see the Fixes tags).  Patch 1 bounds namelen; patch 2 validates
lockname_len, num_locks, and the payload size.  Conforming recovery and
migration traffic is unaffected.

o2net authenticates peers only by the DLM domain key, so any node that has
joined the domain -- including a compromised or malicious member -- can
send these messages.  There is no local trigger; the attacker must already
be a member of the cluster.

Each sink was confirmed under KASAN with an out-of-tree module mirroring
it exactly -- a kmem_cache/kmalloc of the real destination size, then the
same unclamped memcpy/loop: slab-out-of-bounds Write for the two writes,
Read for the recovery walk, and a panic.  A userspace AddressSanitizer
build faults identically under -m32 and -m64.  Scrubbed logs are available
on request.

I reported this privately to security@kernel.org and the ocfs2 maintainers
on 2026-06-20; with no response after the standard embargo period I am
posting the fix publicly.  I have no embargo requirement.


This patch (of 2):

A node receiving a DLM_MIGRATE_REQUEST message trusts the peer-supplied
name length (migrate->namelen) without bounding it.  dlm_init_mle() then
copies that many bytes into the fixed DLM_LOCKID_NAME_MAX-byte mname[]
array of an o2dlm_mle slab object, so a malformed message from a cluster
peer overflows the slab object by up to ~215 bytes: a heap out-of-bounds
write of attacker-controlled data, reachable by any node in the domain.

Reject an oversized name, the way dlm_master_request_handler() and the
other o2dlm receive handlers already do; the migration handler omits the
check entirely.  Conforming messages are unaffected.

Link: https://lore.kernel.org/20260629-b4-disp-94fb6521-v1-0-6953bcc0421f@proton.me
Link: https://lore.kernel.org/20260629-b4-disp-94fb6521-v1-1-6953bcc0421f@proton.me
Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/dlm/dlmmaster.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -3112,6 +3112,12 @@ int dlm_migrate_request_handler(struct o
 
 	name = migrate->name;
 	namelen = migrate->namelen;
+	if (namelen > DLM_LOCKID_NAME_MAX) {
+		mlog(ML_ERROR, "%s: invalid name length %u in migrate request\n",
+		     dlm->name, namelen);
+		ret = -EINVAL;
+		goto leave;
+	}
 	hash = dlm_lockid_hash(name, namelen);
 
 	/* preallocate.. if this fails, abort */


