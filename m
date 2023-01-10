Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA39A93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612EFC433D2;
	Tue, 10 Jan 2023 18:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374261;
	bh=GQGUFmhYX1ymiYp2gW0b6dWHKW8PtEC70qugp1r+wK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cd1wGwejGEkUh9lgv7zjnbl2kGfqDEjPTt2RVZ8pqHigY2SOdxKGHx/YWcqQoQJVc
	 +RvB7ZBZhKbwt8oteb7l1KPFoQGwC7INIvrVEQUSayz5TbP0NhL0A4Vxl6BsNsYQQY
	 IjxUEYyncrOLXoRaH5nMFBLhmHONRDAez1i6BPqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Po-Hsu Lin <po-hsu.lin@canonical.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 075/148] selftests: net: return non-zero for failures reported in arp_ndisc_evict_nocarrier
Date: Tue, 10 Jan 2023 19:02:59 +0100
Message-Id: <20230110180019.595763360@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

[ Upstream commit 1856628baa17032531916984808d1bdfd62700d4 ]

Return non-zero return value if there is any failure reported in this
script during the test. Otherwise it can only reflect the status of
the last command.

Fixes: f86ca07eb531 ("selftests: net: add arp_ndisc_evict_nocarrier")
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/arp_ndisc_evict_nocarrier.sh        | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh b/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
index b4ec1eeee6c9..4a110bb01e53 100755
--- a/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
+++ b/tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
@@ -18,6 +18,7 @@ readonly V4_ADDR1=10.0.10.2
 readonly V6_ADDR0=2001:db8:91::1
 readonly V6_ADDR1=2001:db8:91::2
 nsid=100
+ret=0
 
 cleanup_v6()
 {
@@ -61,7 +62,7 @@ setup_v6() {
     if [ $? -ne 0 ]; then
         cleanup_v6
         echo "failed"
-        exit
+        exit 1
     fi
 
     # Set veth2 down, which will put veth1 in NOCARRIER state
@@ -88,7 +89,7 @@ setup_v4() {
     if [ $? -ne 0 ]; then
         cleanup_v4
         echo "failed"
-        exit
+        exit 1
     fi
 
     # Set veth1 down, which will put veth0 in NOCARRIER state
@@ -115,6 +116,7 @@ run_arp_evict_nocarrier_enabled() {
 
     if [ $? -eq 0 ];then
         echo "failed"
+        ret=1
     else
         echo "ok"
     fi
@@ -134,6 +136,7 @@ run_arp_evict_nocarrier_disabled() {
         echo "ok"
     else
         echo "failed"
+        ret=1
     fi
 
     cleanup_v4
@@ -164,6 +167,7 @@ run_ndisc_evict_nocarrier_enabled() {
 
     if [ $? -eq 0 ];then
         echo "failed"
+        ret=1
     else
         echo "ok"
     fi
@@ -182,6 +186,7 @@ run_ndisc_evict_nocarrier_disabled() {
         echo "ok"
     else
         echo "failed"
+        ret=1
     fi
 
     cleanup_v6
@@ -198,6 +203,7 @@ run_ndisc_evict_nocarrier_disabled_all() {
         echo "ok"
     else
         echo "failed"
+        ret=1
     fi
 
     cleanup_v6
@@ -218,3 +224,4 @@ if [ "$(id -u)" -ne 0 ];then
 fi
 
 run_all_tests
+exit $ret
-- 
2.35.1



