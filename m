Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B533186E58;
	Tue, 17 Mar 2026 17:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767827; cv=none; b=CeqlyVLzKpIrpt2mgceElxwMYH+/DPewv/JPgX7FuK2qMieKoK8SmZ2V0SUMkUYw+H9HGXjVA3EFX7cFzlv7i7PfW5H2ClP4pwrvam6FBvgEEb6jI1L0QsKgesfI/7e2saBLCNtkdm21HP7EsB5wLRrXtluhQA5HacSpGtoyxeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767827; c=relaxed/simple;
	bh=0XQL5BwYRCusbMAOtt0xEf3HG5r3pa3krNUz+NfS0ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgWoJ3mhrtMHpzt6v/EMx9v414UI6ntSrCd7bhi5TH3KtMKYCJjQqgQbK4zCczhxgafAiOiDZhVb14q01C2ZGqmq3ZCs1dJ+fDk466lUzK3/KehwG0HQ37pfLSiazuw8VGoPsnof8xbVTS2DQa+ARnN9FN8arIO434DtqTI3qcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g71XkUJQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g71XkUJQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1893C4CEF7;
	Tue, 17 Mar 2026 17:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767827;
	bh=0XQL5BwYRCusbMAOtt0xEf3HG5r3pa3krNUz+NfS0ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g71XkUJQ6du5IhXjPktz6I34w43KxcOszn6lfA7J7/8BE5pszZkJWu4tWC4pHmekY
	 605s0q3RJD6xHXd2ul/jvqjB2CmAIiCmH/T0KoinURxuJWg7oA1KfLCbGpzrYlynTP
	 Xwh5Vmq67U/+BqRejRYmbKwG5mXBZy4mStNL8miw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH 6.18 166/333] libceph: reject preamble if control segment is empty
Date: Tue, 17 Mar 2026 17:33:15 +0100
Message-ID: <20260317163005.516793882@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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


