Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4414F13BC0C;
	Mon, 23 Dec 2024 16:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969796; cv=none; b=ah55WNJ3+Hkm/xpehuye7J8QGl4VtfZ/ll6F2zwplzCeDiVcg+zR70+yGHVV7u4LatqlR5cRSWO6riB0H2Uj5sSF8gsDb9aB4jlJ1NzwPYX/E+UxWKHp03lTyw1dP9uaDNONxQC9ULpdVp0eOdMs/8Z+XV5OcXFRiGvhS8onnHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969796; c=relaxed/simple;
	bh=BPuFbokWtVaEFHckt100wfOD1plVLFVFzIRq8IOny5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KD74X/b6/a1lOzqIaPxeRJ7JjFRQtixVYHzyv800rKLWxCI/jcG480FULYM8QozO+9wE+V3DuRSmksDWtcZjcFyw8iYz4rgMq715Oct2BF5gRtjqAiCDNJJ+esJ36+M7AvhDLPcrx8KabwPt4iCRgMwoz9N0k9TK3eWaPduHHjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvM5BTWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvM5BTWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0084C4CED3;
	Mon, 23 Dec 2024 16:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969796;
	bh=BPuFbokWtVaEFHckt100wfOD1plVLFVFzIRq8IOny5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvM5BTWnRXgIIOBbShngatU3dEFe/WsjRH4dfzcDsCmzkYctp9y8JURFvWs/LR86O
	 vOpcKFBgZtE17B6YcGaWv9nSIXPQfDtHpOVujEYzoNT1CbSA/UCWi1XAR7JzSGTIYq
	 BVMlT059rKWIslN7CZS+WIsxgzNjX1VEmRojqMTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Moreno <amorenoz@redhat.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/160] selftests: openvswitch: fix tcpdump execution
Date: Mon, 23 Dec 2024 16:57:49 +0100
Message-ID: <20241223155410.920960961@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Moreno <amorenoz@redhat.com>

[ Upstream commit a17975992cc11588767175247ccaae1213a8b582 ]

Fix the way tcpdump is executed by:
- Using the right variable for the namespace. Currently the use of the
  empty "ns" makes the command fail.
- Waiting until it starts to capture to ensure the interesting traffic
  is caught on slow systems.
- Using line-buffered output to ensure logs are available when the test
  is paused with "-p". Otherwise the last chunk of data might only be
  written when tcpdump is killed.

Fixes: 74cc26f416b9 ("selftests: openvswitch: add interface support")
Signed-off-by: Adrian Moreno <amorenoz@redhat.com>
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Link: https://patch.msgid.link/20241217211652.483016-1-amorenoz@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/openvswitch/openvswitch.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/openvswitch/openvswitch.sh b/tools/testing/selftests/net/openvswitch/openvswitch.sh
index cc0bfae2bafa..960e1ab4dd04 100755
--- a/tools/testing/selftests/net/openvswitch/openvswitch.sh
+++ b/tools/testing/selftests/net/openvswitch/openvswitch.sh
@@ -171,8 +171,10 @@ ovs_add_netns_and_veths () {
 		ovs_add_if "$1" "$2" "$4" -u || return 1
 	fi
 
-	[ $TRACING -eq 1 ] && ovs_netns_spawn_daemon "$1" "$ns" \
-			tcpdump -i any -s 65535
+	if [ $TRACING -eq 1 ]; then
+		ovs_netns_spawn_daemon "$1" "$3" tcpdump -l -i any -s 6553
+		ovs_wait grep -q "listening on any" ${ovs_dir}/stderr
+	fi
 
 	return 0
 }
-- 
2.39.5



