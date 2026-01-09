Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ED5310636;
	Fri,  9 Jan 2026 12:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962575; cv=none; b=CTsByNPDmnvqiznttpDMWBF1F28kU5V0dJaMmRPDpGlMPWFWh6nG/qL8hty9gE04Vkvb5Z1eKkZDuN3a43nUu5wgj77R/WQSiPVfAhhZBlIGfWJNwKK1Ma0Gya/DBGbUEKYojWP4cB68xSb2G6jFeAZ5wXN5BxiAg66uCVuo3BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962575; c=relaxed/simple;
	bh=7rlfQB+BIjmVCVl3XfslpDOMuNJEyMtViBfZvDA7o1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2Ow6rlG9jK80JAv6zAJAHyEPuM8/qVRMQah+tren0q4N4SbhpekA77F9WLQASHpvBAwKie8FxdAyf19wXPBmbXx4lm6eZdh9ae+pUYSPVsinNSpzicDDjhweTCXYXvwRwD7qY1+x7kcEw917ie4W8QBDCbMhJ7YZcTPmxGoOfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bs/tIhvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bs/tIhvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54BDC19421;
	Fri,  9 Jan 2026 12:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962575;
	bh=7rlfQB+BIjmVCVl3XfslpDOMuNJEyMtViBfZvDA7o1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bs/tIhvFQ+VLW95e201YtqFS42yOhiQw19YJtT1LQuDQEVHi9G2//80fmgAcST1kY
	 DMMcrqw1UGX+vlS7g5XrWjtkIR5FuitgEynFmPhtkHRPLZpb71Zm1WRodHALtjKPMr
	 fVR35VxCMV8lDj0aAEg3e5wEYQzd88mtcolprO44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alice C. Munduruca" <alice.munduruca@canonical.com>,
	Cengiz Can <cengiz.can@canonical.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 412/634] selftests: net: fix "buffer overflow detected" for tap.c
Date: Fri,  9 Jan 2026 12:41:30 +0100
Message-ID: <20260109112133.034982977@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



