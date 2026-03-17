Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F473EC2F1;
	Tue, 17 Mar 2026 16:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766275; cv=none; b=ccSDXLOA3xT9GX9wfZUflWzcITZrjenmu0AB6lxqn6V/l1mmfkrfTHu6g5gelNnuxrXMkrA9TlehAHwTlUiY4nTrYGlpAWfE0c3LZHG1nafMOp1xfKW2Fq9QjEGL6PJJ/r21ROKpt8ZbVGOSp6R9J/Wc70Rj34ku4VTj8PUlR1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766275; c=relaxed/simple;
	bh=WJ1DFXSwXcqiv+P4yfgaH0GFW4g5PnIrnVGxhkXRgfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGhztD87NfeFWfiBEteLKPiIGJwIgIqPQEB5KvgX/TYO5cSep4yS85qYIFaeSmkYL0AX4XbFNyYeV6opM0hnwA7o7KG8J+m3wBmE6k0WUlL+T+9DfnXOraNgxTUbJs3KIAyTHShAOP3eIv7UmKJhYg9vxolCXd27j5OEwrCU6Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GinvIQWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GinvIQWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04433C4CEF7;
	Tue, 17 Mar 2026 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766275;
	bh=WJ1DFXSwXcqiv+P4yfgaH0GFW4g5PnIrnVGxhkXRgfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GinvIQWnxrM4UV5bfCaOgKL1i1yQP0OfHbc4z72WPTJoIvEwSbgvwc5z+ZpBfCAfa
	 kV4XPbh0qGvJm4p7rqpp8waXL+P/XFiKY5umoePPWvtBuQBe7WfS9QNBSFy3WiagUI
	 ZbU+DkTmFtgyDH4m9CQ3W38wTVonny88Ci1+NseE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Subject: [PATCH 6.19 209/378] libceph: admit message frames only in CEPH_CON_S_OPEN state
Date: Tue, 17 Mar 2026 17:32:46 +0100
Message-ID: <20260317163014.697825034@linuxfoundation.org>
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
@@ -2904,6 +2904,11 @@ static int __handle_control(struct ceph_
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


