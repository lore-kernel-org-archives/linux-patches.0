Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610DA19DF9A;
	Fri, 17 Oct 2025 15:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714300; cv=none; b=gqvkGcslX/rgtUkpc2zEDb4IpTYjws3QMbSx7kVxGr3OI+kHUZQXqcSdk8ibt99akFsSgv/+BIjjGpRL/csNjemYpvwl0URyUsicfKjwHTIccBThb9QGse+yXT7iwxR53iARDTJXmdZma2h0WnXir1LMnsmz9dKb7KwqKZd0mu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714300; c=relaxed/simple;
	bh=lGdiwp+KL+Ij/OCu9PTf+8mY7PfbzHkwjs7fhU92Wx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyWeu6kHEwsDZ1XxVYdHLC5tNgS2R4eSLqUb5tJ43+iuXpybAw18LaH4wsyYy+VW18C7jrejVVHxLkYnJ1gm2jHZmRk8+0F90wSHGl5EK+8bjHzegqQH1NtJjDwI2oZS9neuSpu5Zco+/Qc3xwXLkdmrBq6JQ9gpQioCWi7iRus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9Njr69J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9Njr69J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C49C4CEE7;
	Fri, 17 Oct 2025 15:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714298;
	bh=lGdiwp+KL+Ij/OCu9PTf+8mY7PfbzHkwjs7fhU92Wx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9Njr69JMy0H3KmTCOsbUzofpf3pD9GCLKYJVme6Pnr6W8wWM5Y4UwIp/p/V/GpXa
	 jDDIgyESJ5qVzcFVHVHnU/IdckVOaSwG3cFr7By6Yeta3xYnQfSTCvV7EeaPubSrcM
	 psAk3Sfibx47yjji1mrXzXXOr3NWpK5j17aZcJY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 6.12 095/277] ARM: OMAP2+: pm33xx-core: ix device node reference leaks in amx3_idle_init
Date: Fri, 17 Oct 2025 16:51:42 +0200
Message-ID: <20251017145150.602215871@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Miaoqian Lin <linmq006@gmail.com>

commit 74139a64e8cedb6d971c78d5d17384efeced1725 upstream.

Add missing of_node_put() calls to release
device node references obtained via of_parse_phandle().

Fixes: 06ee7a950b6a ("ARM: OMAP2+: pm33xx-core: Add cpuidle_ops for am335x/am437x")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20250902075943.2408832-1-linmq006@gmail.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-omap2/pm33xx-core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/pm33xx-core.c
+++ b/arch/arm/mach-omap2/pm33xx-core.c
@@ -388,12 +388,15 @@ static int __init amx3_idle_init(struct
 		if (!state_node)
 			break;
 
-		if (!of_device_is_available(state_node))
+		if (!of_device_is_available(state_node)) {
+			of_node_put(state_node);
 			continue;
+		}
 
 		if (i == CPUIDLE_STATE_MAX) {
 			pr_warn("%s: cpuidle states reached max possible\n",
 				__func__);
+			of_node_put(state_node);
 			break;
 		}
 
@@ -403,6 +406,7 @@ static int __init amx3_idle_init(struct
 			states[state_count].wfi_flags |= WFI_FLAG_WAKE_M3 |
 							 WFI_FLAG_FLUSH_CACHE;
 
+		of_node_put(state_node);
 		state_count++;
 	}
 


