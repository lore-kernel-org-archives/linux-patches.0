Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E5F145B08;
	Thu, 11 Apr 2024 10:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830446; cv=none; b=MhrjlBicHPb5Ib3HKuCfQSvlmd8zIRhQ8QG2CdFNcHmiTfRXkO1QSjPPTZaEdJaekmMVju+DfHBl0brElJi68dDHGQQkjlasIzwiheg/Ax+sMQJSSr0npud+ndv6a8PcU4uP+VAt/ZN0RCn3QOzBf4s8ziGyllCuJHYIaFQE8C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830446; c=relaxed/simple;
	bh=INn+FGA1ObcmBVC9Ii4TvFQdOp24SjdvNRSF3+zl2aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELlT74AStdqLMJT2+iu9WpS6j5eNkbjnPOHGygoAhw6nkCCllSPzn7VExJZd+IB8llIqk3yeIkOVF3c0OKSlbgqxZKBJ3MjbYpsAux1X8PmGz0Qa7pd5G+RIA+CNCmmxx8YEUgem9zsKbDlWT1l4UfDq9oHlg6/4TErHss+vjow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5JMD880; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5JMD880"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E664C433F1;
	Thu, 11 Apr 2024 10:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830446;
	bh=INn+FGA1ObcmBVC9Ii4TvFQdOp24SjdvNRSF3+zl2aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5JMD880rLkol4ganNlwejxHS0YlyVN3CSFIfZs6WWAQDiy/hQHn/DnZ2Zqpn5M9e
	 qftd6ksQKGMuRWGRt9gahLjSTgOHXLX+COVXtEbOicOubaI5cvsXRkiyHkwUErJgQy
	 sqYqbRDtvizRI2PK1Cc9g2n7Ipf+B7yaEzPtfbBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 6.8 141/143] VMCI: Fix possible memcpy() run-time warning in vmci_datagram_invoke_guest_handler()
Date: Thu, 11 Apr 2024 11:56:49 +0200
Message-ID: <20240411095425.143714200@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -378,7 +378,8 @@ int vmci_datagram_invoke_guest_handler(s
 
 		dg_info->in_dg_host_queue = false;
 		dg_info->entry = dst_entry;
-		memcpy(&dg_info->msg, dg, VMCI_DG_SIZE(dg));
+		dg_info->msg = *dg;
+		memcpy(&dg_info->msg_payload, dg + 1, dg->payload_size);
 
 		INIT_WORK(&dg_info->work, dg_delayed_dispatch);
 		schedule_work(&dg_info->work);


