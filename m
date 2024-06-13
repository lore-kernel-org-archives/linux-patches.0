Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6AD143739;
	Thu, 13 Jun 2024 12:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280688; cv=none; b=f0iSpjazcVBTqarzxVX3DSU0pDpQLoymaleTF6xKX9xGuRQahBUCA/Dy3BkuVUc6M76CD41DQMZzC+Ot6Qx1GbDxqVuSkSsfri1Lo92OuOl7172Tp4SMrPdWnZ0qeFwM2LXuv+z/ogkHLgu83p/FG+AhxkbJ/5o13dJQQ03yOuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280688; c=relaxed/simple;
	bh=YeE9rKjh3WvtXrXgw5KLTev9TNyxWWXCP3/iPXuQrOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1VEr3YvE647a9XpZlDIhfgirl6JLZT/GEIhk0VYElN4xLmbEJV5YxqVz1QriScTh34f5mTkFRrLRuHW/Ls31ATVqVo9MhBCTD1EgftxZSfAbAjl1422Fh02CZTxA1darG0bwBj5otj06QnAnvyaHJzSe8CMiuvwnLieOmJhM/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFTcECmw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFTcECmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC1DC2BBFC;
	Thu, 13 Jun 2024 12:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280688;
	bh=YeE9rKjh3WvtXrXgw5KLTev9TNyxWWXCP3/iPXuQrOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFTcECmwcBaqozdCRMzYCZEfNEOkrp4msbtLuQMOrCHQ24HztDsMEq1HIsAi0wKuM
	 P1PShS4Nbwyk7iFwZedCvMXh3nUfSVDm7AuG3WFwzp6AWjD7+qbi75jadt0Gs4k9P5
	 rjzRNX1uovjQe5cPoFrYg5GMO8GcEd2hpyKdJ8ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 137/137] selftests: net: more strict check in net_helper
Date: Thu, 13 Jun 2024 13:35:17 +0200
Message-ID: <20240613113228.621469365@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit a71d0908e32f3dd41e355d83eeadd44d94811fd6 upstream.

The helper waiting for a listener port can match any socket whose
hexadecimal representation of source or destination addresses
matches that of the given port.

Additionally, any socket state is accepted.

All the above can let the helper return successfully before the
relevant listener is actually ready, with unexpected results.

So far I could not find any related failure in the netdev CI, but
the next patch is going to make the critical event more easily
reproducible.

Address the issue matching the port hex only vs the relevant socket
field and additionally checking the socket state for TCP sockets.

Fixes: 3bdd9fd29cb0 ("selftests/net: synchronize udpgro tests' tx and rx connection")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/192b3dbc443d953be32991d1b0ca432bd4c65008.1707731086.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/net_helper.sh |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/net/net_helper.sh
+++ b/tools/testing/selftests/net/net_helper.sh
@@ -8,13 +8,16 @@ wait_local_port_listen()
 	local listener_ns="${1}"
 	local port="${2}"
 	local protocol="${3}"
-	local port_hex
+	local pattern
 	local i
 
-	port_hex="$(printf "%04X" "${port}")"
+	pattern=":$(printf "%04X" "${port}") "
+
+	# for tcp protocol additionally check the socket state
+	[ ${protocol} = "tcp" ] && pattern="${pattern}0A"
 	for i in $(seq 10); do
-		if ip netns exec "${listener_ns}" cat /proc/net/"${protocol}"* | \
-		   grep -q "${port_hex}"; then
+		if ip netns exec "${listener_ns}" awk '{print $2" "$4}' \
+		   /proc/net/"${protocol}"* | grep -q "${pattern}"; then
 			break
 		fi
 		sleep 0.1


