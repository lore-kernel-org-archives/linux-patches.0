Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962143EDADB;
	Tue, 17 Mar 2026 16:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766402; cv=none; b=C28bvJ6088O4HMWV41394pxCbh67KSVCIwFgBdNHbNT9ZBBGo4qpfuu97Bsmmhj3h/7TPqe4QPr7LD5lDC+6lR0q1nLhLp3Xfn0Rn8ciNnZxYo/q15mB8SINYfM2X7cK21ji8bxh510Yz2BW7cMmfHhFyGiYmXG0/LWA9+gvdTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766402; c=relaxed/simple;
	bh=tA1f66WkLPSmk/T9UzgNETdzT6D7/a5P1q+BjCeuFTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCdrJC0xYMMt7utn071I++dbd5+ObUJoRiZV/EBUD7MIFFY+rU1wdF12e8DGRfuuFUJXHtHYOYIxq4ccghxvbo2tXcr8DGxyOQ+DlaAJF9KpTpnPZi3OyzPZ5fkg48T0fPF8tGPLqisndaOZ+XGZvaSiESB4CejBNkLPxxJwH6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rk9glvDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rk9glvDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913EFC4CEF7;
	Tue, 17 Mar 2026 16:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766402;
	bh=tA1f66WkLPSmk/T9UzgNETdzT6D7/a5P1q+BjCeuFTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rk9glvDYWHAenRfVOII2OPWwxIr2egGkOOnC9LGtgiBlFD2HdXPcziv6AGSOO48yj
	 04F2VneL3MZ7IugMEmmpuAp+pwBIypwVAaVis8ZXR9L8oImdZG1ww28EMRV0riXh2D
	 fVkia98FCj4BK7hkgwHjzz8xTOGE/GqngPb+v3Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH 6.19 206/378] libceph: reject preamble if control segment is empty
Date: Tue, 17 Mar 2026 17:32:43 +0100
Message-ID: <20260317163014.589520419@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


