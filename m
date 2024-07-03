Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576981487CE;
	Wed,  3 Jul 2024 11:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005650; cv=none; b=p/DjGTj/3Shk7a8qiRCRAL12+hY3PtjMCAc0R1qHaVJcKkqUekpCnqt0jIkJXiyv0RlM0/jcMPNxsHFBoxOgga0EpGFCb33T3CHkDAZweHLZMPz+J6m/0276qyfzvnF/8rQI4oR15hGjnY4aHf8dFsi5JWI3tFeEEKQLMamy8rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005650; c=relaxed/simple;
	bh=pbWyZYqPGrqIuQlgA3Og0MzdBsG/NvGVEHGz/BY0KHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B96annewOqRNSO4wmFeAx4q/ggB5dMULN1gKBmu7evksvO7mlsu9DbR0VcOS87YDTigmF0tELVQOoBqA5KR2ZnaDJ5uNJVyr+oeuadQkQLYJD12FlWP1w1gSY92mGpgYpNgG1OBt8IjV3PvXNxHDUHpFzxKQqk+/z6t/OIqhg1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkML8DmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkML8DmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A1CC2BD10;
	Wed,  3 Jul 2024 11:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005650;
	bh=pbWyZYqPGrqIuQlgA3Og0MzdBsG/NvGVEHGz/BY0KHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkML8DmFhmUbnnMVEZ7ZdJG+j2AR+6HJBbSJojHxzmhlheWHoa7Ki54gS0kmLREmq
	 MM9s7RPW+sG082oPUYDlf+KOZ5Jl93kVuWXSXyU2C0zQ9dE00tzoZqAvJzPNhKL1Tw
	 IExTtlJ5D/JkiDphl1f6OAEJGNNJVGT8rLz6MDwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sicong Huang <congei42@163.com>,
	Ronnie Sahlberg <rsahlberg@ciq.com>
Subject: [PATCH 5.15 143/356] greybus: Fix use-after-free bug in gb_interface_release due to race condition.
Date: Wed,  3 Jul 2024 12:37:59 +0200
Message-ID: <20240703102918.513282017@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


