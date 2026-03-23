Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E688435957;
	Mon, 23 Mar 2026 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278408; cv=none; b=M5pwkLpBXRpdi6WCecLYB5XLeLmqotV8+oMsbR+RiHqfD3ctS5BjZJ0kpGYsgiOGsHV4IhbzjkxIXRkH8tj+t6GZEfNjg4e3y43ofnj6wVNnaG/t+k61A6My0r4MU6OCb3DHao2LU08iwWP8cpIfnWW30E/VNyi7Xnxk7Adetsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278408; c=relaxed/simple;
	bh=kDNOPNpA4H+sIIDf/alN/YbrlefZuymJQkWWImVIsNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWAdoCtARugu1TE7pRxPuYYX/oFbgZQxN04c7LKGA+cGRyxZO33m1slYmVsEo/JjiEM9pA594XCOKTQtt61A5cyU1tQj9uD6kIcYPqD3J9wRu28EsZjOGwvWG9I8InEGFXLgLUR8L7rTgrhVUk9biYGWtJ8FMuHxCG0sgnWCQoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLegFORZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLegFORZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE5FC4CEF7;
	Mon, 23 Mar 2026 15:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278407;
	bh=kDNOPNpA4H+sIIDf/alN/YbrlefZuymJQkWWImVIsNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLegFORZMnJbtuar4mrLyKOuDqmGTSPaPsR5Fg+0kqiTMz5iA48gv4o5IYUFJrj6l
	 Kv0mQ4ftUA+MAkqJuVqb3m6+upsiN8/+XQBg+5B8UO0RQ6tcG4/S+ZMxKvrCKPJ5Un
	 oXuZRCrvZxrf3A8eIM8IRBzhv9KL2mlBWHE5F41c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Subject: [PATCH 6.6 298/567] libceph: admit message frames only in CEPH_CON_S_OPEN state
Date: Mon, 23 Mar 2026 14:43:38 +0100
Message-ID: <20260323134541.191368265@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Ilya Dryomov <idryomov@gmail.com>

commit a5a373705081d7cc6363e16990e2361b0b362314 upstream.

Similar checks are performed for all control frames, but an early check
for message frames was missing.  process_message() is already set up to
terminate the loop in case the state changes while con->ops->dispatch()
handler is being executed.

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger_v2.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -2940,6 +2940,11 @@ static int __handle_control(struct ceph_
 	if (con->v2.in_desc.fd_tag != FRAME_TAG_MESSAGE)
 		return process_control(con, p, end);
 
+	if (con->state != CEPH_CON_S_OPEN) {
+		con->error_msg = "protocol error, unexpected message";
+		return -EINVAL;
+	}
+
 	ret = process_message_header(con, p, end);
 	if (ret < 0)
 		return ret;


