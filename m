Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24B81448F3;
	Thu, 11 Apr 2024 10:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829983; cv=none; b=Lsl0i06cx/9/6l3NLu3HvgNP/K7J1g5CkB2mkfqsFKVOkKZ8P6sPZ7GE0lYJPEmONlaJkWJOvcQQL52PGsFOPjYq+gHoxZ3TQXWUpdCZ388y/J7H7d0tgMDkgwyL40YQfrrpbQypAZz8AXTmaugkPGM3mAh/swg+dycweI5Hsw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829983; c=relaxed/simple;
	bh=BQ/ex29oPXMWJxWzpWJvHM1Rgd838tTlVEcX6A3Cy5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HASw6XuHE4V+VTo/rdWWLDs/vTIuS5QNuW72mIcytcSGTmkgTleFVUlBS114NQ7O3Ok/Uf4eVu+bGYM3pPmxgz4+sGH1R44cCwP+Rro40DKhIVPFLSTeVgsYRMzcOWNAda3Q9Q1+O7VBq4ZBhYUIz0UfSOz6yaIEbTCBunbUFbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bn4Rc+Hk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bn4Rc+Hk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DE4C433F1;
	Thu, 11 Apr 2024 10:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829983;
	bh=BQ/ex29oPXMWJxWzpWJvHM1Rgd838tTlVEcX6A3Cy5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bn4Rc+HkJsEA+cy8B2APnMfy4Yqrc6qJSMYZVgL5nIVaay591w27unXpkU0F9m1R4
	 qRv9kUcXVYnYWXB33VfKTGVfYdD92SuPBatqVau+EpMsiIK5OWFXALIgv0xydorDMO
	 +13IpNpzY8d5ecCN385ii4ihSmfd+4j1g++pomto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 4.19 172/175] VMCI: Fix possible memcpy() run-time warning in vmci_datagram_invoke_guest_handler()
Date: Thu, 11 Apr 2024 11:56:35 +0200
Message-ID: <20240411095424.741849875@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

commit e606e4b71798cc1df20e987dde2468e9527bd376 upstream.

The changes are similar to those given in the commit 19b070fefd0d
("VMCI: Fix memcpy() run-time warning in dg_dispatch_as_host()").

Fix filling of the msg and msg_payload in dg_info struct, which prevents a
possible "detected field-spanning write" of memcpy warning that is issued
by the tracking mechanism __fortify_memcpy_chk.

Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Link: https://lore.kernel.org/r/20240219105315.76955-1-kovalev@altlinux.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/vmw_vmci/vmci_datagram.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/misc/vmw_vmci/vmci_datagram.c
+++ b/drivers/misc/vmw_vmci/vmci_datagram.c
@@ -386,7 +386,8 @@ int vmci_datagram_invoke_guest_handler(s
 
 		dg_info->in_dg_host_queue = false;
 		dg_info->entry = dst_entry;
-		memcpy(&dg_info->msg, dg, VMCI_DG_SIZE(dg));
+		dg_info->msg = *dg;
+		memcpy(&dg_info->msg_payload, dg + 1, dg->payload_size);
 
 		INIT_WORK(&dg_info->work, dg_delayed_dispatch);
 		schedule_work(&dg_info->work);


