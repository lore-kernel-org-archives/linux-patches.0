Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7EB3F075D;
	Mon, 17 Aug 2026 14:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975820; cv=none; b=MCA8YQpOoOh1lPsvdvi/66Zkgecfw5dU4RBfa4chdqZj4cKic3v63oQIBgpJ9/zE4in0LKzR8c51hhFfofMhr7t/cyACGSZoDT7dBhS54VxnEc/2Cz8Z7+xSIVw+wqGreN8JnOi8jdZQ+5PSMdkm/OxxjEjcRzcJzY5G4CbtZFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975820; c=relaxed/simple;
	bh=Zf2Rx1jKxlEyWOF6XvdTAZvwS33I2WJA7tOqoCE4Bmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ct29djgUA7Ci+JJ0KEfB9KzXxEu14c6qGFf4tPjRDmP3pR+R0SSqSbSbN51Nz4/luwwNuUERUFio2JyRfudJuIvcPqZqH0xd8PxnejRpurPdKbt7RcQZZytoXZ61ZENKwRDQ1Bc8PDlL4l96JAI4XWQLbO9n9dx4a6QkIDGqJ7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgM+XCqM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgM+XCqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C2F1F000E9;
	Mon, 17 Aug 2026 14:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975818;
	bh=MeoKGkyUoUrYeiQwBfnAa6SbG8JKwPUKKg6AFSx1+9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EgM+XCqMOkmI7rp0BLRCnIUCUQU1b0p0n4vKvJjqOy2TdiJgwIdMjMiITkaP2zGyH
	 GmJHaDVsEEZVtqRuL4YC4afEYIMFqk76Fw/3ydmN0MFWybgvRSrv/vO1HXrZwRODSL
	 7ZAithBxMdd4Us6zxKdWRv+sQDmwoz9wuOdYhk14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 160/389] ceph: fix pre-auth out-of-bounds read on snaptrace in ceph_handle_caps()
Date: Mon, 17 Aug 2026 15:29:59 +0200
Message-ID: <20260817132545.416116236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
@@ -4125,6 +4125,7 @@ void ceph_handle_caps(struct ceph_mds_se
 
 	snaptrace = h + 1;
 	snaptrace_len = le32_to_cpu(h->snap_trace_len);
+	ceph_decode_need(&snaptrace, end, snaptrace_len, bad);
 	p = snaptrace + snaptrace_len;
 
 	if (msg_version >= 2) {


