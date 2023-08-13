Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A645E9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62CEC433C8;
	Sun, 13 Aug 2023 21:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962399;
	bh=hboxY7cQrJsQHFUlZBf9uHDoTgTtJS+MURE/XNvxtSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rry6En2rdI51mhu8+yaSzRZokoV4HMHiYFEmCTAVr25uE97PhaMjX+vYL/T5uxgI5
	 QsX2ZcxHs5A+ww5FMWFvEIFVivgKIcczNayCYh74RGZHEtYblQ6ZWoTzBAB+0Ahlb2
	 gUpHDKe2ei1vTKZxouYnp2pS2sD65O91Unu728kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Claudi <aclaudi@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 015/149] selftests: mptcp: join: fix delete and re-add test
Date: Sun, 13 Aug 2023 23:17:40 +0200
Message-ID: <20230813211719.255135611@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrea Claudi <aclaudi@redhat.com>

commit aaf2123a5cf46dbd97f84b6eee80269758064d93 upstream.

mptcp_join 'delete and re-add' test fails when using ip mptcp:

  $ ./mptcp_join.sh -iI
  <snip>
  002 delete and re-add                    before delete[ ok ]
                                           mptcp_info subflows=1         [ ok ]
  Error: argument "ADDRESS" is wrong: invalid for non-zero id address
                                           after delete[fail] got 2:2 subflows expected 1

This happens because endpoint delete includes an ip address while id is
not 0, contrary to what is indicated in the ip mptcp man page:

"When used with the delete id operation, an IFADDR is only included when
the ID is 0."

This fixes the issue using the $addr variable in pm_nl_del_endpoint()
only when id is 0.

Fixes: 34aa6e3bccd8 ("selftests: mptcp: add ip mptcp wrappers")
Cc: stable@vger.kernel.org
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Link: https://lore.kernel.org/r/20230803-upstream-net-20230803-misc-fixes-6-5-v1-1-6671b1ab11cc@tessares.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -650,6 +650,7 @@ pm_nl_del_endpoint()
 	local addr=$3
 
 	if [ $ip_mptcp -eq 1 ]; then
+		[ $id -ne 0 ] && addr=''
 		ip -n $ns mptcp endpoint delete id $id $addr
 	else
 		ip netns exec $ns ./pm_nl_ctl del $id $addr


