Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E383BC660;
	Mon, 23 Mar 2026 16:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282628; cv=none; b=d085N+PkSnAWZBJyorNqJVwB7lDcLf7OGxrqU3AgglzbILTCLGwca542IWSa+5Zbr2v+hN/EFfUsWCwfuNfbnjw6QHl0wTl9z4K0SEOHZoeK8AycjaNlnsQBTopw3zMnDxZSAx0PxvofSNpTP5YM53thP1m6oy/csyvNU9qmNgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282628; c=relaxed/simple;
	bh=zUi80OI/YrEBhGKeWHt2/TjHfLGcQG91/BW879XrSMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUWunx9jkAn63uDgRsqgAM3UWjsAt4QsNUfmfMsBt/qsS2Y18wTH1yUmTspPy2xwzRKBkHt36H8yTcjRXaUkHhKQBEUVPplthBx2cr6ciqsbLQkri69uRjQBcAUuyUwFCHnGVJ5HA5FM8ZJ0gyT8kbBeyYvpFaAEU3abu+AIaGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qgpi5pLQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qgpi5pLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612E9C4CEF7;
	Mon, 23 Mar 2026 16:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282628;
	bh=zUi80OI/YrEBhGKeWHt2/TjHfLGcQG91/BW879XrSMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qgpi5pLQFoziMMsjV+gvDBr3Km7SJSTZkNCNmZG+zh74tgrm1EaLKP0na36/GBo4p
	 sZpiz0R27hpuKBjFDSS1Smkf/kPb1mtFgTzlw3MXcNI6Mm17Wl+fmw1TSkbn+TIdpa
	 EHhaATlQCGGScXtZyMr4LTdWs7VJgnzk2Pq8jloE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Subject: [PATCH 6.1 225/481] libceph: prevent potential out-of-bounds reads in process_message_header()
Date: Mon, 23 Mar 2026 14:43:27 +0100
Message-ID: <20260323134530.628880428@linuxfoundation.org>
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

commit 69fb5d91bba44ecf7eb80530b85fa4fb028921d5 upstream.

If the message frame is (maliciously) corrupted in a way that the
length of the control segment ends up being less than the size of the
message header or a different frame is made to look like a message
frame, out-of-bounds reads may ensue in process_message_header().

Perform an explicit bounds check before decoding the message header.

Cc: stable@vger.kernel.org
Reported-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger_v2.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -2646,12 +2646,15 @@ static int process_message_header(struct
 				  void *p, void *end)
 {
 	struct ceph_frame_desc *desc = &con->v2.in_desc;
-	struct ceph_msg_header2 *hdr2 = p;
+	struct ceph_msg_header2 *hdr2;
 	struct ceph_msg_header hdr;
 	int skip;
 	int ret;
 	u64 seq;
 
+	ceph_decode_need(&p, end, sizeof(*hdr2), bad);
+	hdr2 = p;
+
 	/* verify seq# */
 	seq = le64_to_cpu(hdr2->seq);
 	if ((s64)seq - (s64)con->in_seq < 1) {
@@ -2682,6 +2685,10 @@ static int process_message_header(struct
 	WARN_ON(!con->in_msg);
 	WARN_ON(con->in_msg->con != con);
 	return 1;
+
+bad:
+	pr_err("failed to decode message header\n");
+	return -EINVAL;
 }
 
 static int process_message(struct ceph_connection *con)


