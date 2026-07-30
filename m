Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EC04519A7;
	Thu, 30 Jul 2026 15:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424899; cv=none; b=T6wCvlqrlAvJuDPUAMEDt5xH6ZHH5VlJNw8RzWWTVS+080gT4AzK65TTdjWu+ZQY9ZjSKN7zwA663TiRTKSzTxsbaDxq1SXUr07g7W7h0KTjSZ14XKWZsJZ5af0wDoEQxWPW0009P9KFa2LBGIQiMsh592E11GZOJn0iap4/1eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424899; c=relaxed/simple;
	bh=0ZvPy4VkGw/x2Xzkxi6gygA8hE8eTy5S1iA2NwcyjUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0sDILwwb8gwJUdRrfJVn8zpQIl4hglDJ6ro2pt7rvEoGhJel4SGVp0+Hbo+XqQXlnoKJb3c0EePToodVWWDnk0DY1CnOTmrGYqR5q8V+gFgGIrljn+uIi8eb/bL9FQ4OZsMemmhpwF1afeqYTVm6ZWW7s7IrqeRy5YtVUdBZGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EEyaNgL+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EEyaNgL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D681F00A3A;
	Thu, 30 Jul 2026 15:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424897;
	bh=iOS5j86nODY9T5xx6NQcUGNhshlWCOo2hAt4cEFGHPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EEyaNgL+nrqAXTCdd1cXTrxbF4X9EV/eb80xQ4j8VkOIUynU3Hmx41bwmi/UYQMQ4
	 Q+f6K4dlmqT/5E1fFBxmCLWSS6ttMU/p/lkDd44kSeazBeMwfDvwIhdzLnAurVS+SC
	 BPzLM9wHPhme7rGLeehYzKdLu32znJJRkbml42r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.18 511/675] ceph: fix pre-auth out-of-bounds read on snaptrace in ceph_handle_caps()
Date: Thu, 30 Jul 2026 16:14:01 +0200
Message-ID: <20260730141455.989487791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 4dbc71bcaf9a30abf3920a4e2cc4ed33bba78c02 upstream.

ceph_handle_caps() reads snap_trace_len from the wire-format
ceph_mds_caps header and uses it unconditionally to build a fake
end pointer (snaptrace + snaptrace_len) that is later handed to
ceph_update_snap_trace() in the CEPH_CAP_OP_IMPORT case:

    snaptrace     = h + 1;
    snaptrace_len = le32_to_cpu(h->snap_trace_len);
    p             = snaptrace + snaptrace_len;
    ...
    case CEPH_CAP_OP_IMPORT:
        if (snaptrace_len) {
            ...
            if (ceph_update_snap_trace(mdsc, snaptrace,
                                       snaptrace + snaptrace_len,
                                       false, &realm)) { ... }

ceph_update_snap_trace() then decodes a struct ceph_mds_snap_realm
from snaptrace using ceph_decode_need(&p, e, sizeof(*ri), bad)
with the attacker-supplied fake end e == snaptrace + snaptrace_len.
With snaptrace_len == 0xFFFFFFFF the bound check is trivially
satisfied, ri = p reads sizeof(struct ceph_mds_snap_realm) past
the legitimate msg->front buffer, and ri->num_snaps /
ri->num_prior_parent_snaps then drive further out-of-bounds
reads of the encoded snap arrays.

The eleven msg_version >= 2 .. msg_version >= 12 decoder blocks
above the op switch each catch this OOB through their
ceph_decode_*_safe() / ceph_decode_need() helpers, but they sit
behind a hdr.version-gated if, so a malicious or compromised
MDS that sets msg->hdr.version = 1 reaches the IMPORT path with
no version-gated decoder having validated snap_trace_len. The
shape has been present since ceph_handle_caps() was introduced.

Validate snap_trace_len against the message front buffer before
consuming it, using the canonical ceph_decode_need() / ceph_has_room()
helper.  The helper bounds the length with subtraction (n <= end - p,
guarded by end >= p) rather than pointer addition, so it is wrap-safe
for the attacker-controlled u32 length on 32-bit builds where
p + snap_trace_len could overflow the address space.  This matches the
rest of the ceph decode path (e.g. the pool_ns_len check a few lines
below), and the existing goto bad cleanup already covers this exit
path.

Cc: stable@vger.kernel.org
Fixes: a8599bd821d0 ("ceph: capability management")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4364,6 +4364,7 @@ void ceph_handle_caps(struct ceph_mds_se
 
 	snaptrace = h + 1;
 	snaptrace_len = le32_to_cpu(h->snap_trace_len);
+	ceph_decode_need(&snaptrace, end, snaptrace_len, bad);
 	p = snaptrace + snaptrace_len;
 
 	if (msg_version >= 2) {


