Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0670C18C034;
	Thu, 17 Apr 2025 18:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916150; cv=none; b=IGfURWUSdWCkt8lvDFkVgQyxgrkIuBdEUpN+WuQY6TVYuK2cLdgjXAQFkGHq0LNcKHoxVJrw4rodd8nNJi9htcEo8zoA6H+K5YX/+m/357xvQs027eP5IAy0aCnMgHBDdwBIIRHgBcJq8oqL6vNqW8xGZdKB58aGxX8MpmXrJk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916150; c=relaxed/simple;
	bh=ZAY287nr8tpLzL0iBuZQjIXpLypU9cvE/PpsNhjm8Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYIZElLUpcu3ZIZoySEP9fgDTJI375RvLQvU3CnGrKfeManh+OAoaCgNh0NhGgNJAf3jfZFpYzjoVQcA/LqbsfygoH8SiP1Qu4MG7l4ewxULwh/7PcrkopQHskNsD1FAffJym9VHWiM8gvxVNmKRCo6mZ8AN+0zdVxyM+M6svtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7ngCqR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7ngCqR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A990C4CEE7;
	Thu, 17 Apr 2025 18:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916149;
	bh=ZAY287nr8tpLzL0iBuZQjIXpLypU9cvE/PpsNhjm8Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7ngCqR4jqlWFcITo+sRAwSzl9rw8xbXsqYt7kaTAkBcc+fi+CrTX9AeUAwMs3eX8
	 qqVHQYLB40n51q7wNPjy0privwlkJ3+XPvrMnoWnQq0SJDfqz4AVI8QlWfROyIZfOP
	 dUbFnDA8His3M6zDH/iWMX8elzvF4zWLUpvUp6GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 360/393] of/irq: Fix device node refcount leakage in API irq_of_parse_and_map()
Date: Thu, 17 Apr 2025 19:52:49 +0200
Message-ID: <20250417175122.077172844@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit 962a2805e47b933876ba0e4c488d9e89ced2dd29 upstream.

In irq_of_parse_and_map(), refcount of device node @oirq.np was got
by successful of_irq_parse_one() invocation, but it does not put the
refcount before return, so causes @oirq.np refcount leakage.

Fix by putting @oirq.np refcount before return.

Fixes: e3873444990d ("of/irq: Move irq_of_parse_and_map() to common code")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250209-of_irq_fix-v2-6-93e3a2659aa7@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -39,11 +39,15 @@
 unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
 {
 	struct of_phandle_args oirq;
+	unsigned int ret;
 
 	if (of_irq_parse_one(dev, index, &oirq))
 		return 0;
 
-	return irq_create_of_mapping(&oirq);
+	ret = irq_create_of_mapping(&oirq);
+	of_node_put(oirq.np);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
 


