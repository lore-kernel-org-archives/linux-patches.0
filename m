Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743EA46B7
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98F7C43392;
	Mon, 16 Jan 2023 16:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886704;
	bh=6kRdAaeMvZmWYpplSFs7v512gNvYZh1FB4LyxqGWJD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJlOWDK/Z7xCZoCv0o6ILp836xjDMU+ZZisuP/7sJp2RGitCf/EbBR5jtf6p9gbS5
	 D/oVz/vt6HOn5zAg5XK5NwF367GKT5V+0yYc/oLkQbrKgs9oXDHJFELw54EkfO4UWC
	 TR9t8knsChqErpGy+gPGcRnEGQ9AoWl43Tf5WnF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.4 513/658] ipmi: fix use after free in _ipmi_destroy_user()
Date: Mon, 16 Jan 2023 16:50:01 +0100
Message-Id: <20230116154932.982806891@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

commit a92ce570c81dc0feaeb12a429b4bc65686d17967 upstream.

The intf_free() function frees the "intf" pointer so we cannot
dereference it again on the next line.

Fixes: cbb79863fc31 ("ipmi: Don't allow device module unload when in use")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Message-Id: <Y3M8xa1drZv4CToE@kili>
Cc: <stable@vger.kernel.org> # 5.5+
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_msghandler.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -1298,6 +1298,7 @@ static void _ipmi_destroy_user(struct ip
 	unsigned long    flags;
 	struct cmd_rcvr  *rcvr;
 	struct cmd_rcvr  *rcvrs = NULL;
+	struct module    *owner;
 
 	if (!acquire_ipmi_user(user, &i)) {
 		/*
@@ -1358,8 +1359,9 @@ static void _ipmi_destroy_user(struct ip
 		kfree(rcvr);
 	}
 
+	owner = intf->owner;
 	kref_put(&intf->refcount, intf_free);
-	module_put(intf->owner);
+	module_put(owner);
 }
 
 int ipmi_destroy_user(struct ipmi_user *user)


