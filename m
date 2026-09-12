Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D5847CC7F;
	Sat, 12 Sep 2026 13:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220004; cv=none; b=uCj+XE8DWAcB0FXnUg5ZyCX5fDxq5SLMEC67jMKyXyvinrKcKuWHn5vUrhQyyF5yzqo6SE/jkC68eUEzMt15C7IXI0yle53AW3s493irffUsnmGWRP2rV+n2X4pA9GOBzLZquU25hyvBsQe2Ik9nu8N598AWnvMiT1Pm9cfo+nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220004; c=relaxed/simple;
	bh=M9N3OWPl7geMrMZxcIqxVOE8CqrccdJZuBPRMRYwPmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnaiwvkMVIasvBmgONtuTcVuLfwWu+S+SpvrRrnvhTV5tPSh64eqsrecJ4rRrtzBBCojUZZt2Hyu1mfX9FXdurV9HrOhC7TewuwhbS/D9CXfUvjTNS5A29GqjRfKq/eYxtqrpyPf19uXkkhz5RbMhW2GbKC7vq7ObVfVnr3lptw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UymwZEXL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UymwZEXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7705E1F000FF;
	Sat, 12 Sep 2026 13:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220002;
	bh=t9xUu0spmBFJQuWrWbF6ajT07XmcjZWAzp7V8+h5n1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UymwZEXLZ5KC3POWS0U7BIlUpandFeWgWVyVNRrRC32aMF6/zMNj4TKQWG/TyCX3d
	 B9NrfBO6ChCg8aiSzA4UqlAJ7nbLkdUMNwZF7yQUljai2AIUUPJw1KMtB6OezxGTVG
	 ZYSXVM8ZXsrNGe4eITp4n1X05dhFgcpN3P1jDrJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 0071/1424] libceph: validate OSD extent maps before cursor advance
Date: Sat, 12 Sep 2026 08:41:43 +0200
Message-ID: <20260912065608.897508139@linuxfoundation.org>
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
@@ -5864,6 +5865,31 @@ static inline void convert_extent_map(st
 
 #define MAX_EXTENTS 4096
 
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
@@ -5922,6 +5948,10 @@ next_op:
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


