Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBD9143757;
	Wed, 19 Jun 2024 13:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803454; cv=none; b=r7vVOE2VnR8qSMpCV53YRzh4XFa9EoUC+osQs+925ubHkM0yKsg3CZafup6AGErlcBjpQHID8akA+FIwEbCeaUq8DGRfpk8HvOz+b2Mg0XN4EhQtNSD7SYPs61VkyAen9wzP5VNZelLbg+dvK4A2pZf18BSVS6KM5zGhbV+ZIq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803454; c=relaxed/simple;
	bh=by/qSSysD2VS49vj9Hgk8Mrw+pDpaThGDcn1YMI1vpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6AYIMhg2hMfT282KU08cYIm1OFbYKYrCI2tMgZU+2Psabq/LxToqF+TzFiOjWR+0PkUmKqWcjfcbwZ3Duk7vP6PmiKPi/msYVclfRf0LEdEXXAS8B7LXWrGkgVI+wCgbQbeTd252ZCcE+nieh9FAd49li/EEPRFry29/1PjTRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fIKepv/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fIKepv/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E64C2BBFC;
	Wed, 19 Jun 2024 13:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803454;
	bh=by/qSSysD2VS49vj9Hgk8Mrw+pDpaThGDcn1YMI1vpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fIKepv/ZlcIuLFSw1JkIFgaoVBLLlUQ4bc1moGZNLuxmMY3szoEFPN0XnXdQlhdNu
	 pGfLxniHnKVqnXof8XI7iu4i8uC1vmRrmQkvdvWLjSmvFNs2dOpnYqAFYZ4hrP3ceJ
	 wIrnYgjG6SsDaHGeJ21r8t1E/FeAYjfwL42krFtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sicong Huang <congei42@163.com>,
	Ronnie Sahlberg <rsahlberg@ciq.com>
Subject: [PATCH 6.9 272/281] greybus: Fix use-after-free bug in gb_interface_release due to race condition.
Date: Wed, 19 Jun 2024 14:57:11 +0200
Message-ID: <20240619125620.449232904@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sicong Huang <congei42@163.com>

commit 5c9c5d7f26acc2c669c1dcf57d1bb43ee99220ce upstream.

In gb_interface_create, &intf->mode_switch_completion is bound with
gb_interface_mode_switch_work. Then it will be started by
gb_interface_request_mode_switch. Here is the relevant code.
if (!queue_work(system_long_wq, &intf->mode_switch_work)) {
	...
}

If we call gb_interface_release to make cleanup, there may be an
unfinished work. This function will call kfree to free the object
"intf". However, if gb_interface_mode_switch_work is scheduled to
run after kfree, it may cause use-after-free error as
gb_interface_mode_switch_work will use the object "intf".
The possible execution flow that may lead to the issue is as follows:

CPU0                            CPU1

                            |   gb_interface_create
                            |   gb_interface_request_mode_switch
gb_interface_release        |
kfree(intf) (free)          |
                            |   gb_interface_mode_switch_work
                            |   mutex_lock(&intf->mutex) (use)

Fix it by canceling the work before kfree.

Signed-off-by: Sicong Huang <congei42@163.com>
Link: https://lore.kernel.org/r/20240416080313.92306-1-congei42@163.com
Cc: Ronnie Sahlberg <rsahlberg@ciq.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/greybus/interface.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/greybus/interface.c
+++ b/drivers/greybus/interface.c
@@ -693,6 +693,7 @@ static void gb_interface_release(struct
 
 	trace_gb_interface_release(intf);
 
+	cancel_work_sync(&intf->mode_switch_work);
 	kfree(intf);
 }
 


