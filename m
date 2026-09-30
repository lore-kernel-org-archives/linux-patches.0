Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C8C3E315F;
	Wed, 30 Sep 2026 19:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796503; cv=none; b=UFPdRJwHPWx3AK0qLWsVud8kRwBaIDD8848E13es6LUcV77FlScyyCR4WllLTwb1wMDzJqTFvZ8JtV4ng9jvbW+iSXVTusipFNkkqQ9ONhSL8YC/DpXwlQL9AvGc+0mlJVOXofnnOT3ua91TuL0D/WGdOJbd05Jvte3RJsEzX7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796503; c=relaxed/simple;
	bh=cqVwusOm29jjL1oWPzMxvRXlqZQWRzqu6pvzVfDvtEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfrkohhmKH0sTPMs7P3QFrm/TcimBbv4nTxFuhUbB2aVwphHzYfE3nI/oSQcd38+tRIiHkfka0ktOezz9qVXbU5DB9/xsVjuJ/pcstncKc3Tw0FVPNI2qjSDfoaSRGw7fTqh0ibOhiSV+YP1IFZQsONfH670U4qGGEJ5W3V9Tfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tG4ZOius; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tG4ZOius"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAD81F000FF;
	Wed, 30 Sep 2026 19:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796502;
	bh=FDuNxQ4OwLurd8yuynoDnyHDjYQ/k9/2Fgt3APkOJ+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tG4ZOiuswAWhuVLpVTTgZ5TzMdqVR/zABQp1l7oFTGMYyXd2EEmPpMq10ve0XjhD0
	 gXEsZoxHqf57kG24d+Z8loO1u0lptkXZIqsa1hLGiUzpRrkQu9SpwqPifJZNwBYkEP
	 9KT+SbCKqUNvydgYPLIalbHoCmrIVdRrJlii5HLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.6 0935/1193] smb: client: reject short Next offsets in parse_server_interfaces()
Date: Wed, 30 Sep 2026 17:26:59 +0200
Message-ID: <20260930152455.014726060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

commit 1b3221bb121079ad79a1f3c3aa360ba649832e7a upstream.

In parse_server_interfaces(), the server-supplied Next offset is
validated against bytes_left, but not against the size of the interface
structure itself.

A small, non-zero Next value can pass the bounds check but advance the
pointer by less than sizeof(*p). This causes the next iteration of the
loop to read misaligned, overlapping structure fields.

Fix this by ensuring the Next offset is at least sizeof(*p).

Fixes: 7d34ec36abb8 ("smb3: fix for slab out of bounds on mount to ksmbd")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -744,9 +744,9 @@ next_iface:
 			break;
 		}
 		/* Validate that Next doesn't point beyond the buffer */
-		if (next > bytes_left) {
-			cifs_dbg(VFS, "%s: invalid Next pointer %zu > %zd\n",
-				 __func__, next, bytes_left);
+		if (next < sizeof(*p) || next > bytes_left) {
+			cifs_dbg(VFS, "%s: invalid Next pointer %zu out of range [%zu, %zd]\n",
+				 __func__, next, sizeof(*p), bytes_left);
 			rc = -EINVAL;
 			goto out;
 		}


