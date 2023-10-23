Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B21914A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nka3Grws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E7BC433C8;
	Mon, 23 Oct 2023 11:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059148;
	bh=P1jFpBMmufE5fTIMDv+8Zh3tPCs2xsf3WhPLpUAW4Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nka3GrwsvCl/HDCqtF7b7D8pCcD0yxpFVyL3xq98eZNJ/aoyxjI5FscJhnRPkNcZs
	 WWsq5wYXSlkjAto0rCDZ1MSQw/G/NFjDwxaxt26L7hpglY7YyGdAiGjUVNtG40Tkao
	 i5Unbb/tYDFQCdT5ADje2EweCDqX56ZgfJ4doVRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Conole <aconole@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.5 079/241] selftests: openvswitch: Fix the ct_tuple for v4
Date: Mon, 23 Oct 2023 12:54:25 +0200
Message-ID: <20231023104835.813283733@linuxfoundation.org>
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

commit 8eff0e062201e26739c74ac2355b7362622b7190 upstream.

The ct_tuple v4 data structure decode / encode routines were using
the v6 IP address decode and relying on default encode. This could
cause exceptions during encode / decode depending on how a ct4
tuple would appear in a netlink message.

Caught during code review.

Fixes: e52b07aa1a54 ("selftests: openvswitch: add flow dump support")
Signed-off-by: Aaron Conole <aconole@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/openvswitch/ovs-dpctl.py |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
+++ b/tools/testing/selftests/net/openvswitch/ovs-dpctl.py
@@ -732,12 +732,14 @@ class ovskey(nla):
                 "src",
                 lambda x: str(ipaddress.IPv4Address(x)),
                 int,
+                convert_ipv4,
             ),
             (
                 "dst",
                 "dst",
-                lambda x: str(ipaddress.IPv6Address(x)),
+                lambda x: str(ipaddress.IPv4Address(x)),
                 int,
+                convert_ipv4,
             ),
             ("tp_src", "tp_src", "%d", int),
             ("tp_dst", "tp_dst", "%d", int),


