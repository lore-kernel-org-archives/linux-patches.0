Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDFB134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3218C433C8;
	Mon, 26 Jun 2023 18:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803401;
	bh=kO5H7CEDVgr1KBH7LBwaziMyaa4KEJXQ3+U0mSudp2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lh3cz58BtaHTEdJ88mUtJaq6YMfiZvFKhybF+8oIogIZ0eXg6VzPoWMqXIaV7zccD
	 Jm+kUPkTRTnozjQg7PIBF13qks+Zs/5PYGzd2fWSMiNZKsSUwqnWpalkMdt40h2tl5
	 VR4nyFWN36pq//I7TYwsMPozfZZykDeLxUu+D+xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.3 048/199] selftests: mptcp: join: skip PM listener tests if not supported
Date: Mon, 26 Jun 2023 20:09:14 +0200
Message-ID: <20230626180807.691461681@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit 0471bb479af03874b09350fcfe51d3743a5608de upstream.

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

One of them is the support of PM listener events introduced by commit
f8c9dfbd875b ("mptcp: add pm listener events").

It is possible to look for "mptcp_event_pm_listener" in kallsyms to know
in advance if the kernel supports this feature.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 178d023208eb ("selftests: mptcp: listener test for in-kernel PM")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2734,6 +2734,11 @@ verify_listener_events()
 			$e_saddr $e_sport
 	fi
 
+	if ! mptcp_lib_kallsyms_has "mptcp_event_pm_listener$"; then
+		printf "[skip]: event not supported\n"
+		return
+	fi
+
 	type=$(grep "type:$e_type," $evt |
 	       sed --unbuffered -n 's/.*\(type:\)\([[:digit:]]*\).*$/\2/p;q')
 	family=$(grep "type:$e_type," $evt |


