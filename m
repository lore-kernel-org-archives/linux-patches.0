Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608E413AA2F;
	Tue, 27 Feb 2024 13:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042185; cv=none; b=OWUU5RYYCED4v0/S06Ato2IF1eIX75sl5AYXGS39wXkjneBCy6qd+QoaJ4rF4cUhv8pSRyIURyLtvhNEDS9eHfbE9OSLowz1y9YwVYrFKOmXinaf4pEDtOIm7RECUM8gGNq7ycEwxbI0cQGP3n9oSRP205t35idoHkaimLMOK0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042185; c=relaxed/simple;
	bh=psw4aVoNqpuwbh+MSzISsNh670ppVFBUNwtzhV+uR0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XG2j6iCQn+Dt+pZ8zPv0ShbwXrhkrqxxRplSCIgT0M+bu9Jl1jXqg03DtyNe9aJM3UaX7+cxVAiY4e1MjpngsaldjidWBz3YX/lGRRkFZxMKF828crh/tnVgu0zLA3KKQ7wtySAXf+1cTHLiNhc9iAZsp9XiNGHeuGv+/CU6c8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EyFQiLu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyFQiLu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE2FC433F1;
	Tue, 27 Feb 2024 13:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042184;
	bh=psw4aVoNqpuwbh+MSzISsNh670ppVFBUNwtzhV+uR0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EyFQiLu3tY0epWP3M10a7Mt85bPbwMdP2xlq8kmXB8EsJrgA+lyTDdcureGX4+Qkc
	 XzB1kZndJHTOAbQXucHBmgUhabbI3bhWReVdfqIfvCYNR2R1+jAZIVl0jrpBa8gA99
	 zSdEBA86NLaibqafdvQaoc5Zumg7IED59yIc74EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Juergen Gross <jgross@ssue.com>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.6 209/299] xen/events: fix error code in xen_bind_pirq_msi_to_irq()
Date: Tue, 27 Feb 2024 14:25:20 +0100
Message-ID: <20240227131632.519933164@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 7f3da4b698bcc21a6df0e7f114af71d53a3e26ac upstream.

Return -ENOMEM if xen_irq_init() fails.  currently the code returns an
uninitialized variable or zero.

Fixes: 5dd9ad32d775 ("xen/events: drop xen_allocate_irqs_dynamic()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Juergen Gross <jgross@ssue.com>
Link: https://lore.kernel.org/r/3b9ab040-a92e-4e35-b687-3a95890a9ace@moroto.mountain
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/events/events_base.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1099,8 +1099,10 @@ int xen_bind_pirq_msi_to_irq(struct pci_
 
 	for (i = 0; i < nvec; i++) {
 		info = xen_irq_init(irq + i);
-		if (!info)
+		if (!info) {
+			ret = -ENOMEM;
 			goto error_irq;
+		}
 
 		irq_set_chip_and_handler_name(irq + i, &xen_pirq_chip, handle_edge_irq, name);
 


