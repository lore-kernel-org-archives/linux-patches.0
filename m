Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED77A140E3D;
	Thu, 11 Apr 2024 10:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831067; cv=none; b=gcK0/GPQ8ZAMbWf52jpp4Gt+3PowyVHugjSPVf5UijAXxQV0rk+zl6UP5679Zj7zqkMt1kxnNjtfRj06jcOLiNmTZhbFhmZvnOdsClRpj5l6kI0qkT9sbt6XH2mQe4LLeK094+jC1m8Ed8w0T0rzq7mQm9KGrvExL+ddscY6vXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831067; c=relaxed/simple;
	bh=D0cLPRoVayMTAZwEsMcpQkU8at3UvINMQBGk47LjoLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvoNV1G+m8VGX50xjNrvbLnt3PSUcIvEc8UHfUpIacM865u0HNTlLUDP20bw6CaYJzswF+OYUTH5lHnfznDZ4G6O3QQvc5GcnYn+Rmx/R6u/XNwC+mS9VBVvkVOAwg4bFfU5/G0L9rO6LwM2eACExsirjXV6pl9HoIkBC1N1GRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+WoXi8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+WoXi8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70678C433C7;
	Thu, 11 Apr 2024 10:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831066;
	bh=D0cLPRoVayMTAZwEsMcpQkU8at3UvINMQBGk47LjoLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+WoXi8l/t2fQWm51EnIh1Kh71WnWYozPhx5xu2FSWtLEdxH6Dk1TsINNfhO/1Vvg
	 2GTvAYraIA9x3CmSco2/vcBUQDihYN0BIjBAkQB947vG2SvxFymOFUIiasjT5fQdJY
	 EI0w2jTLFzL97Hj3P89LUJUcp7LXoaDY2Afm8KWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.4 212/215] VMCI: Fix possible memcpy() run-time warning in vmci_datagram_invoke_guest_handler()
Date: Thu, 11 Apr 2024 11:57:01 +0200
Message-ID: <20240411095431.235847546@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


