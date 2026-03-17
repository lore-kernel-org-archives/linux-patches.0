Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4DB1A9B58;
	Tue, 17 Mar 2026 17:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767832; cv=none; b=IWWPjM1bMql70VBrZfXFWZcwxKfy1lX79yHDQ0sk5Zv7QMJ4gEC34TkdhKCUK0R7W1EaFt0+p7eDohHU4x5pvN+K5AVW1DElj/VU2dyKWRn1/FN2tYT/a72x1oA5Fmhw+z7YDVniPdDDoheSb3L3D/1J8Mte7XBALboMtmjtE4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767832; c=relaxed/simple;
	bh=OSm0JfBt+rlX/JWtRMG+Ihwxq02PL888Xzk1OzZz7AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtmRaWyEWJ9F1dEP3JmWucPZUUh38PMxZGSQoh/DBwrLQzvCXFTpuUV/6Waq6Yw7vDNUhNrYYSzhoJpRQApTIaXpfJyOAnWy2FA6ipRVkT/PImiQujB9WFRFIh2vuFmilqvep7VOh1ZZUcCQ1v5sEEenAXE4S8XAvU+hRl6cfbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2WHt7nY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2WHt7nY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F95C2BC86;
	Tue, 17 Mar 2026 17:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767832;
	bh=OSm0JfBt+rlX/JWtRMG+Ihwxq02PL888Xzk1OzZz7AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2WHt7nY3Z/co0bQKTO3srF5cOdF36RDP6X6zhse7ku6x/k/A8M3OHLBOfLdYodb0
	 0p62uo7a+mT6WHJ4LvBLYhe52WL9Bx13ON6rdwipq7aBm4PykxKdjTw/I6UctdyqoF
	 3Lx2vad6UxoEj0Ci5eHP9OzpvReRVl/o8Vhi8ieU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Subject: [PATCH 6.18 167/333] libceph: prevent potential out-of-bounds reads in process_message_header()
Date: Tue, 17 Mar 2026 17:33:16 +0100
Message-ID: <20260317163005.553634095@linuxfoundation.org>
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
@@ -2834,12 +2834,15 @@ static int process_message_header(struct
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
@@ -2870,6 +2873,10 @@ static int process_message_header(struct
 	WARN_ON(!con->in_msg);
 	WARN_ON(con->in_msg->con != con);
 	return 1;
+
+bad:
+	pr_err("failed to decode message header\n");
+	return -EINVAL;
 }
 
 static int process_message(struct ceph_connection *con)


