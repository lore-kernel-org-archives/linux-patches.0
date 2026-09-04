Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5852F351C04;
	Fri,  4 Sep 2026 05:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499625; cv=none; b=NJeLzPpv9iRpgxCUgJQJij+aM9FyC1Otbl9CwlThT9QiaUjpQKjL9Z9PepOWLuh4gXjguf6vgkp3s+tOfYSIjml3Z289GX1nxL8p3uQ2BkywrkNz/6qo5CpD7rXgC5XZp1qu6aoCfAA71TGDYCT2w5hwf1kwAjDuPiQL40BZK5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499625; c=relaxed/simple;
	bh=V6YxoMhocD+EnSRlBtacfY1b/v3TpxnxLHvtYyXd2BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+lC9nfr6bkOBQOzp1s9jGCZes7SjDaSWt1eCToYzJsrVzlEHmOKnredgAHaSw+DFrZckhQa6gC/hk/FukKvKz8FzZMePBbtCNd+xgS62/D9j99iYzZyEwIBDcj2174nFejyGdDJY5dNAYGUOKnMW4CO26cXfqzojADXvGmmjsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dg/nh69r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dg/nh69r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B347F1F00A3D;
	Fri,  4 Sep 2026 05:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499624;
	bh=d2maMeCPg9SQ8eZoy2Na123uVbZyqljKxT7kOuGAKTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dg/nh69rRC+G+y+E+HnBEYvMEmkZDTd1shPhU1pBag3euFDIP9YAW4vZxLcURp9VI
	 QIHPr57FoNpBkdXNXkMVX29XIiGwNCXzszVAECqZJ4Q6Pjv5dOxYYlvX/Br5TEMJOw
	 8nFYNq2oUywg8r7z6GyQD8IP1OIKq08ojRAYfXRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifei Gao <gyf161023@gmail.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 7.2 482/713] ipmi: Fix use-after-free of cmd_rcvr in _ipmi_destroy_user()
Date: Fri,  4 Sep 2026 06:57:30 +0200
Message-ID: <20260904045814.629660645@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifei Gao <gyf161023@gmail.com>

commit 05ec76cfbce653e07cec19b9b8b20e33449d5d87 upstream.

Commit 9e91f8a6c868 ("ipmi:msghandler: Remove srcu for the
ipmi_interfaces list") dropped the synchronize_rcu() between unlinking
the command receivers from intf->cmd_rcvrs and freeing them, updating
only the comment that explains why the barrier is needed.

The cmd_rcvrs list is still traversed under plain RCU: find_cmd_rcvr()
walks it inside rcu_read_lock(), and handle_ipmb_get_msg_cmd() borrows
rcvr->user from that lookup within the same read-side section. Without
the grace period, _ipmi_destroy_user() can kfree() a cmd_rcvr while a
reader still holds a pointer to it, causing a use-after-free.

The rework only made srcu unnecessary for the interfaces list; the
cmd_rcvrs list still relies on plain RCU. Restore the synchronize_rcu()
before freeing the receivers.

Fixes: 9e91f8a6c868 ("ipmi:msghandler: Remove srcu for the ipmi_interfaces list")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Yifei Gao <gyf161023@gmail.com>
Message-ID: <20260825234630.1196170-1-gyf161023@gmail.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -1391,6 +1391,7 @@ static void _ipmi_destroy_user(struct ip
 		}
 	}
 	mutex_unlock(&intf->cmd_rcvrs_mutex);
+	synchronize_rcu();
 	while (rcvrs) {
 		rcvr = rcvrs;
 		rcvrs = rcvr->next;


