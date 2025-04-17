Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180862566D3;
	Thu, 17 Apr 2025 18:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914942; cv=none; b=NZLz589tvBtgBdZlSX041QxI1eZByHIXq7Z4ulUw+OKxHUrBJ9sIeELoVSK4Jv96rXXRaxpUj7LB/Qvyb0OQ5KnOGsga3ATZpod+neec2ITeWYbtVMndb29UbFqdSnU8pYLuAYSEgdC79W/KxunRlMcL397KzJ7EGyPJTQZxKW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914942; c=relaxed/simple;
	bh=PM+A+tFiybaiopKnLATgc4yeJW6lBR56kgUrOOt/phk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+bGeVUPNHQUbVSqQgoLBBji2+vQBKX4UUiDNSbRQnp/CtivPtZv7hhAUNshzcB1iYKQdKD3gDz19mWRxY1Ue2VlREx2j+IUaWclh8qLo+Ehb3/Lsv8gPVHbuDXhqz0TnfdAIIrc1/Cz7I6LFyRR2omd4jdRUvX6/M1Qu4C8ui4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0I1gnpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0I1gnpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C48FC4CEE4;
	Thu, 17 Apr 2025 18:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914942;
	bh=PM+A+tFiybaiopKnLATgc4yeJW6lBR56kgUrOOt/phk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0I1gnpKM96+LyBo1H381Ey53wQfhdzh+VfL5zE8IQBjS4EHhDwqbvO56xWdM61Au
	 OL5Dyz9fzpP5Y0jjy6VI/lGGY/ymsL84JdhvcVAwI5hQTbJ0bDU+zs9eYsze4DyyUS
	 TUIFrmJflV4DaGlEhZrs7FDUdknIuruohmW/8yRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.13 382/414] of/irq: Fix device node refcount leakage in API irq_of_parse_and_map()
Date: Thu, 17 Apr 2025 19:52:20 +0200
Message-ID: <20250417175126.820438743@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 


