Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8518364B7;
	Fri, 24 Nov 2023 19:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wgdgwn5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E089C433C7;
	Fri, 24 Nov 2023 19:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853399;
	bh=6T+XFp/QK6q560aREMmq8Lp2nfaEi1P43iLT/Ot0MNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wgdgwn5KJIiVDv5LsBEf+XqG4ycVhAfNUd1Qe88+Yq886lsWIAMfM1AiPK1B2kHC/
	 Ap+PpqTCVggXpY4Fb637fOmKQITQj75rQBDD2wcfAhPK1BwwDbph2c87AMNwStXNeU
	 q+RQ0sKs0Qq3UUJWGPrsuPbKxlDn5B4XQSMlLDTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.15 172/297] hvc/xen: fix error path in xen_hvc_init() to always register frontend driver
Date: Fri, 24 Nov 2023 17:53:34 +0000
Message-ID: <20231124172006.274696859@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw@amazon.co.uk>

commit 2704c9a5593f4a47620c12dad78838ca62b52f48 upstream.

The xen_hvc_init() function should always register the frontend driver,
even when there's no primary console — as there may be secondary consoles.
(Qemu can always add secondary consoles, but only the toolstack can add
the primary because it's special.)

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231020161529.355083-3-dwmw2@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/hvc/hvc_xen.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -603,7 +603,7 @@ static int __init xen_hvc_init(void)
 		ops = &dom0_hvc_ops;
 		r = xen_initial_domain_console_init();
 		if (r < 0)
-			return r;
+			goto register_fe;
 		info = vtermno_to_xencons(HVC_COOKIE);
 	} else {
 		ops = &domU_hvc_ops;
@@ -612,7 +612,7 @@ static int __init xen_hvc_init(void)
 		else
 			r = xen_pv_console_init();
 		if (r < 0)
-			return r;
+			goto register_fe;
 
 		info = vtermno_to_xencons(HVC_COOKIE);
 		info->irq = bind_evtchn_to_irq_lateeoi(info->evtchn);
@@ -637,6 +637,7 @@ static int __init xen_hvc_init(void)
 	}
 
 	r = 0;
+ register_fe:
 #ifdef CONFIG_HVC_XEN_FRONTEND
 	r = xenbus_register_frontend(&xencons_driver);
 #endif


