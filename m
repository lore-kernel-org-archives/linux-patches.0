Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7506612FB31;
	Wed, 19 Jun 2024 13:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802653; cv=none; b=BaDVBWUjfqbZBGKZg/OS/gblTf3NXcuT5eJgeuFKazVC6LbtuxjhqbDJIThP2k35l/qC/X8oK/myiYKgZ3lE0T7e4u6QBiSA1GCiSBi2i1qDc+QLKFVADgZagxjlnE9WXevYKCLqow3a/HrVjNloNrIEIXG45VOMAi0M/v79w/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802653; c=relaxed/simple;
	bh=MuKrbBdRWznJyXyu5gTMtKsjRzzorZ0hOdKB1ioKxrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHH3UZ3Y0Hk1fh14aX8R3jJji+9jkRDTLJ0LGziF1W/JgvslIqmdT8IbWAU6Rof6GFrQpSog054FzPJ0eQ66Yfunb95CaReWHcxCYNWoakVuwLyt/fX8+i7zEu2LDoPne8tEa5fQ+qYkmsM68ESjtrE7q/DtzCcP8g5UGviEHJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJvmHSoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJvmHSoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93C3C2BBFC;
	Wed, 19 Jun 2024 13:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802653;
	bh=MuKrbBdRWznJyXyu5gTMtKsjRzzorZ0hOdKB1ioKxrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJvmHSoVzdYSX5gYInrDTBqaeHtYHzXf7CP94bOr2+Ocesrv53CscCFa5nvG+0me4
	 4wDpW17vBBsFlqrD+G/mVBT4jsNS1ZZcHBTdFQn5fkQGg4uRCylej5IbOjNoi86JKN
	 f98s4q8eTTWPLR2RgZLm9alYgaZK/AcNC2u1zozs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sicong Huang <congei42@163.com>,
	Ronnie Sahlberg <rsahlberg@ciq.com>
Subject: [PATCH 6.6 255/267] greybus: Fix use-after-free bug in gb_interface_release due to race condition.
Date: Wed, 19 Jun 2024 14:56:46 +0200
Message-ID: <20240619125616.104519417@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


