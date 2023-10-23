Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6463513FEC
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJSyUlqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BECC433C7;
	Mon, 23 Oct 2023 11:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059224;
	bh=5EtgBvODPS/MDGdp223TCuAnisUqlItihkfpJvkhgsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJSyUlqhUu2be7TGDVBMW715tfRie1udQa8tWof+4Qcj0S7hOf3hVxtK0SjSl+bz9
	 PgkPLZTujDTZsu4IU+GrpxErXaMOQtDipt3rFfMK3i2EzVJVvqxm2m+q03emqBC0pV
	 jYlDMS19XBvblaUxRjla8VdHyqSJZ3kfbbSrrkSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.5 088/241] selftests: openvswitch: Add version check for pyroute2
Date: Mon, 23 Oct 2023 12:54:34 +0200
Message-ID: <20231023104836.036041968@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Conole <aconole@redhat.com>

commit 92e37f20f20a23fec4626ae72eda50f127acb130 upstream.

Paolo Abeni reports that on some systems the pyroute2 version isn't
new enough to run the test suite.  Ensure that we support a minimum
version of 0.6 for all cases (which does include the existing ones).
The 0.6.1 version was released in May of 2021, so should be
propagated to most installations at this point.

The alternative that Paolo proposed was to only skip when the
add-flow is being run.  This would be okay for most cases, except
if a future test case is added that needs to do flow dump without
an associated add (just guessing).  In that case, it could also be
broken and we would need additional skip logic anyway.  Just draw
a line in the sand now.

Fixes: 25f16c873fb1 ("selftests: add openvswitch selftest suite")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Closes: https://lore.kernel.org/lkml/8470c431e0930d2ea204a9363a60937289b7fdbe.camel@redhat.com/
Signed-off-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/openvswitch/openvswitch.sh |    2 +-
 tools/testing/selftests/net/openvswitch/ovs-dpctl.py   |   10 +++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/openvswitch/openvswitch.sh
+++ b/tools/testing/selftests/net/openvswitch/openvswitch.sh
@@ -204,7 +204,7 @@ run_test() {
 	fi
 
 	if python3 ovs-dpctl.py -h 2>&1 | \
-	     grep "Need to install the python" >/dev/null 2>&1; then
+	     grep -E "Need to (install|upgrade) the python" >/dev/null 2>&1; then
 		stdbuf -o0 printf "TEST: %-60s  [PYLIB]\n" "${tdesc}"
 		return $ksft_skip
 	fi
--- a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
+++ b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
@@ -25,8 +25,10 @@ try:
     from pyroute2.netlink import nlmsg_atoms
     from pyroute2.netlink.exceptions import NetlinkError
     from pyroute2.netlink.generic import GenericNetlinkSocket
+    import pyroute2
+
 except ModuleNotFoundError:
-    print("Need to install the python pyroute2 package.")
+    print("Need to install the python pyroute2 package >= 0.6.")
     sys.exit(0)
 
 
@@ -1459,6 +1461,12 @@ def main(argv):
     nlmsg_atoms.ovskey = ovskey
     nlmsg_atoms.ovsactions = ovsactions
 
+    # version check for pyroute2
+    prverscheck = pyroute2.__version__.split(".")
+    if int(prverscheck[0]) == 0 and int(prverscheck[1]) < 6:
+        print("Need to upgrade the python pyroute2 package to >= 0.6.")
+        sys.exit(0)
+
     parser = argparse.ArgumentParser()
     parser.add_argument(
         "-v",


