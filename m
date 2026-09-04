Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D1723BD1B;
	Fri,  4 Sep 2026 05:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499005; cv=none; b=TYpYCo4d48nhuGa1m192TFzBySGwBVay1ljytrYXlQL8ctI9DrgG3/NL9WUs0WohOMg4UkRQHpZJlQU1jXluQN8eDsbmjocYBvw5IeHpYu5TrXZF05b+eAhIytDzsNlJojp2HQIyx/ma7kXl8RxyiB69cuZqANuYnYAnLWAGrLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499005; c=relaxed/simple;
	bh=ghwD6aTt/r7I/j7W81q1TohIj47PxoC+bXveZoE+Czg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DyDQfBmBdi3cKbVNsM6OSxr7aLpQxDvrmxQQ7kteajPLRaYHFtg8iyeDlQyS4e/NsP8Ig/dtC78KVjMmEgM9JNt0Bdm/u9RHm2Q69xg7p1nyW53Iw9fVVyu/peS505BF9+2rjU7CKZoqtyGpqRor9ixx97RqNrvs8+DXjrfaY/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GY9BHk18; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GY9BHk18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF851F00A3D;
	Fri,  4 Sep 2026 05:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499004;
	bh=psqfKmdeHdZFbOFrDh6A1AQy/b8lc5poupSROWsEafs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GY9BHk1809UGREW8xDjB8QWCgMD0rRwfyPYmMevJHzu9JlwadJn5zUuAgP9dKVxQP
	 BP8rF7Y0z8dYD9Fcnjz0T1cMJlbHIMFZI7AEMFZwLIZ6hcPoahFE/U9K0K9qanEJdA
	 z9dCcfNEl5f5M+x4ej0N+wL+Uv7UUtAOzCylJhoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.2 221/713] ceph: bound num_export_targets array for mds info v2/v3
Date: Fri,  4 Sep 2026 06:53:09 +0200
Message-ID: <20260904045808.773056898@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit a3eb169ee297aa99670ba927c659990bd1e453f3 upstream.

ceph_mdsmap_decode() in fs/ceph/mdsmap.c reads num_export_targets from
each per-mds info record and advances the decode cursor by
num_export_targets * sizeof(u32) without first checking that many bytes
remain. The only upper-bound check that catches a runaway cursor
(*p > info_end) is gated on info_v >= 4, because info_end is left NULL
for info_v 2 and 3. When the monitor sends an MDS map whose per-mds
info version is 2 or 3 with an oversized num_export_targets, the cursor
moves past the message front buffer and the later export-targets loop
calls the unchecked ceph_decode_32() on out-of-bounds memory.

A kernel client processes CEPH_MSG_MDS_MAP from its monitor session
(net/ceph/mon_client.c dispatches it; fs/ceph/super.c routes it to
ceph_mdsc_handle_mdsmap(), which sets end to the front buffer bound and
calls ceph_mdsmap_decode()). A malicious or compromised monitor, or an
on-path attacker on an unsigned/unencrypted messenger session, can
therefore drive an out-of-bounds read in the client kernel; on x86_64
with KASAN it is reported as a slab-out-of-bounds read in
ceph_mdsmap_decode(). The decoded values land in the internal
info->export_targets[] array, so the consequence is a kernel
out-of-bounds read, not an information leak to the attacker.

Impact: a malicious or compromised Ceph monitor sending an MDS map with
a per-mds info version of 2 or 3 and an oversized num_export_targets
field triggers an out-of-bounds read in the CephFS client kernel.

Add a ceph_decode_need() for the export-targets array before advancing
the cursor, so the bound is enforced for every info_v >= 2, not only
info_v >= 4. This mirrors the count-then-need idiom already used for
m_data_pg_pools later in the same function.

Compute the export-targets byte count with size_mul() and reuse that
checked length when advancing the cursor, so the attacker-controlled
num_export_targets multiplication fails closed on overflow rather than
relying on the later kcalloc() guard.

Cc: stable@vger.kernel.org
Fixes: d463a43d69f4 ("ceph: CEPH_FEATURE_MDSENC support")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mdsmap.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -3,6 +3,7 @@
 
 #include <linux/bug.h>
 #include <linux/err.h>
+#include <linux/overflow.h>
 #include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -126,6 +127,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(s
 	u8 mdsmap_v;
 	u16 mdsmap_ev;
 	u32 target;
+	size_t export_targets_len;
 
 	m = kzalloc_obj(*m, GFP_NOFS);
 	if (!m)
@@ -224,8 +226,11 @@ struct ceph_mdsmap *ceph_mdsmap_decode(s
 		*p += namelen;
 		if (info_v >= 2) {
 			ceph_decode_32_safe(p, end, num_export_targets, bad);
+			export_targets_len = size_mul(num_export_targets,
+						      sizeof(u32));
+			ceph_decode_need(p, end, export_targets_len, bad);
 			pexport_targets = *p;
-			*p += num_export_targets * sizeof(u32);
+			*p += export_targets_len;
 		} else {
 			num_export_targets = 0;
 		}


