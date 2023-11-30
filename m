Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4C7495C2;
	Thu, 30 Nov 2023 16:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rauwlF/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E85C433C7;
	Thu, 30 Nov 2023 16:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361440;
	bh=Ht0W2Mhwf9kWOdLGfT+BL3CNekNiWvgtM9xnXk6xO+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rauwlF/5PqmHVsa5BCmr9rO/zrv1wpa5m/l7t4TcR7VZTyYVO8BrRMag6jWf11JXR
	 6sWWILxtWAcjyJYegDTgcOYh+BB31rw6oKdkIbn59SOLydHhNrDGwtVe9EfPoKCWi1
	 aUcuC7UlCG18pDlE5uULBERSZKUIXMkHLBYFpr6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Ani Sinha <anisinha@redhat.com>,
	Shradha Gupta <Shradhagupta@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/112] hv/hv_kvp_daemon: Some small fixes for handling NM keyfiles
Date: Thu, 30 Nov 2023 16:20:51 +0000
Message-ID: <20231130162140.460845742@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Ani Sinha <anisinha@redhat.com>

[ Upstream commit c3803203bc5ec910a3eb06172cf6fb368e0e4390 ]

Some small fixes:
 - lets make sure we are not adding ipv4 addresses in ipv6 section in
   keyfile and vice versa.
 - ADDR_FAMILY_IPV6 is a bit in addr_family. Test that bit instead of
   checking the whole value of addr_family.
 - Some trivial fixes in hv_set_ifconfig.sh.

These fixes are proposed after doing some internal testing at Red Hat.

CC: Shradha Gupta <shradhagupta@linux.microsoft.com>
CC: Saurabh Sengar <ssengar@linux.microsoft.com>
Fixes: 42999c904612 ("hv/hv_kvp_daemon:Support for keyfile based connection profile")
Signed-off-by: Ani Sinha <anisinha@redhat.com>
Reviewed-by: Shradha Gupta <Shradhagupta@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20231016133122.2419537-1-anisinha@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/hv/hv_kvp_daemon.c    | 20 ++++++++++++--------
 tools/hv/hv_set_ifconfig.sh |  4 ++--
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 264eeb9c46a9f..318e2dad27e04 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -1421,7 +1421,7 @@ static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value *new_val)
 	if (error)
 		goto setval_error;
 
-	if (new_val->addr_family == ADDR_FAMILY_IPV6) {
+	if (new_val->addr_family & ADDR_FAMILY_IPV6) {
 		error = fprintf(nmfile, "\n[ipv6]\n");
 		if (error < 0)
 			goto setval_error;
@@ -1455,14 +1455,18 @@ static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value *new_val)
 	if (error < 0)
 		goto setval_error;
 
-	error = fprintf(nmfile, "gateway=%s\n", (char *)new_val->gate_way);
-	if (error < 0)
-		goto setval_error;
-
-	error = fprintf(nmfile, "dns=%s\n", (char *)new_val->dns_addr);
-	if (error < 0)
-		goto setval_error;
+	/* we do not want ipv4 addresses in ipv6 section and vice versa */
+	if (is_ipv6 != is_ipv4((char *)new_val->gate_way)) {
+		error = fprintf(nmfile, "gateway=%s\n", (char *)new_val->gate_way);
+		if (error < 0)
+			goto setval_error;
+	}
 
+	if (is_ipv6 != is_ipv4((char *)new_val->dns_addr)) {
+		error = fprintf(nmfile, "dns=%s\n", (char *)new_val->dns_addr);
+		if (error < 0)
+			goto setval_error;
+	}
 	fclose(nmfile);
 	fclose(ifcfg_file);
 
diff --git a/tools/hv/hv_set_ifconfig.sh b/tools/hv/hv_set_ifconfig.sh
index ae5a7a8249a20..440a91b35823b 100755
--- a/tools/hv/hv_set_ifconfig.sh
+++ b/tools/hv/hv_set_ifconfig.sh
@@ -53,7 +53,7 @@
 #                       or "manual" if no boot-time protocol should be used)
 #
 # address1=ipaddr1/plen
-# address=ipaddr2/plen
+# address2=ipaddr2/plen
 #
 # gateway=gateway1;gateway2
 #
@@ -61,7 +61,7 @@
 #
 # [ipv6]
 # address1=ipaddr1/plen
-# address2=ipaddr1/plen
+# address2=ipaddr2/plen
 #
 # gateway=gateway1;gateway2
 #
-- 
2.42.0



