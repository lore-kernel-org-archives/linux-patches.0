Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851D043C7B4;
	Thu, 30 Jul 2026 14:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422943; cv=none; b=n8XWDW/SsE564uAshf/ivciiVBiLAt2WSeWtd26Hl7XFDyYnz+PQy2AljLA3h66UQ6gpcmK+uCW22HIkbPXyNNmaEPVT0dAbIxNMeXDMu/dEbUT5ewTFGy1VgfkqT9vBdQsaHyyEOWAMh6Rjv4qeQjlCKefyjhDsaqdSn5za6ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422943; c=relaxed/simple;
	bh=XMH4EC//oSmMh/pzZ//8lJbO7MpwJvLrz+fzdiVaF/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAQu3JCnSZ+NElMtwVI/4Fd1JD0xpa7B7nGwiYEeCC+tiMfnMIg4/2q0nUZqDrrsvuSukxyNLGXuF6q7TAMkxzIe0Wv8ojC/dnyVfZeUAOmyeVMXbV9JC118/b7i/FfQBu5TyDXfVRa7MThiZyET62e7lZpYmwYU096N2ZboBAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZPJgETf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZPJgETf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50961F00A3D;
	Thu, 30 Jul 2026 14:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422941;
	bh=j/IXc4ic97nvMMZboE/88tbe8QbNu9m3prhBzY2bQYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZPJgETfcVNGw3hWYIS1RhWkUYSn+f1JryIxDB8pH44kZlQPWq3w89BonqsjbjPQd
	 ArpXAoMSTOYM3QfavR7G3cZ9Z/rn3/N/XbB2rvrbuiDMyD0U6LkB3bLLw6uRHuejs5
	 v3V/tg4AYm3reEiADLkVT+tHRUIRwPbPEbl2/xDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 611/744] selftests: mptcp: userspace_pm: fix undefined variable port
Date: Thu, 30 Jul 2026 16:14:44 +0200
Message-ID: <20260730141457.260936782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

commit e3213292c4fd69ba442c6ed4693f91a92b753140 upstream.

In make_connection(), the variable "port" is used but never defined.
This leads to an empty argument being passed to wait_local_port_listen(),
causing "printf: : invalid number" errors:

 # INFO: Init
 # 01 Created network namespaces ns1, ns2                          [ OK ]
 # INFO: Make connections
 # ./../lib.sh: line 651: printf: : invalid number
 # 02 Established IPv4 MPTCP Connection ns2 => ns1                 [ OK ]
 # INFO: Connection info: 10.0.1.2:59516 -> 10.0.1.1:50002
 # ./../lib.sh: line 651: printf: : invalid number
 # 03 Established IPv6 MPTCP Connection ns2 => ns1                 [ OK ]

Fix it by using the correctly defined variable "app_port", which holds the
appropriate port number for the connection.

Fixes: 39348f5f2f13 ("selftests: mptcp: wait for port instead of sleep")
Cc: stable@vger.kernel.org
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260722-net-mptcp-misc-fixes-7-2-rc5-v1-4-6fb595bc86ef@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/userspace_pm.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -212,7 +212,7 @@ make_connection()
 	   ./mptcp_connect -s MPTCP -w 300 -p $app_port -l $listen_addr > /dev/null 2>&1 &
 	local server_pid=$!
 
-	mptcp_lib_wait_local_port_listen "${ns1}" "${port}"
+	mptcp_lib_wait_local_port_listen "${ns1}" "${app_port}"
 
 	# Run the client, transfer $file and stay connected to the server
 	# to conduct tests


