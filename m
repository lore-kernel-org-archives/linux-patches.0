Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354D5A93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EBDC433EF;
	Tue, 10 Jan 2023 18:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375233;
	bh=kPfkr10vSTUUGbHK++BxhQ27fBbG54iakhQ9d+iP+6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wWqSiTPbc922MPOt566EvGeWXmK/ud5na1fTRo9O2oElDlVtwfOpiCeHgq2Lj0f+J
	 jvHhvuqX1iObtdTHuRjcbTJ+q+4IUobTH17EciJrz7UUWOGV2JNd7OlY3itmS4e6tU
	 AGbRrLbpMfKUWLd0zjEAO+y8XE9tJ9W9JcHNK4Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 5.15 122/290] ipmi: fix use after free in _ipmi_destroy_user()
Date: Tue, 10 Jan 2023 19:03:34 +0100
Message-Id: <20230110180036.008036375@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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
@@ -1273,6 +1273,7 @@ static void _ipmi_destroy_user(struct ip
 	unsigned long    flags;
 	struct cmd_rcvr  *rcvr;
 	struct cmd_rcvr  *rcvrs = NULL;
+	struct module    *owner;
 
 	if (!acquire_ipmi_user(user, &i)) {
 		/*
@@ -1334,8 +1335,9 @@ static void _ipmi_destroy_user(struct ip
 		kfree(rcvr);
 	}
 
+	owner = intf->owner;
 	kref_put(&intf->refcount, intf_free);
-	module_put(intf->owner);
+	module_put(owner);
 }
 
 int ipmi_destroy_user(struct ipmi_user *user)


