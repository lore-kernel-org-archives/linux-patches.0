Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB114330B30;
	Fri, 17 Oct 2025 15:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716376; cv=none; b=M7PgH/11p0UmRqz1z6H8sPbS4oYcUtnnDXJYlrGzVUfHyVkEkOcG/em/jSKR8aAEDbc9ppJvbJMDPQDvfJecd+taPhKMY8KKIWx1Rqiem/r9tw9CEXi9Q+yi/5BEAaCsMB+S00vgYy4cW+QhIOo6AQTh6uhZsuuz5gGeGBl+7rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716376; c=relaxed/simple;
	bh=onRzFKT+3+DqkA8JYz65sao8+SU7sh0B6NXYk4SWCpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKBzNoDqU5mZLatyhhKDhSTM4AidltXdhLIe+nBf8v0/eQWONXgjVNmBiBwPlBW6tuVjofFmSQKuJLk4q4u1E0tfuxp24V2OBsvwMMM7IS/4SgANqzMPkiyOLE/FtlnhCb0sls9QjmCAPpY6MQg96cHftvetG0bPaWJhvhxL5no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQ32dEjz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQ32dEjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5062BC4CEE7;
	Fri, 17 Oct 2025 15:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716376;
	bh=onRzFKT+3+DqkA8JYz65sao8+SU7sh0B6NXYk4SWCpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQ32dEjzEFALzAn7plxqICbGLY6vuxYdLMU2EGWZWzoef/6IvsiHl+cL3AXCqrbYZ
	 Lo+7wxyOFTXpnrXlIcwys89fzGKImiQiCtlbW4Ui3PKt0IjXFQNvI9KDTKuPwJ5Yd6
	 GCTCR5rc1C3sLGa//70uiNJMeU+8FX24OSUdjICw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 5.15 169/276] ARM: OMAP2+: pm33xx-core: ix device node reference leaks in amx3_idle_init
Date: Fri, 17 Oct 2025 16:54:22 +0200
Message-ID: <20251017145148.642085017@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -393,12 +393,15 @@ static int __init amx3_idle_init(struct
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
 
@@ -408,6 +411,7 @@ static int __init amx3_idle_init(struct
 			states[state_count].wfi_flags |= WFI_FLAG_WAKE_M3 |
 							 WFI_FLAG_FLUSH_CACHE;
 
+		of_node_put(state_node);
 		state_count++;
 	}
 


