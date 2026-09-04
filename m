Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153E635AC03;
	Fri,  4 Sep 2026 06:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502158; cv=none; b=njj3FuUUQ+Fn4Vcr4sYM6riQAc7NlekzH7pSIXyD3H5pRaq2UNfIGPZhRJ/y5kkwi7aJQ54UjfZZvBLaEJ7xtLd7uiENImEjnIKJMKWYo758WCzbyjztDidxRv+N56EzdMap+7XHY8d7mtQOQQIwVLUNBcxH61Fz6kgHggmu4E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502158; c=relaxed/simple;
	bh=1DbzmNnassFpDL/vGENy3wxR+O1gg+X+f4zxLPPnZX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFH97QxIRZO9tT2fvjLbBEC6CT2GUyPi5vcvPtOXD1GNsIr3NZ/Z91P8DhSwRGceGqELr4ycHD5mDpzEILkKtwAHjseNWeZxXyru3ugHX6ghTUdorLoPHWeEKETMW7eLGv5YemVjalUhHtTno9QEk5z+gauxsgbOwbYLFzw0LBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnDXULI8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnDXULI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C89C1F00A3D;
	Fri,  4 Sep 2026 06:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502157;
	bh=mFS8oi+qZfDogDHfia36mmlcxYOaQmC8ghwYo3hkynU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wnDXULI8WNlkqRR0VQSWuLPWjcbXJZHdOtuZDEaPUuNaUZo+9OtQs3ZeNKsHzwt2v
	 xeu2kTY1dhRI+X7nhZOXi0tR8FxF8b9NFprSHVcPGq8hmBFyNEd1ITy+XXkPOJ9FzI
	 tL2v05uSBgGtiCUsyqGx2KPyshvtGpBRGYY6JVuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 109/403] libceph: validate OSD extent maps before cursor advance
Date: Fri,  4 Sep 2026 06:58:32 +0200
Message-ID: <20260904045737.307661087@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 9ec08b7499a62c6d4afa93d36ab47a43fcad57d1 upstream.

net/ceph/osd_client.c:osd_sparse_read() validates that the sparse-read
data length matches the summed extent lengths, but it does not validate
that each OSD-supplied extent is monotonic and lies inside the original
request range. A malformed authenticated OSD reply can advertise a
far-forward nonzero extent offset with a matching data length and make
the client advance the message-data cursor beyond the request buffer.
This reaches the BUG_ON(!*length) assertion in ceph_msg_data_next() from
the client receive path.

Impact: A malicious or compromised authenticated Ceph OSD peer can crash
a kernel Ceph client via a malformed sparse-read reply.

Reject sparse extent maps that overflow, move backwards, overlap, or
extend outside the original sparse-read request before advancing the
cursor.

[ idryomov: perform sparse_extent_map_valid() check a bit earlier,
  in CEPH_SPARSE_READ_DATA_LEN instead of CEPH_SPARSE_READ_DATA_PRE
  state ]

Cc: stable@vger.kernel.org
Fixes: f628d7999727 ("libceph: add sparse read support to OSD client")
Assisted-by: Codex:gpt-5-5-xhigh
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -6,6 +6,7 @@
 #include <linux/err.h>
 #include <linux/highmem.h>
 #include <linux/mm.h>
+#include <linux/overflow.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
@@ -5862,6 +5863,31 @@ static inline void convert_extent_map(st
 }
 #endif
 
+static bool sparse_extent_map_valid(struct ceph_sparse_read *sr)
+{
+	u64 req_end, pos;
+	int i;
+
+	if (check_add_overflow(sr->sr_req_off, sr->sr_req_len, &req_end))
+		return false;
+
+	pos = sr->sr_req_off;
+	for (i = 0; i < sr->sr_count; i++) {
+		struct ceph_sparse_extent *ext = &sr->sr_extent[i];
+		u64 end;
+
+		if (ext->off < pos)
+			return false;
+		if (check_add_overflow(ext->off, ext->len, &end))
+			return false;
+		if (end > req_end)
+			return false;
+		pos = end;
+	}
+
+	return true;
+}
+
 static int osd_sparse_read(struct ceph_connection *con,
 			   struct ceph_msg_data_cursor *cursor,
 			   char **pbuf)
@@ -5913,6 +5939,10 @@ next_op:
 		fallthrough;
 	case CEPH_SPARSE_READ_DATA_LEN:
 		convert_extent_map(sr);
+		if (!sparse_extent_map_valid(sr)) {
+			pr_warn_ratelimited("invalid sparse extent map\n");
+			return -EREMOTEIO;
+		}
 		ret = sizeof(sr->sr_datalen);
 		*pbuf = (char *)&sr->sr_datalen;
 		sr->sr_state = CEPH_SPARSE_READ_DATA_PRE;


