Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E786C148;
	Tue, 29 Apr 2025 17:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948781; cv=none; b=gjs6ybNDGIjKLCRsHVOH+SAY8XR9VYlneqeyFHoquAXSEG5Ucd0aZ4CABIQzMRMhyhxxJCLzk76t7/MgiccPp8PS6Qz3VrXhixnYAW9N5x1cA37vovZrj8bMLeP4sQK5UfBUfVJOqSC7hQFw2ak4GLXHr3nPElm47KVIYOlISJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948781; c=relaxed/simple;
	bh=emK9oCTvY/2HJDyxkrpEMaYxqtiqEx2XRIyyCVENt8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hL6xoRWUIIf7Es7qT7UYrCQ5m64gh0gGhqPuyhtnbN+K4ab3M4gadRJRjNNBYrvoD4N88XX9BO0Zp/X3rEHI0/4T6nuC2I8+crSM3xJ3SABqjeVHD15uSIENZ9yr1VLzRPwNfLzvAj7pOgHjPt5BWDdIZnGuw0G3v1GcjtxrhRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUOodjtj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUOodjtj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F3DC4CEE3;
	Tue, 29 Apr 2025 17:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948781;
	bh=emK9oCTvY/2HJDyxkrpEMaYxqtiqEx2XRIyyCVENt8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUOodjtjfnU/oX/RwxHbj/jJd/G1zCmzN9EA6fWU/XxIJSS1KSyuYLG0v5JscN0yr
	 WomuJ4xun6f7juHTLM2fvr/thmXLxP6vNdMeIEi1HkIzpP5SXDewlqXUwF0cLO3TbD
	 xEIuKThL+lL8G1pCTr/lynYDVhh14gUBzXyuawCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.15 110/373] of/irq: Fix device node refcount leakage in API irq_of_parse_and_map()
Date: Tue, 29 Apr 2025 18:39:47 +0200
Message-ID: <20250429161127.695486387@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -36,11 +36,15 @@
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
 


