Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F20C13AC4
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF89C433C0;
	Mon, 26 Jun 2023 18:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804112;
	bh=zfZESOLOkYLtdIRgj5FHS4SjZcmF4oaUzPNdHYIHPW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2nGB3Phl2f7Kp+MD58JQbu5zjr216laZAapGlWClt2hFqUqyuO0VhwQv+g6p76ED
	 SiUxZQqLoxVH+iBmf2aEIkLd5vWJHVD9m8ZM1PTIeQOXCgMMSpQaWOL9sUHxlSaP9/
	 BhkyAeDTiiIovG7tjR2J4N3O1or0y0A+ZzQNzIuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 018/170] selftests: mptcp: connect: skip disconnect tests if not supported
Date: Mon, 26 Jun 2023 20:09:47 +0200
Message-ID: <20230626180801.380024137@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
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

commit 4ad39a42da2e9770c8e4c37fe632ed8898419129 upstream.

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

One of them is the full support of disconnections from the userspace
introduced by commit b29fcfb54cd7 ("mptcp: full disconnect
implementation").

It is possible to look for "mptcp_pm_data_reset" in kallsyms because a
preparation patch added it to ease the introduction of the mentioned
feature.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 05be5e273c84 ("selftests: mptcp: add disconnect tests")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -782,6 +782,11 @@ run_tests_disconnect()
 	local old_cin=$cin
 	local old_sin=$sin
 
+	if ! mptcp_lib_kallsyms_has "mptcp_pm_data_reset$"; then
+		echo "INFO: Full disconnect not supported: SKIP"
+		return
+	fi
+
 	cat $cin $cin $cin > "$cin".disconnect
 
 	# force do_transfer to cope with the multiple tranmissions


