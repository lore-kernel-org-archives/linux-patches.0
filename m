Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C4419DF9A;
	Fri, 17 Oct 2025 15:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713948; cv=none; b=jUoF+RHx4+63e89DifDxPaBWQFIDw10FSJfWcD9LUFbozG1xhCQFOJZKSfIvP9+2qat9amhZEzy416m7LKXEMXeL/xHwyiiobZopgswjpCXMzaaNde68r4zZzDLfWcIGSJcsBXJ9PqUtOG/bmu0lp6v5rAdVU1wDQo6ugQqwCYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713948; c=relaxed/simple;
	bh=+7FnJPn96W9GVGEWZ2XWvzatj6cgYrIpnaWmvD4zS9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0M+ZvVRhr3f6/6Sm7AkXz9EfbTjW/qouUkDr3mP67MFl1Rtf//tY5/kAG8vCqe5KCDoST85tWPPgiinkBv6DM5+x28UOXMEoiGrI6ScIzw2EaZOsdb6oGLZtg17J5G29EB/0YviOKM5jsb4o7oYpDbMDIuz97CCN6kJNnHcBKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IA0v0NVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IA0v0NVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F364EC4CEE7;
	Fri, 17 Oct 2025 15:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713948;
	bh=+7FnJPn96W9GVGEWZ2XWvzatj6cgYrIpnaWmvD4zS9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IA0v0NVEHQlBpDFh5nrX1+dfyhYLFDd66vVpIvHSAwB3rQ7YZ02ivV9qJRxYBlnaX
	 M+vnT+UewDXwRvb3zlWdxLSoTTA7zCynSW2sGseZyZ/mzHK7KkDgRv1/XZ82jxC+sn
	 4LluCdqg/eVEPqM49BzB0sk1/QrqZkc9JjA0idno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Greg Thelen <gthelen@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.6 175/201] ipmi: Fix handling of messages with provided receive message pointer
Date: Fri, 17 Oct 2025 16:53:56 +0200
Message-ID: <20251017145141.173878947@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

commit e2c69490dda5d4c9f1bfbb2898989c8f3530e354 upstream

Prior to commit b52da4054ee0 ("ipmi: Rework user message limit handling"),
i_ipmi_request() used to increase the user reference counter if the receive
message is provided by the caller of IPMI API functions. This is no longer
the case. However, ipmi_free_recv_msg() is still called and decreases the
reference counter. This results in the reference counter reaching zero,
the user data pointer is released, and all kinds of interesting crashes are
seen.

Fix the problem by increasing user reference counter if the receive message
has been provided by the caller.

Fixes: b52da4054ee0 ("ipmi: Rework user message limit handling")
Reported-by: Eric Dumazet <edumazet@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Message-ID: <20251006201857.3433837-1-linux@roeck-us.net>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -2311,8 +2311,11 @@ static int i_ipmi_request(struct ipmi_us
 	if (supplied_recv) {
 		recv_msg = supplied_recv;
 		recv_msg->user = user;
-		if (user)
+		if (user) {
 			atomic_inc(&user->nr_msgs);
+			/* The put happens when the message is freed. */
+			kref_get(&user->refcount);
+		}
 	} else {
 		recv_msg = ipmi_alloc_recv_msg(user);
 		if (IS_ERR(recv_msg))


