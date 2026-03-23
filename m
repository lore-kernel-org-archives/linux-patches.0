Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0074A1A680B;
	Mon, 23 Mar 2026 14:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275513; cv=none; b=MMWVZjtmRbv0UgJyp7eAgJeEyW7hqV0oP8B9lD6S+6WhaR3L7s1P6ijddCIhojouAvVO2c/kPrNiO8UySZpAwFKWDlPAk/jYp0HO3Xgx+hhXc8mD/K7buMXQqhM/5/XKcuU5+i2rDFWy9sd2dIrMocAahlIFymjcKufk3RmTMFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275513; c=relaxed/simple;
	bh=03CdyjTsc2NcpmVC5t3NzKmw185iWUPMSjIDwI+mPsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OzC7TbPI+/JOKR5nPjtd8iMcSm8ZfrMNeX5O48IDhf7StL5rsTN+5cL2E9Za1vIdOt4UwZ0i1RnPW2GPAki5MtMoub6efqDwG5E2HoQL21r/GVTOthO2U5E98FQXQZvTv0DQBLzt/ciqYgHDs9JlnZ3pUbcumV6cZ8E9yl3PHSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvJL/WHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvJL/WHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFCBC4CEF7;
	Mon, 23 Mar 2026 14:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275512;
	bh=03CdyjTsc2NcpmVC5t3NzKmw185iWUPMSjIDwI+mPsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvJL/WHOttw90HA4fnmat2Pk0M9XHdrqfrrg/tU2OV7d2CIVje52w7MJHYMLIdPzM
	 DGMZSxaOFTwm4CPKGX5OPJWVG73xS+IJxp8l/x0VNu8QuSJ3Hp5vkwfUrlankJIL6G
	 ot0werXK35RaAs6OzsrSL9W1UNkez5WbBxmyvt5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH 6.12 127/460] libceph: reject preamble if control segment is empty
Date: Mon, 23 Mar 2026 14:42:03 +0100
Message-ID: <20260323134529.735043971@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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


