Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C65303A0D;
	Sat, 17 Oct 2026 16:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256144; cv=none; b=G+Z3HEWjgwc0BzxK3jL/NXoVjDVcBZ76xNVWx0qhEPmN7+Te7pr7Klt38Lva9SzMSvQbRULDW0VKVHcItjJcunY4BgFn2RItRMh0Inb7skhWVYjztfK8yxCVJGOysVrWpEh7lwx4g9ODTmZT4VJi9kEp1VVatwEnMRCI1zTq42I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256144; c=relaxed/simple;
	bh=RxXAGrsc5ccNg0PHOTStikwGhNXDDc7I5vWn8ZU+Mwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1p8mysPuzjONIVXG4RHIDZMSqoBwXj02Mef8A5XK77BplM484JFQS2aeDLTs/7rhKfg0DYbwi1LslCZVp+ECA0oi9vFjyPdR4lM0SsSSrrJdQRNpqEUw0za5FlGvG8YFKGXOYcER7DRIfHznpWy7dK5NadNhJAZDvz3JN4OSXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1uC7DeN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1uC7DeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AACB1F000C4;
	Sat, 17 Oct 2026 16:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256143;
	bh=GGI+vWoG4/DRCE9mNpl8KOAtJcq9/X6yNQUO2tz+F7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o1uC7DeNVoeGC1g1IwwzgeT6Tn/kH+x5JruPclYfkTtk/sCi4XDInh/mSOVC14LXA
	 RarX8hxtgqqachTOBplhb5c+pRDbKbErEfELoH6UQ33CSx/cu/r7uGHfVm715MV/cp
	 i8ZIgEgaIe3TMwXVGCyrDnk/uye0U/hOqwr1Fmbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Yuqi Xu <xuyuqiabc@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0139/1674] net: ipconfig: bound DHCP option construction
Date: Sat, 17 Oct 2026 17:40:11 +0200
Message-ID: <20261017160434.725628244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Yuqi Xu <xuyuqiabc@gmail.com>

[ Upstream commit e47a1958e12abc3a17b5231a4f21c8f1bf662e08 ]

ic_dhcp_init_options() appends the hostname (option 12), vendor-class
(option 60) and client-ID (option 61) options into the fixed 312-byte
bootp_pkt.exten[] buffer.  Only the client-ID branch checked the
remaining space; the hostname and vendor-class writes were unbounded.

A 64-byte hostname together with the maximum 252-byte dhcpclass=
identifier needs 18 + (2 + 64) + (2 + 252) = 338 of the 312 available
bytes even before the terminating END marker, so the vendor-class memcpy
runs past the end of exten[].  With CONFIG_FORTIFY_SOURCE this is
reported as a field-spanning write and, when the kernel is booted with
panic_on_warn=1, aborts boot with a panic.

Route the optional options through a common helper that makes sure the
option, its 2-byte header and the END marker all fit and drops an option
that would not.  Configurations with short options keep sending exactly
the same bytes as before.

Fixes: 130c0f47fdf9 ("ipconfig: send host-name in DHCP requests")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Yuqi Xu <xuyuqiabc@gmail.com>
Reviewed-by: Ren Wei <weir@nebusec.ai>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/7808dfbfa2162dfd0b19f59aff5742d6e0db2abb.1789798023.git.xuyuqiabc@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipconfig.c | 45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 6109ef9e4dd45..74a770ea22885 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -676,6 +676,24 @@ static const u8 ic_bootp_cookie[4] = { 99, 130, 83, 99 };
 
 #ifdef IPCONFIG_DHCP
 
+static bool __init
+ic_dhcp_add_option(u8 **options, const u8 *end, u8 type, const void *value,
+		   int len)
+{
+	u8 *e = *options;
+
+	/* leave room for the option header and the END marker */
+	if (len > U8_MAX || end - e < len + 3)
+		return false;
+
+	*e++ = type;
+	*e++ = len;
+	memcpy(e, value, len);
+	*options = e + len;
+
+	return true;
+}
+
 static void __init
 ic_dhcp_init_options(u8 *options, struct ic_device *d)
 {
@@ -691,6 +709,7 @@ ic_dhcp_init_options(u8 *options, struct ic_device *d)
 		42,	/* NTP servers */
 	};
 	u8 mt = (ic_servaddr == NONE) ? DHCPDISCOVER : DHCPREQUEST;
+	u8 *end = options + sizeof(((struct bootp_pkt *)0)->exten);
 	u8 *e = options;
 	int len;
 
@@ -721,31 +740,19 @@ ic_dhcp_init_options(u8 *options, struct ic_device *d)
 	e += sizeof(ic_req_params);
 
 	if (ic_host_name_set) {
-		*e++ = 12;	/* host-name */
 		len = strlen(utsname()->nodename);
-		*e++ = len;
-		memcpy(e, utsname()->nodename, len);
-		e += len;
+		ic_dhcp_add_option(&e, end, 12, utsname()->nodename, len);
 	}
 	if (*vendor_class_identifier) {
-		pr_info("DHCP: sending class identifier \"%s\"\n",
-			vendor_class_identifier);
-		*e++ = 60;	/* Class-identifier */
 		len = strlen(vendor_class_identifier);
-		*e++ = len;
-		memcpy(e, vendor_class_identifier, len);
-		e += len;
+		if (ic_dhcp_add_option(&e, end, 60, vendor_class_identifier, len))
+			pr_info("DHCP: sending class identifier \"%s\"\n",
+				vendor_class_identifier);
 	}
 	len = strlen(dhcp_client_identifier + 1);
-	/* the minimum length of identifier is 2, include 1 byte type,
-	 * and can not be larger than the length of options
-	 */
-	if (len >= 1 && len < 312 - (e - options) - 1) {
-		*e++ = 61;
-		*e++ = len + 1;
-		memcpy(e, dhcp_client_identifier, len + 1);
-		e += len + 1;
-	}
+	/* the minimum length of identifier is 2, include 1 byte type */
+	if (len >= 1)
+		ic_dhcp_add_option(&e, end, 61, dhcp_client_identifier, len + 1);
 
 	*e++ = 255;	/* End of the list */
 }
-- 
2.53.0



