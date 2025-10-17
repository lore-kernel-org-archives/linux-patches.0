Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693052F12DB;
	Fri, 17 Oct 2025 15:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713633; cv=none; b=GHEeHBIuft3zJapuexjd9CJv36ZhzZtWhNs2XNLml6s0RvG1bWqhvf+TqylDRUu707/Uzo3hUh30/vkvBvFh/KIv8NsK1UoQp++oZe9/eNmYNHoEo4kfCJnfWOPXccNq/zeC1CWard5/IckpEASYuCgtgQKnpIgLYiEpnKHIc0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713633; c=relaxed/simple;
	bh=+NmEGl5gRvoxqn5oXPBglvnDESQduxFyjjmYF0P7F0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jc7Z3dfbbmpDOnwQE24Y2qcBPfNCttPnQvBiLiK5/EIsS4Wlu3d9bKCUnfl85Ru7cCMN8xb6u65CGayC5RpTmZYMynFCj2AiD0cFEAuDxtjWNNobgTrXX9UE3uBn+9XthGv90G1hIrc3Vv0TsXTkYTMuqjBQ2tBotcIiujJ/n2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxkE8cDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxkE8cDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15D2C4CEF9;
	Fri, 17 Oct 2025 15:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713633;
	bh=+NmEGl5gRvoxqn5oXPBglvnDESQduxFyjjmYF0P7F0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxkE8cDjyl0qldIntLgIGPXLfHWxPiwNpK/THBXtT5pK3dV7FOORdqg1lWlzTjeoJ
	 lNkbpdGP/T2/1UxmrC5CLCO/bkfFw159M6dCwOpHuIT2jg8kmqpSJLu4sANm2HiNn/
	 JK4Uczyee/k0UeoHyJIEeBuiaYhf3Ehm2fBqWKVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 6.6 065/201] ARM: OMAP2+: pm33xx-core: ix device node reference leaks in amx3_idle_init
Date: Fri, 17 Oct 2025 16:52:06 +0200
Message-ID: <20251017145137.139219766@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


