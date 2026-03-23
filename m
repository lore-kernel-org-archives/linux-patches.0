Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A15D3BC67C;
	Mon, 23 Mar 2026 16:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282626; cv=none; b=DhxZ4hh5XyNAG7qPLyTCvKiVQ0HNNBXJhLK7Qk90Q/cd2taYsbqBOmbJqQx04qX2BH+BH2O/2LbcnQkGfm8GH/M2F440bt6D2ksfmalKtSQfvDNncu9rgFS47yXNVnSQaTGBe4z57ezlgAYuMxyFRzoOPb9/0RO20j6v/9oSUsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282626; c=relaxed/simple;
	bh=OqvMPpUfNEt/wYk7yQHZ5r4MGIEZI3ifVklz8j5/EHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBIGk/KvytiX44s3zbUf1JhpltTArrfE9cgNTe8xCmnTsH7Dkq/xPfvsL/MRlSjO5Od7tzyXW7eZyOzgU/prHSFTR4LIBJxaIiF/zu9fQGz7DEXvt/SQ/wZ9e+2hU0PQFpvCKxks4h41ICGC64I7mdmCSoql4jzw6TWboU1iRTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Le0LcL0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Le0LcL0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6406C4CEF7;
	Mon, 23 Mar 2026 16:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282626;
	bh=OqvMPpUfNEt/wYk7yQHZ5r4MGIEZI3ifVklz8j5/EHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Le0LcL0NXvHrQ0iM6RTmohOXWpwUH35vITv/Yji8lmmukdNwwS4pF94EfqVhSpS5S
	 vA7iz2tVwmoxG3ZIaaGp24QDviwDr6aSmNBc4do4jeKz9yCUbHa4XJo1tG5X4VSTUW
	 MJgcMA1ZffOS59tdCK0TDcPzQfp8LlwdUvS1sZto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH 6.1 224/481] libceph: reject preamble if control segment is empty
Date: Mon, 23 Mar 2026 14:43:26 +0100
Message-ID: <20260323134530.607239477@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit c4c22b846eceff05b1129b8844a80310e55a7f87 upstream.

While head_onwire_len() has a branch to handle ctrl_len == 0 case,
prepare_read_control() always sets up a kvec for the CRC meaning that
a non-empty control segment is effectively assumed.  All frames that
clients deal with meet that assumption, so let's make it official and
treat the preamble with an empty control segment as malformed.

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger_v2.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -392,7 +392,7 @@ static int head_onwire_len(int ctrl_len,
 	int head_len;
 	int rem_len;
 
-	BUG_ON(ctrl_len < 0 || ctrl_len > CEPH_MSG_MAX_CONTROL_LEN);
+	BUG_ON(ctrl_len < 1 || ctrl_len > CEPH_MSG_MAX_CONTROL_LEN);
 
 	if (secure) {
 		head_len = CEPH_PREAMBLE_SECURE_LEN;
@@ -401,9 +401,7 @@ static int head_onwire_len(int ctrl_len,
 			head_len += padded_len(rem_len) + CEPH_GCM_TAG_LEN;
 		}
 	} else {
-		head_len = CEPH_PREAMBLE_PLAIN_LEN;
-		if (ctrl_len)
-			head_len += ctrl_len + CEPH_CRC_LEN;
+		head_len = CEPH_PREAMBLE_PLAIN_LEN + ctrl_len + CEPH_CRC_LEN;
 	}
 	return head_len;
 }
@@ -528,11 +526,16 @@ static int decode_preamble(void *p, stru
 		desc->fd_aligns[i] = ceph_decode_16(&p);
 	}
 
-	if (desc->fd_lens[0] < 0 ||
+	/*
+	 * This would fire for FRAME_TAG_WAIT (it has one empty
+	 * segment), but we should never get it as client.
+	 */
+	if (desc->fd_lens[0] < 1 ||
 	    desc->fd_lens[0] > CEPH_MSG_MAX_CONTROL_LEN) {
 		pr_err("bad control segment length %d\n", desc->fd_lens[0]);
 		return -EINVAL;
 	}
+
 	if (desc->fd_lens[1] < 0 ||
 	    desc->fd_lens[1] > CEPH_MSG_MAX_FRONT_LEN) {
 		pr_err("bad front segment length %d\n", desc->fd_lens[1]);
@@ -549,10 +552,6 @@ static int decode_preamble(void *p, stru
 		return -EINVAL;
 	}
 
-	/*
-	 * This would fire for FRAME_TAG_WAIT (it has one empty
-	 * segment), but we should never get it as client.
-	 */
 	if (!desc->fd_lens[desc->fd_seg_cnt - 1]) {
 		pr_err("last segment empty, segment count %d\n",
 		       desc->fd_seg_cnt);


