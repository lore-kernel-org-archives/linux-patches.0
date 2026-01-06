Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A282773E5;
	Tue,  6 Jan 2026 17:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720719; cv=none; b=fjn/Bm429/5bFlPilV2Is4pfeMVV+VoAaFCAZoEFRHt2p1zK4OMVP5Hz69JsThQuFbvBcnVaxnl/qnagf5XumQEUa+E7AsczFnhTXLg47gcRFS6MzCngYc3GSLO8j9cC8p2AsayZ+jMySq1fntKOEZR7oNUj9S5VYQya8w+KbkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720719; c=relaxed/simple;
	bh=3FnSlG2C63ecpNzidA6vPpUEx7y2gR02zgcc6skTRLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScN/MQhHGdF0y9KWdH5Di+aURr+qYYix3nqm+ZaKs2ICzP6uj8lGIWhs6NUz/HBVk9ORmchJIGZGZvvtWg/9xRZ85ke2rrZmSBBmoYmFtrciIXVICLy9IF8W8UO6ryLrOd0MdQWYUWOyvM1RJi8HaxJNIWH6veY1AK5GoOaJUGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+wV18g1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+wV18g1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D87C116C6;
	Tue,  6 Jan 2026 17:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720719;
	bh=3FnSlG2C63ecpNzidA6vPpUEx7y2gR02zgcc6skTRLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+wV18g1ErVM2QsD/B2kBIF5ipSSR20A7B7FEQg3ZU1Y0yj0Z9pr2vp9dcpfUv9oc
	 bzZZFy9UBruY60It0NBYBii4iOSGQ6yyCp//34y00lF+PjbtBEj3sMdzVtkGW7C7a4
	 oQaWsiTX86zVrQPx55Kg8dvq5/svCSKLHWl5360I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alice C. Munduruca" <alice.munduruca@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 314/567] selftests: net: fix "buffer overflow detected" for tap.c
Date: Tue,  6 Jan 2026 18:01:36 +0100
Message-ID: <20260106170502.944266431@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Alice C. Munduruca <alice.munduruca@canonical.com>

[ Upstream commit 472c5dd6b95c02b3e5d7395acf542150e91165e7 ]

When the selftest 'tap.c' is compiled with '-D_FORTIFY_SOURCE=3',
the strcpy() in rtattr_add_strsz() is replaced with a checked
version which causes the test to consistently fail when compiled
with toolchains for which this option is enabled by default.

 TAP version 13
 1..3
 # Starting 3 tests from 1 test cases.
 #  RUN           tap.test_packet_valid_udp_gso ...
 *** buffer overflow detected ***: terminated
 # test_packet_valid_udp_gso: Test terminated by assertion
 #          FAIL  tap.test_packet_valid_udp_gso
 not ok 1 tap.test_packet_valid_udp_gso
 #  RUN           tap.test_packet_valid_udp_csum ...
 *** buffer overflow detected ***: terminated
 # test_packet_valid_udp_csum: Test terminated by assertion
 #          FAIL  tap.test_packet_valid_udp_csum
 not ok 2 tap.test_packet_valid_udp_csum
 #  RUN           tap.test_packet_crash_tap_invalid_eth_proto ...
 *** buffer overflow detected ***: terminated
 # test_packet_crash_tap_invalid_eth_proto: Test terminated by assertion
 #          FAIL  tap.test_packet_crash_tap_invalid_eth_proto
 not ok 3 tap.test_packet_crash_tap_invalid_eth_proto
 # FAILED: 0 / 3 tests passed.
 # Totals: pass:0 fail:3 xfail:0 xpass:0 skip:0 error:0

A buffer overflow is detected by the fortified glibc __strcpy_chk()
since the __builtin_object_size() of `RTA_DATA(rta)` is incorrectly
reported as 1, even though there is ample space in its bounding
buffer `req`.

Additionally, given that IFLA_IFNAME also expects a null-terminated
string, callers of rtaddr_add_str{,sz}() could simply use the
rtaddr_add_strsz() variant. (which has been renamed to remove the
trailing `sz`) memset() has been used for this function since it
is unchecked and thus circumvents the issue discussed in the
previous paragraph.

Fixes: 2e64fe4624d1 ("selftests: add few test cases for tap driver")
Signed-off-by: Alice C. Munduruca <alice.munduruca@canonical.com>
Reviewed-by: Cengiz Can <cengiz.can@canonical.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20251216170641.250494-1-alice.munduruca@canonical.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tap.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/net/tap.c b/tools/testing/selftests/net/tap.c
index 247c3b3ac1c9..51a209014f1c 100644
--- a/tools/testing/selftests/net/tap.c
+++ b/tools/testing/selftests/net/tap.c
@@ -56,18 +56,12 @@ static void rtattr_end(struct nlmsghdr *nh, struct rtattr *attr)
 static struct rtattr *rtattr_add_str(struct nlmsghdr *nh, unsigned short type,
 				     const char *s)
 {
-	struct rtattr *rta = rtattr_add(nh, type, strlen(s));
+	unsigned int strsz = strlen(s) + 1;
+	struct rtattr *rta;
 
-	memcpy(RTA_DATA(rta), s, strlen(s));
-	return rta;
-}
-
-static struct rtattr *rtattr_add_strsz(struct nlmsghdr *nh, unsigned short type,
-				       const char *s)
-{
-	struct rtattr *rta = rtattr_add(nh, type, strlen(s) + 1);
+	rta = rtattr_add(nh, type, strsz);
 
-	strcpy(RTA_DATA(rta), s);
+	memcpy(RTA_DATA(rta), s, strsz);
 	return rta;
 }
 
@@ -119,7 +113,7 @@ static int dev_create(const char *dev, const char *link_type,
 
 	link_info = rtattr_begin(&req.nh, IFLA_LINKINFO);
 
-	rtattr_add_strsz(&req.nh, IFLA_INFO_KIND, link_type);
+	rtattr_add_str(&req.nh, IFLA_INFO_KIND, link_type);
 
 	if (fill_info_data) {
 		info_data = rtattr_begin(&req.nh, IFLA_INFO_DATA);
-- 
2.51.0



