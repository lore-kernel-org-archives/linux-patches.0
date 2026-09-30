Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E95D36A37E;
	Wed, 30 Sep 2026 17:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788873; cv=none; b=XnM1oZomKo4WmXOsMGZGakrflwpldUHj9P4IFpNYR8HyFeCHrLADF3caUq79lEeDYotA+R+rLIe63CaeoGkWZ6SzyNsw8IF2EAqzXD55mulEn/p4sGJB5TP1Ijsg71DkK74BTCQur0iCU1V51qILHdYBwXVM4pQtgIi5/Xi/Y+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788873; c=relaxed/simple;
	bh=eWmhUGTQuTnc/+9wzzCkCT2UUWH6C+6nn2leckSDuSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhmMrT1FAdO7uH6riOtEpTkxAMfELSuW7Pw/tIFgFe7PDU0p/bGSeEbf1+0S7eGQKlpxR9wpupBCp+19SPeZCyNatmUJ3seVc/bUmz433xEfnefIt17bUpI9ZlFAjw9rjyIcTvEP5nWg2MuzBEm2X3MXpRTT9nIop/gOkNgKU/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bk4z122k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bk4z122k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1C41F000FF;
	Wed, 30 Sep 2026 17:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788872;
	bh=MtZTYByLo5DOn+yUQ/UXl6KgPsFtCnnwzUHqGaI5+Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bk4z122kW2PHddRfI+2DpHVT2o+e9Gvti70d2V0BlzbO3whmdot1Q28WGLB88yO/7
	 wvy10tZeme98+sM6gfs/k3kTjXSZayQ00tkw2TP6sTuHcrgNmzqu4RPwF8eYs2iTfV
	 EajfoQq+ZMcYspjUjgxXrx65KIv4rXRG8gx3v3WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 278/877] smb: client: reject short Next offsets in parse_server_interfaces()
Date: Wed, 30 Sep 2026 17:19:49 +0200
Message-ID: <20260930152420.717888573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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


