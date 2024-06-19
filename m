Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86BC147C6E;
	Wed, 19 Jun 2024 13:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804145; cv=none; b=DkQ7ZfIafFaCWkrjo//37YT/ZOFLbiZd+QGtehWjHJPXnZ82pEmXeN8ZFt3kop20wE5Eicp1KRMZXXCvHpCuPdTMoXMrfCqegDiRItHXDZt6GOFKmxDl6S75WEpcJkRsQzxhGW2GfX8M3oFom6cHXCHfSuu24GxZhifM74CO9VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804145; c=relaxed/simple;
	bh=J8UtCk6tjy/0J+6A/+TbIqxAwj11Ry1ekP9dSDONiUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWRAwoT/RwInSH6R+1xZh9r9gVC9yzLSfmmMff7l9IA5rsOvqe5ux/k+O3B3XKWzDT9OHgFxNBpvybhpjIQ3NXZMgxSh0M7G7kEsMNFntdyc1632n4v/upnOGrmQ7Z85zQvPz5biD7vDklTWLUzCNBC92GdhF9soUKx6T84tvJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFZlgUvi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFZlgUvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA85C2BBFC;
	Wed, 19 Jun 2024 13:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804145;
	bh=J8UtCk6tjy/0J+6A/+TbIqxAwj11Ry1ekP9dSDONiUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFZlgUviKaeL9BDyny4YXLT/CkvrCR3kZ6lAkDT540uCMN67qEAwO5PguDJbl8vQB
	 bl9OrIlcN/84uYcLbH8TOPWrbGc6ZsordzuPwdcsDTunxGd+LUER9tGd60YRhMOXWz
	 t8Npym3FHNZCOkeDxyf62zO5IHFqV/E+SCh7eGU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sicong Huang <congei42@163.com>,
	Ronnie Sahlberg <rsahlberg@ciq.com>
Subject: [PATCH 6.1 210/217] greybus: Fix use-after-free bug in gb_interface_release due to race condition.
Date: Wed, 19 Jun 2024 14:57:33 +0200
Message-ID: <20240619125604.797725439@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -694,6 +694,7 @@ static void gb_interface_release(struct
 
 	trace_gb_interface_release(intf);
 
+	cancel_work_sync(&intf->mode_switch_work);
 	kfree(intf);
 }
 


