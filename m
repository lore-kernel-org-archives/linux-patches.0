Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702DC5328AE;
	Wed, 23 Sep 2026 14:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175192; cv=none; b=t9suezZhgADsF1gQjHA9IZZXOYmoxC6OyeIcOwBfM6rWou5Sytgifngk3JnoKT3/2OWzkOPvxP/3OCuZP4S6s4oU/64XCkn5lEJ9fxrVVYm2bk17PNGy9cX5m63JhA9NH4QDP5mN69xcIMDAs39CyQULc9pBjc4hlYQ6vsDsKRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175192; c=relaxed/simple;
	bh=ovjRV3BF+vBj9daG7pzNs9Jz9sHR9Fr090ogoEuP0ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xj96mraFb3qcW8VFDndRbBwsu+gmY2yDbzI8eGcIqVCsekIRr9sDoWV0XzsRsdVl6K5PT0xNotw1gLQSJ0lQPmmPq86sZXi+tJCjESwdy5PTuY7suFHQeEgGzIJT98DqsYzdAWJ6GCNd8MJIfbGdxR7e/gphEU36R+DheDknkrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APy2mRau; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APy2mRau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D031F000FF;
	Wed, 23 Sep 2026 14:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175191;
	bh=0lQhC9SFfvvSGjb8kldbfIMZtqzCjThuOv35cYdbq54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=APy2mRauoV9A4J5U0lSvyQW/s4VJxecJzWhkBALTMDQT1zqKeslyWlDmMPSEkRWM1
	 JJ5Tx80iRpI24f4hTgU8uzPSMMq8PLEyhgQ++YIl5JHcss1L54GJ5XpahGFvcuMqft
	 8klBssJ3jdHnvUwFsmcTw8/gnmxkI/tBnphDBbtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 348/398] smb: client: reject short Next offsets in parse_server_interfaces()
Date: Wed, 23 Sep 2026 16:07:02 +0200
Message-ID: <20260923140652.451310526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
@@ -786,9 +786,9 @@ next_iface:
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


