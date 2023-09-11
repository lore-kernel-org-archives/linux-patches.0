Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29DE11710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DDBC433C9;
	Mon, 11 Sep 2023 15:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694446060;
	bh=mCCJl/tqLNeP/S7XEWOwnAhl635ldxciGOJ9h3F9vuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oV9Vm8BxN/8gdsPge1ApDqS5xVC54Uvrfx1rIXqiHjv52i4+LO0jyXI2ppWWBWj9v
	 6xcwomXwwF9SkKpeYyKilUf9SyUrpjWY/U4raPE/RiM+LbPOMMRxtm/EZ2Wpwl98xj
	 bjossK6/S6envrXN7H738DlDyitBHahxCy2hO1X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Siwar Zitouni <siwar.zitouni@6wind.com>,
	Guillaume Nault <gnault@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 568/600] net: handle ARPHRD_PPP in dev_is_mac_header_xmit()
Date: Mon, 11 Sep 2023 15:50:01 +0200
Message-ID: <20230911134650.376314534@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit a4f39c9f14a634e4cd35fcd338c239d11fcc73fc upstream.

The goal is to support a bpf_redirect() from an ethernet device (ingress)
to a ppp device (egress).
The l2 header is added automatically by the ppp driver, thus the ethernet
header should be removed.

CC: stable@vger.kernel.org
Fixes: 27b29f63058d ("bpf: add bpf_redirect() helper")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Tested-by: Siwar Zitouni <siwar.zitouni@6wind.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/if_arp.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/if_arp.h
+++ b/include/linux/if_arp.h
@@ -53,6 +53,10 @@ static inline bool dev_is_mac_header_xmi
 	case ARPHRD_NONE:
 	case ARPHRD_RAWIP:
 	case ARPHRD_PIMREG:
+	/* PPP adds its l2 header automatically in ppp_start_xmit().
+	 * This makes it look like an l3 device to __bpf_redirect() and tcf_mirred_init().
+	 */
+	case ARPHRD_PPP:
 		return false;
 	default:
 		return true;


