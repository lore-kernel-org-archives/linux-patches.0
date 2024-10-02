Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB1418DF60;
	Wed,  2 Oct 2024 13:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876676; cv=none; b=RFDZhR/eoLPsRugQUQpfbXxMjea3MhC8Om4UsdJdfKkrv6zFsEHESEPr9QSb1O26LDb64bR8qRf8nAeOpEhKpua9Luh8bcHOYQgi4ETaOt2XXP0GnEu/ze/sD+2GOrTYFrApRe9dIzOkeJ2mv2pbVdLrlbHLX7tYm+L7xIHq/9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876676; c=relaxed/simple;
	bh=QIqJHHhmIlTZzz5rzo3Uk1z6cYYMGLMupAvT6qkZurY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUBUykeCG3gHM2rH/vnJw1Ydx5ybgKIGqMozQ41JSvXaOsXqMVEZgtIvgX+KFnnHtQnbMhs9Ns82muLVA5fq8aEkY3ly7QNSZ0zB4SFFJB7jR5hNjqBwVWDpGEITYbjl5C1FitDW/0jIlXQUbrTvRhVfYXSr1/gFit6+JkM6Ug4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFWd6RAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFWd6RAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63996C4CEC5;
	Wed,  2 Oct 2024 13:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876676;
	bh=QIqJHHhmIlTZzz5rzo3Uk1z6cYYMGLMupAvT6qkZurY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFWd6RAhI+xlbWjGNTDzQZ7iVKP090sIt9D2SwE6JewVa2RASlNkmvGdELhZ2Rht5
	 8HSyAeJ51BMruJYqVlM/z5YZ6am9DRDgY1xoNwXFNL7Wje+s5dv5rTonRtYJqIJIr8
	 MgfIzVKBplCCEeQu5JkqV/nr9b/6AI1nkeDuqnBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 494/695] selftests: netfilter: Avoid hanging ipvs.sh
Date: Wed,  2 Oct 2024 14:58:12 +0200
Message-ID: <20241002125842.190173984@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit fc786304ad9803e8bb86b8599bc64d1c1746c75f ]

If the client can't reach the server, the latter remains listening
forever. Kill it after 5s of waiting.

Fixes: 867d2190799a ("selftests: netfilter: add ipvs test script")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/netfilter/ipvs.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/ipvs.sh b/tools/testing/selftests/net/netfilter/ipvs.sh
index 4ceee9fb39495..d3edb16cd4b3f 100755
--- a/tools/testing/selftests/net/netfilter/ipvs.sh
+++ b/tools/testing/selftests/net/netfilter/ipvs.sh
@@ -97,7 +97,7 @@ cleanup() {
 }
 
 server_listen() {
-	ip netns exec "$ns2" socat -u -4 TCP-LISTEN:8080,reuseaddr STDOUT > "${outfile}" &
+	ip netns exec "$ns2" timeout 5 socat -u -4 TCP-LISTEN:8080,reuseaddr STDOUT > "${outfile}" &
 	server_pid=$!
 	sleep 0.2
 }
-- 
2.43.0



